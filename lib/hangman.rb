def determine_secret_word
  dictionary = File.read("dictionary.txt").split(/\n/)
  list_of_words = []
  dictionary.each do |word|
    list_of_words << word if word.length > 4 && word.length < 13
  end
  secret_word = list_of_words[rand(list_of_words.length)].downcase.split(//)
end

def generate_hidden_letters(secret_word)
  hidden_letters = []
  (0...secret_word.length).each do
    hidden_letters << "_"
  end
  hidden_letters
end

def check_guess(secret_word, hidden_letters, guessed_letter)
  (0...secret_word.length).each do |index|
    hidden_letters[index] = guessed_letter if secret_word[index] == guessed_letter
  end
  hidden_letters
end

def play_hangman(secret_word, hidden_letters, remaining_turns)
  puts "Welcome back to Hangman - Ruby Edition\n\n"

  loop do
    puts hidden_letters.join(" ")
    puts
    puts "You have #{remaining_turns} turns remaining. Good luck!"
    puts "Select a letter(or type 1 to save your game"
    guessed_letter = gets.chomp[0].downcase
    
    if guessed_letter == "1"    
      save_game(secret_word, hidden_letters, remaining_turns)
      break
    end

    hidden_letters = check_guess(secret_word, hidden_letters, guessed_letter) 
    remaining_turns -= 1 unless secret_word.include?(guessed_letter)
    
    unless hidden_letters.include?("_")
      puts "Congratulations, you figured out the word!"
      puts "The word was: #{secret_word.join("")}"
      break
    end

    if remaining_turns == 0
      puts "You ran out of turns, you LOSE!"
      puts "The word was: #{secret_word.join("")}"
      break
    end
  end
end

def save_game(secret_word, hidden_letters, remaining_turns)
  save_data = "#{secret_word.join("")}\n#{hidden_letters.join("")}\n#{remaining_turns}\n"
  save_file = open("hangman.sav", 'w')
  save_file.truncate(0)
  save_file.write(save_data)
  save_file.close
end

def load_game
  load_file = File.read("hangman.sav").split(/\n/)
  load_file[0] = load_file[0].split(//)
  load_file[1] = load_file[1].split(//)
  load_file[2] = load_file[2].to_i
  load_file
end

def game_menu
  loop do
    puts "\nWelcome to Hangman - Ruby Edition\n\n"
    puts "What would you like to do?"
    puts "1 - New Game"
    puts "2 - Load Game"
    selection = gets.chomp

    if selection == "1"
      secret_word = determine_secret_word
      hidden_letters = generate_hidden_letters(secret_word)
      remaining_turns = 6
      play_hangman(secret_word, hidden_letters, remaining_turns)
      break
    elsif selection == "2"
      game_data = load_game
      play_hangman(game_data[0], game_data[1], game_data[2])
      break
    end
  end
end

game_menu