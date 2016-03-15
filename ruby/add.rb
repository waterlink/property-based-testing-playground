require "rantly/rspec_extensions"

module Add
  def add(x, y)
    return x if y == 0
    x + y
  end
end

RSpec.describe Add do
  include Add

  it "adds numbers" do
    expect(add(37, 5)).to eq(42)
  end

  it "satisfies reflexivity" do
    property_of { [integer, integer] }.check do |x, y|
      expect(add(x, y)).to eq(add(y, x))
    end
  end

  it "satisfies identity" do
    property_of { integer }.check do |x|
      expect(add(x, 0)).to eq(x)
    end
  end

  it "satisfies a non-identity" do
    property_of { [integer, integer] }.check do |x, notid|
      if notid != 0
        expect(add(x, notid)).not_to eq(x)
      end
    end
  end

  it "satisfies associativity" do
    property_of { [integer, integer, integer] }.check do |x, y, z|
      expect(add(x, add(y, z))).to eq(add(add(x, y), z))
    end
  end
end
