package day4

import utest.*

object Day4Tests extends TestSuite {
  def tests = Tests {
    test("simple") {
      val result = Day4.generateHtml("hello")
      assert(result == "<h1>hello</h1>")
      result
    }
    test("escaping") {
      val result = Day4.generateHtml("<hello>")
      assert(result == "<h1>&lt;hello&gt;</h1>")
      result
    }
  }
}
