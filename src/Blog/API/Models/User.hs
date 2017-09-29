{-# LANGUAGE DeriveGeneric #-}

module Blog.API.Models.User where

import Prelude (Eq, Show, String, Integer, Maybe, (<$>), (<*>))
import Data.Aeson.Types (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.ToField (toField)

data NewUser = NewUser
  { newName :: String
  , newEmail :: String
  , newPassword :: String
  } deriving (Eq, Show, Generic)

instance ToJSON NewUser
instance FromJSON NewUser

instance ToRow NewUser where
  toRow u = [toField (newName u), toField (newEmail u), toField (newPassword u)]


data UpdateUser = UpdateUser
  { updateName :: Maybe String
  , updateEmail :: Maybe String
  , updatePassword :: Maybe String
  } deriving (Eq, Show, Generic)

instance ToJSON UpdateUser


data PublicUser = PublicUser
  { id :: Integer
  , name :: String
  , email :: String
  } deriving (Eq, Show, Generic)

instance ToJSON PublicUser

instance FromRow PublicUser where
  fromRow = PublicUser <$> field <*> field <*> field

instance ToRow PublicUser where
  toRow u = [toField (id u), toField (name u), toField (email u)]
