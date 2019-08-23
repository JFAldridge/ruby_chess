class Pieces
  def initialize(b_or_w, board)
    @b_or_w = b_or_w
    @board = board
  end

  attr_accessor :b_or_w, :board

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
    return true if @board.current_state[y].nil? || @board.current_state[y][x].nil?
    false
  end
end