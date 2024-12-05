import day_04
import gleam/io

pub type Row {
  Row(Int, Int)
}

pub fn main() {
  day_04.solve()
  |> io.debug()
}
