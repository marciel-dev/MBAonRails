class Vector4
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def *(value)
    puts "Output: (#{ value * x }, #{ value * y })" if value.kind_of?(Numeric)
    puts "Output: #{ (value.x * x)  + (value.y * y) } (dot product)" if value.kind_of?(Vector4)
  end

end

Integer.class_eval do
  ORIGINAL_INTEGER_METHOD = Integer.instance_method(:*)
  def *(value)
    return value * self if value.kind_of?(Vector4)
    ORIGINAL_INTEGER_METHOD.bind(self).call(value)
  end
end

Float.class_eval do
  ORIGINAL_FLOAT_METHOD = Float.instance_method(:*)
  def *(value)
    return value * self if value.kind_of?(Vector4)
    ORIGINAL_FLOAT_METHOD.bind(self).call(value)
  end
end



v = Vector4.new(3, 4)

puts v * 2
puts v * 2.5
puts v * v
puts 2 * v
puts 2.5 * v
puts 2 * 2
puts 2.5 * 2
puts 2 * 2.5