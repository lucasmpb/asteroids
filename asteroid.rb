class Asteroid
  attr_reader :x, :y, :size

  def initialize(img)
    @img = img
    @x = rand * 640
    @y = rand * 480
    @size = 1 # Size could be 1, 2 or 4

    @view_angle = @angle = rand(359)
    @speed = rand(4) + 1
  end

  def main_asteroid
    @size == 1
  end

  def update
    @x += Gosu.offset_x(@angle, @speed)
    @y += Gosu.offset_y(@angle, @speed)
    @x %= SampleWindow::SCREEN_WIDTH
    @y %= SampleWindow::SCREEN_HEIGHT

    @view_angle += @speed
  end

  def draw
    @img.draw_rot(@x, @y, ZOrder::STARS, @view_angle)
  end
end
