###############################################################################
#
# Locale specific functions for playing back time, numbers and spelling words.
# Often, the functions in this file are the only ones that have to be
# reimplemented for a new language pack.
#
###############################################################################
# Руский синтаксис для воспроизведения времени
# by R2ADU

###############################################################################
# Speak number and measure units
###############################################################################



proc speakNumber {module_name value unit} {
  if {$value<0} {
    playMsg "MetarInfo" "minus";
    set value [expr abs($value)];
  }
  if {[regexp {(\d+)\.(\d+)?} $value -> integer fraction]} {
    speakNumber $module_name $integer "integer";
    playMsg "Default" "and";
    if {[string length $fraction] == 2} {
      speakNumber $module_name $fraction "hundredth"
    } else {
      speakNumber $module_name $fraction "tenth"
    }
    if {$unit != ""} {
      append unit "1"
      playMsg $module_name "$unit"
    }
    return;
  }
  regexp {^0*(\d+)} $value _dummy value
  if {$unit=="minute" || $unit=="thousand" || $unit=="unit_mph" || $unit=="integer" || $unit=="tenth" || $unit=="hundredth" || $unit=="connected_station"} {
    set gender "f" 
  } else {
    set gender ""
  }
  if {$unit != ""} {
    append unit [getCase $value]
  }
  if {$value>999} {
    set x_tmp [expr $value / 1000]
    speakNumber "Default" $x_tmp "thousand"
    append x_tmp "000"
    set value [expr $value - $x_tmp]
    if {$value == 0} {return}
  }
  if {$value>99} {
    set x_tmp [expr [string index $value 0]*100]
    playMsg "Default" $x_tmp
    set value [expr $value-$x_tmp]
    if {$value == 0} {return}
  }
  if {$value <= 20} {
    set x_tmp [expr int($value)]
    if {$value == 1 || $value == 2} {append x_tmp $gender}
    playMsg "Default" $x_tmp
  } else {
    set x_tmp [expr [string index $value 0]*10]
    playMsg "Default" $x_tmp
    set value [expr $value-$x_tmp]
    if {$value !=0} {
      if {$value == 1 || $value == 2} {append value $gender}
      playMsg "Default" $value
    }
  }
  if {$unit != ""} {
    playMsg $module_name $unit
  }
}

############################################################################################################
# Returns the digit modifier according to case 
############################################################################################################
proc getCase {value} {
  if {[string length $value] > 2 } {   
    set value [string range $value [string length $value]-2 [string length $value]]
  }
  if {[string length $value] == 2 } {
    if {([string index $value 0] == 1)} {return "s" } else {set value [string index $value 1]}
  }
  if {($value == 0) || ($value >= 5) } {return "s"}
  if {($value >= 2) && ($value <= 4) } {return "1"} else {return ""}  
}

############################################################################################################
# Say the time specified by function arguments "hour" and "minute".
############################################################################################################
proc playTime {hour minute} {
  variable Logic::CFG_TIME_FORMAT
# Strip white space and leading zeros. Check ranges.
  if {[scan $hour "%d" hour] != 1 || $hour < 0 || $hour > 23} {
    error "playTime: Non digit hour or value out of range: $hour"
  }
  if {[scan $minute "%d" minute] != 1 || $minute < 0 || $minute > 59} {
    error "playTime: Non digit minute or value out of range: $minute"
  }
  if {[info exists CFG_TIME_FORMAT] && ($CFG_TIME_FORMAT == 12)} {
    if {$hour < 12} {
      set ampm "AM";
      if {$hour == 0} {
        set hour 12;
      }
    } else {
      set ampm "PM";
      if {$hour > 12} {
        set hour [expr $hour - 12];
      }
    }
  }

  if {$hour > 20} {
    playMsg "Default" "[string index $hour 0]X"
    playMsg "Default" [string index $hour 1]
  } else {
      playMsg "Default" $hour
  }
    playMsg "Default" "hour[getCase $hour]"
    if {$minute == 30 || $minute == 40 || $minute == 50} {
        playMsg "Default" "[string index $minute 0]X"
        playMsg "Default" "minute[getCase $minute]"
        return
    }

    if {$minute == 00} {
            playMsg "Default" "[string index $minute 0]"
            playMsg "Default" "minute[getCase $minute]"
            return
    }

    if {$minute > 20} {
      playMsg "Default" "[string index $minute 0]X"
      set minute [string index $minute 1]
    }

    if {$minute > 2} {
      playMsg "Default" $minute
    } else {
        playMsg "Default" "[string index $minute 0]f"
    }
    if {$minute == 0} {playMsg "Default" "[string index $minute 0]"}
    playMsg "Default" "minute[getCase $minute]"

    if {[info exists CFG_TIME_FORMAT] && ($CFG_TIME_FORMAT == 12)} {
        playMsg "Core" $ampm;
        playSilence 100;
    }
}

############################################################################################################
# Replacing standard pronunciation procedures
############################################################################################################
proc playFrequency {fq} {
  if {$fq < 1000} {
    set unit "Hz"
  } elseif {$fq < 1000000} {
    set fq [expr {$fq / 1000.0}]
    set unit "kHz"
  } elseif {$fq < 1000000000} {
    set fq [expr {$fq / 1000000.0}]
    set unit "MHz"
  } else {
    set fq [expr {$fq / 1000000000.0}]
    set unit "GHz"
  }
   speakNumber "Core" [string trimright [format "%.3f" $fq] ".0"] $unit
}

proc playNumber {number} {
  speakNumber "Default" $number ""
}
//
// proc spellNumber {number} {
//  speakNumber "Default" $number ""
// }


# End russian localisation
