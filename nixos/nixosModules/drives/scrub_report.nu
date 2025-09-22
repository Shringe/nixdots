def lines_from_start_to_end [start: string, end: string] {
  mut out = []
  
  # Reversed to make sure we get the most recent scrub report from the device,
  # and not the oldest one
  mut collecting = false
  for line in ($in | reverse) {
    if ($line | str contains $end) {
      $collecting = true
    } else if ($line | str contains $start) {
      break
    } else if $collecting {
      $out = ($out | append $line)
    }
  }

  $out | reverse
}

def find_absolute_paths [device_path: string] {
  mut out = []

  let device_mounts = findmnt --noheadings --output TARGET --source $device_path | lines
  for file in $in {
    for mount in $device_mounts {
      let potential = $mount | path join $file
      if ($potential | path exists) {
        $out = ($out | append $potential)
      }
    }
  }

  $out
}

def get_currupted_files [disklabel: string] {
  # Getting device
  let dmesg_out = dmesg | lines
  let device_path = blkid -L $disklabel
  let device = $device_path | path basename

  # Getting the scrub output for this specific btrfs scrub event
  let scrub_begins = $"BTRFS info \(device ($device)): scrub: started"
  let scrub_ends = $"BTRFS info \(device ($device)): scrub: finished"
  let scrub_out = $dmesg_out | lines_from_start_to_end $scrub_begins $scrub_ends | find $"\(device ($device))"

  # Finding currupted file paths
  let checksum_errors = $scrub_out | find "scrub: checksum error at logical"
  let currupted_files_relative = $checksum_errors | parse --regex "path: ([^)]+)" | get capture0 | uniq
  let currupted_files_absolute = $currupted_files_relative | find_absolute_paths $device_path

  $currupted_files_absolute
}

def main [disklabel: string] {
  let files = get_currupted_files $disklabel
  if ($files | is-empty) {
    print "Success! No currupted files found"
  } else {
    print $"Failure! The following currupted files were found:\n($files | str join "\n")\n"

    print "Reporting to matrix..."
    let out = btrfs scrub status $"/dev/disk/by-label/($disklabel)"
    let num_of_files = $files | length
    let num_of_currupt_files_sentence = if ($num_of_files == 1) {
      $"($num_of_files) currupted file was found."
    } else {
      $"($num_of_files) currupted files were found."
    };

    matrixReport $"
      <p>
        Btrfs scrub for device <code>($disklabel)</code> failed!
        ($num_of_currupt_files_sentence)
        Check system logs for more details.
      </p>
      <code>($out)</code>
    "
  }
}
