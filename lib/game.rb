require_relative 'board.rb'
require_relative './players/human_player.rb'
require_relative 'interface.rb'
require 'yaml'

class Game
  include Interface

  def initialize
    @board = Board.new
    @players = create_players
    @whos_turn = 1
    @game_ongoing = true
    @game_saved = false
    game_cycle
  end

  attr_accessor :board, :players, :game_ongoing, :game_saved

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
      
      if loc_dest.length == 2
        @board.move_piece(loc_dest[0], loc_dest[1])

        @board.upgrade_pawn(loc_dest[1]) if @board.pawn_upgrade?(loc_dest[1])

      elsif loc_dest.length == 3
        @board.en_passant_capture(loc_dest[2])
        @board.move_piece(loc_dest[1], loc_dest[2])

      elsif loc_dest.length == 4
        @board.move_piece(loc_dest[0], loc_dest[1])
        @board.move_piece(loc_dest[2], loc_dest[3])

      else
        loc_dest == 'savegame' ? game_over('save') : game_over('draw')
      end

      if @board.checks_opponent_king?(@players[@whos_turn].b_or_w) 
        if @board.check_mate?(@players[@whos_turn].b_or_w)
          game_over('win')
        else
          puts "#{@players[1 - @whos_turn].b_or_w} ".capitalize << "king is checked"
          @players[1 - @whos_turn].king_in_check = true
        end
      else
        @players[1 - @whos_turn].king_in_check = false
      end
    end
  end

  def game_over(condition)
    @board.print_board

    @game_ongoing = false
    
    if condition == 'win'
      puts "#{@players[@whos_turn].b_or_w} ".capitalize << "side wins!"
    elsif condition == 'draw'
      puts "The game is a draw."
    else
      save_game
      @game_saved = true
      puts "Your game has been saved."
    end
  end

  def switch_turns
    @whos_turn = 1 - @whos_turn
    @turn_color = @turn_color =='white' ? 'black' : 'white'
  end

  def save_game
    now = Time.new
    File.open("./saves/#{now.month}-#{now.day}-#{now.year}_#{now.hour}:#{now.min}.yml", "w"){|file| file.puts YAML::dump(self)}
  end

end



