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
    build_knight_tree(end_coordinates)
  end

  def build_knight_tree(end_coordinates)
    until @queue.length <= 0
      break if @unvisited_squares.empty?

      current_coordinates = @queue.shift
      next unless @unvisited_squares.include?(current_coordinates)

      current_square = find(current_coordinates)
      @unvisited_squares.delete(current_coordinates)
      make_children(current_square)
      current_square.children.each do |child_square|
        @queue.push(child_square.coordinates)
      end
      if end_coordinates == current_coordinates
        show_parent(end_coordinates)
        break
      end
    end
  end

  def show_parent(end_coordinates)
    current_square = find(end_coordinates)
    path = []
    until current_square.nil?
      path << current_square.coordinates
      current_square = current_square.parent
    end
    puts "You made it in #{path.size - 1} moves! Here's your path:"
    path.reverse.each { |coord| p coord }
  end

  def make_children(current_square)
    moves = [[-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1]]
    moves.map! { |move| move.zip(current_square.coordinates).map { |a, b| a + b } }
    moves.keep_if { |x, y| x <= 7 && x >= 0 && y <= 7 && y >= 0 }
    moves.keep_if { |move| @unvisited_squares.include?(move)}
    current_square.children = moves.map { |move| find(move) }
    assign_parent(current_square.children, current_square)
  end

  def assign_parent(children_square, parent_square)
    children_square.each do |child_square|
      child_square.parent = parent_square
    end
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
board.knight_moves([3,3], [4,3])
