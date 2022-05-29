# hangman
Project description: You will be building a simple command line Hangman game where one player plays against the computer, but a bit more advanced.
# Gameplay
1. A new game is started that will randomly select a word, 5-12 characters long from a txt file dictionary
2. Each turn the player will guess a (case-insensitive) letter 
3. The display is updated to reflect whether the letter is correct or incorrect
4. Counter is displayed containing amount of guesses left
5. When guesses run out, the player loses
6. To win the player must guess all the letters in the word before guesses run out
# Savestates
- At the start of a turn the player has the option to save the game
- 'Saving the game' actually serializes the objects and their unique instance variables
- When the program starts, an option to load a list of saved games will be given
  Ex: 'Type the # of the save file you want to load'
'Save #1:  _ r o g r a _ _ i n g'
'Save #2: _k__ch_ook'
'Save #3: _i_sta'