{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController where

import Prelude (IO, Bool(True, False), Int, Either(Left, Right), Maybe(Just, Nothing), return, ($))
import Control.Exception (SomeException, try)
import Blog.API.Models.User (PublicUser, NewUser(newName, newEmail, newPassword))
import Blog.DB (safeGetConn)
import Database.PostgreSQL.Simple (Only(Only), query, query_, returning, execute, close)
import Data.Int (Int64)

index :: IO [PublicUser]
index = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return []
        Right conn -> do
            eitherUsers <- try $ query_ conn "select id, name, email from users" :: IO (Either SomeException [PublicUser])
            close conn
            case eitherUsers of
                Left _ -> return []
                Right users -> return users

show :: Int -> IO (Maybe PublicUser)
show id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ query conn "select name, email from users where id = ?" $ Only id) :: IO (Either SomeException [PublicUser])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing

store :: NewUser -> IO (Maybe PublicUser)
store user = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ returning conn "insert into users (name, email, password) VALUES (?, ?, ?) returning id, name, email" [(newName user, newEmail user, newPassword user)]) :: IO (Either SomeException [PublicUser])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing

destroy :: Int -> IO Bool
destroy id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return False
        Right conn -> do
            eitherRes <- (try $ execute conn "delete from users where id = ?" $ Only id) :: IO (Either SomeException Int64)
            close conn
            case eitherRes of
                Left _ -> return False
                Right 1 -> return True
                Right _ -> return False
