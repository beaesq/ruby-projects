# frozen_string_literal: true

class Game
  def initialize(grid = make_grid)
    @grid = grid
  end

  attr_reader :maximum_height, :grid

  def make_grid(col_num = 7, max_height = 6)
    @maximum_height = max_height
    grid = []
    col_num.times { grid << '' }  # workaround for ruby giving me an array with multiple copies of the SAME object
    grid
  end

  def add_token(col_num, token, grid = @grid)
    return grid if col_num >= grid.length || col_num.negative?

    grid[col_num] += token unless grid[col_num].length >= @maximum_height
    grid
  end

  def set_players(token_a = '◉', token_b = '○')
    @player_a = Player.new(get_player_name(1), token_a)
    @player_b = Player.new(get_player_name(2), token_b)
  end

  def game_over?(token)
    win_vertical?(token) || win_horizontal?(token) || win_diagonal_down?(token) || win_diagonal_up?(token)
  end

  def win_vertical?(token, grid = @grid)
    match = token * 4
    grid.length.times do |col_num|
      grid[col_num]
      return true if grid[col_num].include?(match)
    end
    false
  end

  def win_horizontal?(token, grid = @grid)
    match = token * 4
    hor_array = get_all_horizontal(grid)
    hor_array.include?(match)
  end

  def win_diagonal_down?(token, grid = @grid)
    match = token * 4
    diag_down_array = get_all_diagonal_down(grid)
    diag_down_array.include?(match)
  end

  def win_diagonal_up?(token, grid = @grid)
    match = token * 4
    diag_up_array = get_all_diagonal_up(grid)
    diag_up_array.include?(match)
  end

  private

  def get_all_diagonal_up(grid = @grid)
    array = []
    grid.each_index do |col|
      grid[col].length.times do |row|
        du_line = get_char(col, row, grid) + get_char(col + 1, row + 1, grid) + get_char(col + 2, row + 2, grid) + get_char(col + 3, row + 3, grid)
        array << du_line if du_line.length == 4
      end
    end
    array
  end

  def get_all_diagonal_down(grid = @grid)
    array = []
    grid.each_index do |col|
      grid[col].length.times do |row|
        dd_line = get_char(col, row, grid) + get_char(col + 1, row - 1, grid) + get_char(col + 2, row - 2, grid) + get_char(col + 3, row - 3, grid)
        array << dd_line if dd_line.length == 4
      end
    end
    array
  end

  def get_all_horizontal(grid = @grid)
    array = []
    grid.each_index do |col|
      grid[col].length.times do |row|
        hor_line = get_char(col, row, grid) + get_char(col + 1, row, grid) + get_char(col + 2, row, grid) + get_char(col + 3, row, grid)
        array << hor_line if hor_line.length == 4
      end
    end
    array
  end

  def get_char(col_num, row_num, grid = @grid)
    return '' if col_num.negative? || row_num.negative?
    return '' if col_num >= grid.length || row_num >= grid[col_num].length

    column = grid[col_num]
    char = column[row_num]
    char.nil? ? '' : char
  end

  def get_player_name(player_num)
    print "Enter player # #{player_num}'s name: "
    gets.chomp
  end
end
