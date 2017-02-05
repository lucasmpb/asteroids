class Asteroid
  attr_reader :x, :y, :size, :radious

  def initialize(img)
    @img = img
    @x = rand * 640
    @y = rand * 480
    @size = 1 # Size could be 1, 2 or 4
    @radious = img.width / 2.0
    puts @radious

    @view_angle = @angle = rand(359)
    @speed = rand(4) + 1
  end

  def main_asteroid
    @size == 1
  end

  def update
    @x += Gosu.offset_x(@angle, @speed)
    @y += Gosu.offset_y(@angle, @speed)
    @view_angle += @speed

    return if in_screen?

    @x %= SampleWindow::SCREEN_WIDTH + @radious
    @y %= SampleWindow::SCREEN_HEIGHT + @radious
  end

  def draw
    @img.draw_rot(@x, @y, ZOrder::STARS, @view_angle)
  end

  private

  def in_screen?
    (- @radious < @x && @x < SampleWindow::SCREEN_WIDTH + @radious) && (- @radious < @y && @y < SampleWindow::SCREEN_HEIGHT + @radious)
  end
end
