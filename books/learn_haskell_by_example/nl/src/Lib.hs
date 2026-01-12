module Lib
  ( displayString,
    numberAllLines,
    numberNonEmptyLines,
    isStringEmpty,
    maybeIndex,
    jlines,
    junlines,
  )
where

import Data.Char (isPrint, isSeparator)

numberAllLines :: [String] -> [(String, Int)]
numberAllLines line =
  let impl :: [String] -> Int -> [(String, Int)]
      impl [] _ = []
      impl (x : xs) idx = (x, idx) : impl xs (idx + 1)
   in impl line 0

numberNonEmptyLines :: [String] -> [(String, Maybe Int)]
numberNonEmptyLines line =
  let impl :: [String] -> Int -> [(String, Maybe Int)]
      impl [] _ = []
      impl (x : xs) idx = if isStringEmpty x
          then (x, Nothing) : impl xs (idx + 1)
          else (x, Just idx) : impl xs (idx + 1)
   in impl line 0

-- index all the lines
-- index only the lines that have content
-- show indices only on the lines that have content

displayString :: [(String, Int)] -> String
displayString [] = ""
displayString ((line, idx) : xs) = show idx ++ ". " ++ line ++ "\n" ++ displayString xs

isStringEmpty :: String -> Bool
isStringEmpty str = null str || all (\c -> not (isPrint c) || isSeparator c) str

maybeIndex :: [Int] -> Int -> Maybe Int
maybeIndex [] _ = Nothing
maybeIndex (x : xs) idx
  | idx > 0 = maybeIndex xs (idx - 1)
  | idx == 0 = Just x
  | otherwise = Nothing

jlines :: String -> [String]
jlines "" = []
jlines str =
  let impl :: String -> String -> [String]
      impl [] acc = [reverse acc]
      impl (x : xs) acc
        | x == '\n' = (reverse acc) : (impl xs "")
        | otherwise = impl xs (x : acc)
   in impl str ""

junlines :: [String] -> String
junlines [] = ""
junlines (x : xs) = x ++ "\n" ++ (junlines xs)
