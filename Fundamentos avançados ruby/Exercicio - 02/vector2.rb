class Vector2
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def *(value)
    puts "Output: (#{ value * x }, #{ value * y })" if value.kind_of?(Numeric)
    puts "Output: #{ (value.x * x)  + (value.y * y) } (dot product)" if value.kind_of?(Vector2)
  end

  def coerce(value)
    return  [self, value] if value.kind_of?(Numeric)
    raise TypeError, "operação não permitida"
  end
end


v = Vector2.new(3, 4)

puts v * 2
puts v * 2.5
puts v * v
puts 2 * v
puts 2.5 * v