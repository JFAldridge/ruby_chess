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
    set_board
  end

  attr_accessor :current_state
  
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
    captured = capture_if_can(dest)

    moving_piece = @current_state[loc[0]][loc[1]]
    
    @current_state[dest[0]][dest[1]] = moving_piece 

    @current_state[loc[0]][loc[1]] = 0
    
    puts "#{moving_piece.b_or_w} ".capitalize << "#{moving_piece.class} ".downcase << "to #{conv_x(dest[1])}#{conv_y(dest[0])}."
    
    if captured
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

  #begin checks_enemy_king methods

  def checks_enemy_king(turn_color)
    ally_locs = find_ally_locs(turn_color) 
        
    checker_loc = ally_locs.find { |loc| @current_state[loc[0]][loc[1]].checks_king?(loc) }

    puts checker_loc
    return false unless checker_loc

    checker = @current_state[checker_loc[0]][checker_loc[1]]

    return "#{checker.b_or_w} ".capitalize + "#{checker.class}".downcase
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


end


