module Blog
    ( start
    ) where

import Prelude (IO, Bool(False))
import Blog.Server (app)
import Network.Wai.Handler.Warp (run)
import qualified Configuration.Dotenv as Dotenv (loadFile)

start :: IO ()
start = do
    Dotenv.loadFile False ".env"
    run 8081 app