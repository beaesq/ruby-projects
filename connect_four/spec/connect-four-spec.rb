# frozen_string_literal: true

require_relative '../lib/main'

describe Game do
  subject(:new_game) { described_class.new }
  let(:player_a) { instance_double(Player, name: 'Chuu', token: 'O') }
  let(:player_b) { instance_double(Player, name: 'Yves') }

  describe '#make_grid' do
    it 'can create a grid with 7 columns with a maximum height of 6' do
      grid_array = new_game.make_grid
      column = grid_array.length
      height = new_game.maximum_height
      expect(height).to eq(6)
      expect(column).to eq(7)
      expect(grid_array[0]).to eq([]) # bad!
    end
  end

  describe '#add_token' do
    before(:each) do
      @test_grid = [[], [], [], [], [], [], []]
    end
    it 'adds token to empty column' do
      column = 0
      token = 'O'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq([token])
      expect(new_grid[1..6]).to all(eq([]))
    end

    it 'adds token to non-empty column' do
      column = 6
      token = 'O'
      @test_grid[column] = [token, token]
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq([token, token, token])
      expect(new_grid[0..5]).to all(eq([]))
    end

    it 'does not add token when column is full' do
      column = 6
      token = 'O'
      @test_grid[column] = [token, token, token, token, token, token]
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq([token, token, token, token, token, token])
      expect(new_grid[0..5]).to all(eq([]))
    end

    it 'is not able to add token outside grid' do
      column = 7
      token = 'O'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[0..6]).to all(eq([]))
    end
  end

  describe '#set_players' do
    before do
      allow(new_game).to receive(:gets).and_return('Yves', 'Chuu')
      allow(new_game).to receive(:print)
    end

    it 'makes two players' do
      expect(Player).to receive(:new).with('Yves', 'O').at_most(:once)
      expect(Player).to receive(:new).with('Chuu', '0').at_most(:once)
      new_game.set_players
    end
  end

  describe '#game_over?' do
    context 'when game is won' do
      xit 'returns true' do
      end
    end
    
    context 'when game is not over' do
      xit 'returns false' do
      end
    end
  end
  
  describe '#win_vertical?' do
    context 'when four tokens connect vertically' do
      before do
        @test_grid = [['X', 'O'], ['X', 'O', 'X', 'O', 'X', 'O'], [], [], ['X', 'O', 'O', 'O', 'O'], ['X'], []]
      end
      xit 'returns true' do
        
      end
    end
    context 'when no tokens connect' do
      xit 'returns false' do
      end
    end
  end

  describe '#win_horizontal?' do
    context 'when four tokens connect horizontally' do
      xit 'returns true' do
      end
    end
    context 'when no tokens connect' do
      xit 'returns false' do
      end
    end
  end

  describe '#win_diagonal_down?' do
    context 'when four tokens connect diagonally \\' do
      xit 'returns true' do
      end
    end
    context 'when no tokens connect' do
      xit 'returns false' do
      end
    end
  end

  describe '#win_diagonal_up?' do
    context 'when four tokens connect diagonally /' do
      xit 'returns true' do
      end
    end
    context 'when no tokens connect' do
      xit 'returns false' do
      end
    end
  end
end
