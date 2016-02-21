import Test.QuickCheck
import Data.Set

sort' :: [Int] -> [Int]
sort' = sort'' . Prelude.map wrap
  where
    wrap x = [x]

    sort'' [] = []
    sort'' [xs] = xs
    sort'' xss = sort'' $ merge_pairs xss

    merge_pairs [] = []
    merge_pairs [xs] = [xs]
    merge_pairs (xs:ys:zss) =
      merge xs ys : merge_pairs zss

    merge xs [] = xs
    merge [] ys = ys
    merge (x:xs) (y:ys)
      | x <= y = x: merge xs (y:ys)
      | otherwise = y: merge (x:xs) ys


main = do
  check "sort' applied twice is the same as applying once" $ \xs ->
    sort' (sort' xs) == sort' xs

  check "sort' yields only ordered (<=) items" $ \xs ->
    isOrdered (sort' xs)

  check "sort' yields same items" $ \xs ->
    fromList xs == fromList (sort' xs)

  where
    isOrdered :: [Int] -> Bool
    isOrdered [] = True
    isOrdered (x:[]) = True
    isOrdered (x:y:xs) = x <= y && isOrdered (y:xs)

check name prop = do
  print $ name ++ " property:"
  quickCheckWith stdArgs { maxSize = 10000 } prop

