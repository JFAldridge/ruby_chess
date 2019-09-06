require_relative 'players.rb'

class HumanPlayer < Players
  def initialize(name, b_or_w, board)
    @name = name
    @b_or_w = b_or_w
    @board = board
    @king_in_check = false
  end
  attr_accessor :name, :b_or_w, :board, :king_in_check

  def get_move
    puts "It's your turn, #{@name}, what's your move?"
    @board.print_board
    
    move = nil

    until move
      loc_and_dest = get_loc_and_dest
      loc = loc_and_dest[0]
      dest = loc_and_dest[1]

      unless players_piece?(loc)
        puts "You don't have a piece there to move."
        next
      end

      if @board.en_passant?(loc, dest)
        return [[], loc, dest]
      end

      if @board.possible_castling?(loc, dest, @king_in_check)
        y_or_n = nil

        puts "Would you like to castle?"

        until y_or_n
          puts "Enter 'y' or 'n'."
          input = gets.chomp.downcase

          y_or_n = input if input == 'y' || input == 'n'
        end

        return @board.castling_coordinates(loc, dest) if y_or_n == 'y'
      end

      unless valid_destination(loc, dest)
        puts "That piece can not move there."
        next
      end

      if @board.current_state[loc[0]][loc[1]].checks_allied_king?(loc, dest)
        puts @king_in_check ? "You must uncheck your king." : "That move puts your king in check."
        next
      end

      move = loc_and_dest
    end
    
    move
  end

  #begin get_loc_and_dest methods

  def get_loc_and_dest
    loc_and_dest = nil
    
    until loc_and_dest
      input = gets.chomp
      
      input_arr = successful_input_arr(input)
      next unless input_arr
      
      next unless readable_coordinates?(input_arr)
      
      loc_and_dest = convert_to_loc_and_dest(input_arr)
    end
    loc_and_dest
  end

  def successful_input_arr(input)
    input.gsub!(/[^0-9A-Za-z]/, '')
    input.gsub!(/\s+/, "")
    input.downcase!

    if input.length != 4
      puts "Move a piece by typing it's location, followed by it's destination. \nExample: c2 f7"
      return false
    end

    input_arr = [input[0..1], input[2..3]]
  end

  def readable_coordinates?(coordinates)
    readable = true
    
    coordinates.each do |alph_num|
      unless alph_num.match?(/[a-h][1-8]/)
        puts "Move a piece by typing it's location, followed by it's destination. \nExample: c2 f7"
        readable = false
        break
      end
    end

    readable
  end

  #begin convert_to_loc_and_dest methods

  def convert_to_loc_and_dest(i_arr)
    loc_and_dest = i_arr.map do |alph_num|
      alph_num = [to_y(alph_num[1]), to_x(alph_num[0])]
    end
  end

  def to_y(num)
    numbers = ['8', '7', '6', '5', '4', '3', '2', '1']
    numbers.index(num)
  end

  def to_x(let)
    letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    letters.index(let)
  end

  #end convert_to_loc_and_dest methods
  #end get_loc_and_dest methods

  def players_piece?(loc)
    return false if @board.current_state[loc[0]][loc[1]] == 0
    return true if @board.current_state[loc[0]][loc[1]].b_or_w == @b_or_w
    false
  end

  def valid_destination(loc, dest)
    @board.current_state[loc[0]][loc[1]].is_move_allowed?(loc, dest)
  end

  #end get_move methods
end
