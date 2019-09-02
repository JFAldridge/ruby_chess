require './lib/board.rb'

describe Board do
  before { @board = Board.new }

  it 'initializes with propper 2D array' do
    expect((@board.current_state[1][5]).instance_of? Pawn).to eq(true)
    expect((@board.current_state[1][5]).b_or_w).to eq('black')
    expect((@board.current_state[7][5]).instance_of? Bishop).to eq(true)
    expect((@board.current_state[7][5]).b_or_w).to eq('white')
  end

  describe '#checks_opponent_king' do
    it 'returns false when an allied piece does not check the opponents king' do
      expect(@board.checks_opponent_king('white')).to eq(false)
    end
    it 'returns the color and class of the piece checking the opponents king' do
      @board.current_state[2][3] = @board.current_state[7][1]
      expect(@board.checks_opponent_king('white')).to eq('White knight')
    end
  end

end

