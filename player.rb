class Player
  MAX_BULLETS = 3
  attr_reader :score

  def initialize
    @image = Gosu::Image.new('media/player.png')
    @bullet = Gosu::Image.new('media/bullet.png')
    @beep = Gosu::Sample.new('media/beep.wav')
    @shoot = Gosu::Sample.new('media/shoot.wav')
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0

    @fire_anim = Gosu::Image.load_tiles('media/fire.png', 32, 32)
    @fire = Fire.new(@fire_anim)

    @bullets = []
  end

  def fire_bullet
    return unless @bullets.size < MAX_BULLETS
    # fire bullet from the ship tip
    bx = @x + Gosu.offset_x(@angle, 26)
    by = @y + Gosu.offset_y(@angle, 26)
    @shoot.play
    @bullets.push(Bullet.new(bx, by, @angle, @bullet))
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, 0.4)
    @vel_y += Gosu.offset_y(@angle, 0.4)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= SampleWindow::SCREEN_WIDTH
    @y %= SampleWindow::SCREEN_HEIGHT

    @vel_x *= 0.95
    @vel_y *= 0.95

    @fire.update(@x, @y, @angle, @vel_x, @vel_y)

    @bullets.each(&:update)
    @bullets.select!(&:in_screen)
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
    @fire.draw
    @bullets.each(&:draw)
  end
end
