class Pieces
  def initialize(b_or_w, board)
    @b_or_w = b_or_w
    @board = board
  end

  attr_accessor :b_or_w, :board
end