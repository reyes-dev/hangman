require 'yaml'
# selects a random word between 5 and 12 letters long from a dictionary file
module DictionaryWord
  def PickWord
    File.read('dictionary.txt').split(' ').select do |w|
      w.length > 4 && w.length < 13
    end.sample.split('')
  end
end

module Checkable
  # checks if a players guessed letter is in the word 
  # updates the display variable if it is
  def letter_check(letter, word, hidden_word)
    word.each_with_index do |char, idx|
      hidden_word[idx] = char if letter == char
    end
  end
  # check if the words match exactly and changes game ending boolean variable
  def game_over_check(word, hidden_word)
    @game_over = true if word == hidden_word
  end

  def check(letter, word, hidden_word)
    letter_check(letter, word, hidden_word)
    game_over_check(word, hidden_word)
  end
end

class Game
  include DictionaryWord
  include Checkable

  attr_accessor :random_word, :hidden_word, :tries, :game_over, :letter, :wrong_letters

  def initialize(
    random_word = self.PickWord,
    hidden_word = Array.new(random_word.length, '_'),
    tries = 6,
    game_over = false,
    wrong_letters = []
  )
    @random_word = random_word
    @hidden_word = hidden_word
    @tries = tries
    @game_over = game_over
    @wrong_letters = wrong_letters
  end

  def play
    until @tries == 0 || game_over
      puts "You have #{@tries} tries left!"
      puts "Wrong letter guesses: #{@wrong_letters.uniq.join(', ')}" unless @wrong_letters.empty?
      puts @hidden_word.join('')
      self.input_guess
      check(@letter, @random_word, @hidden_word)
      unless @random_word.any?(@letter)
        @tries = tries - 1
        @wrong_letters.push(@letter)
      end
    end
    puts "The word was #{random_word.join('')}!"
    puts @game_over ? 'You won!' : 'You lost!'
  end
  # takes a single letter input
  # gives option to save game or exit game
  def input_guess
    loop do
      puts 'Enter a letter, save or exit: '
      @letter = gets.chomp.downcase
      if @letter.match?(/^[a-zA-Z]{1}$/)
        break
      elsif @letter.match?('save')
        save_game
      elsif @letter.match?('exit')
        exit
      end
    end
  end
  # stores instance variables in a yaml file
  def to_yaml
    YAML.dump ({
      :random_word => @random_word,
      :hidden_word => @hidden_word,
      :tries => @tries,
      :game_over => @game_over,
      :wrong_letters => @wrong_letters
    })
  end
  # instantiates an object passing parameters stored in a yaml file
  def self.from_yaml(string)
    data = YAML.load string
    self.new(data[:random_word], data[:hidden_word], data[:tries], data[:game_over], data[:wrong_letters])
  end
  # creates a new file in yaml form holding the current values of instance variables to be loaded later
  def save_game
    puts "Enter save game filename: "
    save_name = gets.chomp.downcase
    File.open("saves/#{save_name}.yaml", 'w') { |file| file.write(self.to_yaml) }
  end
  # displays save files and takes input to load one of them in
  # by calling the from_yaml class method and passing the inputted name equivalent
  # to a file in the saves folder
  def load_game
    begin
    exit if Dir.children("./saves").empty?
    puts Dir.children("./saves").map { |fn| fn.gsub('.yaml', '') }
    puts "Enter filename you want to load: "
    load_name = gets.chomp.downcase
    Game.from_yaml(YAML.load File.read("saves/#{load_name}.yaml").to_yaml).play
    rescue
      retry
    end
  end
  # calls load game or play on input
  def start
    puts "Type 'load' to load a game, or any key to start a new game: "
    gets.chomp.match?('load') ? load_game : play
  end
end

Game.new.start