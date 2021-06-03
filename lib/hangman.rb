require 'pry'
require 'yaml'

class Game
    @@dictionnary_words = File.readlines('5desk.txt')

    def initialize
        @letters = ['']
        @tries_left = 10
        @word_chosen = self.random_word_selection
        @word_to_guess = "_ " * @word_chosen.length
        
    end

    def random_word_selection
        @word_chosen = @@dictionnary_words[rand(0..61405)].strip
        until @word_chosen.length >= 5 && @word_chosen.length <= 12 do
            @word_chosen = @@dictionnary_words[rand(0..61405)].strip
        end
        @word_chosen
    end

    def display_the_word
        puts @word_to_guess
    end

    def guess_a_letter
        puts "Enter a letter or type save to save your progress"
        @letter = gets.chomp
            if @letter.downcase == 'save'
                self.save_game
            else 
                @letters << @letter.downcase
            end
    end

    def check_the_letter
        @good_answer = false
        @word_chosen.each_char.with_index do |letter, index|
            if letter == @letter.downcase 
                @word_to_guess[index*2] = @letter.downcase
                @good_answer = true
            end
        end
    end

    def advance_rounds
        until @tries_left == 0 || !@word_to_guess.include?('_') do
            self.guess_a_letter
            self.check_the_letter
            if !@good_answer
                @tries_left -= 1
            end
            puts @word_to_guess
            puts "\nYou have #{@tries_left} tries left!\n"
            puts "Here are the letters already guessed : #{@letters.join(", ")}\n"
        end
        self.determine_win_condition
    end

    def determine_win_condition
        if @tries_left > 0 
            puts "You Win ! \n"
        else 
            puts "You have lost :-( \nThe word was #{@word_chosen}!"
        end
    end
    
    def save_data
        YAML.dump(
            'letters' => @letters,
            'word_chosen' => @word_chosen,
            'word_to_guess' => @word_to_guess,
            'tries_left' => @tries_left
        )
    end

    def save_game

        Dir.mkdir("saved") unless Dir.exist?("saved")
        puts "How do you want to call your game ?"
        name = gets.chomp.downcase
        @filename = "saved/#{name}.yaml"
          
        File.open(@filename, "w") do |file|
            file.write save_data
            exit
        end
    end

    def load_game
        puts "\nWhat's the name of your saved game ?\n"
        name = gets.chomp.downcase
        data = File.open("saved/#{name}.yaml")
        
        loaded_game = YAML::load(data)
        @word_chosen = loaded_game['word_chosen']
        @letters = loaded_game['letters']
        @word_to_guess = loaded_game['word_to_guess']
        @tries_left = loaded_game['tries_left']
    end

    def start_game
        puts "\n Type load to load a new game or new to start a fresh one"
        choice = gets.chomp.downcase
        if choice == "load"
            self.load_game
        else
            self.random_word_selection
            self.display_the_word
        end
            self.advance_rounds
        
    end
end

game = Game.new
game.start_game
# select a word between 5 and 12 characters long 
