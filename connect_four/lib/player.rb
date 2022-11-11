# frozen_string_literal: true

class Player
  def initialize(name = 'Chuu')
    @name = name
  end

  attr_reader :name
end