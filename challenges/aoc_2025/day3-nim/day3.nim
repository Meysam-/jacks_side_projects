import std/strutils
import std/sequtils
import std/sugar
import std/enumerate
import std/strformat
import std/unittest
import std/algorithm

proc largestDigitBetween(bank: string, start: int, length: int): (int, char) =
    let (idx, c) = bank[start..(bank.len() - length)]
        .pairs
        .toSeq
        .foldl(if b[1] > a[1]: b else: a)

    (idx + start, c)

proc largestPairDigitSeqIn(bank: string): int =
    let (idx, first) = largestDigitBetween(bank, 0, 2)

    let second = bank[(idx + 1)..(bank.len() - 1)]
        .foldl(if b > a: b else: a)

    fmt"{first}{second}".parseInt()

proc largestDigitSeqIn(bank: string, length: int): int =
    var idx = 0
    var acc = ""
    for length in countdown(length, 1):
        let (idxOfChar, c) = largestDigitBetween(bank, idx, length)
        idx = (idxOfChar + 1)
        acc.add(c)
    
    acc.parseInt()

#-----------------------------------------------------------------------
# main
#-----------------------------------------------------------------------

let input = readFile("./day3.txt")
    .splitLines()
    .filter(v => not v.isEmptyOrWhitespace())

let part1 = input
    .map(v => largestPairDigitSeqIn(v))
    .foldl(a + b)

echo fmt"Answer to part one is {part1}"

let part2 = input
    .map(v => largestDigitSeqIn(v, 12))
    .foldl(a + b)

echo fmt"Answer to part two is {part2}"

#-----------------------------------------------------------------------
# tests
#-----------------------------------------------------------------------

suite "Tests for aoc day 3":
    echo "We're setting up the suite"

    test "basic":
        require(1 == 1)

    test "largest sequence":
        require(largestPairDigitSeqIn("12345") == 45)
        require(largestPairDigitSeqIn("987654321111111") == 98)
        require(largestPairDigitSeqIn("811111111111119") == 89)
        require(largestPairDigitSeqIn("234234234234278") == 78)

    test "largest digit from end":
        require(largestDigitBetween("12345", 0, 2) == (3, '4'))
        require(largestDigitBetween("987654321111111", 0, 12) == (0, '9'))
        require(largestDigitBetween("987654321111111", 1, 11) == (1, '8'))

    test "largest 12 sequence":
        require(largestDigitSeqIn("987654321111111", 12) == 987654321111)
        require(largestDigitSeqIn("811111111111119", 12) == 811111111119)
        require(largestDigitSeqIn("234234234234278", 12) == 434234234278)
        require(largestDigitSeqIn("818181911112111", 12) == 888911112111)
