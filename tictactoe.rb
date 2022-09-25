# frozen_string_literal: true

# for player data, make two instances per game
class Player
  def initialize(player_name)
    @player_name = player_name
    @player_score = 0
  end

  attr_accessor :player_score
  attr_reader :player_name
end

class Game
  def self.make_new_player(player_number)
    print "Enter Player #{player_number}'s name: "
    name = gets.chomp
    Player.new(name)
  end

  def self.randomize_first_player
    first_player = rand(1..2) == 1 ? 'A' : 'B'
    puts "#{first_player == 'A' ? @@player_a.player_name : @@player_b.player_name} plays first!"
    first_player == 'A' ? @@player_a : @@player_b
  end

  def initialize
    @@player_a = Game.make_new_player('A')
    @@player_b = Game.make_new_player('B')
    game_loop
  end

  def game_loop
    game_over = false
    until game_over
      first_player = Game.randomize_first_player
      Round.new(first_player, first_player == @@player_a ? @@player_b : @@player_a)
      print_score
      game_over = Game.end_game?
    end
    puts 'ok bye stan loona'
  end

  def print_score
    puts "#{@@player_a.player_name}: #{@@player_a.player_score}"
    puts "#{@@player_b.player_name}: #{@@player_b.player_score}"
  end

  def self.end_game?
    print 'Play another round? (y/n) '
    case gets.chomp
    when 'y' then false
    when 'n' then true
    else (raise 'Please enter y or n')
    end
  rescue StandardError => e
    puts e.message
    retry
  end
end

class Round
  @@number_of_rounds = 0

  def initialize(x_player, o_player)
    @@x_player = x_player
    @@o_player = o_player
    @@number_of_rounds += 1
    puts "Round #{@@number_of_rounds}"
    Round.play_round
  end

  def self.number_of_rounds
    @@number_of_rounds
  end

  def self.play_round
    @current_grid = Grid.new
    @current_mark = 'X'
    round_loop
    # Game.update_score
    print_winner
  end

  def self.round_loop
    is_round_over = false
    until is_round_over
      @current_grid.draw_grid
      Round.player_input
      @round_winner = @current_grid.check_grid
      is_round_over = true if @round_winner == 'X' || @round_winner == 'O' || @round_winner == 'draw'
      @current_mark = @current_mark == 'X' ? 'O' : 'X'
    end
    update_score
  end

  def self.update_score
    case @round_winner 
    when 'X' then @@x_player.player_score += 1
    when 'O' then @@o_player.player_score += 1
    end
  end

  def self.print_winner
    if @round_winner == 'draw'
      puts "It's a draw!"
    else
      winner_name = @round_winner == 'X' ? @@x_player.player_name : @@o_player.player_name
      puts "#{winner_name} wins!"
    end
  end

  def self.input_row
    begin
      print 'Enter row (1-3): '
      row = gets.chomp.to_i - 1
      [0, 1, 2].none?(row) && (raise 'Please choose between 1-3')
    rescue StandardError => e
      puts e.message
      retry
    end
    row
  end

  def self.input_column
    begin
      print 'Enter column (A-C): '
      column = gets.chomp
      %w[A B C].none?(column) && (raise 'Please choose between A-C')
      column = convert_column_input(column)
    rescue StandardError => e
      puts e.message
      retry
    end
    column
  end

  def self.player_input
    puts "#{@current_mark == 'X' ? @@x_player.player_name : @@o_player.player_name}'s turn (#{@current_mark})"
    while true
      row = input_row
      column = input_column
      overwrite?(row, column) || break
      puts 'Please choose a different square.'
    end
    value = @current_mark
    @current_grid.update_grid(row, column, value)
  end

  def self.overwrite?(row, column)
    @current_grid.grid[row][column] != ' '
  end

  def self.convert_column_input(char)
    case char
    when 'A' then 0
    when 'B' then 1
    when 'C' then 2
    else 3
    end
  end
end

# for grids actions
class Grid
  def draw_grid
    puts '   A   B   C '
    puts "1  #{@grid[0].join(' │ ')}"
    puts '  ───┼───┼───'
    puts "2  #{@grid[1].join(' │ ')}"
    puts '  ───┼───┼───'
    puts "3  #{@grid[2].join(' │ ')}"
  end

  def check_grid
    if win?('X')
      result = 'X'
    elsif win?('O')
      result = 'O'
    elsif draw?
      result = 'draw'
    else
      return
    end
    draw_grid
    result
  end

  def win?(value)
    [row_win?(value), column_win?(value), diagonal_win?(value)].any?
  end

  def initialize
    @grid = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']]
  end

  attr_reader :grid

  def update_grid(row, col, value)
    @grid[row][col] = value
  end

  def draw?
    @grid.flatten.all? { |a| a != ' ' }
  end

  def row_win?(value)
    @grid[0].all?(value) || @grid[1].all?(value) || @grid[2].all?(value)
  end

  def column_win?(value)
    @grid.map { |row| row[0] }.all?(value) || @grid.map { |row| row[1] }.all?(value) ||
      @grid.map { |row| row[2] }.all?(value)
  end

  def diagonal_win?(value)
    [@grid[0][0], @grid[1][1], @grid[2][2]].all?(value) || [@grid[0][2], @grid[1][1], @grid[2][0]].all?(value)
  end
end

Game.new
