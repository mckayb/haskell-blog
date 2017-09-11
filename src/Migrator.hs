{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}

module Migrator where

import Prelude (Show, Eq, IO, String, Bool(False), Either(Left, Right), putStrLn, take, length, head, tail, filter, not, null, (.), (==))
import Blog.DB (safeGetConn)
import System.Environment (getArgs)
import Database.PostgreSQL.Simple (close)
import qualified Migrator.Cmds.Help as Cmds.Help (run)
import qualified Migrator.Cmds.Migrate as Cmds.Migrate (run)
import qualified Migrator.Cmds.Reset as Cmds.Reset (run)
import qualified Migrator.Cmds.Rollback as Cmds.Rollback (run)
import qualified Migrator.Cmds.Version as Cmds.Version (run)
import qualified Configuration.Dotenv as Dotenv (loadFile)

main :: IO ()
main = do
    Dotenv.loadFile False ".env"
    conn <- safeGetConn
    case conn of
        Left _ -> putStrLn "I'm having trouble connecting to the database... Check your .env file and try again."
        Right c -> do
            cmdLineArgs <- getArgs
            case parseArgs cmdLineArgs of
                Help -> Cmds.Help.run
                Version -> Cmds.Version.run
                Error -> Cmds.Help.run
                Cmd Options {cmd, args, flags} ->
                    case cmd of
                        "" -> Cmds.Migrate.run args flags
                        "migrate" -> Cmds.Migrate.run args flags
                        "rollback" -> Cmds.Rollback.run args flags
                        "reset" -> Cmds.Reset.run args flags
                        _ -> Cmds.Help.run
            close c

parseArgs :: [String] -> ParseResult
parseArgs args =
  case args of
    ["--help"] -> Help
    ["--version"] -> Version
    _ ->
      if null cmds
        then Cmd Options {cmd = "migrate", args = [], flags}
        else Cmd Options {cmd = head cmds, args = tail cmds, flags}
  where
    isPrefix pre str = take (length pre) str == pre
    cmds = filter (not . isPrefix "-") args
    flags = filter (isPrefix "-") args

data Options = Options
  { cmd :: String
  , args :: [String]
  , flags :: [String]
  } deriving (Show, Eq)

data ParseResult
  = Help
  | Version
  | Cmd Options
  | Error