# frozen_string_literal: true

require 'json'

# contains game data
class Game
  def initialize
    @guessed_letters = []
    @wrong_guesses = 0
    @correct_word = random_word
    @correct_word_array = @correct_word.split(//).uniq
  end

  attr_accessor :guessed_letters, :wrong_guesses
  attr_reader :correct_word, :correct_word_array

  def save
    data = make_hash
    filename = input_savefile_name
    File.open("#{filename}.json", 'w') { |file| file.puts(JSON.dump(data)) }
  end

  private

  def input_savefile_name
    print 'Name your save file (only alphanumberic chars and _ please): '
    name = gets.chomp
    raise 'Only alphanumberic characters and _ please.' unless name.match?(/^[0-9a-zA-Z_]+$/)

    name
  rescue StandardError => e
    puts e.message
    retry
  end

  def make_hash
    {
      'guessed_letters': @guessed_letters,
      'wrong_guesses': @wrong_guesses,
      'correct_word': @correct_word,
      'correct_word_array': @correct_word_array
    }
  end

  def random_word
    word = ''
    until word.length <= 12 && word.length >= 5
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

def input_letter(current_game)
  print "Guess a letter (or enter 'save' to save your game): "
  letter = gets.chomp
  if letter == 'save'
    current_game.save
    raise 'Game saved.'
  end
  raise 'Please enter a letter.' unless letter.match?(/[a-zA-Z]/)
  raise 'Please enter only one letter.' if letter.length > 1
  raise 'Please enter a new letter.' if current_game.guessed_letters.include?(letter.downcase)

  letter.downcase
rescue StandardError => e
  puts e.message
  retry
end

def draw_screen(current_game)
  clear
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
  current_game.wrong_guesses >= 6 || word_guessed?(current_game)
end

def word_guessed?(current_game)
  (current_game.guessed_letters & current_game.correct_word_array).size == current_game.correct_word_array.size
end

def print_game_over(current_game)
  (puts "oh no! the word was #{current_game.correct_word} :P") if current_game.wrong_guesses >= 6
  (puts 'you guessed the word :o') if word_guessed?(current_game)
end

def check_wrong_guess(current_game, letter)
  current_game.wrong_guesses += 1 if current_game.correct_word_array.none?(letter)
end

current_game = Game.new
# p current_game.correct_word
until game_over?(current_game)
  draw_screen(current_game)
  letter = input_letter(current_game)
  current_game.guessed_letters.push(letter)
  check_wrong_guess(current_game, letter)
end

draw_screen(current_game)
print_game_over(current_game)

# draw_screen(current_game)
# current_game.guessed_letters = %w[a b c d e f g h i j k l m n]
# draw_screen(current_game)
# current_game.guessed_letters = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
# draw_screen(current_game)