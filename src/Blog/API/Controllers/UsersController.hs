{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController where

import Prelude (IO, Int, return, ($))
import Blog.API.Models.User (User)
import Blog.DB (opts)
import Database.PostgreSQL.Simple
    ( Only(Only)
    , query
    , query_
    , connect
    )

index :: IO [User]
index = do
    conn <- connect opts
    query_ conn "select name, email, password from users"

show :: Int -> IO User
show id = do
    conn <- connect opts
    [u] <- query conn "select name, email, password from users where id = ?" $ Only id
    return u