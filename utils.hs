module Utils where

import System.Info (os)
import System.Process (readProcessWithExitCode)
import System.Exit
import Text.Printf
import qualified Data.List as L
import qualified Data.Text as T

uppercase = map T.toUpper
lowercase = map T.toLower

-- | Attempt to open a web browser on the given url, all platforms.
openBrowser :: String -> IO ExitCode
openBrowser u = trybrowsers browsers u
    where
      trybrowsers (b:bs) u = do
        (e,_,_) <- readProcessWithExitCode b [u] ""
        case e of
          ExitSuccess -> return ExitSuccess
          ExitFailure _ -> trybrowsers bs u
      trybrowsers [] u = do
        putStrLn $ printf "Could not start a web browser (tried: %s)" $ L.intercalate ", " browsers
        putStrLn $ printf "Please open your browser and visit %s" u
        return $ ExitFailure 127
      browsers | os=="darwin"  = ["open"]
               | os=="mingw32" = ["c:/Program Files/Mozilla Firefox/firefox.exe"]
               | otherwise     = ["sensible-browser","gnome-www-browser","firefox"]

{-
main = do
    openBrowser "http://google.com"

-}
