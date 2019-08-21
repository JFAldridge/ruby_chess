require_relative 'pieces.rb'

class King < Pieces
  def initialize(b_or_w, board)
    super(b_or_w, board)
  end
end