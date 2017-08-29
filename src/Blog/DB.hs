module Blog.DB (safeGetConn) where

import Prelude (IO, Either, return)
import Database.PostgreSQL.Simple ( Connection
                                  , ConnectInfo( connectHost
                                               , connectUser
                                               , connectPassword
                                               , connectDatabase
                                               )
                                  , defaultConnectInfo
                                  , connect
                                  )
import Control.Exception (try, SomeException)
import Blog.Config (env)

opts :: IO ConnectInfo
opts = do
  host <- env "DB_HOST" "localhost"
  user <- env "DB_USER" "homestead"
  pw <- env "DB_PASSWORD" "secret"
  db <- env "DB_NAME" "homestead"
  return defaultConnectInfo
    { connectHost = host
    , connectUser = user
    , connectPassword = pw
    , connectDatabase = db
    }

safeGetConn :: IO (Either SomeException Connection)
safeGetConn = do
  cOpts <- opts
  try (connect cOpts)