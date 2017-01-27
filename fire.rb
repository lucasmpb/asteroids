class Fire
  def initialize(animation)
    @animation = animation
    @x = @y = @speed = @angle = 0.0
  end

  def update(x, y, angle)
    @angle = angle + 180
    @x = x + Gosu::offset_x(angle, -42)
    @y = y + Gosu::offset_y(angle, -42)
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw_rot(@x, @y, 1, @angle)
  end
end