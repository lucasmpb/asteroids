class Explosion
  attr_reader :x, :y

  def initialize(x, y, animation)
    @animation = animation
    @x, @y = x, y
    @animation_start = Gosu.milliseconds
    @speed = 50
  end

  def draw
    img = @animation[frame]
    img.draw_rot(@x, @y, ZOrder::STARS, 0) unless img.nil? # TODO: sometimes we try to draw an image out of the animation
  end

  def frame
    (Gosu.milliseconds - @animation_start) / @speed
  end

  def finished?
    frame >= @animation.size
  end
end
