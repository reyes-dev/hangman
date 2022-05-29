# load the dictionary
# randomly select a word
# store it in a variable
module DictionaryWord
  def PickWord
    File.read('dictionary.txt').split(' ').select {
      |w| w.length > 4 && w.length < 13 
     }.sample
  end
end

module Checkable

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
      @tries = @tries - 1
    end
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
my_game.play