require './lib/board.rb'

describe Board do
  before { @board = Board.new }

  it 'initializes with propper 2D array' do
    expect((@board.current_state[1][5]).instance_of? Pawn).to eq(true)
    expect((@board.current_state[1][5]).b_or_w).to eq('black')
    expect((@board.current_state[7][5]).instance_of? Bishop).to eq(true)
    expect((@board.current_state[7][5]).b_or_w).to eq('white')
  end

  describe '#checks_opponent_king?' do
    it 'returns false when an allied piece does not check the opponents king' do
      expect(@board.checks_opponent_king?('white')).to eq(false)
    end
    it 'returns true if checking the opponents king' do
      @board.current_state[2][3] = @board.current_state[7][1]
      expect(@board.checks_opponent_king?('white')).to eq(true)
    end
  end

  describe '#check_mate?' do
    it 'returns true if checkmated' do
      @board.current_state[5][5] = @board.current_state[6][5]
      @board.current_state[4][6] = @board.current_state[6][6]
      @board.current_state[6][5] = 0
      @board.current_state[6][6] = 0
      @board.current_state[4][7] = @board.current_state[0][3]
      @board.current_state[0][3] = 0
      expect(@board.check_mate?('black')).to eql(true)
    end
    it 'returns false if king can escape check' do
      @board.current_state[5][5] = @board.current_state[6][5]
      @board.current_state[4][6] = @board.current_state[6][6]
      @board.current_state[6][5] = 0
      @board.current_state[6][6] = 0
      @board.current_state[4][7] = @board.current_state[0][3]
      @board.current_state[0][3] = 0
      @board.current_state[5][3] = @board.current_state[6][3]
      @board.current_state[6][3] = 0
      expect(@board.check_mate?('black')).to eql(false)
    end
  end


end

