module Hangman

  require 'yaml'

  class Game
    attr_accessor :player

    def initialize
      @dictionary = import_dictionary('words.txt')
      @player = Player.new
      @secret_word = secret_word(@dictionary)
      @dictionary = nil
      @revealed_word =initialize_revealed_word(@secret_word)
      @turns_remaining = 11
      @previous_guesses = []
    end

    def play
      puts Dir.pwd
      #While game is not over keep taking turns
      while !game_over?
        turn
      end
    end

    def game_over?
      #test if the word is fully guessed
      if !@revealed_word.include?("_")
        puts "You win!"
        return true
      #test if there are no turns remaining
      elsif @turns_remaining == 0
        puts "You lose"
        puts "Word was '#{@secret_word}'"
        return true
      #otherwise game is not over
      else
        return false
      end
    end

    def turn
      #Prompts player for a guess (can be > 1 and not previously asked)
      player_letter = guess
      while @previous_guesses.include?(player_letter)
        puts "You've already guessed that!"
        player_letter = guess
      end

      #If the player is guessing a word test if it's right
      if player_letter.length > 1
        if player_letter == @secret_word
          @revealed_word = @secret_word
        end
      #If the player is guessing a letter test if it's included
      elsif player_letter.length == 1
        update_previous_guesses(player_letter)
        if @secret_word.include?(player_letter)
          @revealed_word = update_revealed_word(player_letter)
        end
      end

      #Provide user feedback
      puts "Previous guesses: #{@previous_guesses.join("")}"
      puts "Revealed word: #{@revealed_word}"

      @turns_remaining -= 1
      puts "You have #{@turns_remaining} turns remaining"
    end

    def import_dictionary(filename)
      all_words = File.readlines(filename)

      all_words.collect! { |word| word.strip }

      select_words = all_words.select do |word|
        word.length > 4 && word.length < 13
      end
      select_words
    end

    def secret_word(dictionary)
      dictionary[rand(dictionary.length)].upcase
    end

    def initialize_revealed_word(secret_word)
      word = ''
      secret_word.length.times { |x| word += ('_')}
      word
    end

    def guess
      puts "What is your guess?"
      gets.chomp.upcase
    end

    def update_revealed_word(player_letter)
      split_secret_word = @secret_word.split("")
      split_revealed_word = @revealed_word.split("")

      split_secret_word.each_with_index do |letter, index|
        if letter == player_letter
          split_revealed_word[index] = player_letter
        end
      end

      split_revealed_word.join("")
    end

    def update_previous_guesses(player_letter)
      @previous_guesses << player_letter
    end

    def save_game_to_file
      File.open(File.join(File.dirname(__FILE__), "/save_file.yaml"), "w") do |file|
        file.puts YAML::dump(self)
      end
    end

    def load_game_from_file
      loaded_file = File.open(File.dirname(__FILE__) + "/save_file.yaml", "r")
      loaded_save_object = YAML::load(loaded_file)

      loaded_save_object
    end

  end

  class Player
    attr_accessor :name

    def initialize
      @name = player_name
    end

    def player_name
      puts "Enter player's name:"
      name = gets.chomp
    end
  end

end
