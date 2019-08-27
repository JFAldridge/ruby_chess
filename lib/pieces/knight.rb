require_relative 'pieces.rb'

class Knight < Pieces
  DIRECTIONS = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]

  def initialize(b_or_w, board)
    super(b_or_w, board)
    @uni = @b_or_w == 'white' ? "\u2658" : "\u265E"
  end

  attr_reader :uni

  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves(loc[0], loc[1])
    
    allowed_moves.include?(dest)
  end

  def find_allowed_moves(y, x)
    move_list = []
    
    DIRECTIONS.each do |dir|
      next if off_board?(dir[0] + y, dir[1] + x)
      next if ally_piece?(dir[0] + y, dir[1] + x)
      
      move_list.push([dir[0] + y, dir[1] + x])
    end

    move_list
  end

  def checks_king?(loc)
    DIRECTIONS.any? do |dir|
      next if off_board?(dir[0] + loc[0], dir[1] + loc[1])
      
      opponent_king?(dir[0] + loc[0], dir[1] + loc[1])
    end
  end
end