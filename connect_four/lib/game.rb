# frozen_string_literal: true

class Game
  def initialize
    @grid = make_grid
    
  end

  def make_grid(col_num = 7, row_num = 6)
    one_column = Array.new(row_num)
    Array.new(col_num, one_column)
  end

  def add_token(col_num, grid = @grid)
    
  end
end
