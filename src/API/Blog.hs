{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module API.Blog where

import Prelude (Eq, Show, String, return)
import GHC.Generics (Generic)
import Data.Aeson.Types (ToJSON)
import Servant (Application, Server, Proxy(Proxy), Get, JSON, serve, (:>), (:<|>)((:<|>)))

userAPI :: Proxy UserAPI
userAPI = Proxy

data User = User
  { name :: String
  , email :: String
  } deriving (Eq, Show, Generic)

instance ToJSON User

isaac :: User
isaac = User "Isaac Newton" "isaac@newton.co.uk"

albert :: User
albert = User "Isaac Newton" "isaac@newton.co.uk"

type UserAPI = "users" :> Get '[JSON] [User] :<|> "albert" :> Get '[JSON] User :<|> "isaac" :> Get '[JSON] User

server :: Server UserAPI
server = return [isaac, albert]
  :<|> return albert
  :<|> return isaac

app :: Application
app = serve userAPI server