{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Blog.API.Models.User where

import Prelude (Eq, Show, Integer, Maybe, (<$>), (<*>), (<=))
import Data.Aeson.Types (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.ToField (toField)
import Data.Text (Text)

newtype User a = User a
  deriving (Eq, Show, Generic)

instance ToJSON a => ToJSON (User a)
instance FromJSON a => FromJSON (User a)

data NewUser =
  NewUser { newName :: Text , newEmail :: Text , newPassword :: Text }
  deriving (Eq, Show, Generic) 

instance ToJSON NewUser
instance FromJSON NewUser
instance ToRow NewUser where
  toRow (NewUser a b c) = toRow (a, b, c)
  
data UpdateUser =
  UpdateUser { updateName :: Maybe Text, updateEmail :: Maybe Text, updatePassword :: Maybe Text }
  deriving (Eq, Show, Generic)

instance ToJSON UpdateUser
instance FromJSON UpdateUser
instance ToRow UpdateUser

data DBUser =
  DBUser { responseId :: Integer, responseName :: Text, responseEmail :: Text }
  deriving (Eq, Show, Generic)

instance ToJSON DBUser
instance FromJSON DBUser
instance FromRow DBUser