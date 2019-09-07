require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/king.rb'
require_relative './pieces/pawn.rb'
require_relative 'colorize.rb'

class Board
  def initialize
    @current_state = []
    @white_taken = []
    @black_taken = []
    @en_passant_column = nil
    @hundred_moves = 0
    set_board
  end

  attr_accessor :current_state, :en_passant_column, :hundred_moves
  
  def set_board
    @current_state.push([Rook.new('black', self), Knight.new('black', self), Bishop.new('black', self), Queen.new('black', self), King.new('black', self), Bishop.new('black', self), Knight.new('black', self), Rook.new('black', self)])
    @current_state.push([Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self), Pawn.new('black', self)])
    4.times {@current_state.push(Array.new(8, 0))}
    @current_state.push([Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self), Pawn.new('white', self)])
    @current_state.push([Rook.new('white', self), Knight.new('white', self), Bishop.new('white', self), Queen.new('white', self), King.new('white', self), Bishop.new('white', self), Knight.new('white', self), Rook.new('white', self)])
  end

  def print_board
    @current_state.each_with_index do |row, i|
      print 8 - i
      row.each_with_index do |sqr, f|
        if sqr == 0
          print "   ".send((f - i).even? ? "bg_blue" : "bg_red")
          next
        end
        if sqr.b_or_w == 'white'
          print " #{sqr.uni} ".send((f - i).even? ? "bg_blue" : "bg_red")
        else
          print " #{sqr.uni} ".send((f - i).even? ? "bg_blue" : "bg_red").black
        end
      end
      print " "
      @white_taken.each {|piece| print "#{piece.uni}".bg_magenta} if i == 0
      @black_taken.each {|piece| print "#{piece.uni}".black.bg_magenta} if i == 7
      puts
    end
    puts "  a  b  c  d  e  f  g  h"
  end

  #begin move_piece methods

  def move_piece(loc, dest)
    @hundred_moves += 1

    captured = capture_if_can(dest)

    moving_piece = @current_state[loc[0]][loc[1]]

    @hundred_moves = 0 if moving_piece.instance_of?(Pawn)

    if moving_piece.instance_of?(Pawn) && (loc[0] - dest[0]).abs == 2
      @en_passant_column = dest[1]
    else
      @en_passant_column = nil
    end

    moving_piece.been_moved = true if moving_piece.instance_of?(King) || moving_piece.instance_of?(Rook)
    
    @current_state[dest[0]][dest[1]] = moving_piece 

    @current_state[loc[0]][loc[1]] = 0
    
    puts "#{moving_piece.b_or_w} ".capitalize << "#{moving_piece.class} ".downcase << "to #{conv_x(dest[1])}#{conv_y(dest[0])}."
    
    if captured
      @hundred_moves = 0

      puts captured + "falls."
    end

    puts
  end

  def conv_y(y)
    printed_y = ('1'..'8').to_a.reverse
    printed_y[y]
  end

  def conv_x(x)
    printed_x = ('a'..'h').to_a
    printed_x[x]
  end

  def capture_if_can(dest)
    return false if @current_state[dest[0]][dest[1]] == 0

    dest_square = @current_state[dest[0]][dest[1]]

    dest_square.b_or_w == 'white' ? @white_taken.push(dest_square) : @black_taken.push(dest_square)
    
    captured_piece = "#{dest_square.b_or_w} ".capitalize  + "#{dest_square.class} ".downcase
  end

  #end move_piece methods

  #begin checks_opponent_king methods

  def checks_opponent_king?(turn_color)
    ally_locs = find_ally_locs(turn_color) 
        
    checker_loc = ally_locs.any? { |loc| @current_state[loc[0]][loc[1]].checks_king?(loc) }
  end

  def find_ally_locs(b_or_w)
    ally_piece_locations = [] 

    @current_state.each_with_index do |row, y|
      row.each_with_index do |space, x| 
        next if space == 0
        if space.b_or_w == b_or_w
          ally_piece_locations.push([y, x])
        end 
      end
    end

    ally_piece_locations
  end
    
  #end checks_enemy_king methods

  #begin check_mate? methods

  def check_mate?(b_or_w)
    checked_team_locs = find_checked_team_locs(b_or_w)

    return false if ally_piece_can_uncheck_king?(checked_team_locs)
    return true
  end

  def find_checked_team_locs(b_or_w)
    opponent_piece_locations = [] 

    @current_state.each_with_index do |row, y|
      row.each_with_index do |space, x| 
        next if space == 0
        if space.b_or_w != b_or_w
          opponent_piece_locations.push([y, x])
        end 
      end
    end
    opponent_piece_locations
  end


  def ally_piece_can_uncheck_king?(allied_pieces_locs)
    allied_pieces_locs.any? do |loc|
      allowed_moves = @current_state[loc[0]][loc[1]].find_allowed_moves(loc[0], loc[1])

      allowed_moves.any? do |dest| 
        unchecks = !@current_state[loc[0]][loc[1]].checks_allied_king?(loc, dest)
        unchecks
      end
    end
  end

  #end check_mate? methods
  #begin castling methods

  def possible_castling?(loc, dest, king_in_check)
    moving_piece = @current_state[loc[0]][loc[1]]
    y = moving_piece.b_or_w == 'white' ? 7 : 0
    
    return false unless moving_piece.instance_of? King
    return false if moving_piece.been_moved
    return false if king_in_check

    return false if dest[0] != y

    if dest[1] < 4
      return false unless @current_state[y][0].instance_of? Rook
      return false if @current_state[y][0].been_moved

      return false unless @current_state[y][1] == 0 && @current_state[y][2] == 0 && @current_state[y][3] == 0
      return false if moving_piece.checks_allied_king?(loc, [y, 3]) || moving_piece.checks_allied_king?(loc, [y, 2])
    end

    if dest[1] > 4
      return false unless @current_state[y][7].instance_of? Rook
      return false if @current_state[y][7].been_moved

      return false unless @current_state[y][5] == 0 && @current_state[y][6] == 0
      return false if moving_piece.checks_allied_king?(loc, [y, 5]) || moving_piece.checks_allied_king?(loc, [y, 6])
    end

    return true
  end

  def castling_coordinates(loc, dest)
    moving_piece = @current_state[loc[0]][loc[1]]
    y = moving_piece.b_or_w == 'white' ? 7 : 0

    return [[y, 4], [y, 2], [y, 0], [y, 3]] if dest[1] < 4
    return [[y, 4], [y, 6], [y, 7], [y, 5]] if dest[1] > 4
  end

    
  #end castling methods
  #begin en_passant methods
  
  def en_passant?(loc, dest)
    return false unless @en_passant_column
    return false unless @current_state[loc[0]][loc[1]].instance_of?(Pawn)
    return false unless loc[1] == @en_passant_column - 1 || loc[1] == @en_passant_column + 1
    return false unless dest[1] == @en_passant_column
    
    correct_starting_row = @current_state[loc[0]][loc[1]].b_or_w == 'white' ? 3 : 4

    return false unless loc[0] == correct_starting_row

    return true
  end

  def en_passant_capture(dest)
    capture_pawn_row = dest[0] == 2 ? 3 : 4

    captured_pawn = @current_state[capture_pawn_row][dest[1]]

    @current_state[capture_pawn_row][dest[1]] = 0

    captured_pawn.b_or_w == 'white' ? @white_taken.push(captured_pawn) : @black_taken.push(captured_pawn)
    
    captured_piece = "#{captured_pawn.b_or_w} ".capitalize << "pawn"
  end

  #end en_passant methods

  def pawn_upgrade?(dest)
    moved_piece = @current_state[dest[0]][dest[1]]

    return false unless moved_piece.instance_of?(Pawn)

    last_row = moved_piece.b_or_w == 'white' ? 0 : 7 

    return false unless dest[0] == last_row

    return true
  end

  def upgrade_pawn(dest)
    b_or_w = @current_state[dest[0]][dest[1]].b_or_w

    puts "Would you like to upgrade to a (1)Queen, (2)Rook, (3)Bishop, or (4)Knight?"
    piece_choice = nil

    until piece_choice
      puts "Pick a piece by it's corresponding number."

      input = gets.chomp.to_i
      next unless (1..4).include? input

      piece_choice = input
    end

    case piece_choice
    when 1
      @current_state[dest[0]][dest[1]] = Queen.new(b_or_w, self)
    when 2
      @current_state[dest[0]][dest[1]] = Rook.new(b_or_w, self)
    when 3
      @current_state[dest[0]][dest[1]] = Bishop.new(b_or_w, self)
    else
      @current_state[dest[0]][dest[1]] = Knight.new(b_or_w, self)
    end

  end

end




