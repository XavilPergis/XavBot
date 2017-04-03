# fst :: [a, b] -> a
const fst = ([a, b]) -> a

# snd :: [a, b] -> b
const snd = ([a, b]) -> b

# succ :: Number -> Number
const succ = (a) -> a + 1

# pred :: Number -> Number
const pred = (a) -> a - 1

# a -> (Unit -> a)
const constant = (x) -> -> x

# remove-at :: Number -> [a] -> [a, [a]]
const remove-at = (x, xs) -->
  [xs[x], (take x - 1, xs) ++ (drop x + 1, xs)]

# pick-partition :: [a] -> [a, [a]]
const pick-partition = (xs) ->
  idx = Math.floor (Math.random! * xs.length)
  remove-at idx, xs

# pick :: [a] -> a
const pick = head . pick-partition

# multi-pick :: Number -> [a] -> [a]
const multi-pick = (amt, xs) -->
  builder = []
  for n from 0 to amt - 1
    [a, xs] = pick-partition xs
    builder.push a
  builder

const contains = (h, n) -->
  (h.index-of n) != -1

module.exports = {
  fst, snd, succ, pred, constant, remove-at, pick-partition, pick, multi-pick, contains
}

# multi-pick-recursive = (amt, xs) -->
#   | amt == 0 => []
#   | _ =>
#     [a, xs] = pick-partition xs
#     [a] ++ multi-pick-recursive (pred amt), xs
