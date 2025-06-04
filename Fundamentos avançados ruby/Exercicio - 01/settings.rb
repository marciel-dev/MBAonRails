class Settings

  def initialize
    @values = {}
  end

  def add(chave, valor, alias_name: nil, readonly: false)
    @values[chave]={ value: valor, readonly: readonly }

    define_singleton_method(chave) do
      @values[chave][:value]
    end

    define_singleton_method("#{chave}=") do |novo_valor|
        @values[chave][:value] = novo_valor
    end unless readonly

    define_singleton_method(chave) do
      @values[chave][:value]
    end

    define_singleton_method(alias_name, method(chave)) unless alias_name.nil?

  end

  def all
    puts @values
  end

  def method_missing(method, *args)
    if method.to_s.end_with?('=')
      chave = method.to_s.chomp('=').to_sym
      if @values.key?(chave) && @values[chave][:readonly]
        puts "A configuração #{chave} é somente leitura."
      end
    else
      return "Configuração '#{method}' não existe."
    end
  end
end


puts "---------Instanciando a classe principal-------"
puts "=> settings = Settings.new"
settings = Settings.new
puts "---------Adicionando valores do teste-------"

puts "=> settings.add(:timeout, 30)"
settings.add(:timeout, 30)
puts "=> settings.add(:mode, 'production')"
settings.add(:mode, "production")
puts "---------Imprimindo valores adicionados-------"
puts "settings.timeout => #{settings.timeout}"
puts "settings.mode => #{settings.mode}"
puts "settings.retry => #{settings.retry}"
puts "settings.respond_to?(:timeout) => #{settings.respond_to?(:timeout)}}"
puts "settings.respond_to?(:retry) => #{settings.respond_to?(:retry, false)}"

puts "---------------------config alias------------------------"
puts "=> settings.add(:timeout, 30, alias_name: :espera)"
settings.add(:timeout, 30, alias_name: :espera)

puts "chave padrão: settings.timeout => #{settings.timeout}"
puts "alias: settings.espera => #{settings.timeout}"


puts "------------------Configandoi read-only-----------------------"
puts "settings.add(:api_key, 'SECRET', readonly: true)"
settings.add(:api_key, "SECRET", readonly: true)
puts "settings.api_key => #{settings.api_key}"
puts "-------------Tentando atribuir valor a um readonly--------------"
puts "settings.api_key='HACKED'"
settings.api_key="HACKED"

puts "Checando o valor: settings.api_key => #{settings.api_key}"

puts "----------tentando atribuir um valor para config sem readonly-------------"
puts "settings.mode = 'Staging'"
settings.mode = "Staging"
puts "settings.mode => #{settings.mode}"

puts "-------Todas as configurações com: settings.all -----------------"
settings.all