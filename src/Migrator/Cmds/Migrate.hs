module Migrator.Cmds.Migrate where

import Prelude(IO, String, putStrLn, print)

run :: [String] -> [String] -> IO ()
run args flags = do
  print args
  print flags
  putStrLn "Migrate"