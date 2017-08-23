module Lib
    ( start
    ) where

import API.Blog (app)
import Network.Wai.Handler.Warp (run)

start :: IO ()
start = run 8081 app
