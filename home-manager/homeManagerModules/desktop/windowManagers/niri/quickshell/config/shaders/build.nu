#!/usr/bin/env nu

def main [] {
  main build
}

# Build all shaders in src
def "main build" [] {
  print "Building all shaders"
  let src_shaders = glob $"($env.FILE_PWD)/src/*"
  let bin_shaders = $src_shaders
    | path parse
    | update parent { $in | path parse | update stem bin | path join }
    | update extension {|e| $"($e.extension).qsb" } 
    | path join
  let shaders = $src_shaders | zip $bin_shaders | each { {src: $in.0, bin: $in.1} }

  for s in $shaders {
    print $"building ($s.src | path relative-to $env.FILE_PWD)..."
    qsb -O --glsl "300 es" -o $s.bin $s.src
  }
}

# Clean the bin directory
def "main clean" [] {
  print "Cleaning the build directory"
  let shaders = glob $"($env.FILE_PWD)/bin/*"
  for s in $shaders {
    print $"removing ($s | path relative-to $env.FILE_PWD)"
    rm $s
  }
}

def "main clean build" [] {
  main clean
  main build
}
