import day_01
import gleam/io

pub type Row {
  Row(Int, Int)
}

pub fn main() {
  let final_result = day_01.solve_day_01()

  io.debug(final_result)
}
