require_relative 'board.rb'
require_relative './players/human_player.rb'
require_relative './players/computer_player.rb'
require_relative 'interface.rb'

class Game
  include Interface

  def initialize
    @board = Board.new
    @players = create_players
    @whos_turn = 0
    @turn_color = 'white'
    @game_ongoing = true
    game_cycle
  end

  attr_accessor :board, :players

  def create_players
    players = get_player_names_and_type.map do |n_and_t|
      n_and_t[1] == 'human' ? HumanPlayer.new(n_and_t[0]) : ComputerPlayer.new(n_and_t[0], self)
    end
  end

  def game_cycle
    get_move

    puts 'taco'
  end

  

  def get_move
    puts "It's your turn, #{@players[@whos_turn].name}, what's you move?"
    @board.print_board
    
    move = nil

    until move
      loc_and_dest = get_loc_and_dest

      unless players_piece?(loc_and_dest[0])
        puts "You don't have a piece there to move."
        next
      end

      unless valid_destination(loc_and_dest[0], loc_and_dest[1])
        puts "That piece can not move there."
        next
      end

      move = loc_and_dest
    end
    
    move
  end

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

  def players_piece?(loc)
    return false if @board.current_state[loc[0]][loc[1]] == 0
    return true if @board.current_state[loc[0]][loc[1]].b_or_w == @turn_color
    false
  end

  def valid_destination(loc, dest)
    @board.current_state[loc[0]][loc[1]].is_move_allowed?(loc, dest)
  end




  def switch_turns
    @whos_turn = 1 - @whos_turn
    @turn_color = @turn_color =='white' ? 'black' : 'white'
  end
end

game = Game.new