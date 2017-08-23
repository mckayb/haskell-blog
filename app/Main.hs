module Main where

import Prelude (IO, putStrLn)
import Lib (start)

main :: IO ()
main = do
  putStrLn "Listening on port 8081"
  start
