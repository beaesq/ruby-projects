# frozen_string_literal: false

# display methods for a connect four game
module Board
  def display_board(grid, maximum_height, player_a, player_b)
    clear
    print_player_tokens(player_a, player_b)
    grid_by_row = arrange_grid_by_row(grid, maximum_height)
    print_grid(grid_by_row, maximum_height)
  end

  def print_player_tokens(player_a, player_b)
    puts "   #{player_a.name} - #{player_a.token}       #{player_b.name} - #{player_b.token}"
    puts ''
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

  def display_intro
    puts "Let's play some Connect Four!"
    puts 'Choose a column to slide a token in! Connect Four tokens in any direction to win!'
  end

  def display_outro(winning_player, is_game_won, is_grid_full)
    
    puts 'Nobody won! :O' if is_grid_full
    puts "#{winning_player.name} won! Congratulations!" if is_game_won
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

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
end
