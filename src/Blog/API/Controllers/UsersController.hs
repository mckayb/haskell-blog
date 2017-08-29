{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController where

import Prelude (IO, Int, Either(Left, Right), Maybe(Just, Nothing), return, ($))
import Control.Exception (SomeException, try)
import Blog.API.Models.User (User)
import Blog.DB (safeGetConn)
import Database.PostgreSQL.Simple (Only(Only), query, query_, close)

index :: IO [User]
index = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return []
        Right conn -> do
            eitherUsers <- try $ query_ conn "select name, email, password from users" :: IO (Either SomeException [User])
            close conn
            case eitherUsers of
                Left _ -> return []
                Right users -> return users

show :: Int -> IO (Maybe User)
show id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ query conn "select name, email, password from users where id = ?" $ Only id) :: IO (Either SomeException [User])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing