module Lib
    ( start
    ) where

import Blog.Server (app)
import Network.Wai.Handler.Warp (run)

start :: IO ()
start = run 8081 app