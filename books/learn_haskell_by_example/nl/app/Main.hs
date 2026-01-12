module Main (main) where

import Data.List.Utils (startswith)
import Lib (displayString, numberAllLines, numberNonEmptyLines)
import System.Environment (getArgs)

data Args = Args {numberAll :: Bool, fileName :: String} deriving (Show)

main :: IO ()
main = do
  args <- getArgs
  case parseArguments args of
    Just (Args parseAll fileName) -> do
      contents <- readLines fileName
      putStrLn $
        if parseAll
          then displayString . numberAllLines $ contents
          else "hello world!"
    Nothing -> putStrLn "nl <file name>"

parseArguments :: [String] -> Maybe Args
parseArguments [] = Nothing
parseArguments args =
  let impl Nothing _ = Nothing
      impl (Just args@(Args {numberAll = a, fileName = f})) arg =
        if arg == "--all"
          then
            if a
              then
                Nothing
              else
                Just args {numberAll = True}
          else
            if startswith "--" arg
              then
                Nothing
              else
                if null f
                  then
                    Just args {fileName = arg}
                  else
                    Nothing

      result = foldl impl (Just $ Args False "") args
   in case result of
        Just args@(Args {numberAll = _, fileName = f}) ->
          if null f
            then Nothing
            else Just args
        Nothing -> Nothing

readLines :: FilePath -> IO [String]
readLines filePath = do
  fileContents <- readFile filePath
  return (lines fileContents)
