module Blog.Config (env, load) where

import Prelude (Char, String, IO, Bool, return, readFile, lines, break, map, filter, dropWhile, mapM_, (==), (/=))
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv, setEnv)

setVar :: [String] -> IO ()
setVar [k, v] = setEnv k v
setVar _ = return ()

load :: String -> IO ()
load path = do
  contents <- readFile path
  let vars = map (split (== '=')) (filter (/= "") (lines contents))
  mapM_ setVar vars

env :: String -> String -> IO String
env n x = do
  v <- lookupEnv n
  return (fromMaybe x v)

split :: (Char -> Bool) -> String -> [String]
split p s =
  case dropWhile p s of
    "" -> []
    s' -> w : split p s''
      where (w, s'') = break p s'