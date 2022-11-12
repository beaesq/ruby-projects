# frozen_string_literal: true

class Game
  def initialize
    @grid = make_grid
  end

  attr_reader :maximum_height, :grid

  def make_grid(col_num = 7, max_height = 6)
    @maximum_height = max_height
    grid = []
    col_num.times { grid << [] }  # workaround for ruby giving me an array with multiple copies of the SAME object
    grid
  end

  def add_token(col_num, token, grid = @grid)
    return grid if col_num >= grid.length || col_num.negative?

    grid[col_num].push(token) unless grid[col_num].length >= @maximum_height
    grid
  end

  def set_players(token_a = 'O', token_b = '0')
    @player_a = Player.new(get_player_name(1), token_a)
    @player_b = Player.new(get_player_name(2), token_b)
  end

  private

  def get_player_name(player_num)
    print "Enter player # #{player_num}'s name: "
    gets.chomp
  end
end
