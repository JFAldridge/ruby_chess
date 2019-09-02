require './lib/board.rb'

describe Rook do
  before { @board = Board.new }

  describe '#is_move_allowed?' do
  
    describe 'rejects invalid move' do
      it 'four spaces forward when blocked by pawn' do
        expect(@board.current_state[7][7].is_move_allowed?([7, 7], [3, 7])).to eq(false)
      end
      it 'one space forward into pawns space' do
        expect(@board.current_state[7][7].is_move_allowed?([7, 7], [6, 7])).to eq(false)
      end
      it 'two spaces diagonally when spaces are open' do
        @board.current_state[6][6] = 0
        expect(@board.current_state[7][7].is_move_allowed?([7, 7], [5, 5])).to eq(false)
      end
      it 'one space past opponent queen' do
        @board.current_state[4][7] = @board.current_state[7][7]
        @board.current_state[4][2] = @board.current_state[0][3]
        expect(@board.current_state[4][7].is_move_allowed?([4, 7], [4, 1])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'four spaces forward when spaces are open' do
        @board.current_state[6][7] = 0
        expect(@board.current_state[7][7].is_move_allowed?([7, 7], [3, 7])).to eq(true)
      end
      it 'five spaces sideways when to take queen' do
        @board.current_state[4][7] = @board.current_state[7][7]
        @board.current_state[4][2] = @board.current_state[0][3]
        expect(@board.current_state[4][7].is_move_allowed?([4, 7], [4, 2])).to eq(true)
      end
    end
  end

  describe '#checks_king?' do
    it 'returns true when it can attack the opponents king' do
      @board.current_state[2][4] = @board.current_state[0][0]
      @board.current_state[6][4] = 0
      expect(@board.current_state[2][4].checks_king?([2, 4])).to eq(true)
    end
    it 'returns false when it can not attack the opponents king' do
      @board.current_state[2][4] = @board.current_state[0][0]
      expect(@board.current_state[2][4].checks_king?([2, 4])).to eq(false)
    end
  end
end



