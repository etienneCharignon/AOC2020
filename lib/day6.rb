require './data_day6'

# INPUT = %{a
# b
# c}

GROUPS_INPUTS = INPUT.split("\n\n")
groups_counts = GROUPS_INPUTS.map do |group_responses_string|
  group_responses = group_responses_string.split("\n")
  group_yes = group_responses[0].split('')
  group_responses.each do |personne_responses|
    group_yes.clone.each { |response| group_yes.delete(response) unless personne_responses.include?(response) }
  end
  group_yes.size
end
p groups_counts
p groups_counts.inject(0, :+)
