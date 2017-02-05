require 'optparse'
require 'gosu'
require_relative 'asteroid'
require_relative 'bullet'
require_relative 'fire'
require_relative 'player'
require_relative 'star'

class SampleWindow < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600

  def initialize(options)
    super SCREEN_WIDTH, SCREEN_HEIGHT
    self.caption = 'Sample Game'
    @options = options

    @background_image = Gosu::Image.new('media/space.png', tileable: true)

    @player = Player.new
    @player.warp(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

    @star_anim = Gosu::Image.load_tiles('media/star.png', 25, 25)
    @stars = []

    @font = Gosu::Font.new(20)

    @asteroid_img = Gosu::Image.new('media/asteroid.png')
    @asteroids = []
  end

  def update
    @player.turn_left if go_left?
    @player.turn_right if go_right?
    @player.accelerate if go_forward?
    @player.move
    @player.collect_stars(@stars)

    @stars.push(Star.new(@star_anim)) if add_star?
    @stars.each(&:update)

    @asteroids.push(Asteroid.new(@asteroid_img)) if add_asteroid?
    @asteroids.each(&:update)
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0)
    @stars.each(&:draw)
    @asteroids.each(&:draw)
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    return unless @options[:debug]
    # DEBUG CODE STARTS HERE
    @font.draw("Stars: #{@stars.size}", 700, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
    @font.draw("FPS: #{1000.0 / update_interval}", 700, 550, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @player.fire_bullet if id == Gosu::KbSpace
  end

  private

  def add_star?
    rand(100) < 4 && @stars.size < 250
  end

  def add_asteroid?
    (rand(100) < 4) && (@asteroids.select(&:main_asteroid).size < 3)
  end

  def go_left?
    (Gosu.button_down? Gosu::KbLeft) || (Gosu.button_down? Gosu::GpLeft)
  end

  def go_right?
    (Gosu.button_down? Gosu::KbRight) || (Gosu.button_down? Gosu::GpRight)
  end

  def go_forward?
    (Gosu.button_down? Gosu::KbUp) || (Gosu.button_down? Gosu::GpButton0)
  end
end

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: sample.rb [options]'

  opts.on('-d', '--debug', 'Show debug info') do |v|
    options[:debug] = v
  end
end.parse!

puts options if options[:debug]

window = SampleWindow.new(options)
window.show
