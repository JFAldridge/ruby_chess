require_relative 'game.rb'

class StartsGame
  def initialize
    create_or_load
    @game = nil
  end

  def create_or_load
    puts "Would you like to \n (1) create a new game or \n (2) resume a saved one?"
    choice = 0
    until choice == "1" || choice == "2"
      puts "Please input 1 or 2"
      choice = gets.chomp.strip
    end
    

    @game = Game.new if choice == "1"
    
    if choice == "2"
      any_saves = true
      any_saves = pic_from_saved_game

      unless any_saves || @game.game_saved
        puts "There are no saves on file.  Let's start a new game. :)"
        @game = Game.new
      end
    end

    play_again unless @game.game_saved
  end

  def pic_from_saved_game
    paths = Dir.glob("./saves/*.yml").sort_by { |x| File.mtime(x) }
    return false if paths.length == 0

    puts "Saves:"
    display_presentable_save_data(paths)
    
    choice = -1
    while choice < 1 || choice > paths.length
      puts "Choose your save by it's number."
      choice = gets.chomp.strip.to_i
    end

    load_then_delete_save(paths[choice - 1])
  end

  def display_presentable_save_data(paths)
    timestamps = paths.map { |path| File.basename(path, ".*") }
    
    longest_path = timestamps.max_by {|arr| arr[0].length}[0].length
    
    timestamps.each_with_index do |timestamp, i|
      timestamp_str = timestamp.split("-").join("/").split("_").join(" ")
      
      puts "(#{i + 1}) Save Date: #{timestamp_str.ljust(longest_path.to_i * 2)}"
    end
  end

  def load_then_delete_save(path)
    saved_game = YAML::load(File.read(path))
    
    delete_save(path)

    @game = saved_game
    saved_game.game_ongoing = true
    saved_game.switch_turns
    saved_game.game_cycle
  end

  def delete_save(path)
    File.delete(path)
  end

  def play_again
    puts "Would you like to play again?"
    again = ""
    until again == "yes" || again == "no"
      puts 'Enter "yes" or "no".'
      again = gets.chomp.strip.downcase
    end
    if again == "yes"
      create_or_load
    else 
      puts "See you later!"
    end
  end
end

new_game = StartsGame.new