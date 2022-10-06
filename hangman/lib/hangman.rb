class Game
  def initialize
    @guessed_letters = []
    @wrong_guesses = 0
    @correct_word = random_word
  end

  attr_accessor :guessed_letters, :wrong_guesses
  attr_reader :correct_word

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
  print 'Enter a letter: '
  letter = gets.chomp
  raise 'Please enter a letter.' unless letter.match?(/[a-zA-Z]/)
  letter.downcase
rescue StandardError => e
  retry
end

def draw_screen(current_game)
  clear
  draw_hangman(current_game.wrong_guesses)
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
  word_array = current_game.correct_word.split(//).uniq
  (current_game.guessed_letters & word_array).size == word_array.size
end

current_game = Game.new
until game_over?(current_game) do 
  draw_screen(current_game)
end
# %w[a b c d e f g h i j k l m n]
# %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]