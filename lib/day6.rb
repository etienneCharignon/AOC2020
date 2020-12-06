require './data_day6'

GROUPS_INPUTS = INPUT.split("\n\n")
groups_counts = GROUPS_INPUTS.map do |group_inputs|
  group_inputs.gsub(/\n/, '').split('').uniq.count
end
p groups_counts.inject(0, :+)
