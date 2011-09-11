module Utils where

import System.Info (os)
import System.Process (readProcessWithExitCode)
import System.Exit
import Text.Printf
import Control.Monad (forM)
import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))
import qualified Data.List as L
import Data.List.Split
import qualified Data.Text as T
import Text.Regex

-- convenience functions to translate Maybes to bools
maybe_bool (Just _)= True
maybe_bool Nothing = False

-- convenience function to make Haskell regexes behave like Perl regexes
str =~ regex = maybe_bool $ matchRegex (mkRegex regex) str
str !~ regex = not $ str =~ regex

joinOn str l = foldl1 (\acc x -> acc ++ str ++ x) l

join = joinOn ""

-- given a file name, get the name of the directory that it's in
dirName f = ((joinOn "/").init.(splitOn "/")) f

-- a glob function. usage:
-- glob "/usr/local/bin/*.hs"
glob pat = do
    -- try to guess the directory name by ignoring everything after the first * and getting the dir name from the part before the *.
    let dir = dirName (fst (break (=='*') pat))
    contents <- getRecursiveContents dir
    -- get files that match that pattern and aren't invisible files or dirs
    return $ filter (\x -> (x =~ pat) && (x !~ "/\\..*")) contents

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


-- Given a directory, get all the contents in that dir, recursively.
getRecursiveContents :: FilePath -> IO [FilePath]
getRecursiveContents topdir = do
  names <- getDirectoryContents topdir
  let properNames = filter (`notElem` [".", ".."]) names
  paths <- forM properNames $ \name -> do
    let path = topdir </> name
    isDirectory <- doesDirectoryExist path
    if isDirectory
      then getRecursiveContents path
      else return [path]
  return (concat paths)


{-
main = do
    openBrowser "http://google.com"
    getRecursiveContents "."
-}
