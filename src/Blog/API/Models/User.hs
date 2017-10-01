{-# LANGUAGE DeriveGeneric #-}

module Blog.API.Models.User where

import Prelude (Eq, Show, String, Integer, Maybe, (<$>), (<*>))
import Data.Aeson.Types (ToJSON, FromJSON)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.ToField (toField)

newtype User a = User a
  deriving (Eq, Show, Generic)

data NewUser =
  NewUser { newName :: String , newEmail :: String , newPassword :: String }
  deriving (Eq, Show, Generic)

data UpdateUser =
  UpdateUser { updateName :: Maybe String, updateEmail :: Maybe String, updatePassword :: Maybe String }
  deriving (Eq, Show, Generic)

data ResponseUser =
  ResponseUser { responseId :: Integer, responseName :: String, responseEmail :: String }

-- TODO: Add FromRow, ToRow, FromJSON, ToJSON to proper fields