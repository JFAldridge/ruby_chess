require './lib/board.rb'

describe Knight do
  before { @board = Board.new }

  describe '#is_move_allowed?' do
  
    describe 'rejects invalid move' do
      it 'into allied pawn' do
        expect(@board.current_state[0][1].is_move_allowed?([0, 1], [1, 3])).to eq(false)
      end
      it 'outside range' do
        expect(@board.current_state[0][1].is_move_allowed?([0, 1], [2, 3])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'into empty space' do
        expect(@board.current_state[0][1].is_move_allowed?([0, 1], [2, 2])).to eq(true)
      end
      it 'into enemy pawn' do
        @board.current_state[2][2] = @board.current_state[6][2]
        expect(@board.current_state[0][1].is_move_allowed?([0, 1], [2, 2])).to eq(true)
      end
    end
  end

  describe '#checks_king?' do
    it 'returns true when it can attack the opponents king' do
      @board.current_state[2][5] = @board.current_state[7][6]
      expect(@board.current_state[2][5].checks_king?([2, 5])).to eq(true)
    end
    it 'returns false when it can not attack the opponents king' do
      expect(@board.current_state[7][6].checks_king?([7, 6])).to eq(false)
    end
  end
end

