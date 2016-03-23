require "quick"

def mul(x, y)
  x * y
end

Quick.def_gen_choice(NotOne, Quick::Range(-100, 0), Quick::Range(2, 100))
Quick.def_gen_choice(NotZero, Quick::Range(-100, -1), Quick::Range(1, 100))
alias Negative = Quick::Range(-100, -1)

def main
  Quick.check("mul returns Int32", [x : Int32, y : Int32]) do
    mul(x, y).is_a?(Int32)
  end

  Quick.check("mul reflexivity", [x : Int32, y : Int32]) do
    mul(x, y) == mul(y, x)
  end

  Quick.check("mul identity", [x : Int32]) do
    mul(x, 1) == x
  end

  Quick.check("mul non-identity", [x : Int32, y : NotOne]) do
    mul(x, y) != x
  end

  Quick.check("mul zero", [x : Int32]) do
    mul(x, 0) == 0
  end

  Quick.check("mul non-zero", [x : NotZero, y : NotZero]) do
    mul(x, y) != 0
  end

  Quick.check("mul transitivity", [x : Int32, y : Int32, z : Int32]) do
    mul(x, mul(y, z)) == mul(mul(x, y), z)
  end

  Quick.check(
    "mul 2 negative values is a positive value",
    [x : Negative, y : Negative]) do
      mul(x, y) > 0
  end

  puts "OK"
rescue e
  puts "Error: #{e.message}"
end

main
