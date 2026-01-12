module Lib where

import Data.List (elemIndex)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- Input of a char list and rotate the input by some other thing
--
-- Have the input sorted into alphabets
-- Get the index of that letter in the alphabet
-- Rotate it by some index in that alphabet

lower :: String
lower = ['a' .. 'z']

isLower :: Char -> Bool
isLower char = char `elem` lower

upper :: String
upper = ['A' .. 'Z']

isUpper :: Char -> Bool
isUpper char = char `elem` upper

digit :: String
digit = ['0' .. '9']

isDigit :: Char -> Bool
isDigit char = char `elem` digit

alphabet :: String
alphabet = lower ++ upper ++ digit

caesar :: Int -> String -> String
caesar rotation message = case mapM (flip elemIndex alphabet) message of
    Just indices -> map (\v -> alphabet !! ((v + rotation) `mod` (length alphabet))) indices
    Nothing -> ""

indexOf :: [a] -> Int -> a
indexOf (x:_) 0 = x
indexOf [x] 0 = x
indexOf (_:xs) idx
    | idx > 0
    = indexOf xs (idx - 1)

-- trying to reimplement the map function
transform :: (a -> b) -> [a] -> [b]
transform _ [] = []
transform fun (x:xs) = fun x : transform fun xs

-- counting the number of occurences of a character in a string
count :: Char -> String -> Int
count _ [] = 0
count c (x:xs) = (if c == x then 1 else 0) + count c xs
