module Sort where

sort :: Ord a => [a] -> [a]
sort [] = []
sort (p:ps) = (sort lesser) ++ [p] ++ (sort greater)
    where
        lesser  = filter (< p) ps
        greater = filter (>= p) ps
