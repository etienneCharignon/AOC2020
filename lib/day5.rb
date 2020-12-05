require './bording_pass_calculator'
require './data_day5'


INPUTS = INPUT.split("\n")
ids = INPUTS.map { |pass| BordingPassCalculator.seat(pass) }.sort
ids.each { |pass| p (pass + 1) unless ids.include?(pass + 1) }
