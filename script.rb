# load the dictionary
# randomly select a word
# store it in a variable
module DictionaryWord
  def PickWord
    File.read('dictionary.txt').split(' ').select do |w|
      w.length > 4 && w.length < 13
    end.sample.split('')
  end
end

module Checkable
  def letter_check(letter, word, hidden_word)
    word.each_with_index do |char, idx|
      hidden_word[idx] = char if letter == char
    end
  end

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

  def initialize
    @random_word = self.PickWord
    @hidden_word = Array.new(@random_word.length, '_')
    @tries = 6
    @game_over = false
    @wrong_letters = []
  end

  def play
    until @tries == 0 || game_over
      puts "You have #{@tries} tries left!"
      puts "Wrong letter guesses: #{@wrong_letters.uniq.join(', ')}"
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

  def input_guess
    loop do
      puts 'Enter a letter: '
      @letter = gets.chomp.downcase
      break if @letter.match?(/^[a-zA-Z]{1}$/)
    end
  end
end

my_game = Game.new
print my_game.random_word
my_game.play