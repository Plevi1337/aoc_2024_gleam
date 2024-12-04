import gleam/io

pub fn debug_map(value: value, map_fn: fn(value) -> any) {
  io.debug(map_fn(value))
  value
}
