package day4
import mainargs.{main, ParserForMethods}
import scala.collection.immutable.NumericRange

def parseRange(input: String): (Long, Long) = {
  val elements = input.split("-")
  (elements(0).toLong, elements(1).toLong)
}

def combineRange(lhs: (Long, Long), rhs: (Long, Long)): Option[(Long, Long)] = {
  if lhs._1 > rhs._2 || lhs._2 < rhs._1 then {
    None
  } else {
    val min = if lhs._1 < rhs._1 then lhs._1 else rhs._1
    val max = if lhs._2 > rhs._2 then lhs._2 else rhs._2
    Some((min, max))
  }
}

def combineManyRanges(ranges: Vector[(Long, Long)]): Vector[(Long, Long)] = {
  ranges.sortBy(_._1).foldLeft(Vector.empty[(Long, Long)]){case (acc, (min, max)) => {
    acc.lastOption match {
      case Some((lastMin, lastMax)) if min <= lastMax =>
        acc.dropRight(1) :+ (lastMin, lastMax.max(max))
      case Some(_) | None =>
        acc :+ (min, max)
    }
  }}
}

object Day4 {
  @main
  def main() = {
    val path = os.pwd / "day4.txt"
    val lines = os.read.lines(path)
    val idx = lines.indexOf("")
    val (ranges, values) = lines.splitAt(idx)

    val r = ranges.map(parseRange(_)).toVector
    val v = values.drop(1).map(_.toLong)

    val count = v.fold(0L)((acc, v) => {
      if r.find((range) => v >= range._1 && v <= range._2).isDefined then
        acc + 1
      else
        acc
    })
    val numberOfPossibleFresh = combineManyRanges(r).foldLeft(0L){case (acc, (min, max)) => acc + (max - min + 1L) }

    println(count)
    println(numberOfPossibleFresh)
  }

  def main(args: Array[String]): Unit = ParserForMethods(this).runOrExit(args)
}
