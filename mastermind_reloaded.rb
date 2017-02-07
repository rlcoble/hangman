require 'sinatra'
require 'sinatra/reloader' if development?

class Game
	attr_reader :turn, :message
	attr_accessor :input
	def initialize(code)
		@input = ""
		@code = code
		@turn = 0
		@message = ""
	end

	def win?(guess)
		if guess == @code
			@message = "You Win!"
			return true
		else
			diff = guess - @code

			correct_count = 0
			@code.each_with_index do |color,i| 
				correct_count+=1 if color == guess[i]
			end

			@message = "You have guessed #{4 - diff.length} correct colors, and you have #{correct_count} colors in the correct place"
			false
		end
	end

	def play()
		if @turn != 12
			guess = @input
			win?(guess) ? return : @turn+=1
		else
			@message = "You Lose! Code = #{@code}"
		end 
	end
end

colors = ['B','G','O','P','R','S','W','Y']
seq = colors.shuffle[0..3]
game = Game.new(seq)

get '/' do
	input = ""
	turn = ""
	message = ""

	if !params['input'].nil?
		input = params['input'].chomp.split("")
		game.input = input
		turn = game.turn
		game.play
		message = game.message
	end

	if message.include?("Lose") || message.include?("Win")
		colors = ['B','G','O','P','R','S','W','Y']
		seq = colors.shuffle[0..3]
		game = Game.new(seq)
	end
	erb :index, :locals => {:turn => turn, :message => message}
end