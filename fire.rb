class Fire
  def initialize(animation)
    @animation = animation
    @x = @y = @angle = @factor = 0.0
  end

  def update(x, y, angle, vel_x, vel_y)
    size(vel_x, vel_y)
    @angle = angle + 180
    @x = x + Gosu::offset_x(angle, -26)
    @y = y + Gosu::offset_y(angle, -26)
  end

  def size(vel_x, vel_y)
    speed = (vel_x.abs + vel_y.abs).round
    speed = (speed > 5) ? 5 : speed
    @factor = speed == 0 ? 0 : (1.0 / (6 - speed))
  end

  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw_rot(@x, @y, 1, @angle, 0.5, 1, @factor, @factor)
  end
end
