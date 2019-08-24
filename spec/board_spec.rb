require './lib/board.rb'

describe Board do
  before { @board = Board.new }

  it 'initializes with propper 2D array' do
    expect((@board.current_state[1][5]).instance_of? Pawn).to eq(true)
    expect((@board.current_state[1][5]).b_or_w).to eq('black')
    expect((@board.current_state[7][5]).instance_of? Bishop).to eq(true)
    expect((@board.current_state[7][5]).b_or_w).to eq('white')
  end

end

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
end

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
end

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
end