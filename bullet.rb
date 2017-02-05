class Bullet
  attr_reader :x, :y, :angle

  def initialize(x, y, angle, image)
    @image = image
    @x = x
    @y = y

    @angle = angle
    @speed = 8
  end

  def update
    @x += Gosu.offset_x(@angle, @speed)
    @y += Gosu.offset_y(@angle, @speed)
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::UI, @angle, 0.5, 1)
  end

  def in_screen
    @x.positive? && @x < SampleWindow::SCREEN_WIDTH && @y.positive? && @y < SampleWindow::SCREEN_HEIGHT
  end
end
