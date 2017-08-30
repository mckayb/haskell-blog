{-# LANGUAGE OverloadedStrings #-}

module M2017_08_30_144002_create_users_table where

import Prelude (IO, Maybe(Just, Nothing))
import Database.Rivet.V0 (ColumnSpec, createTable)

migrate :: Migration IO ()
migrate = createTable "users" [ ColumnSpec "name" "varchar(255)" Nothing (Just "not null")
                              , ColumnSpec "email" "varchar(255)" Nothing (Just "not null")
                              , ColumnSpec "password" "varchar(255)" Nothing (Just "not null")
                              , ColumnSpec "created_at" "timestamp" (Just "current_timestamp") (Just "not null")
                              , ColumnSpec "updated_at" "timestamp" (Just "current_timestamp") (Just "not null")
                              ]