# frozen_string_literal: true

require_relative '../lib/main'

describe Game do
  subject(:new_game) { described_class.new }
  let(:player_a) { instance_double(Player, name: 'Chuu', token: 'O') }
  let(:player_b) { instance_double(Player, name: 'Yves') }

  describe '#make_grid' do
    it 'creates 7x6 empty grid' do
      grid_array = new_game.make_grid
      column = grid_array.length
      rows = []
      7.times do |index|
        rows << grid_array[index].length
      end
      expect(rows).to all(eq(6))
      expect(column).to eq(7)
    end
  end

  describe '#add_token' do
    before(:each) do
      test_column = Array.new(6)
      @test_grid = Array.new(7, test_column)
    end
    it 'adds token in empty column' do
      column = 0
      new_game.add_token(column, @test_grid)
      expect(test_grid[column][0]).not_to eq(nil)
      expect(test_grid[column][1..5]).to all( be_nil )
    end

    xit 'adds token non-empty column' do
    end

    xit 'does not add token when column is full' do
    end

    xit 'is not able to add token outside grid' do
      
    end
  end

  describe '#set_players' do
    xit 'makes two players' do
      
    end
  end
end