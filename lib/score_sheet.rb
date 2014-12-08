require_relative "fivedice.rb"
class ScoreSheet # Class for Score Sheet
	
	@@upper_scores = :ones, :twos, :threes, :fours, :fives, :sixes
	@@lower_scores = :full_house, :small_straight, :large_straight, :three_of_a_kind, :four_of_a_kind, :yahtzee, :chance
	attr_reader :sheet # Hash table of two element arrays where the first value is the score and the second is whether the field has been played
	attr_reader :filled # true if the score sheet is completely filled and no legal moves remain
	def initialize
		@filled, @sheet = false, Hash.new
		Array.new(@@upper_scores).concat(@@lower_scores).each {|s| @sheet[s] = [0, false]}
		@upper_score_bonus, @upper_score_total, @lower_score_total, @total = 0, 0, 0, 0
	end
=begin
	Enter a score
	Arguments: dice is an instance of the FiveDice class
			   field is a score field on the yahtzee score sheet
=end
	def enter_score(dice, field)
		@sheet[field] = send field, dice.dice.num
		# Check if upper score bonus can be awarded
		raw_upper = @sheet.select{|x| @@upper_scores.include? x }.each{|x| x[1]}.reduce :+
		if raw_upper >= 63; @upper_score_bonus = 35; end

		@upper_score_total = raw_upper + bonus
		@lower_score_total = @sheet.select{|x| @@lower_scores.include? x }.each{|x| x[1]}.reduce :+
		@total = @lower_score_total + @upper_score_total

		@filled = @sheet.each{|x| x[1]}.all? {|x| x == true}
	end

	def ones(dice); 	single_face 1	;end # The total of all the ones
	def twos(dice);		single_face 2	;end # The total of all the twos
	def threes(dice);	single_face 3	;end # The total of all the threes
	def fours(dice); 	single_face 4	;end # The total of all the fours
	def fives(dice); 	single_face 5	;end # The total of all the fives
	def sixes(dice); 	single_face 6	;end # The total of all the sixes

	def three_of_a_kind(dice); of_a_kind dice, 3; end # Checks to see if you have a 3 of a kind
	def four_of_a_kind(dice); of_a_kind dice, 4; end

	def yahtzee(dice); of_a_kind dice, 5; end # Checks to see if all the dice are the same

	def full_house(dice)
		f_table = freq dice
		if f_table.length == 1..2 && f_table.has_value?(3) then return 25
		else; return 0
		end
	end

	def small_straight(dice); straight dice, 4, 30; end
	def large_straight(dice); straight dice, 5, 40; end

	def chance(dice); dice.reduce :+; end
	

=begin
	***Helper methods for score calculation methods***

	single_face calculates the score for the upper half fields of the score sheet
	value indicates which dice face is being counted
=end
	def single_face(dice, value)
=begin
		dice.select{|number| number == value} filters the value
		reduce(:+) sums the array
=end
		return dice.select{|number| number == value}.reduce(:+)
	end
=begin
	freq returns a frequency hash table
=end
	def freq(dice)
		return dice.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		#=> {1=>3, 2=>1, 3=>1}
	end

	
	def mode(dice) # returns a 2 element array with the mode and model frequency
		return freq(dice).max_by{|k,v| v}
	end
=begin
	helper method for calculating the scores of three of a kind, four of a kind and yahtzee
	Use limit = 3 for three of a kind, limit = 4 for four of a kind and limit = 5 for yahtzee
=end
	def of_a_kind(dice, limit)
		model_value, mode_f = mode dice
		if mode_f >= limit then return dice.reduce :+
		else; return 0
		end
	end
=begin
	common code for both small straight (SS) and large straight (LS)
	limit = 4 for SS and limit = 5 for LS
	score is the score to return
=end
	def straight(dice, limit, score)
		#each_cons is generating every possible value for a straight of length limit
		(1..6).each_cons(limit).each do |i|
			# Asking if i is a subset of dice
			if (i - dice).empty?
				return score if (i - dice)
			end
		end
		return 0
	end

	def display; end # displays score sheet
		
end
