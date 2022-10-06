class Game
  def initialize
    @guessed_letters = {}
    @guess_counter = 0
    @correct_word = random_word
  end

  def self.random_word
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
