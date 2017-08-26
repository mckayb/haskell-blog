module Blog.DB (safeGetConn) where

import Prelude (IO, Either)
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

opts :: ConnectInfo
opts = defaultConnectInfo
    { connectHost = "localhost"
    , connectUser = "homestead"
    , connectPassword = "secret"
    , connectDatabase = "homestead"
    }

safeGetConn :: IO (Either SomeException Connection)
safeGetConn = try (connect opts)