{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Blog.Server where

import Prelude (Int, Maybe(Just, Nothing), fmap, return)
import Control.Monad.IO.Class (liftIO)
import Servant ( Application , Server , Handler , Proxy(Proxy)
               , Capture , Get , Post , Delete , Put , JSON
               , ServantErr(errBody) , ReqBody , NoContent(NoContent)
               , serve , throwError , err404 , err400
               , (:>) , (:<|>)((:<|>))
               )
import Blog.API.Models.User (User(User), NewUser, UpdateUser, AuthUser)
import qualified Blog.API.Controllers.UsersController as UsersController (index, show, store, update, destroy)

type BlogAPI =
       "users" :> Get '[JSON] [User AuthUser]
  :<|> "users" :> Capture "id" Int :> Get '[JSON] (User AuthUser)
  :<|> "users" :> ReqBody '[JSON] (User NewUser) :> Post '[JSON] (User AuthUser)
  :<|> "users" :> Capture "id" Int :> ReqBody '[JSON] (User UpdateUser) :> Put '[JSON] (User AuthUser)
  :<|> "users" :> Capture "id" Int :> Delete '[JSON] NoContent

blogServer :: Server BlogAPI
blogServer = indexUsers
  :<|> showUser
  :<|> storeUser
  :<|> updateUser
  :<|> deleteUser
    where
      indexUsers :: Handler [User AuthUser]
      indexUsers = do
        users <- liftIO UsersController.index
        return (fmap User users)

      showUser :: Int -> Handler (User AuthUser)
      showUser id = do
        mu <- liftIO (UsersController.show id)
        case mu of
          Just u -> return (User u)
          Nothing -> throwError (err404 { errBody = "Not found!" })

      storeUser :: User NewUser -> Handler (User AuthUser)
      storeUser (User user) = do
        mu <- liftIO (UsersController.store user)
        case mu of
          Just u -> return (User u)
          Nothing -> throwError (err400 { errBody = "Unable to create new user!" })

      updateUser :: Int -> User UpdateUser -> Handler (User AuthUser)
      updateUser id (User user) = do
        mu <- liftIO (UsersController.update id user)
        case mu of
          Just u -> return (User u)
          Nothing -> throwError (err400 { errBody = "Unable to update user!" })

      deleteUser :: Int -> Handler NoContent
      deleteUser id = do
        res <- liftIO (UsersController.destroy id)
        if res then return NoContent else throwError (err400 { errBody = "Unable to delete user!" })


blogAPI :: Proxy BlogAPI
blogAPI = Proxy

app :: Application
app = serve blogAPI blogServer