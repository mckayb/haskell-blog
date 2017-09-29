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
               , Post
               , Delete
               , JSON
               , ServantErr(errBody)
               , ReqBody
               , NoContent(NoContent)
               , serve
               , throwError
               , err404
               , err400
               , (:>)
               , (:<|>)((:<|>))
               )
import Blog.API.Models.User (PublicUser, NewUser)
import qualified Blog.API.Controllers.UsersController as UsersController (index, show, store, destroy)

type BlogAPI = "users" :> Get '[JSON] [PublicUser]
  :<|> "users" :> Capture "id" Int :> Get '[JSON] PublicUser
  :<|> "users" :> ReqBody '[JSON] NewUser :> Post '[JSON] PublicUser
  -- :<|> "users" :> Capture "id" Int :> ReqBody '[JSON] NewUser :> Put '[JSON] PublicUser
  :<|> "users" :> Capture "id" Int :> Delete '[JSON] NoContent

blogServer :: Server BlogAPI
blogServer = indexUsers
  :<|> showUser
  :<|> storeUser
  -- :<|> updateUser
  :<|> deleteUser
    where
      indexUsers :: Handler [PublicUser]
      indexUsers = liftIO UsersController.index

      showUser :: Int -> Handler PublicUser
      showUser id = do
        mu <- liftIO (UsersController.show id)
        case mu of
          Just u -> return u
          Nothing -> throwError (err404 { errBody = "Not found!" })

      storeUser :: NewUser -> Handler PublicUser
      storeUser user = do
        mu <- liftIO (UsersController.store user)
        case mu of
          Just u -> return u
          Nothing -> throwError (err400 { errBody = "Unable to create new user!" })

      {- updateUser :: Int -> NewUser -> Handler PublicUser
      updateUser id user = do
        mu <- liftIO (UsersController.update id user)
        case mu of
          Just u -> return u
          Nothing -> throwError (err400 { errBody = "Unable to update user!" }) -}

      deleteUser :: Int -> Handler NoContent
      deleteUser id = do
        res <- liftIO (UsersController.destroy id)
        if res then return NoContent else throwError (err400 { errBody = "Unable to delete user!" })


blogAPI :: Proxy BlogAPI
blogAPI = Proxy

app :: Application
app = serve blogAPI blogServer