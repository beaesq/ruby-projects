module Board
  def display_board(grid, maximum_height)
    grid_by_row = arrange_grid_by_row(grid, maximum_height)
    print_grid(grid_by_row, maximum_height)
  end

  def print_grid(grid, maximum_height)
    (maximum_height - 1).downto(0) do |row_num|
      # row = grid[row_num].join(' │ ')
      print "│"
      grid[row_num].each_char { |char| print " #{char} │" }
      puts ''
    end
    puts '├───┴───┴───┴───┴───┴───┴───┤'
    
  end

  def arrange_grid_by_row(grid, maximum_height)
    grid_by_row = []
    maximum_height.times do |row_num|
      row = ''
      grid.length.times do |col_num|
        row << get_char_space(col_num, row_num, grid)
      end
      grid_by_row << row
    end
    grid_by_row
  end

  def get_char_space(col_num, row_num, grid = @grid)
    column = grid[col_num]
    char = column[row_num]
    char.nil? ? ' ' : char
  end
end