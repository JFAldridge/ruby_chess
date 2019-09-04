require_relative 'board.rb'
require_relative './players/human_player.rb'
require_relative './players/computer_player.rb'
require_relative 'interface.rb'

class Game
  include Interface

  def initialize
    @board = Board.new
    @players = create_players
    @whos_turn = 1
    @game_ongoing = true
    game_cycle
  end

  attr_accessor :board, :players

  def create_players
    players = get_player_names_and_type.map.with_index do |n_and_t, i|
      b_or_w = i == 0 ? 'white' : 'black'  
      n_and_t[1] == 'human' ? HumanPlayer.new(n_and_t[0], b_or_w, @board) : ComputerPlayer.new(n_and_t[0], b_or_w, @board)
    end
  end

  def game_cycle
    while @game_ongoing
      switch_turns

      loc_dest = @players[@whos_turn].get_move
      
      loc = loc_dest[0]
      dest = loc_dest[1]
      
      @board.move_piece(loc, dest)

      if @board.checks_opponent_king?(@players[@whos_turn].b_or_w) 
        if @board.check_mate?(@players[@whos_turn].b_or_w)
          game_over
        else
          puts "#{@players[1 - @whos_turn].b_or_w} ".capitalize << "king is checked"
          @players[1 - @whos_turn].king_in_check = true
        end
      else
        @players[1 - @whos_turn].king_in_check = false
      end
    end
  end

  def game_over
    @board.print_board

    @game_ongoing = false
    
    puts "#{@players[@whos_turn].b_or_w} ".capitalize << "side wins!"
  end

  def switch_turns
    @whos_turn = 1 - @whos_turn
    @turn_color = @turn_color =='white' ? 'black' : 'white'
  end
end



game = Game.new