class LuggageRull
  def self.read_lines(lines)
    graph = {}
    lines.each do |line|
      line_data = read(line)
      graph[line_data[0]] = line_data[1]
    end
    graph
  end

  def self.read(line)
    bagged = line.gsub('bags', 'bag').gsub(/[,.]/, '').gsub('contain ', '')
    bags = bagged.split(' bag')
    response = []
    response << bags.shift

    dependency = {}
    bags.each do |bag|
      break if bag == ' no other'
      bag_count = / (\d)* (.*)/.match(bag)
      dependency[bag_count[2]] = bag_count[1].to_i
    end
    response << dependency
  end

  def self.containing_bags(bags, my_bag)
    containing = []
    bags.each do |bag, contained|
      containing << bag if contained.keys.include?(my_bag)
    end
    containing.clone.each do |bag|
      containing << containing_bags(bags, bag)
    end
    containing.flatten.uniq
  end
end
