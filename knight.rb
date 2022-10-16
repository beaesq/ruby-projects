# frozen_string_literal: true

# squares on the board
class Square
  def initialize(coordinates)
    @coordinates = coordinates
    @north = nil
    @west = nil
    @south = nil
    @east = nil
  end

  attr_accessor :coordinates
  attr_reader :north, :west, :south, :east

  def set_edges!
    
  end
end

class Board
  def initialize
     for x in 0..7
      for y in 0..7
        sq = Square.new([x, y])
        sq.set_edges!
        @root = sq if [0, 0].eql?([x, y])
      end
    end
  end
end