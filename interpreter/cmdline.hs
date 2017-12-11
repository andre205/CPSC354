module Main where
import System.Environment  -- needed for getArgs
import Data.List  -- needed for mapM

main = do
    args <- getArgs                  -- IO [String]
    progName <- getProgName          -- IO String
    putStrLn "The arguments are:"
    mapM putStrLn args
    putStrLn "The program name is:"
    putStrLn progName
