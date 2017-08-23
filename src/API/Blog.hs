{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module API.Blog where

import Prelude (Eq, Show, String, Int, return)
import Control.Monad.IO.Class (liftIO)
import GHC.Generics (Generic)
import Data.Aeson.Types (ToJSON)
import Servant (Application, Server, Proxy(Proxy), Get, JSON, serve, (:>), (:<|>)((:<|>)))

import API.DB (test)

userAPI :: Proxy UserAPI
userAPI = Proxy

data User = User
  { name :: String
  , email :: String
  , age :: Int
  } deriving (Eq, Show, Generic)

instance ToJSON User

isaac :: User
isaac = User "Isaac Newton" "isaac@newton.co.uk" 112

albert :: User
albert = User "Isaac Newton" "isaac@newton.co.uk" 122

type UserAPI = "users" :> Get '[JSON] [User]
  :<|> "albert" :> Get '[JSON] User
  :<|> "isaac" :> Get '[JSON] User

server :: Server UserAPI
server = return [isaac, albert]
  :<|> do
    res <- liftIO test
    return (User "Isaac Newton" "Blue" res)
  :<|> return isaac

app :: Application
app = serve userAPI server