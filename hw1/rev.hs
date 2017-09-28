module Rev where

--Append first element to end of list, and reverse the rest
rev :: [a] -> [a]
rev [] = []
rev (x:xs) = rev xs ++ [x]
