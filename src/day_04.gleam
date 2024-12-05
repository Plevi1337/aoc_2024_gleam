import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type LetterCoords =
  #(Int, Int)

pub type LetterTable =
  dict.Dict(#(Int, Int), String)

pub fn solve() {
  use input_string <- result.try(read_input())

  let input = parse_input(input_string)
  solve_part1(input) |> io.debug()

  solve_part2(input) |> io.debug()
  Ok(1)
}

fn solve_part1(input: LetterTable) {
  let x_coords = get_letter_coords(input, "X")
  list.map(x_coords, fn(x_coord) { determine_if_xmas(input, x_coord) })
  |> list.fold(0, fn(prev, acc) { prev + acc })
}

fn solve_part2(input: LetterTable) {
  let a_coords = get_letter_coords(input, "A")

  list.map(a_coords, fn(a_coord) { determine_if_x_mas(input, a_coord) })
  |> list.count(fn(x) { x })
}

fn read_input() -> Result(String, String) {
  simplifile.read("./inputs/input_04.txt")
  |> result.map_error(fn(_) { "File error" })
}

fn parse_input(input: String) -> LetterTable {
  string.split(input, "\n")
  |> list.map(fn(line) { string.split(line, "") })
  |> list.index_map(fn(line, line_index) {
    list.index_map(line, fn(char, char_index) {
      #(#(line_index, char_index), char)
    })
  })
  |> list.flatten
  |> dict.from_list
}

fn get_letter_coords(input: LetterTable, letter: String) -> List(LetterCoords) {
  input
  |> dict.filter(fn(_, value) { value == letter })
  |> dict.keys()
}

fn determine_if_xmas(input: LetterTable, xcoord: LetterCoords) {
  let directions = [
    #(0, 1),
    #(1, 0),
    #(0, -1),
    #(-1, 0),
    #(1, 1),
    #(-1, -1),
    #(1, -1),
    #(-1, 1),
  ]

  list.count(directions, fn(direction) {
    "XMAS"
    |> string.split("")
    |> list.fold(Ok(xcoord), fn(prev, acc) {
      use prev_coord <- result.try(prev)
      let current_letter = dict.get(input, prev_coord)
      case current_letter {
        Ok(acc_letter) if acc == acc_letter ->
          Ok(#(prev_coord.0 + direction.0, prev_coord.1 + direction.1))
        _ -> Error("Not found")
      }
    })
    |> result.map(fn(_) { True })
    |> result.unwrap(False)
  })
}

fn determine_if_x_mas(input: LetterTable, acoord: LetterCoords) -> Bool {
  let top_left_letter =
    dict.get(input, #(acoord.0 - 1, acoord.1 - 1)) |> result.unwrap(".")
  let top_right_letter =
    dict.get(input, #(acoord.0 - 1, acoord.1 + 1)) |> result.unwrap(".")
  let bottom_left_letter =
    dict.get(input, #(acoord.0 + 1, acoord.1 - 1)) |> result.unwrap(".")
  let bottom_right_letter =
    dict.get(input, #(acoord.0 + 1, acoord.1 + 1)) |> result.unwrap(".")

  let letters = [
    top_left_letter,
    top_right_letter,
    bottom_left_letter,
    bottom_right_letter,
  ]
  let s_count = list.count(letters, fn(letter) { letter == "S" })
  let m_count = list.count(letters, fn(letter) { letter == "M" })

  case s_count, m_count {
    s_count, m_count
      if s_count == 2 && m_count == 2 && top_left_letter != bottom_right_letter
    -> True
    _, _ -> False
  }
}
