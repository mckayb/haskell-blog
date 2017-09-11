module Migrator.Cmds.Reset where

import Prelude(String, IO, putStrLn, print)

run :: [String] -> [String] -> IO ()
run args flags = do
  print args
  print flags
  putStrLn "Reset"