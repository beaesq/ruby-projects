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
    puts '│'
  end

  def self.draw_board(size, code_list, key_list)
    1.upto(size) { |row| draw_line(row, code_list[row-1], key_list[row-1])}
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

  attr_reader :code
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

class Game; end

keys_list = []
input_code_list = [['blue','blue','green','red'],['blue','green','green','red'],['blue','magenta','brown','cyan']]
p correct_code = Code.new(true)
0.upto(input_code_list.size - 1) do |index|
  current_key = Key.new(input_code_list[index], correct_code.code)
  keys_list.push(current_key.key)
  Board.draw_board(index + 1, input_code_list, keys_list) # change first parameter to input length later
  puts ''
end
