# frozen_string_literal: true

# player name & token & other things
class Player
  def initialize(name, token = 'O')
    @name = name
    @token = token
  end

  attr_reader :name, :token
end
