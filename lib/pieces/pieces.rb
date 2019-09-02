class Pieces
  def initialize(b_or_w, board)
    @b_or_w = b_or_w
    @board = board
  end

  attr_accessor :b_or_w, :board

  #methods for Bishop, Rook, and Queen

  def find_allowed_moves_crossboard(y, x, directions)
    move_list = []
    
    directions.each do |dir|
      y_temp = y
      x_temp = x
      
      loop do
        y_temp += dir[0]
        x_temp += dir[1]

        break if off_board?(y_temp, x_temp)
        break if ally_piece?(y_temp, x_temp)
        
        move_list.push([y_temp, x_temp])
        
        next if open_space?(y_temp, x_temp)
          
        break
      end
    end

    move_list
  end

  def checks_king_crossboard?(y, x, directions)
    directions.any? do |dir|
      y_temp = y
      x_temp = x
      
      loop do
        y_temp += dir[0]
        x_temp += dir[1]

        break if off_board?(y_temp, x_temp)

        next if open_space?(y_temp, x_temp)

        return true if opponent_king?(y_temp, x_temp)

        break if ally_piece?(y_temp, x_temp)
        break if opponent_piece?(y_temp, x_temp)
      end
    end
  end

  #helper methods

  def opponent_piece?(y, x)
    return false if open_space?(y, x)
    @board.current_state[y][x].b_or_w != @b_or_w 
  end

  def ally_piece?(y, x)
    return false if open_space?(y, x)
    @board.current_state[y][x].b_or_w == @b_or_w 
  end

  def open_space?(y, x)
    @board.current_state[y][x] == 0
  end

  def off_board?(y, x)
    return true if y < 0
    return true if x < 0
    return true if @board.current_state[y].nil? || @board.current_state[y][x].nil?
    false
  end

  def opponent_king?(y, x)
    return false if off_board?(y, x)
    @board.current_state[y][x].is_a?(King) && opponent_piece?(y, x)
  end

  #methods for finding opponents pieces
  
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

  #method to check if move puts allied king in check

  def checks_allied_king?(dest)
    opponent_locs = find_opponent_locs(@b_or_w, @board) 
    
    square_holder = @board.current_state[dest[0]][dest[1]]

    @board.current_state[dest[0]][dest[1]] = self.dup
    
    king_is_checked = opponent_locs.any? { |loc| @board.current_state[loc[0]][loc[1]].checks_king?(loc) }
    
    @board.current_state[dest[0]][dest[1]] = square_holder

    king_is_checked
  end

end