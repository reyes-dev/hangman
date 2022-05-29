# load the dictionary
# randomly select a word
# store it in a variable
module DictionaryWord
  def PickWord
    File.read('dictionary.txt').split(' ').select {
      |w| w.length > 4 && w.length < 13 
     }.sample.split('')
  end
end

module Checkable
  def letter_check(letter, word, hidden_word)
    word.each_with_index do |char, idx|
      if letter == char
        hidden_word[idx] = char
      end
    end
  end

  def game_over_check(word, hidden_word)
    if word == hidden_word
      @game_over = true
    end
  end

  def check(letter, word, hidden_word)
    self.letter_check(letter, word, hidden_word)
    self.game_over_check(word, hidden_word)
  end
end

class Game
  include DictionaryWord
  include Checkable

  attr_accessor :random_word, :hidden_word, :tries, :game_over, :letter

  def initialize
    @random_word = self.PickWord
    @hidden_word = Array.new(@random_word.length, '_')
    @tries = 6
    @game_over = false
  end

  def play
    until @tries == 0 || game_over
      puts "You have #{@tries} tries left!"
      puts @hidden_word.join('')
      self.input_guess
      self.check(@letter, @random_word, @hidden_word)
      @tries = @tries - 1
    end
    puts "The word was #{random_word.join('')}!"
  end

  def input_guess
    loop do
      puts "Enter a letter: "
      @letter = gets.chomp  
      break if @letter.match?(/^[a-zA-Z]{1}$/)
    end
  end
end

my_game = Game.new
print my_game.random_word
my_game.play