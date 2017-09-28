module Poly where

type Polynomial = [Double]

--Add first element to evaluated rest of lists
ev :: Polynomial -> Double -> Double
ev [] a = 0
ev (x:xs) t = x + t*(ev xs t)

--Concatenate added first elements, with added rest of lists
addP :: Polynomial->Polynomial->Polynomial
addP x [] = x
addP [] y = y
addP (x:xs) (y:ys) = [x+y] ++ addP xs ys

--Concatenate scaled first element with scaled rest of list
scale :: Double -> Polynomial -> Polynomial
scale s [] = []
scale s (x:xs) = [s*x] ++ scale s xs



--Append 0 to front of polynomial (multiply it by X)
multiplyByX poly = 0:poly

--For polys in the form
--x = [1,2,3] and y = [4,5,6]
--Evaluate scale(1 y) and add it to multP [0,2,3] y , repeat recursively


multP :: Polynomial -> Polynomial -> Polynomial
multP x [] = []
multP [] y = []
multP (x1:xs) y = let x1Timesy = scale x1 y
                      restTimesX = multiplyByX $ multP xs y
                  in addP x1Timesy restTimesX


--[1,2,3] is 3x^2 + 2x + 1   ---> 6x + 2 is [2,6]
--[drop,same,index*value]
--der :: Polynomial->Polynomial
--der [] = []
--der [x] = []
--der p = der (take (length p - 1) p) ++  [(last p * (length p - 1)::Double)]


der [x] = []
der p = der (take (length p - 1) p) ++  [(last p * (length p - 1))]

--der (x:x1:xs) = (0:x1:der xs)
