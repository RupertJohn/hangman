module Hangman

  class Game
    def initialize
      @dictionary = import_dictionary('words.txt')
      @player = Player.new
      @secret_word = secret_word(@dictionary)
      @revealed_word =initialize_revealed_word(@secret_word)
      @turns_remaining = 11
      @previous_guesses = []
    end

    def play
      while !game_over?
        turn
      end
    end

    def game_over?
      if !@revealed_word.include?("_")
        puts "You win!"
        return true
      elsif @turns_remaining == 0
        puts "You lose"
        puts "Word was '#{@secret_word}'"
        return true
      else
        return false
      end
    end

    def turn
      player_letter = guess
      while @previous_guesses.include?(player_letter)
        puts "You've already guessed that!"
        player_letter = guess
      end

      if player_letter.length > 1
        if player_letter == @secret_word
          @revealed_word = @secret_word
        end
      elsif player_letter.length == 1
        update_previous_guesses(player_letter)
        if @secret_word.include?(player_letter)
          @revealed_word = update_revealed_word(player_letter)
        end
      end

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
      puts "Which letter do you guess?"
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
