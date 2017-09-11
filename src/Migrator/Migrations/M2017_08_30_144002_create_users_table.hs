{-# LANGUAGE OverloadedStrings #-}

module Migrator.Migrations.M2017_08_30_144002_create_users_table (up, down) where
import Database.PostgreSQL.Simple (Connection)
import Prelude (IO, Maybe(Just, Nothing), putStrLn)

up :: Connection -> IO ()
up conn = do
  putStrLn "Migrating M2017_08_30_133002_create_users_table..."
  putStrLn "Going up!"
  putStrLn "Migrated M2017_08_30_133002_create_users_table."

down :: Connection -> IO ()
down conn = do
  putStrLn "Rolling Back M2017_08_30_133002_create_users_table..."
  putStrLn "Going down!"
  putStrLn "Rolled back M2017_08_30_133002_create_users_table."



-- migrate :: IO ()
-- migrate = putStrLn "Testing"
-- migrate = createTable "users" [ ColumnSpec "name" "varchar(255)" Nothing (Just "not null")
                              -- , ColumnSpec "email" "varchar(255)" Nothing (Just "not null")
                              -- , ColumnSpec "password" "varchar(255)" Nothing (Just "not null")
                              -- , ColumnSpec "created_at" "timestamp" (Just "current_timestamp") (Just "not null")
                              -- , ColumnSpec "updated_at" "timestamp" (Just "current_timestamp") (Just "not null")
                              -- ]