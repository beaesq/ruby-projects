# frozen_string_literal: true

# squares on the board
class Square
  def initialize(coordinates)
    @coordinates = coordinates
    @x = coordinates[0]
    @y = coordinates[1]
    @north = nil
    @west = nil
    @south = nil
    @east = nil
  end

  attr_accessor :coordinates, :x, :y, :north, :west, :south, :east

  def connect_north_south_square!(south_square)
    self.south = south_square
    south_square.north = self unless south_square.nil?
  end

  def connect_east_west_square!(west_square)
    self.west = west_square
    west_square.east = self unless west_square.nil?
  end
end

class Board
  def initialize
    @board_array = []
    make_board
    connect_north_south
    connect_east_west
  end

  attr_reader :board_array, :root

  private

  def connect_north_south
    north_sq = nil
    for x in 0..7
      for y in 0..7
        south_sq = y.zero? ? nil : north_sq
        north_sq = @board_array[x][y]
        north_sq.connect_north_south_square!(south_sq)
      end
    end
  end

  def connect_east_west
    east_sq = nil
    for y in 0..7
      for x in 0..7
        west_sq = x.zero? ? nil : east_sq
        east_sq = @board_array[x][y]
        east_sq.connect_east_west_square!(west_sq)
      end
    end
  end

  def make_board
    line_array = []
     for x in 0..7
      for y in 0..7
        new_sq = Square.new([x, y])
        line_array << new_sq
        @root = new_sq if [0, 0].eql?([x, y])
      end
      @board_array << line_array
      line_array = []
    end
  end
end

board = Board.new
pp board.board_array[0][0].west
# pp board.board_array[1][1].west
# pp board.board_array[4][3]
# pp board.board_array[7][7]