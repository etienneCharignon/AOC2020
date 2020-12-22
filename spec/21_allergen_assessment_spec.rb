require "data_day21"

EXAMPLE21=%{mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)}

def read21(input)
  input.split("\n").each_with_object({}) do |line, alergens|
    information = /(.*) \(contains (.*)\)/.match line
    information[2].split(", ").each do |a|
      alergens[a] ||= []
      alergens[a] << information[1].split(' ')
    end
  end
end

def find_alergenics(rulls)
  rulls.transform_values { |possible_ingredients| possible_ingredients.inject(:&) }.values.inject(:|)
end

def count_non_alergenic(input)
  alergenics = find_alergenics(read21(input))
  count = 0
  input.split("\n").each do |line|
    ingredients = (/(.*) \(contains (.*)\)/.match(line))[1].split(' ')
    count += (ingredients - alergenics).count
  end
  count
end

def find_cdil(rulls)
  alergens_ingredients = rulls.transform_values { |possible_ingredients| possible_ingredients.inject(:&) }
  alergens = {}
  while alergens_ingredients.size != alergens.size do
    alergens_ingredients.each { |a, ingredients| alergens[a] = ingredients[0] if ingredients.size == 1 }
    alergens_ingredients.transform_values! { |p_i| p_i - alergens.values }
  end
  alergens.sort.to_h.values.join(',')
end

RSpec.describe "Allergen Assessment" do
  describe "Part 1" do
    describe "#read21" do
      it do
        expect(read21(EXAMPLE21)).to eql({
          'dairy' => [["mxmxvkd", "kfcds", "sqjhc", "nhms"], ["trh", "fvjkl", "sbzzf", "mxmxvkd"]],
          'fish' => [["mxmxvkd", "kfcds", "sqjhc", "nhms"], ["sqjhc", "mxmxvkd", "sbzzf"]],
          'soy' => [["sqjhc", "fvjkl"]]
        })
      end
    end

    describe "#find alergenics ingredients" do
      it { expect(find_alergenics(read21(EXAMPLE21))).to eql (["mxmxvkd", "sqjhc", "fvjkl"]) }
    end

    describe "#find canonical dangerous ingredient list" do
      it { expect(find_cdil(read21(EXAMPLE21))).to eql ("mxmxvkd,sqjhc,fvjkl") }
      it { expect(find_cdil(read21(INPUT21))).to eql ("zfcqk,mdtvbb,ggdbl,frpvd,mgczn,zsfzq,kdqls,kktsjbh") }
    end

    describe "#count non alergenic ingredients" do
      it { expect(count_non_alergenic(EXAMPLE21)).to eql (5) }
      it { expect(count_non_alergenic(INPUT21)).to eql (2075) }
    end
  end
end
