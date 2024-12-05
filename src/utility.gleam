import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub fn debug_map(value: value, map_fn: fn(value) -> any) {
  io.debug(map_fn(value))
  value
}

pub fn read_input(day_number: Int) -> Result(String, String) {
  simplifile.read(
    "./inputs/input_"
    <> string.pad_start(int.to_string(day_number), 2, "0")
    <> ".txt",
  )
  |> result.map_error(fn(_) { "File error" })
}
