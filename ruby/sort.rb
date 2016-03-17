require "rantly/rspec_extensions"
require "rantly/shrinks"

module Sort
  def sort(array)
    mergesort(array)
  end

  def mergesort(array)
    return array if array.size <= 1

    half = (array.size + 1) / 2
    merge(
      sort(array[0...half]),
      sort(array[half...array.size])
    )
  end

  def merge(left, right)
    merged = []
    i = 0
    j = 0

    while i < left.size && j < right.size
      if left[i] <= right[j]
        merged << left[i]
        i += 1
      else
        merged << right[j]
        j += 1
      end
    end

    while i < left.size
      merged << left[i]
      i += 1
    end

    while j < right.size
      merged << right[j]
      j += 1
    end

    merged
  end
end

RSpec.describe Sort do
  include Sort

  it "sorts small array" do
    expect(sort([5, 2, 1, 3])).to eq([1, 2, 3, 5])
  end

  it "being applied twice returns same result" do
    property_of do
      len = range(0, 1000)
      Deflating.new(array(len) { integer })
    end.check do |array|
      expect(sort(sort(array))).to eq(sort(array))
    end
  end

  it "contains same elements" do
    property_of do
      len = range(0, 1000)
      Deflating.new(array(len) { integer })
    end.check do |array|
      expect(frequencies(sort(array))).to eq(frequencies(array))
    end
  end

  it "has ordered elements" do
    property_of do
      len = range(0, 1000)
      Deflating.new(array(len) { integer })
    end.check do |array|
      expect(ordered?(sort(array))).to eq(true)
    end
  end

  describe "#merge(left, right)" do
    it "merges 2 ordered arrays" do
      expect(merge([1, 3, 5], [2, 3, 4])).to eq([1, 2, 3, 3, 4, 5])
    end
  end

  def frequencies(array)
    array_from(array).each_with_object(Hash.new(0)) do |value, hash|
      hash[value] += 1
    end
  end

  def ordered?(array)
    array_from(array).each_cons(2).all? { |x, y| x <= y }
  end

  def array_from(maybe_deflating)
    return maybe_deflating.array if maybe_deflating.is_a?(Deflating)
    maybe_deflating
  end
end
