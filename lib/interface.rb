module Interface

  def get_player_names_and_type
    players = []
    player_comp = 2
    
    if player_comp == 1
      puts "What's your name?"
    else
      puts "What is player one's name?"
    end
  
    name_1 = gets.chomp
    if name_1 == ''
      puts "We'll call you \"Babababababababa\" for simplicities sake."
      name_1 = "Babababababababa"
    end
    players.push([name_1, 'human'])
  
    if player_comp == 1
      puts
      puts "Your opponent will be \"Blip,\" a toaster with aspirations."
      players.push(["Blip", 'computer'])
    else
      puts
      puts "What is player two's name?"
      name_2 = gets.chomp
      if name_2 == '' || name_2 == name_1
      puts "Let's call you \"Pie.\""
      name_2 = "Pie"
    end
      players.push([name_2, 'human'])
    end
  
    players
  end

  

end