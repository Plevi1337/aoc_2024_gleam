import day_01
import day_02
import gleam/io

pub type Row {
  Row(Int, Int)
}

pub fn main() {
  let final_result = day_02.solve_day_02()

  io.debug(final_result)
}
