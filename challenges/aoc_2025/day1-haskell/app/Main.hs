module Main (main) where

import Text.Read (readMaybe)
import Data.Maybe (catMaybes)

data Direction = L | R deriving (Show)

parseInstructions :: String -> [(Direction, Int)]
parseInstructions contents = catMaybes $ map parseInstruction $ lines contents

parseInstruction :: String -> Maybe (Direction, Int)
parseInstruction ('L' : xs) = (\v -> (L, v) ) <$> readMaybe xs
parseInstruction ('R' : xs) = (\v -> (R, v) ) <$> readMaybe xs
parseInstruction _ = Nothing

resolveCounter1 :: Int -> Int -> (Int, Int)
resolveCounter1 counter dial
    | dial == 0 = (counter + 1, dial)
    | dial < 0 = resolveCounter1 counter (dial + 100)
    | dial > 99 = resolveCounter1 counter (dial - 100)
    | otherwise = (counter, dial)

part1 :: Int -> Int -> [(Direction, Int)] -> (Int, Int)
part1 counter dial [] = (counter, dial)
part1 counter dial ((dir, ticks) : xs) =
    let
        newDialRaw = case dir of
            L -> dial - ticks
            R -> dial + ticks
        (newCounter, newDial) = resolveCounter1 counter newDialRaw 
    in
        part1 newCounter newDial xs

resolveCounter2 :: Int -> Int -> Int -> (Int, Int)
resolveCounter2 counter dial oldDial
    | dial == 0 || dial == 100 = (counter + 1, 0)
    | dial == -100 && oldDial > 0 = (counter + 2, 0)
    | dial == -100 = (counter + 1, 0)
    | dial < 0 && dial > -100 && oldDial > 0 = resolveCounter2 (counter + 1) (dial + 100) oldDial
    | dial < -100 = resolveCounter2 (counter + 1) (dial + 100) oldDial
    | dial < 0 = resolveCounter2 counter (dial + 100) oldDial
    | dial > 99 = resolveCounter2 (counter + 1) (dial - 100) oldDial
    | otherwise = (counter, dial)

part2 :: Int -> Int -> [(Direction, Int)] -> (Int, Int)
part2 counter dial [] = (counter, dial)
part2 counter dial ((dir, ticks) : xs) =
    let
        newDialRaw = case dir of
            L -> dial - ticks
            R -> dial + ticks
        (newCounter, newDial) = resolveCounter2 counter newDialRaw dial
    in
        part2 newCounter newDial xs

part2Again :: Int -> Int -> [(Direction, Int)] -> (Int, Int)
part2Again counter dial [] = (counter, dial)
part2Again counter dial (inst : xs) =
    let (newCounter, newDial) = processInst2 counter dial inst
    in part2Again newCounter newDial xs

processInst2 :: Int -> Int -> (Direction, Int) -> (Int, Int)
processInst2 counter dial ((R, ticks)) =
    let
        tmp = dial + ticks
        newDial = tmp `mod` 100
        newCounter = counter + (tmp `div` 100)
    in
        (newCounter, newDial)

processInst2 counter dial ((L, ticks)) =
    let
        tmp = dial - ticks
        newDial = abs $ tmp `mod` 100
        landsOnZeroCount = if newDial == 0 then 1 else 0
        startsOnZeroCount = if dial == 0 then -1 else 0
        newCounter =
            if ticks > dial then
                counter + (abs $ tmp `div` 100) + landsOnZeroCount + startsOnZeroCount
            else
                counter + landsOnZeroCount
    in
        (newCounter, newDial)

part2TestsAgain :: IO ()
part2TestsAgain = do
    _ <- readFile "day1-example.txt"
    print "starting positive going left"
    print "expect 1"
    print $ processInst2 0 50 (L, 50)
    print "expect 1"
    print $ processInst2 0 50 (L, 100)
    print "expect 2"
    print $ processInst2 0 50 (L, 150)
    print "expect 2"
    print $ processInst2 0 50 (L, 200)
    print "starting on zero going left"
    print "expect 0"
    print $ processInst2 0 0 (L, 50)
    print "expect 1"
    print $ processInst2 0 0 (L, 100)
    print "expect 1"
    print $ processInst2 0 0 (L, 150)
    print "starting positive going right"
    print "expect 0"
    print $ processInst2 0 50 (R, 25)
    print "expect 1"
    print $ processInst2 0 50 (R, 50)
    print "expect 1"
    print $ processInst2 0 50 (R, 100)
    print "expect 2"
    print $ processInst2 0 50 (R, 200)
    print "starting on zero going right"
    print "expect 0"
    print $ processInst2 0 0 (R, 50)
    print "expect 1"
    print $ processInst2 0 0 (R, 100)
    print "expect 1"
    print $ processInst2 0 0 (R, 150)
    print "expect 2"
    print $ processInst2 0 0 (R, 200)
    print "expect 2"
    print $ processInst2 0 0 (R, 250)
    print "expect 10"
    print $ processInst2 0 50 (R, 1000)

part2Tests :: IO ()
part2Tests = do
    _ <- readFile "day1-example.txt"
    print "starting positive going left"
    print "expect 1"
    print $ resolveCounter2 0 (50 - 50) 50
    print "expect 1"
    print $ resolveCounter2 0 (50 - 100) 50
    print "expect 2"
    print $ resolveCounter2 0 (50 - 150) 50
    print "expect 2"
    print $ resolveCounter2 0 (50 - 200) 50
    print "starting on zero going left"
    print "expect 0"
    print $ resolveCounter2 0 (-50) 0
    print "expect 1"
    print $ resolveCounter2 0 (-100) 0
    print "expect 1"
    print $ resolveCounter2 0 (-150) 0
    print "starting positive going right"
    print "expect 0"
    print $ resolveCounter2 0 (50 + 25) 50
    print "expect 1"
    print $ resolveCounter2 0 (50 + 50) 50
    print "expect 1"
    print $ resolveCounter2 0 (50 + 100) 50
    print "expect 2"
    print $ resolveCounter2 0 (50 + 200) 50
    print "starting on zero going right"
    print "expect 0"
    print $ resolveCounter2 0 50 0
    print "expect 1"
    print $ resolveCounter2 0 100 0
    print "expect 1"
    print $ resolveCounter2 0 150 0
    print "expect 2"
    print $ resolveCounter2 0 200 0
    print "expect 2"
    print $ resolveCounter2 0 250 0
    print "expect 10"
    print $ resolveCounter2 0 1050 50

main :: IO ()
main = do
    -- contents <- readFile "day1-example.txt"
    contents <- readFile "day1.txt"
    let instructions =  parseInstructions contents
    let result = part1 0 50 instructions
    print result
    let result = part2 0 50 instructions
    print result
    let result = part2Again 0 50 instructions
    print result
    -- part2TestsAgain
