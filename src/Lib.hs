module Lib
    ( start
    ) where

import Blog.Server (app)
import Blog.Config (load)
import Network.Wai.Handler.Warp (run)

start :: IO ()
start = do
    load ".env"
    run 8081 app