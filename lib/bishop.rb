require_relative 'pieces.rb'

class Bishop < Pieces
  DIRECTIONS = [[1, 1], [1, -1], [1, -1], [-1, -1]]

  def initialize(b_or_w, board)
    super(b_or_w, board)
  end

  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves_crossboard(loc[0], loc[1], DIRECTIONS)
    
    allowed_moves.include?(dest)
  end

  def checks_king?(loc)
    checks_king_crossboard?(loc[0], loc[1], DIRECTIONS)
  end

end
