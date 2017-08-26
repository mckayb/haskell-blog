module Blog.DB where

import Prelude (IO, Either)
import Database.PostgreSQL.Simple ( Connection
                                  , ConnectInfo( connectHost
                                               , connectUser
                                               , connectPassword
                                               , connectDatabase
                                               )
                                  , defaultConnectInfo
                                  , connect
                                  , SqlError
                                  )
import Control.Exception (try, Exception, SomeException)

opts :: ConnectInfo
opts = defaultConnectInfo
    { connectHost = "localhost"
    , connectUser = "homestead"
    , connectPassword = "secret"
    , connectDatabase = "homestead"
    }

getConn :: IO Connection
getConn = connect opts

safeGetConn :: ConnectInfo -> IO (Either SomeException Connection)
safeGetConn opts = try (connect opts)