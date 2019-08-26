require_relative 'players.rb'

class ComputerPlayer < Players
  def initialize(name, game)
    @name = name
    @game = game
  end

  attr_accessor :name, :game
end