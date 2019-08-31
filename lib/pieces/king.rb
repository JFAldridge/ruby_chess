require_relative 'pieces.rb'

class King < Pieces
  DIRECTIONS = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1], [1, -1], [-1, -1]]

  def initialize(b_or_w, board)
    super(b_or_w, board)
    @been_moved = false 
    @uni = @b_or_w == 'white' ? "\u2655" : "\u265B"
  end

  attr_accessor :been_moved
  attr_reader :uni

  def is_move_allowed?(loc, dest)
    allowed_moves = find_allowed_moves(loc[0], loc[1])
    
    @been_moved = true

    allowed_moves.include?(dest)
  end

  def find_allowed_moves(y, x)
    move_list = []

    DIRECTIONS.each do |dir|
      y_move = dir[0] + y
      x_move = dir[1] + x

      next if off_board?(y_move, x_move)
      next if ally_piece?(y_move, x_move)
      
      move_list.push([y_move, x_move])
    end

    move_list
  end

  def checks_king?(loc)
    DIRECTIONS.any? do |dir|
      next if off_board?(dir[0] + loc[0], dir[1] + loc[1])

      opponent_king?(dir[0] + loc[0], dir[1] + loc[1])
    end
  end

  def find_opponent_locs(b_or_w, board)
    opponent_piece_locations = [] 

    board.current_state.each_with_index do |row, y|
      row.each_with_index do |space, x| 
        next if space == 0
        if space.b_or_w != b_or_w
          opponent_piece_locations.push([y, x])
        end 
      end
    end

    opponent_piece_locations
  end

end