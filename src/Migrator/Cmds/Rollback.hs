module Migrator.Cmds.Rollback where

import Prelude(IO, String, putStrLn, print)

run :: [String] -> [String] -> IO ()
run args flags = do
  print args
  print flags
  putStrLn "Rollback"