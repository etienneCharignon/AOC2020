require './bording_pass_calculator'
require './data_day5'


INPUTS = INPUT.split("\n")
p INPUTS.map { |pass| BordingPassCalculator.seat(pass) }.max
