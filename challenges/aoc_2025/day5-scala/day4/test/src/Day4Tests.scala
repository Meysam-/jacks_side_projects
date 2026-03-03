package day4

import utest.*

object Day4Tests extends TestSuite {
  def tests = Tests {
    test("basic parsing range") {
      val result = parseRange("0-1")
      assert(result == (0L, 1L))
      result
    }
    test("basic parsing different range") {
      val result = parseRange("10-15")
      assert(result == (10L, 15L))
      result
    }

    test("Make new range from overlap") {
      assert(combineRange((0, 2), (4, 6)) == None)
      assert(combineRange((0, 2), (1, 3)) == Some((0, 3)))
      assert(combineRange((0, 5), (1, 3)) == Some((0, 5)))
      assert(combineRange((1, 2), (0, 3)) == Some((0, 3)))
    }

    test("Combine list of ranges") {
      val result = combineManyRanges(Vector((0, 2), (4, 6)))
      println(result)
      assert(result == Vector((0, 2), (4, 6)))
      assert(combineManyRanges(Vector((0, 4), (4, 6))) == Vector((0, 6)))
    }
  }
}
