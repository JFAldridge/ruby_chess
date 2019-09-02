require './lib/board.rb'

describe Pawn do
  before { @board = Board.new }

  describe '#is_move_allowed?' do

    describe 'rejects invalid move' do
      it 'one space forward when space is occupied by ally' do
        @board.current_state[2][5] = @board.current_state[1][6]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [2, 5])).to eq(false)
      end
      it 'one space forward when space is occupied by opponent' do
        @board.current_state[2][5] = @board.current_state[7][6]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [2, 5])).to eq(false)
      end
      it 'one space diagonally when space is occupied by ally' do
        @board.current_state[2][6] = @board.current_state[1][6]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [2, 6])).to eq(false)
      end
      it 'two spaces forward when first space is occupied by ally' do
        @board.current_state[2][5] = @board.current_state[1][6]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [3, 5])).to eq(false)
      end
      it 'two spaces forward when second space is occupied by ally' do
        @board.current_state[3][5] = @board.current_state[1][6]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [3, 5])).to eq(false)
      end
      it 'two spaces forward when second space is occupied by enemy' do
        @board.current_state[3][5] = @board.current_state[6][5]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [3, 5])).to eq(false)
      end
      it 'two spaces forward when not in starting position' do
        @board.current_state[2][5] = @board.current_state[1][5]
        expect(@board.current_state[2][5].is_move_allowed?([2, 5], [4, 5])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'one space forward when space is empty' do
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [2, 5])).to eq(true)
      end
      it 'one space diagonally when space is occupied by opponent' do
        @board.current_state[2][6] = @board.current_state[6][4]
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [2, 6])).to eq(true)
      end
      it 'two spaces forward when in starting position and both spaces ahead are empty' do
        expect(@board.current_state[1][5].is_move_allowed?([1, 5], [3, 5])).to eq(true)
      end
    end
  end

  describe '#checks_king?' do
    it 'returns true when it can attack the opponents king' do
      @board.current_state[5][4] = @board.current_state[0][4]
      expect(@board.current_state[6][3].checks_king?([6, 3])).to eq(true)
    end
    it 'returns false when it can not attack the opponents king' do
      @board.current_state[5][4] = @board.current_state[0][4]
      expect(@board.current_state[6][3].checks_king?([6, 3])).to eq(true)
    end
  end
end

