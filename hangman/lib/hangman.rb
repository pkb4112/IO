#Hangman 
require 'yaml/store'

class Game

  attr_accessor :word, :turns, :lives, :wrong, :right

  def initialize 
  	@turns = 0
  	@lives = 8
  	@wrong = []
  	@right = []
    @word = set_word
  end


  def word_guessed
	word_so_far = @word.scan(/\w/)
	word_so_far.each_with_index do |letter,index|
		unless @right.include? letter
			word_so_far[index]="_ "
		end
	end
  end
#compares the users letter to a word
  def compare_letter(letter)
  	if @wrong.include?(letter) || @right.include?(letter)
      	puts "You already guessed that letter"
      	return ""
	elsif word.include? letter
		@right << letter 
	else 
		puts "Letter not in the word."
		@lives-=1
		@wrong << letter
	end

  end

#checks if you guessed the word correctly
  def win?
    if word_guessed.select{|x| x!="_ "}.count == @word.length
  		return true
  	else
  		false
  	end
  end

#allows the user to guess a letter
  def guess_letter
  	loop do 
  	  puts "Guess a letter or type 'save' to save the game and continue later."
  	  letter = gets.chomp.downcase.strip
  	  if letter == "save"
  	  	save
  	  else
        if letter.match(/[a-z]/) && letter.length == 1
  		  return letter
        else
    	  puts "Invalid Character - Try Again"
  	    end
      end
    end
  end

#saves the game to a file in yaml format to be continued later.
  def save
  	data = self
  	
  	File.open('store.yml','w') do |f|
  		f.write(data.to_yaml)
  	end
  	puts data
  	puts "Saved!"
  	puts ""
  end

#load a previous game
  def load 
  	puts "Type 'load' to load an existing game, or press Enter to continue."
  	answer = gets.chomp.downcase
  	if answer == 'load'
      data = YAML.load_file('store.yml')
      @turns = data.turns
      @lives = data.lives
      @wrong = data.wrong
      @right = data.right
      @word= data.word
      puts "Loading..."
      sleep(2)
    end

  end

  private
#Picks the word to guess randomly out of the dictionary
  def set_word
    dic = File.read("dic.txt").downcase.split
    dic.reject! {|word| word.length<5 || word.length>12}
    word = dic.sample
  end

end #Game class end




#plays the game
def play

  game=Game.new
  game.load
  while game.lives > 0 && !game.win?
  	system "clear"
  	print game.word_guessed
  	puts ""
    puts "You have #{game.lives} lives remaining."
    puts ""
    puts "Incorrect Letters:"
    game.wrong.each {|letter| print "#{letter}, "}
    puts ""
    letter=game.guess_letter
    game.compare_letter(letter)
    sleep(1)
  end
  system "clear"
  if game.win?
  	puts "You Win!"
  else 
    puts "You Lose!"
  end
  puts "The word was '#{game.word}'"


end

play