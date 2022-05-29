# load the dictionary
# randomly select a word
# store it in a variable
class Game
  attr_accessor :secret_word

  def initialize
    @secret_word = File.read('dictionary.txt').split(' ').select {
       |w| w.length > 4 && w.length < 13 
      }.sample
  end
end

my_game = Game.new
puts my_game.secret_word