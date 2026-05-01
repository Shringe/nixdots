def main [--arch: string] {
  mut last_is_rust = true
  mut last_is_native = true

  loop {
    sleep 100ms

    let processes = try {
      ps -l
    } catch {
      continue
    }

    let is_rust = $processes | find "rustc" | is-not-empty
    let is_native = $processes | find $"-march=($arch)" | is-not-empty

    if $is_rust != $last_is_native or $is_native != $last_is_rust {
      let msg = $"(ansi yellow)Is rust being compiled?: ($is_rust)\nAre native optimizations being applied?: ($is_native)(ansi reset)"
      print $msg
    }

    $last_is_rust = $is_rust
    $last_is_native = $is_native
    sleep 2sec
  }
}
