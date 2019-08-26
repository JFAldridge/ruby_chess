require_relative 'players.rb'

class HumanPlayer < Players
  def initialize(name)
    @name = name
  end
  attr_accessor :name
end