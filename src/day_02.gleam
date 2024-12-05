import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn solve_day_02() -> Result(Int, String) {
  let input = parse_input()
  input
  |> result.map(fn(input) {
    let _first = calculate_first_task(input)
    calculate_second_task(input)
  })
}

fn parse_input() -> Result(List(List(Int)), String) {
  simplifile.read("./inputs/input_02.txt")
  |> result.map_error(fn(_) { "File error" })
  |> result.map(fn(input) { string.split(input, "\n") })
  |> result.map(fn(lines) {
    list.map(lines, fn(line) {
      string.split(line, " ")
      |> list.map(fn(x) {
        case int.parse(x) {
          Ok(n) -> n
          Error(Nil) -> 0
        }
      })
    })
  })
}

fn calculate_first_task(input: List(List(Int))) {
  input
  |> list.count(fn(row) { calculate_row_safety(row) })
}

fn calculate_second_task(input: List(List(Int))) {
  input
  |> list.count(fn(row) { try_problem_dampener(row) })
}

fn try_problem_dampener(row: List(Int)) {
  list.index_map(row, fn(_, index) {
    remove_at(index, row)
    |> calculate_row_safety
  })
  |> list.any(fn(x) { x })
}

fn calculate_row_safety(row: List(Int)) -> Bool {
  let windowed_list = list.window_by_2(row)

  let differ_in_range =
    windowed_list
    |> list.all(fn(window) {
      let diff =
        window.0 - window.1
        |> int.absolute_value

      diff > 0 && diff < 4
    })

  let increasing =
    windowed_list
    |> list.all(fn(window) { window.0 < window.1 })

  let decreasing =
    windowed_list
    |> list.all(fn(window) { window.0 > window.1 })

  differ_in_range && { increasing || decreasing }
}

fn remove_at(index: Int, items: List(a)) -> List(a) {
  case list.length(items) {
    len if index < 0 || index >= len -> items
    _ -> list.flatten([list.take(items, index), list.drop(items, index + 1)])
  }
}
