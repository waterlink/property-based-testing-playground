require "rantly/rspec_extensions"

module Mul
  def mul(x, y)
    x * y
  end
end

RSpec.describe Mul do
  include Mul

  it "multiplies numbers" do
    expect(mul(7, 6)).to eq(42)
  end

  it "satisfies reflexivity" do
    property_of { [integer, integer] }.check do |x, y|
      expect(mul(x, y)).to eq(mul(y, x))
    end
  end

  it "satisfies identity" do
    property_of { integer }.check do |x|
      expect(mul(x, 1)).to eq(x)
    end
  end

  it "satisfies zero" do
    property_of { integer }.check do |x|
      expect(mul(x, 0)).to eq(0)
    end
  end

  it "satisfies non-identity" do
    property_of { [integer, integer] }.check do |x, notid|
      if notid != 1 && notid != 0
        expect(mul(x, notid)).not_to eq(x)
      end
    end
  end

  it "satisfies associativity" do
    property_of { [integer, integer, integer] }.check do |x, y, z|
      expect(mul(x, mul(y, z))).to eq(mul(mul(x, y), z))
    end
  end
end
