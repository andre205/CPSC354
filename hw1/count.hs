module Count where

count :: String -> Char -> Int
count str c = length $ filter (== c) str
