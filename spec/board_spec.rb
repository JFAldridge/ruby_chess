require './lib/board.rb'

describe Board do
  before { @board = Board.new }

  it 'initializes with propper 2D array' do
    expect((@board.current_state[1][5]).instance_of? Pawn).to eq(true)
    expect((@board.current_state[1][5]).b_or_w).to eq('black')
    expect((@board.current_state[7][5]).instance_of? Bishop).to eq(true)
    expect((@board.current_state[7][5]).b_or_w).to eq('white')
  end

  describe '#checks_enemy_king' do
    it 'returns false when an allied piece does not check the enemy king' do
      expect(@board.checks_enemy_king('white')).to eq(false)
    end
  end

end

