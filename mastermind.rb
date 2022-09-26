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


module Board

  def draw_board; end

end

class Code

  def initialize(is_random)
    @code = is_random ? random_code : %w[gray gray gray gray]
    p @code
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

class Game; end
