{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController where

import Prelude (IO, Int, Either(Left, Right), return, fmap, ($), (>>=))
import Control.Exception (Exception, SomeException, try)
import Blog.API.Models.User (User)
import Blog.DB (opts, getConn, safeGetConn)
import Database.PostgreSQL.Simple ( Only(Only)
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

indexSafe :: IO [User]
indexSafe = do
    conn <- safeGetConn opts
    case conn of
        Left e -> return []
        Right connection -> 
            let
                connResults :: IO (Either SomeException [User])
                connResults = try $ query_ connection "select name, email, password from users"
            in do
                eitherUsers <- connResults
                case eitherUsers of
                    Left e -> return []
                    Right u -> return u
