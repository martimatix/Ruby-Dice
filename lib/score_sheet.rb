class ScoreSheet # Class for Score Sheet
=begin
	Enter a score
	Arguments: dice is an instance of the dice class
				 field is a score field on the yahtzee score sheet
=end
	def enter_score(dice, field); end
=begin
	***Methods for calculating score***
	The methods take an array of five ints as an argument

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

	def three_of_a_kind(dice); of_a_kind dice, 3; end # Checks to see if you have a 3 of a kind
	def four_of_a_kind(dice); of_a_kind dice, 4; end

	def yahtzee(dice) # Checks to see if all the dice are the same
		of_a_kind dice, 5
	end

	def full_house(dice)
		f_table = freq dice
		if f_table.length == 1..2 && f_table.has_value?(3) then return 25
		else; return 0
		end
	end

	def small_straight(dice); straight dice, 4, 30; end
	def large_straight(dice); straight dice, 5, 40; end

	def chance(dice); dice.reduce(:+); end
	

=begin
	***Helper methods for score calculation methods***

	freq returns a frequency hash table
=end
	def freq(dice)
		return dice.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		#=> {1=>3, 2=>1, 3=>1}
	end

	# returns a 2 element array with the mode and modal frequency
	def mode(dice)
		return freq(dice).max_by{|k,v| v}
	end
=begin
	helper method for calculating the scores of three of a kind, four of a kind and yahtzee
	Use limit = 3 for three of a kind, limit = 4 for four of a kind and limit = 5 for yahtzee
=end
	def of_a_kind(dice, limit)
		model_value, mode_f = mode dice
		if mode_f >= limit then return dice.reduce(:+)
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
		
end

# test
dice, ss = [1, 2, 3, 4, 5], ScoreSheet.new
puts ss.chance dice