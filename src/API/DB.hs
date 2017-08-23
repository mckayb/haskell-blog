{-# LANGUAGE OverloadedStrings #-}

module API.DB where

import Prelude (IO, Int, return)
import Database.PostgreSQL.Simple (Only(Only), ConnectInfo(connectHost, connectUser, connectPassword, connectDatabase), query_, connect, defaultConnectInfo)

test :: IO Int
test = do
    conn <- connect defaultConnectInfo { connectHost = "localhost", connectUser = "homestead", connectPassword = "secret", connectDatabase = "homestead" }
    [Only i] <- query_ conn "select 2 + 2"
    return i 