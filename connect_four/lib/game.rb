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
end
