require_relative 'priority_queue'
class DynamicThreadPool
  attr_reader :max_threads, :current_thread_count, :active_threads

  def initialize(initial_threads: 2, max_threads: 10)
    @initial_threads = initial_threads
    @max_threads = max_threads
    @priority_queue = PriorityQueue.new
    @threads = []
    @mutex = Mutex.new
    @shutdown = false
    @active_threads = 0
    @idle_timeout = 30

    @initial_threads.times { spawn_worker_thread }
  end

  def schedule(priority = :default, &block)
    raise ArgumentError, "Bloco é obrigatório" unless block_given?
    raise RuntimeError, "ThreadPool foi encerrada" if @shutdown

    @priority_queue.enqueue(priority, block)

    maybe_spawn_thread if should_spawn_thread?
  end

  def current_thread_count
    @mutex.synchronize { @threads.size }
  end

  def pending_tasks
    @priority_queue.size
  end

  def stats
    @mutex.synchronize do
      {
        total_threads: @threads.size,
        active_threads: @active_threads,
        idle_threads: @threads.size - @active_threads,
        pending_tasks: @priority_queue.size,
        max_threads: @max_threads
      }
    end
  end

  def shutdown(wait: true, timeout: 30)
    @mutex.synchronize { @shutdown = true }
    @priority_queue.shutdown

    if wait
      deadline = Time.now + timeout
      @threads.each do |thread|
        remaining_time = deadline - Time.now
        if remaining_time > 0
          thread.join(remaining_time)
        end
      end

      @threads.each do |thread|
        thread.kill if thread.alive?
      end
    end

    @threads.clear
  end

  def shutdown!
    @mutex.synchronize { @shutdown = true }
    @priority_queue.shutdown
    @threads.each(&:kill)
    @threads.clear
  end

  private

  def spawn_worker_thread
    @mutex.synchronize do
      return if @threads.size >= @max_threads || @shutdown

      thread = Thread.new { worker_loop }
      thread[:created_at] = Time.now
      @threads << thread

      puts "Nova thread criada. Total: #{@threads.size}"
    end
  end

  def worker_loop
    loop do
      break if @shutdown && @priority_queue.empty?

      task = @priority_queue.dequeue(@idle_timeout)

      if task
        execute_task(task)
      else
        break if should_remove_thread?
      end
    end
  ensure
    @mutex.synchronize do
      @threads.delete(Thread.current)
      puts "Thread removida. Total: #{@threads.size}"
    end
  end

  def execute_task(task)
    @mutex.synchronize { @active_threads += 1 }

    begin
      task.call
    rescue StandardError => e
      puts "Erro ao executar tarefa: #{e.message}"
      puts e.backtrace.join("\n")
    ensure
      @mutex.synchronize { @active_threads -= 1 }
    end
  end

  def should_spawn_thread?
    @mutex.synchronize do
      return false if @shutdown || @threads.size >= @max_threads

      @active_threads >= @threads.size && @priority_queue.size > 0
    end
  end

  def should_remove_thread?
    @mutex.synchronize do
      return false if @threads.size <= @initial_threads

      @shutdown || idle_thread_count > 1
    end
  end

  def maybe_spawn_thread
    Thread.new { spawn_worker_thread } if should_spawn_thread?
  end

  def idle_thread_count
    @threads.size - @active_threads
  end
end