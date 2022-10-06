class Game
  def initialize
    @guessed_letters = []
    @wrong_guesses = 0
    @correct_word = random_word
    @correct_word_array = @correct_word.split(//).uniq
  end

  attr_accessor :guessed_letters, :wrong_guesses
  attr_reader :correct_word, :correct_word_array

  private
  def random_word
    word = ''
    until word.length <= 12 && word.length >= 5 do 
      word_file = File.open('google-10000-english-no-swears.txt', 'r')
      rand(1..9894).times { word = word_file.gets.chomp }
      word_file.close
    end
    word
  end
end

def draw_hangman(num)
  puts ' ╔════╗'
  print ' ║    '
  num >= 1 ? (puts '◯') : (puts '')
  print ' ║   '
  num >= 3 ? (print '▔') : (print ' ')
  num >= 2 ? (print '┃') : (print '')
  num >= 4 ? (puts '▔') : (puts '')
  print ' ║   '
  num >= 5 ? (print '╱ ') : (print '  ')
  num >= 6 ? (puts '╲') : (puts '')
  puts ' ║'
  puts ' ║'
  puts '═╩════════'
end

def input_letter
  print 'Guess a letter: '
  letter = gets.chomp
  raise 'Please enter a letter.' unless letter.match?(/[a-zA-Z]/)
  letter.downcase
rescue StandardError => e
  retry
end

def draw_screen(current_game)
  # clear
  draw_hangman(current_game.wrong_guesses)
  display_word(current_game)
  print_incorrect_letters(current_game)
end

def print_incorrect_letters(current_game)
  print 'Incorrect letters: '
  arr = current_game.guessed_letters - current_game.correct_word_array
  arr.each { |char| print "#{char} "}
  puts ''
end

def display_word(current_game)
  current_game.correct_word.each_char do |char|
    if current_game.guessed_letters.include?(char)
      print "#{char} "
    else
      print '▁ '
    end
  end
  puts ''
end

def clear
  if Gem.win_platform?
    system 'cls'
  else
    system 'clear'
  end
end

def game_over?(current_game)
  current_game.wrong_guesses >= 6 || is_word_guessed?(current_game)
end

def is_word_guessed?(current_game)
  (current_game.guessed_letters & current_game.correct_word_array).size == current_game.correct_word_array.size
end

current_game = Game.new
# until game_over?(current_game) do
#   draw_screen(current_game)
# end
p current_game.correct_word

draw_screen(current_game)
current_game.guessed_letters = %w[a b c d e f g h i j k l m n]
draw_screen(current_game)
current_game.guessed_letters = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
draw_screen(current_game)