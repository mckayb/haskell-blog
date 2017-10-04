{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Controllers.UsersController (index, store, show, update, destroy) where

import Prelude (IO, Bool(True, False), Int, Either(Left, Right), Maybe(Just, Nothing), return, ($))
import Control.Exception (SomeException, try)
import Blog.API.Models.User ( NewUser(newName, newEmail, newPassword)
                            , UpdateUser(updateName, updateEmail , updatePassword)
                            , DBUser(dbName, dbEmail, dbPassword)
                            , AuthUser
                            )
import Blog.DB (safeGetConn)
import Database.PostgreSQL.Simple (Only(Only), query, query_, returning, execute, close)
import Data.Int (Int64)
import Data.Maybe (fromMaybe)

index :: IO [AuthUser]
index = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return []
        Right conn -> do
            eitherUsers <- try $ query_ conn "select id, name, email from users" :: IO (Either SomeException [AuthUser])
            close conn
            case eitherUsers of
                Left _ -> return []
                Right users -> return users

show :: Int -> IO (Maybe AuthUser)
show id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ query conn "select id, name, email from users where id = ?" $ Only id) :: IO (Either SomeException [AuthUser])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing

update :: Int -> UpdateUser -> IO (Maybe AuthUser)
update id attrs = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            maybeExistingUser <- showDBUser id
            case maybeExistingUser of
                Nothing -> return Nothing
                Just usr -> do
                    let q = "update users set name = ?, email = ?, password = ? where id = ? returning id, name, email"
                    let bindings = [( fromMaybe (dbName usr) (updateName attrs)
                                    , fromMaybe (dbEmail usr) (updateEmail attrs)
                                    -- TODO: encrypt the password, don't store as plain text
                                    , fromMaybe (dbPassword usr) (updatePassword attrs)
                                   )]
                    updatedUser <- (try $ returning conn q bindings) :: IO (Either SomeException [AuthUser])
                    close conn
                    case updatedUser of
                        Left _ -> return Nothing
                        Right [u] -> return (Just u)
                        Right _ -> return Nothing

store :: NewUser -> IO (Maybe AuthUser)
store user = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            -- TODO: encrypt the password, don't store as plain text
            eitherUser <- (try $ returning conn "insert into users (name, email, password) VALUES (?, ?, ?) returning id, name, email" [(newName user, newEmail user, newPassword user)]) :: IO (Either SomeException [AuthUser])
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


-- Helper Function
showDBUser :: Int -> IO (Maybe DBUser)
showDBUser id = do
    eitherConn <- safeGetConn
    case eitherConn of
        Left _ -> return Nothing
        Right conn -> do
            eitherUser <- (try $ query conn "select id, name, email, password from users where id = ?" $ Only id) :: IO (Either SomeException [DBUser])
            close conn
            case eitherUser of
                Left _ -> return Nothing
                Right [u] -> return (Just u)
                Right _ -> return Nothing
