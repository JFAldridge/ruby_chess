require_relative 'pieces.rb'

class Rook < Pieces
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1]]

  def initialize(b_or_w, board)
    super(b_or_w, board)
    @been_moved = false 
    @uni = @b_or_w == 'white' ? "\u2656" : "\u265C"
  end

  attr_reader :uni

  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves_crossboard(loc[0], loc[1], DIRECTIONS)

    @been_moved = true
    
    allowed_moves.include?(dest)
  end

  def checks_king?(loc)
    checks_king_crossboard?(loc[0], loc[1], DIRECTIONS)
  end

end

