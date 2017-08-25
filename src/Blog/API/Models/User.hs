{-# LANGUAGE DeriveGeneric #-}

module Blog.API.Models.User where

import Prelude (Eq, Show, String, (<$>), (<*>))
import Data.Aeson.Types (ToJSON)
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.ToField (toField)

data User = User
  { name :: String
  , email :: String
  , password :: String
  } deriving (Eq, Show, Generic)

instance ToJSON User

instance FromRow User where
  fromRow = User <$> field <*> field <*> field

instance ToRow User where
  toRow u = [toField (name u), toField (email u), toField (password u)]