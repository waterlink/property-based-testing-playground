require "quick"

def add(x, y)
  x + y
end

Quick.def_gen_choice(NotZero, Quick::Range(-100, -1), Quick::Range(1, 100))
alias Positive = Quick::Range(1, 100)

def main
  Quick.check("add returns Int32", [x : Int32, y : Int32]) do
    add(x, y).is_a?(Int32)
  end

  Quick.check("add reflexivity", [x : Int32, y : Int32]) do
    add(x, y) == add(y, x)
  end

  Quick.check("add identity", [x : Int32]) do
    add(x, 0) == x
  end

  Quick.check("add not-identity", [x : Int32, y : NotZero]) do
    add(x, y) != x
  end

  Quick.check("add associativity", [x : Int32, y : Int32, z : Int32]) do
    add(x, add(y, z)) == add(add(x, y), z)
  end

  Quick.check(
    "add 2 positive numbers is a bigger number",
    [x : Positive, y : Positive]) do
      add(x, y) > x && add(x, y) > y
  end

  puts "OK"
rescue e
  puts "Error: #{e.message}"
end

main
