module Blog.DB where

import Database.PostgreSQL.Simple
  ( defaultConnectInfo
  , ConnectInfo(connectHost, connectUser, connectPassword, connectDatabase)
  )

opts :: ConnectInfo
opts = defaultConnectInfo
    { connectHost = "localhost"
    , connectUser = "homestead"
    , connectPassword = "secret"
    , connectDatabase = "homestead"
    }
