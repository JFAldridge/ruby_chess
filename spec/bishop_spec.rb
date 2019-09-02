require './lib/board.rb'


describe Bishop do
  before { @board = Board.new }

  describe '#is_move_allowed?' do
  
    describe 'rejects invalid move' do
      it 'four spaces diagonally when blocked by ally pawn' do
        expect(@board.current_state[7][5].is_move_allowed?([7, 5], [3, 1])).to eq(false)
      end
      it 'five spaces straight forward when spaces are emtpy' do
        @board.current_state[6][5] = 0
        expect(@board.current_state[7][5].is_move_allowed?([7, 5], [2, 5])).to eq(false)
      end
    end

    describe 'accepts valid move' do
      it 'four spaces diagonally when spaces are empty' do
        @board.current_state[6][4] = 0
        expect(@board.current_state[7][5].is_move_allowed?([7, 5], [3, 1])).to eq(true)
      end
      it 'four spaces diagonally to take a pawn' do
        @board.current_state[6][4] = 0
        @board.current_state[3][1] = @board.current_state[1][1]
        expect(@board.current_state[7][5].is_move_allowed?([7, 5], [3, 1])).to eq(true)
      end
    end
  end

  it "holds the proper unicode" do
    expect(@board.current_state[7][2].uni).to eq("\u2657")
  end
end

