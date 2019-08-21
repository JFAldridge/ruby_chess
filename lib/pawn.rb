require_relative 'pieces.rb'

class Pawn < Pieces
  def initialize(b_or_w, board)
    super(b_or_w, board)
  end

  attr_accessor :b_or_w

  def move_allowed(loc, dest)
    diagonal = [-1, 1]
    y_move = b_or_w == 'white' ? -1 : 1

    possible_x_paths = []

    possible_x_paths.push(0) if @board[loc[0] + y_move][loc[1]] == 0

    diagonal.each do |d| 
      next if @board[loc[0] + y_move][loc[1] + d] == 0
      possible_x_paths.push(d) if opponent_piece((loc[0] + y_move), (loc[1] + d)) 
    end
  end

  def opponent_piece(y, x)
    @board[y][x].b_or_w == @b_or_w ? true : false
  end
end