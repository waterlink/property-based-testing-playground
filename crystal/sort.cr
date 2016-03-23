require "quick"

def sort(array)
  mergesort(array)
end

def mergesort(array : Enumerable(T))
  return array if array.size <= 1

  half = (array.size + 1) / 2
  merge(
    sort(array[0...half]),
    sort(array[half...array.size])
  )
end

def merge(left : Enumerable(T), right)
  result = [] of T
  left_idx = 0
  right_idx = 0

  while left_idx < left.size && right_idx < right.size
    if left[left_idx] <= right[right_idx]
      result << left[left_idx]
      left_idx += 1
    else
      result << right[right_idx]
      right_idx += 1
    end
  end

  while left_idx < left.size
    result << left[left_idx]
    left_idx += 1
  end

  while right_idx < right.size
    result << right[right_idx]
    right_idx += 1
  end

  result
end

def main
  Quick.check("sort returns Array(Int32)", [a : Array(Int32)]) do
    sort(a).is_a?(Array(Int32))
  end

  Quick.check("being applied twice returns same array", [a : Array(Int32)]) do
    sort(sort(a)) == sort(a)
  end

  Quick.check("contains same element as input", [a : Array(Int32)]) do
    frequencies(sort(a)) == frequencies(a)
  end

  Quick.check("has ordered elements", [a : Quick::Array(Int32, 10000)]) do
    is_ordered?(sort(a))
  end

  puts "OK"
rescue e
  puts "Error: #{e.message}"
end

def frequencies(array : Enumerable(T))
  array.each_with_object({} of T => Int32) do |x, freq|
    freq[x] = freq.fetch(x, 0) + 1
  end
end

def is_ordered?(array)
  array.each_cons(2).all? do |v|
    a, b = v
    a <= b
  end
end

main
