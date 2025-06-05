class Vector3
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def *(value)
    puts "Output: (#{ value * x }, #{ value * y })" if value.kind_of?(Numeric)
    puts "Output: #{ (value.x * x)  + (value.y * y) } (dot product)" if value.kind_of?(Vector3)
  end

end

Integer.class_eval do
  alias_method :original_int_method, :*
  def *(value)
    return value * self if value.kind_of?(Vector3)
    original_int_method(value)
  end
end

Float.class_eval do
  alias_method :original_float_method, :*
  def *(value)
    return value * self if value.kind_of?(Vector3)
    original_float_method(value)
  end
end



v = Vector3.new(3, 4)

puts v * 2
puts v * 2.5
puts v * v
puts 2 * v
puts 2.5 * v
puts 2 * 2
puts 2.5 * 2
puts 2 * 2.5