#!/usr/bin/env tclsh
source "parse_metar.tcl"

#!/usr/bin/env tclsh
source "parse_metar.tcl"

proc main {} {
  global argv
  set metar [lindex $argv 0]
  set parsed [parse_metar $metar]

  puts "Structured Data:"
  dict for {key value} $parsed {
    if {$key eq "runway"} {
      puts "Runway:"
      dict for {subkey subval} $value {
        puts "  $subkey: $subval"
      }
    } elseif {$key eq "contamination"} {
      puts "Contamination:"
      dict for {subkey subval} $value {
        puts "  $subkey: $subval"
      }
    } elseif {$key eq "deposit_depth"} {
      puts "Deposit Depth:"
      dict for {subkey subval} $value {
        puts "  $subkey: $subval"
      }
    } else {
      puts "$key: $value"
    }
  }
}

main