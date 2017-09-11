module Blog.Config (env) where

import Prelude (String, IO, return)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)

env :: String -> String -> IO String
env n x = do
  v <- lookupEnv n
  return (fromMaybe x v)