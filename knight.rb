# frozen_string_literal: true

# square nodes
class Square
  def initialize(coordinates, parent = nil)
    @coordinates = coordinates
    @x = coordinates[0]
    @y = coordinates[1]
    @children = []
    @parent = parent
  end

  attr_accessor :coordinates, :x, :y, :children, :parent
end

# board
class Board
  def initialize
    @board_array = []
    make_board
  end

  def make_board
    line_array = []
    8.times do |x|
      8.times do |y|
        new_sq = Square.new([x, y])
        line_array << new_sq
        # @root = new_sq if [0, 0].eql?([x, y])
      end
      @board_array << line_array
      line_array = []
    end
  end

  def find(coordinates)
    return nil if coordinates.nil?

    x = coordinates[0]
    y = coordinates[1]
    @board_array[x][y]
  end

  attr_reader :board_array

  def knight_moves(start_coordinates, end_coordinates)
    @queue = []
    @unvisited_squares = list_all_squares
    @queue.push(start_coordinates) if @queue.empty?
    build_knight_tree(start_coordinates, end_coordinates)
  end

  def build_knight_tree(start_coordinates, end_coordinates)

  end

  def make_children(current_square)
    moves = [[-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1]]
    moves.map! { |move| move.zip(current_square.coordinates).map { |a, b| a + b } }
    moves.keep_if { |x, y| x <= 7 && x >= 0 && y <= 7 && y >= 0 }
    current_square.children = moves.map { |move| find(move) }
  end

  def enqueue_children(current_square)
    current_square.children.each { |child| @queue.push(child.coordinates) }
  end

  def list_all_squares
    arr = []
    8.times do |x|
      8.times do |y|
        arr << [x, y]
      end
    end
    arr
  end
end

board = Board.new
p board.knight_moves([0,0], [2,2])
