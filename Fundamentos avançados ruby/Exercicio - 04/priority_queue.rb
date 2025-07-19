require 'thread'

class PriorityQueue
  PRIORITIES = [:high, :medium, :low, :default].freeze

  def initialize
    @queues = {}
    @mutex = Mutex.new
    @condition = ConditionVariable.new
    @shutdown = false

    # Inicializa uma fila para cada prioridade
    PRIORITIES.each do |priority|
      @queues[priority] = Queue.new
    end
  end

  def enqueue(priority, task)
    priority = :default unless PRIORITIES.include?(priority)

    @mutex.synchronize do
      return if @shutdown
      @queues[priority].push(task)
      @condition.signal
    end
  end

  def dequeue(timeout = nil)
    @mutex.synchronize do
      loop do
        return nil if @shutdown

        PRIORITIES.each do |priority|
          queue = @queues[priority]
          unless queue.empty?
            return queue.pop(true)
          end
        end

        if timeout
          return nil unless @condition.wait(@mutex, timeout)
        else
          @condition.wait(@mutex)
        end
      end
    end
  rescue ThreadError
    nil
  end

  def empty?
    @mutex.synchronize do
      @queues.values.all?(&:empty?)
    end
  end

  def size
    @mutex.synchronize do
      @queues.values.sum(&:size)
    end
  end

  def shutdown
    @mutex.synchronize do
      @shutdown = true
      @condition.broadcast
    end
  end

  def shutdown?
    @mutex.synchronize { @shutdown }
  end
end