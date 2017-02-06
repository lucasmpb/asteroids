class Explosion
  attr_reader :x, :y

  def initialize(x, y, size, animation)
    @animation = animation
    @x, @y, @size = x, y, size
    @animation_start = Gosu.milliseconds
    @speed = 50
  end

  def draw
    img = @animation[frame]
    img&.draw_rot(@x, @y, ZOrder::PLAYER, 0, 0.5, 0.5, 1.0 / @size, 1.0 / @size) # TODO: sometimes we try to draw an image out of the animation
  end

  def frame
    (Gosu.milliseconds - @animation_start) / @speed
  end

  def finished?
    frame >= @animation.size
  end
end
