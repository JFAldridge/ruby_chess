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
  end

  attr_accessor :board, :players

  def create_players
    players = get_player_names_and_type.map do |n_and_t|
      n_and_t[1] == 'human' ? HumanPlayer.new(n_and_t[0]) : ComputerPlayer.new(n_and_t[0], self)
    end
  end
end

