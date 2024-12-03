import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type Row {
  Row(Int, Int)
}

pub fn solve_day_01() {
  let input =
    simplifile.read("./inputs/input_01.txt")
    |> result.map_error(fn(_) { "File error" })

  let asd =
    result.map(input, fn(x) {
      x
      |> string.split("\n")
      |> list.filter(fn(line) { line != "" })
      |> list.map(parse_row)
      |> result.all
    })
    |> result.flatten

  let first_list =
    asd
    |> result.map(fn(rows) {
      list.map(rows, fn(row) {
        case row {
          Row(first, _) -> first
        }
      })
    })
    |> result.map(fn(second_list) { list.sort(second_list, by: int.compare) })
  let second_list =
    asd
    |> result.map(fn(rows) {
      list.map(rows, fn(row) {
        case row {
          Row(_, second) -> second
        }
      })
    })
    |> result.map(fn(second_list) { list.sort(second_list, by: int.compare) })

  let final_result =
    result.all([first_list, second_list])
    |> result.map(fn(lists) {
      case lists {
        [first_list, second_list] ->
          list.fold(first_list, 0, fn(prev, acc) {
            let count = list.count(second_list, fn(a) { a == acc })
            { count * acc } + prev
          })
        _ -> 0
      }
    })

  final_result
}

fn parse_row(line: String) -> Result(Row, String) {
  let columns =
    string.split(line, " ")
    |> list.filter(fn(x) { x != "" })
  case columns {
    [col1, col2] ->
      case int.parse(col1), int.parse(col2) {
        Ok(int1), Ok(int2) -> Ok(Row(int1, int2))
        _, _ -> Error(string.concat(["Failed to parse row: ", line]))
      }
    _ -> Error(string.concat(["Invalid row format: ", line]))
  }
}
