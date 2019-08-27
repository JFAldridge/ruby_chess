require_relative 'pieces.rb'

class Pawn < Pieces
  def initialize(b_or_w, board)
    super(b_or_w, board)
    @y_move = @b_or_w == 'white' ? -1 : 1
    @uni = @b_or_w == 'white' ? "\u2659" : "\u265F"
  end

  attr_reader :uni
  
  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves(loc[0], loc[1])
    
    allowed_moves.include?(dest)
  end
  
  def find_allowed_moves(y, x)
    move_list = []

    move_list.push([y + @y_move, x]) if open_space?(y + @y_move, x)
    move_list.push([y + @y_move, x - 1]) if opponent_piece?(y + @y_move, x - 1)
    move_list.push([y + @y_move, x + 1]) if opponent_piece?(y + @y_move, x + 1)
    move_list.push([y + @y_move * 2, x]) if two_forward_allowed?(y, x)

    move_list
  end

  def two_forward_allowed?(y, x)
    return false unless is_first_move?(y)
    return false unless open_space?(y + @y_move, x) && open_space?(y + @y_move * 2, x)
    true
  end

  def is_first_move?(y)
    return true if @b_or_w == 'black' && y == 1 || @b_or_w == 'white' && y == 6
    false
  end

  def checks_king?(loc)
    return true if opponent_king?(loc[0] + @y_move, loc[1] - 1) 
    return true if opponent_king?(loc[0] + @y_move, loc[1] + 1)

    false
  end

end