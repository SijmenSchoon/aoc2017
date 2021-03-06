module Main where
import Data.Maybe (mapMaybe)
import qualified Data.Map.Lazy as M

step :: Int -> (Int, Int) -> (Int, Int)
step steps (x, y) = case (steps - 1) `rem` 4 of
  0 -> (x + 1, y)
  1 -> (x, y + 1)
  2 -> (x - 1, y)
  _ -> (x, y - 1)

calcValue :: M.Map (Int, Int) Int -> (Int, Int) -> Int
calcValue grid (x, y) =
  sum $ mapMaybe (grid M.!?)
    [ (x - 1, y - 1), (x, y - 1), (x + 1, y - 1)
    , (x - 1, y),                 (x + 1, y)
    , (x - 1, y + 1), (x, y + 1), (x + 1, y + 1)
    ]

part1 :: Int -> Int -> Int -> (Int, Int) -> Int
part1 n steps (-1) c = part1 n (steps + 1) (steps `quot` 2) c
part1 n steps i (x, y)
  | n > 0     = part1 (n - 1) steps (i - 1) (step steps (x, y))
  | otherwise = abs x + abs y

part2 :: M.Map (Int, Int) Int -> Int -> Int -> Int -> (Int, Int) -> Int
part2 grid n steps (-1) coords = part2 grid n (steps + 1) (steps `quot` 2) coords
part2 grid n steps i coords
  | value < n = part2 nextGrid n steps (i - 1) next
  | otherwise = value
  where next = step steps coords
        nextGrid = M.insert next value grid
        value = calcValue grid next

main :: IO ()
main = do
  n <- read <$> getLine
  print $ part1 (n - 1) 0 (-1) (0, 0)

  let grid = M.singleton (0, 0) 1
  print $ part2 grid n 0 (-1) (0, 0)
