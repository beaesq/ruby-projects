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
    context 'when game_won? and grid_filled? are both false then game_won? is true' do
      test_grid = ['', '○', '○', '○', '', '', '']
      subject(:win_game) { described_class.new(test_grid) }
      let(:player_a) { instance_double(Player, name: 'Yves', token: '◉') }
      let(:player_b) { instance_double(Player, name: 'Chuu', token: '○') }

      before do
        allow(win_game).to receive(:game_won?).and_return(false, true)
        allow(win_game).to receive(:grid_full?).and_return(false)
        win_game.instance_variable_set(:@current_player, player_a)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
        win_game.instance_variable_set(:@maximum_height, 6)
        allow(win_game).to receive(:display_board)
        allow(win_game).to receive(:player_add_token)
      end
      it 'calls display_board and player_add_token one time' do
        expect(win_game).to receive(:display_board).with(test_grid, 6, player_a, player_b).twice
        expect(win_game).to receive(:player_add_token).twice
        win_game.game_loop
      end

      it 'changes the player' do
        win_game.game_loop
        current_player = win_game.instance_variable_get(:@current_player)
        expect(current_player.token).to eq('○')
      end
    end

    context 'when game_won? and grid_filled? are both false then grid_filled? is true' do
      test_grid = ['', '○', '○', '○', '', '', '']
      subject(:win_game) { described_class.new(test_grid) }
      let(:player_a) { instance_double(Player, name: 'Yves', token: '◉') }
      let(:player_b) { instance_double(Player, name: 'Chuu', token: '○') }

      before do
        allow(win_game).to receive(:game_won?).and_return(false)
        allow(win_game).to receive(:grid_full?).and_return(false, true)
        win_game.instance_variable_set(:@current_player, player_a)
        win_game.instance_variable_set(:@player_a, player_a)
        win_game.instance_variable_set(:@player_b, player_b)
        win_game.instance_variable_set(:@maximum_height, 6)
        allow(win_game).to receive(:display_board)
        allow(win_game).to receive(:player_add_token)
      end
      it 'calls display_board and player_add_token one time' do
        expect(win_game).to receive(:display_board).with(test_grid, 6, player_a, player_b).once
        expect(win_game).to receive(:player_add_token).once
        win_game.game_loop
      end

      it 'changes the player' do
        win_game.game_loop
        current_player = win_game.instance_variable_get(:@current_player)
        expect(current_player.token).to eq('○')
      end
    end
  end

  # describe '#play_game' do
    
  # end

  describe '#player_add_token' do
    test_grid = ['', '○', '○', '○', '', '', '']
    subject(:ongoing_game) { described_class.new(test_grid) }
    let(:player_a) { instance_double(Player, name: 'Yves', token: '◉') }
    before do
      allow(ongoing_game).to receive(:print)
      allow(ongoing_game).to receive(:check_column_input).and_return(6)
      ongoing_game.instance_variable_set(:@current_player, player_a)
      ongoing_game.instance_variable_set(:@player_a, player_a)
      ongoing_game.instance_variable_set(:@maximum_height, 6)
    end
    it 'adds the token' do
      ongoing_game.player_add_token
      grid = ongoing_game.instance_variable_get(:@grid)
      expect(grid).to eq(['', '○', '○', '○', '', '', '◉'])
    end
  end

  describe '#check_column_input' do
    context 'when given an invalid input twice then a valid input' do
      before do
        allow(new_game).to receive(:gets).and_return('A', '10', '1')
        allow(new_game).to receive(:print)
      end
      it 'asks for input three times and returns 0' do
        expect(new_game).to receive(:print).twice
        result = new_game.check_column_input
        expect(result).to eq(0)
      end
    end

    context 'when given an input greater than the grid length then a valid input' do
      before do
        allow(new_game).to receive(:gets).and_return('8', '7')
        allow(new_game).to receive(:print)
      end
      it 'asks for input twice and returns 6' do
        expect(new_game).to receive(:print).once
        result = new_game.check_column_input
        expect(result).to eq(6)
      end
    end
  end

  describe '#arrange_grid_by_row' do
    context 'when grid has empty columns' do
      test_grid = ['', '○', '○', '○○', '', '', '◉○']
      subject(:incomplete_game) { described_class.new(test_grid) }
      it 'has spaces for empty columns' do
        maximum_height = 6
        result_grid = incomplete_game.arrange_grid_by_row(test_grid, maximum_height)
        expect(result_grid).to eq([' ○○○  ◉', '   ○  ○', '       ', '       ', '       ', '       '])
      end
    end

    context 'when grid is full' do
      test_grid = ['◉○◉○◉○', '◉○◉○◉○', '◉○◉○◉○', '◉○◉○◉○', '◉○◉○◉○', '◉○◉○◉○', '◉○◉○◉○']
      subject(:full_game) { described_class.new(test_grid) }
      it 'has spaces for empty columns' do
        maximum_height = 6
        result_grid = full_game.arrange_grid_by_row(test_grid, maximum_height)
        expect(result_grid).to eq(['◉◉◉◉◉◉◉', '○○○○○○○', '◉◉◉◉◉◉◉', '○○○○○○○', '◉◉◉◉◉◉◉', '○○○○○○○'])
      end
    end
  end
end
