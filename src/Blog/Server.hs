{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Blog.Server where

import Prelude (Int, Maybe(Just, Nothing), return)
import Control.Monad.IO.Class (liftIO)
import Servant ( Application
               , Server
               , Handler
               , Proxy(Proxy)
               , Capture
               , Get
               , JSON
               , ServantErr(errBody)
               , serve
               , throwError
               , err404
               , (:>)
               , (:<|>)((:<|>))
               )
import Blog.API.Models.User (User)
import qualified Blog.API.Controllers.UsersController as UsersController (indexUsers, showUser)

type BlogAPI = "users" :> Get '[JSON] [User]
  :<|> "users" :> Capture "id" Int :> Get '[JSON] User

blogServer :: Server BlogAPI
blogServer = all
  :<|> single
    where
      all :: Handler [User]
      all = liftIO UsersController.indexUsers

      single :: Int -> Handler User
      single id = do
        mu <- liftIO (UsersController.showUser id)
        case mu of
          Just u -> return u
          Nothing -> throwError (err404 { errBody = "Not found!" })

blogAPI :: Proxy BlogAPI
blogAPI = Proxy

app :: Application
app = serve blogAPI blogServer