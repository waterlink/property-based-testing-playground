import Test.QuickCheck

add :: Int -> Int -> Int
add x y = x + y

main = do
  check "add reflexivity" $ \x y ->
    add x y == add y x

  check "add identity" $ \x ->
    add x 0 == x && add 0 x == x

  check "add associativity" $ \x y z ->
    add x (add y z) == add (add x y) z

check name prop = do
  print $ name ++ " property:"
  quickCheck prop
