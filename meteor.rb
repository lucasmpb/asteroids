class Meteor
  attr_reader :x, :y, :size

  def initialize(img)
    @img = img
    @x = rand * 640
    @y = rand * 480
    @size = 1 # Size could be 1, 2 or 4

    @angle = rand(359)
    @speed = rand(4) + 1
  end

  def main_meteor
    @size == 1
  end

  def update
    @x += Gosu.offset_x(@angle, @speed)
    @y += Gosu.offset_y(@angle, @speed)
    @x %= SampleWindow::SCREEN_WIDTH
    @y %= SampleWindow::SCREEN_HEIGHT
  end

  def draw
    @img.draw(@x - @img.width / 2.0, @y - @img.height / 2.0, ZOrder::STARS, 1, 1)
  end
end
