class Asteroid
  attr_reader :x, :y, :size, :angle, :speed, :radious

  def initialize(img, father = nil, angle = nil)
    @img = img
    if father.nil?
      @x = rand * 640
      @y = rand * 480
      @size = 1 # Size could be 1, 2 or 4
      @view_angle = @angle = rand(359)
      @speed = rand(4) + 1
    else
      @x = father.x
      @y = father.y
      @size = father.size * 2
      @view_angle = @angle = angle
      @speed = father.speed + rand(2)
    end

    @radious = img.width / 2.0 / @size
  end

  def main_asteroid
    @size == 1
  end

  def final_asteroid?
    @size == 4
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
    @img.draw_rot(@x, @y, ZOrder::STARS, @view_angle, 0.5, 0.5, 1.0 / @size, 1.0 / @size)
  end

  private

  def in_screen?
    (- @radious < @x && @x < SampleWindow::SCREEN_WIDTH + @radious) && (- @radious < @y && @y < SampleWindow::SCREEN_HEIGHT + @radious)
  end
end
