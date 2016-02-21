import Test.QuickCheck

mul :: Int -> Int -> Int
mul x y = x * y

main = do
  check "mul reflexivity" $ \x y ->
    mul x y == mul y x

  check "mul identity" $ \x ->
    mul x 1 == x && mul 1 x == x

  check "mul associativity" $ \x y z ->
    mul x (mul y z) == mul (mul x y) z

  check "mul zero edge case" $ \x ->
    mul x 0 == 0 && mul 0 x == 0

check name prop = do
  print $ name ++ " property:"
  quickCheck prop

