import day_01
import day_02
import day_03
import gleam/io

pub type Row {
  Row(Int, Int)
}

pub fn main() {
  let final_result = day_03.solve_day_03()

  io.debug(final_result)
}
