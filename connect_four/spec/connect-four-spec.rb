# frozen_string_literal: true

require_relative '../lib/main'

describe Game do
  subject(:new_game) { described_class.new }

  describe '#make_grid' do
    it 'can create a grid with 7 columns with a maximum height of 6' do
      grid_array = new_game.make_grid
      column = grid_array.length
      height = new_game.maximum_height
      expect(height).to eq(6)
      expect(column).to eq(7)
      expect(grid_array[0]).to eq('') # bad!
    end
  end

  describe '#add_token' do
    before(:each) do
      @test_grid = ['', '', '', '', '', '', '']
    end
    it 'adds token to empty column' do
      column = 0
      token = 'O'
      correct_column = 'O'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq(correct_column)
      expect(new_grid[1..6]).to all(eq(''))
    end

    it 'adds token to non-empty column' do
      column = 6
      token = 'O'
      correct_column = 'OOO'
      @test_grid[column] = 'OO'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq(correct_column)
      expect(new_grid[0..5]).to all(eq(''))
    end

    it 'does not add token when column is full' do
      column = 6
      token = 'O'
      correct_column = 'OOOOOO'
      @test_grid[column] = 'OOOOOO'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[column]).to eq(correct_column)
      expect(new_grid[0..5]).to all(eq(''))
    end

    it 'is not able to add token outside grid' do
      column = 7
      token = 'O'
      new_grid = new_game.add_token(column, token, @test_grid)
      expect(new_grid[0..6]).to all(eq(''))
    end
  end

  describe '#set_players' do
    before do
      allow(new_game).to receive(:gets).and_return('Yves', 'Chuu')
      allow(new_game).to receive(:print)
    end

    it 'makes two players' do
      expect(Player).to receive(:new).with('Yves', '◉').at_most(:once)
      expect(Player).to receive(:new).with('Chuu', '○').at_most(:once)
      new_game.set_players
    end
  end

  describe '#game_won?' do
    context 'when game is won' do
      test_grid = ['○◉○○◉', '◉◉○○', '○○○○◉○', '○○◉◉○○', '○○◉◉○', '○◉○○◉○', '○']
      subject(:win_game) { described_class.new(test_grid) }

      it 'returns true' do
        result = win_game.game_won?('◉')
        expect(result).to be true
      end
    end

    context 'when game is not won' do
      test_grid = ['○○○○◉', '◉◉○○', '○○○○◉○', '○○◉◉○○', '○○◉◉○', '○○○○◉○', '○']
      subject(:win_game) { described_class.new(test_grid) }

      it 'returns false' do
        result = win_game.game_won?('◉')
        expect(result).to be false
      end
    end
  end
  
  describe '#win_vertical?' do
    context 'when four tokens connect vertically' do
      before do
        @test_grid = ['OOXX', 'XOOXOX', 'OOXOOO', 'XXOOOO', 'OOX', 'X', 'OO']
      end
      it 'returns true' do
        result = new_game.win_vertical?('O', @test_grid)
        expect(result).to be true
      end
    end
    context 'when no tokens connect' do
      before do
        @test_grid = ['OOXX', 'XOOXOX', 'OOXOOO', 'XXOOXO', 'OOXXXX', 'X', 'OO']
      end
      it 'returns false' do
        result = new_game.win_vertical?('O', @test_grid)
        expect(result).to be false
      end
    end
  end

  describe '#win_horizontal?' do
    context 'when four tokens connect horizontally' do
      before do
        @test_grid = ['OOXX', 'XXXX', 'XOXXX', 'OOOXXX', 'OOXXO', 'XOX', 'X']
      end
      it 'returns true' do
        result = new_game.win_horizontal?('O', @test_grid)
        expect(result).to be true
      end
    end
    context 'when no tokens connect' do
      before do
        @test_grid = ['OOXX', 'XXXX', 'XOXXX', 'OOOXXX', 'OXXO', 'XOX', '']
      end
      it 'returns false' do
        result = new_game.win_horizontal?('O', @test_grid)
        expect(result).to be false
      end
    end
  end

  describe '#win_diagonal_down?' do
    context 'when four tokens connect diagonally \\' do
      before do
        @test_grid = ['12345', '9876', 'XXXXOX', 'XXOOXX', 'XXOOX', 'XOXXOX', 'X']
      end
      it 'returns true' do
        result = new_game.win_diagonal_down?('O', @test_grid)
        expect(result).to be true
      end
    end
    context 'when no tokens connect' do
      before do
        @test_grid = ['12345', '9876', 'XXXXXX', 'XXOOXX', 'XXOOX', 'XOXXOX', 'X']
      end
      it 'returns false' do
        result = new_game.win_diagonal_down?('O', @test_grid)
        expect(result).to be false
      end
    end
  end

  describe '#win_diagonal_up?' do
    context 'when four tokens connect diagonally /' do
      before do
        @test_grid = ['12345', '9876', 'XOXXXX', 'XXOOXX', 'XXOOX', 'XXXXOX', 'O']
      end
      it 'returns true' do
        result = new_game.win_diagonal_up?('O', @test_grid)
        expect(result).to be true
      end
    end
    context 'when no tokens connect' do
      before do
        @test_grid = ['12345', '9876', 'XOXXXX', 'XXOOXX', 'XXOOX', 'XXXXXX', 'O']
      end
      it 'returns false' do
        result = new_game.win_diagonal_up?('O', @test_grid)
        expect(result).to be false
      end
    end
  end

  describe '#grid_full?' do
    context 'when grid is full' do
      test_grid = ['○○○○○◉', '○○◉◉○○', '○○○○◉○', '○○◉◉○○', '○○◉◉○○', '○○○○◉○', '○○○○○○']
      subject(:full_game) { described_class.new(test_grid) }
      it 'return true' do
        full_game.instance_variable_set(:@maximum_height, 6)
        expect(full_game).to be_grid_full
      end
    end

    context 'when grid is not full' do
      test_grid = ['○○○○◉', '○○◉◉○○', '○○○○◉○', '○○◉◉○○', '○○◉◉○○', '○○○○◉○', '○○○○○○']
      subject(:not_full_game) { described_class.new(test_grid) }
      it 'return false' do
        not_full_game.instance_variable_set(:@maximum_height, 6)
        expect(not_full_game).not_to be_grid_full
      end
    end
  end

  describe '#game_loop' do
    context 'when game is won' do
      xit 'ends game' do
        
      end
    end

    context 'when grid is filled and no one has won' do
      xit 'ends game' do
        
      end
    end
  end
end
