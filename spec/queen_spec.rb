require './lib/board.rb'

describe Queen do
  before { @board = Board.new }

  describe '#is_move_allowed?' do
  
    describe 'rejects invalid move' do
      it 'four spaces forward when blocked by pawn' do
        expect(@board.current_state[0][3].is_move_allowed?([0, 3], [4, 3])).to eq(false)
      end
      it 'four spaces diagonally when blocked by pawn' do
        expect(@board.current_state[0][3].is_move_allowed?([0, 3], [4, 7])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'four spaces forward when spaces are open' do
        @board.current_state[1][3] = 0
        expect(@board.current_state[0][3].is_move_allowed?([0, 3], [4, 3])).to eq(true)
      end
      it 'four spaces diagonally when spaces are open' do
        @board.current_state[1][4] = 0
        expect(@board.current_state[0][3].is_move_allowed?([0, 3], [4, 7])).to eq(true)
      end
      it 'four spaces diagonally to take pawn' do
        @board.current_state[1][4] = 0
        @board.current_state[4][7] = @board.current_state[6][7]
        expect(@board.current_state[0][3].is_move_allowed?([0, 3], [4, 7])).to eq(true)
      end
    end
  end

  describe '#checks_king?' do
    it 'returns true when it can attack the opponents king' do
      @board.current_state[2][4] = @board.current_state[0][3]
      @board.current_state[6][4] = 0
      expect(@board.current_state[2][4].checks_king?([2, 4])).to eq(true)
    end
    it 'returns false when it can not attack the opponents king' do
      @board.current_state[2][4] = @board.current_state[0][3]
      expect(@board.current_state[2][4].checks_king?([2, 4])).to eq(false)
    end
  end

  describe '#checks_allied_king?' do
    it 'does not return true when you check opponent king' do
      @board.current_state[4][4] = @board.current_state[7][3]
      expect(@board.current_state[4][4].checks_allied_king?([1, 4])).to eq(false)
    end
  end
end