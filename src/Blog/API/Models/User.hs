{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Models.User where

import Prelude (Eq, Show, Integer, Maybe)
import Data.Aeson.Types (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow)
import Database.PostgreSQL.Simple.ToRow (ToRow)
import Data.Text (Text)

newtype User a = User a
  deriving (Eq, Show, Generic)

instance ToJSON a => ToJSON (User a)
instance FromJSON a => FromJSON (User a)

data NewUser =
  NewUser { newName :: Text , newEmail :: Text , newPassword :: Text }
  deriving (Eq, Show, Generic) 

instance FromJSON NewUser
instance ToRow NewUser
  
data UpdateUser =
  UpdateUser { updateName :: Maybe Text, updateEmail :: Maybe Text, updatePassword :: Maybe Text }
  deriving (Eq, Show, Generic)

instance FromJSON UpdateUser
instance ToRow UpdateUser

data AuthUser =
  AuthUser { authId :: Integer, authName :: Text, authEmail :: Text }
  deriving (Eq, Show, Generic)

instance ToJSON AuthUser
instance FromRow AuthUser

data DBUser =
  DBUser { dbId :: Integer, dbName :: Text, dbEmail :: Text, dbPassword :: Text }
  deriving (Eq, Show, Generic)

instance ToJSON DBUser
instance FromRow DBUser