module Poly where

type Polynomial = [Double]

ev :: Int a => [a] -> a -> a
ev [] = []
ev [x:xs] t = x + ev[x:xs]
