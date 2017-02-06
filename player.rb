class Player
  MAX_BULLETS = 3
  attr_reader :score, :bullets

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

    @explosion_anim = Gosu::Image.load_tiles('media/explosion.png', 64, 64)
    @explosions = []
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

  def kill_asteroids(asteroids, img)
    asteroids.reject! do |asteroid|
      @bullets.any? do |bullet|
        if Gosu.distance(bullet.x, bullet.y, asteroid.x, asteroid.y) < asteroid.radious
          bullet_hits_asteroid(bullet, asteroid)
          # add 2 new smaller asteroids
          unless asteroid.final_asteroid?
            [90, -90].each do |angle_offset|
              asteroids.push(Asteroid.new(img, asteroid, asteroid.angle + angle_offset))
            end
          end
          true
        else
          false
        end
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

    @explosions.reject!(&:finished?)
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
    @fire.draw
    @bullets.each(&:draw)
    @explosions.each(&:draw)
  end

  private

  def bullet_hits_asteroid(bullet, asteroid)
    @score += 10 * asteroid.size
    @beep.play
    @bullets.delete(bullet)
    # show an explosion
    @explosions.push(Explosion.new(asteroid.x, asteroid.y, asteroid.size, @explosion_anim))
  end
end
