require './lib/board.rb'


describe King do
  before { @board = Board.new }

  describe '#is_move_allowed?' do
  
    describe 'rejects invalid move' do
      it 'into allied pawn' do
        expect(@board.current_state[7][4].is_move_allowed?([7, 4], [6, 4])).to eq(false)
      end
      it 'outside range' do
        @board.current_state[6][4] = 0
        expect(@board.current_state[7][4].is_move_allowed?([7, 4], [5, 4])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'into empty space' do
        @board.current_state[6][4] = 0
        expect(@board.current_state[7][4].is_move_allowed?([7, 4], [6, 4])).to eq(true)
      end
      it 'into enemy pawn' do
        @board.current_state[6][4] = @board.current_state[1][4]
        expect(@board.current_state[7][4].is_move_allowed?([7, 4], [6, 4])).to eq(true)
      end
    end
  end

  describe '#checks_king?' do
    it 'returns true when it can attack the opponents king' do
      @board.current_state[6][4] = @board.current_state[0][4]
      expect(@board.current_state[6][4].checks_king?([6, 4])).to eq(true)
    end
    it 'returns false when it can not attack the opponents king' do
      expect(@board.current_state[0][4].checks_king?([0, 4])).to eq(false)
    end
  end

  describe '#checks_allied_king?' do
    it 'returns true if a destination will put the king into check' do
      expect(@board.current_state[0][4].checks_allied_king?([5, 2])).to eq(true)
    end

    it 'returns false if a destination will not put the king into check' do
      expect(@board.current_state[0][4].checks_allied_king?([3, 3])).to eq(false)
    end
  end
end