require_relative 'pieces.rb'

class Bishop < Pieces
  DIRECTIONS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def initialize(b_or_w, board)
    super(b_or_w, board)
    @uni = @b_or_w == 'white' ? "\u2657" : "\u265D"
  end

  attr_reader :uni

  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves(loc[0], loc[1])

    allowed_moves.include?(dest)
  end

  def find_allowed_moves(y, x)
    find_allowed_moves_crossboard(y, x, DIRECTIONS)
  end

  def checks_king?(loc) 
    checks_king_crossboard?(loc[0], loc[1], DIRECTIONS)
  end

end
