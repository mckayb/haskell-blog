{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Blog.API.Server where

import Prelude (Int)
import Control.Monad.IO.Class (liftIO)
import Servant ( Application
               , Server
               , Handler
               , Proxy(Proxy)
               , Capture
               , Get
               , JSON
               , serve
               , (:>)
               , (:<|>)((:<|>))
               )
import Blog.API.Models.User (User)
import qualified Blog.API.Controllers.UsersController as UsersController (index, show)

type BlogAPI = "users" :> Get '[JSON] [User]
  :<|> "users" :> Capture "id" Int :> Get '[JSON] User

blogServer :: Server BlogAPI
blogServer = indexUsers
  :<|> showUser
    where
      indexUsers :: Handler [User]
      indexUsers = liftIO UsersController.index

      showUser :: Int -> Handler User
      showUser id = liftIO (UsersController.show id)

blogAPI :: Proxy BlogAPI
blogAPI = Proxy

app :: Application
app = serve blogAPI blogServer