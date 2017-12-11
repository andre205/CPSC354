module Store where
{--
Provides a monadic model of variable store.

Ingredients:

  + The StateT transformer combines IO monad with stateful behavior.
  + Data.HashMap.Strict (here qualified as HM) implements essentially the functionality of python dictionaries.

Remember that a monad m is essentially model of computation. So a value of type
  'm a' is a computation of type 'a'.

Here, we want computation to support two things:
  + Perform IO
  + Modify the storage of data by name (the typical use of variables
    in imperative programs)

So the code combines the monadic behavior of state transformation with IO.

'StateT t m' wraps a monad 'm' inside a 'State t' monad. So roughly,
  this models stateful computation of 'm' computations.
  In our case, we want stateful computations of IO.

To get at the underlying computational behavior (in this case IO),
  StateT provides a function called 'lift'. I rename it to doIO to make code
  more readable.

--}

import qualified Data.HashMap.Strict as HM-- faster lookup of variables
import Control.Monad.State


-- Store is a dictionary of (variable, int) pairs
type Store = HM.HashMap String Int

-- A 'StoreComputation t' is actually a function 'Store -> IO (t, Store)'
-- The idea that a computation
--   (i) produces a value of type t depending on the store
--   (ii) may modify the store, and
--   (iii) may involve IO also depending on the store

-- runStateT extracts this function

type StoreComputation t = StateT Store IO t

-- Helper to update the store, modelling assignment to a variable
updateStore :: String -> Int -> StoreComputation ()
updateStore name val = modify $ HM.insert name val

-- Helper to get the value of a variable from the store
--  return Nothing if variable is not present
retrieveFromStore :: String -> StoreComputation (Maybe Int)
retrieveFromStore name = gets $ HM.lookup name

doIO :: IO a -> StoreComputation a
doIO = lift

run :: StoreComputation ()
run = do
  doIO $ putStr "Cmd: "
  c <- doIO getLine
  case c of
    "a" -> do
      name <- doIO getId
      val <- doIO getVal
      updateStore name val
      run

    "p" -> do
      name <- doIO getId
      mx <- retrieveFromStore name
      case mx of
        Just x -> doIO $ putStrLn $ name ++ " = " ++ show x
        Nothing -> doIO $ putStrLn $ name ++ " does not exist."
      run

    "q" -> doIO $ putStrLn "G'bye"

    _ -> do
      doIO $ putStrLn "invalid command."
      run
  where
    getId  = do  -- get a string after prompting
      putStrLn "Id: "
      getLine

    getVal = do -- get an integer after prompting
      putStrLn "Val: "
      valStr <- getLine
      return $ read valStr

test :: IO () -- rename to 'main' to treat as a program
test = do
  (x,s) <- runStateT run $ HM.fromList [("x",1), ("y",2)]
  return x
