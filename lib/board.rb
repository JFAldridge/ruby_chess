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
    puts
    end
    puts "  a  b  c  d  e  f  g  h"
  end

end

board = Board.new
board.print_board

