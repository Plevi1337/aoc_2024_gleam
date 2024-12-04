import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import simplifile

pub type Day3Error {
  RegexError(regexp.CompileError)
  StringError(String)
}

pub fn solve_day_03() {
  use input <- result.try(read_input() |> result.map_error(StringError))

  //solve_first(input)
  solve_second(input)
}

fn solve_first(input: String) {
  use mul_ops <- result.try(get_mul_ops(input))

  list.map(mul_ops, calculate_mul_op)
  |> result.all
  |> result.map(fn(x) { list.fold(x, 0, fn(a, b) { a + b }) })
}

fn solve_second(input: String) {
  use segments <- result.try(get_do_segments(input))

  segments
  |> list.map(get_mul_ops)
  |> result.all
  |> result.try(fn(mul_ops) {
    list.flatten(mul_ops)
    |> list.map(calculate_mul_op)
    |> result.all
  })
  |> result.map(fn(x) { list.fold(x, 0, fn(a, b) { a + b }) })
}

fn get_mul_ops(input_result: String) -> Result(List(String), Day3Error) {
  regexp.from_string("mul\\([0-9]+,[0-9]+\\)")
  |> result.map_error(RegexError)
  |> result.map(fn(regex) {
    regexp.scan(regex, input_result)
    |> list.map(fn(match) { match.content })
  })
}

fn calculate_mul_op(input: String) -> Result(Int, Day3Error) {
  use regex <- result.try(
    regexp.from_string("mul\\(([0-9]+),([0-9]+)\\)")
    |> result.map_error(RegexError),
  )

  regexp.scan(regex, input)
  |> list.map(fn(match) {
    list.map(match.submatches, fn(submatch) {
      case submatch {
        option.Some(submatch) -> submatch
        option.None -> ""
      }
    })
    |> list.map(fn(x) {
      case int.parse(x) {
        Ok(n) -> n
        Error(_) -> 0
      }
    })
  })
  |> list.flatten()
  |> list.fold(1, fn(a, b) { a * b })
  |> Ok()
}

fn read_input() -> Result(String, String) {
  simplifile.read("./inputs/input_03.txt")
  |> result.map_error(fn(_) { "File error" })
}

fn get_do_segments(input: String) -> Result(List(String), Day3Error) {
  use regex <- result.try(
    regexp.from_string("do\\(\\)(.*?)don't\\(\\)")
    |> result.map_error(RegexError),
  )

  regexp.scan(regex, "do()" <> input <> "don't()")
  |> list.map(fn(match) {
    list.map(match.submatches, fn(submatch) {
      case submatch {
        option.Some(submatch) -> submatch
        option.None -> ""
      }
    })
  })
  |> list.flatten()
  |> Ok()
}
