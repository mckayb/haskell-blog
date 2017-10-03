{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController where

import Prelude (IO, Bool(True, False), Int, Either(Left, Right), Maybe(Just, Nothing), return, ($))
import Control.Exception (SomeException, try)
import Blog.API.Models.User ( NewUser(newName, newEmail, newPassword)
                            , UpdateUser(updateName, updateEmail , updatePassword)
                            , DBUser(dbName, dbEmail)
                            )
import Blog.DB (safeGetConn)
import Database.PostgreSQL.Simple (Only(Only), query, query_, returning, execute, close)
import Data.Int (Int64)
import Data.Maybe (fromMaybe)

index :: IO [DBUser]
index = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return []
        Right conn -> do
            eitherUsers <- try $ query_ conn "select id, name, email from users" :: IO (Either SomeException [DBUser])
            close conn
            case eitherUsers of
                Left _ -> return []
                Right users -> return users

show :: Int -> IO (Maybe DBUser)
show id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ query conn "select id, name, email from users where id = ?" $ Only id) :: IO (Either SomeException [DBUser])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing

update :: Int -> UpdateUser -> IO (Maybe DBUser)
update id attrs = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            maybeExistingUser <- show id
            case maybeExistingUser of
                Nothing -> return Nothing
                Just usr -> do
                    let query = "update users set name = ?, email = ?, password = ? where id = ? returning id, name, email"
                    let bindings = [( fromMaybe (dbName usr) (updateName attrs)
                                    , fromMaybe (dbEmail usr) (updateEmail attrs)
                                    -- FIXME: How do I pull correct password from the existing user
                                    -- , fromMaybe (dbPassword usr) (updatePassword attrs)
                                    , fromMaybe "Blah" (updatePassword attrs)
                                   )]
                    updatedUser <- (try $ returning conn query bindings) :: IO (Either SomeException [DBUser])
                    close conn
                    case updatedUser of
                        Left _ -> return Nothing
                        Right [u] -> return (Just u)
                        Right _ -> return Nothing

store :: NewUser -> IO (Maybe DBUser)
store user = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ returning conn "insert into users (name, email, password) VALUES (?, ?, ?) returning id, name, email" [(newName user, newEmail user, newPassword user)]) :: IO (Either SomeException [DBUser])
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
