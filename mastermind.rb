# frozen_string_literal: true

# terminal colorizer
class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  
  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end
  
  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end

# This prints the board and everything in it
module Board
  def self.color_to_draw(str)
    case str
    when 'red' then '■'.red
    when 'green' then '■'.green
    when 'brown' then '■'.brown
    when 'blue' then '■'.blue
    when 'magenta' then '■'.magenta
    when 'cyan' then '■'.cyan
    end
  end

  def self.key_to_draw(str)
    case str
    when 'black_key' then '◯'.red.bold
    when 'white_key' then '△'.green.bold
    when 'no_key' then '🞨'.blue.bold
    end
  end

  def self.print_code(code)
    code.each { |color| print "#{color_to_draw(color)} " }
  end

  def self.print_key(key)
    key[0].times { print "#{key_to_draw('black_key')} " }
    key[1].times { print "#{key_to_draw('white_key')} " }
    key[2].times { print "#{key_to_draw('no_key')} " }
  end

  def self.draw_line(index, code, key)
    print "%02d" % index
    print ' │ '
    print_code(code)
    print '│ '
    print_key(key)
    print '│'
    draw_legend(index)
    puts ''
  end

  def self.draw_empty_line(index)
    print "%02d" % index
    print " │ #{'◦'.gray} #{'◦'.gray} #{'◦'.gray} #{'◦'.gray} │ #{'◦'.gray} #{'◦'.gray} #{'◦'.gray} #{'◦'.gray} │"
    draw_legend(index)
    puts ''
  end

  def self.draw_board(size, code_list, key_list)
    clear
    1.upto(size) { |row| draw_line(row, code_list[row - 1], key_list[row - 1]) }
    (size + 1).upto(12) { |row| draw_empty_line(row) }
    puts ''
  end

  def self.draw_legend(row)
    print '          '
    print case row
          when 1 then 'KEY'
          when 2 then '◯ correct color & position'.red
          when 3 then '△ correct color, wrong position'.green
          when 4 then '🞨 wrong color & position'.blue
          when 5 then 'COLORS'
          when 6 then '■ red'.red
          when 7 then '■ blue'.blue
          when 8 then '■ green'.green
          when 9 then '■ brown'.brown
          when 10 then '■ magenta'.magenta
          when 11 then '■ cyan'.cyan
          end
  end

  def self.clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end
end

# This creates, randomizes, and contains a code
class Code
  def initialize(is_random)
    @code = is_random ? random_code : %w[gray gray gray gray]
  end

  def random_code
    random_code = []
    for i in 1..4 
      random_code.push(random_color)
    end
    random_code
  end

  def random_color
    case rand(1..6)
    when 1 then 'red'
    when 2 then 'green'
    when 3 then 'brown'
    when 4 then 'blue'
    when 5 then 'magenta'
    when 6 then 'cyan'
    end
  end

  attr_accessor :code
end

# Makes an array of the key pegs [black pegs, white pegs, empty spaces]
class Key
  def self.count_black_keys(input_code, correct_code)
    # black key = correct color and position
    count = 0
    correct_code.each_with_index { |correct_sqr, index| count += 1 if correct_sqr == input_code[index] }
    count
  end

  def self.compare_key_numbers(input_value, correct_value)
    if correct_value == input_value || correct_value > input_value
      input_value
    elsif correct_value < input_value
      correct_value
    end
  end

  def self.count_white_keys(input_code, correct_code)
    # white key = correct color wrong position
    correct_count = correct_code.tally
    input_count = input_code.tally
    sum = 0
    correct_count.each_key do |key|
      sum += compare_key_numbers(input_count[key], correct_count[key]) if input_count.include?(key)
    end
    sum
  end

  def self.check_code(input_code, correct_code)
    black_keys = count_black_keys(input_code, correct_code)
    white_keys = count_white_keys(input_code, correct_code) - black_keys
    no_keys = 4 - black_keys - white_keys
    [black_keys, white_keys, no_keys]
  end

  def initialize(input_code, correct_code)
    @key = Key.check_code(input_code, correct_code)
  end

  attr_reader :key
end

class Game
  def game_loop
    for round_num in 1..12
      is_game_won = play_round(round_num)
      if is_game_won
        game_win
        break
      elsif round_num == 12
        game_lose
      end
    end
  end

  def play_round(round_num)
    @input_code_list.push(player_input_code)
    current_key = Key.new(@input_code_list[round_num - 1], @correct_code.code)
    @keys_list.push(current_key.key)
    Board.draw_board(round_num, @input_code_list, @keys_list)
    codes_match?(current_key.key)
  end

  def game_lose
    puts "You didn't guess the code :("
  end

  def codes_match?(current_key)
    current_key == [4, 0, 0]
  end

  def game_win
    puts 'Congratulations! You Guessed The Code!'
  end

  def player_input_code
    input_code = []
    1.upto(4) do
      input_color_display(input_code)
      input_code.push(input_color)
    end
    input_code
  end

  def input_color
    begin
      input = gets.chomp
      (raise 'Please enter a color from the list.') if %w[red green brown blue cyan magenta].none?(input)
    rescue StandardError => e
      puts e.message
      retry
    end
    input
  end

  def input_color_display(input_code)
    print 'Your code: '
    1.upto(input_code.size) { |i| print "#{Board.color_to_draw(input_code[i - 1])} " } unless input_code.empty?
    4.downto(input_code.size + 1) { print "#{'◦'.gray} " }
    print '  Enter a color: '
  end

  def initialize
    @input_code_list = []
    @keys_list = []
    Board.draw_board(0, [], [])
    @game_type = ask_game_type
    if @game_type == 1
      @correct_code = Code.new(true)
    else
      @correct_code = Code.new(false)
      p @correct_code.code = input_correct_code
    end
  end

  def input_correct_code
    puts 'Enter your code.'
    player_input_code
  end

  def ask_game_type
    puts 'Would you like to play as the codebreaker or the codemaker?'
    input_game_type
  end

  def input_game_type
    begin
      print 'Enter 1 for codebreaker, 2 for codemaker: '
      choice = gets.chomp.to_i
      (raise 'Please enter either 1 or 2.') unless [1, 2].include?(choice)
    rescue StandardError => e
      puts e.message
      retry
    end
    choice
  end
end

game = Game.new
game.game_loop
