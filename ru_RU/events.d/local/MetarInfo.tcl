# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU

namespace eval MetarInfo {

# Произносит число и единицу измерения
#   - температура в градусах по Цельсию ("unit_degree") - градус, градуса, градусов
#   - давление в ГектоПаскалях ("unit_hPa") гектопаскаль, гектопаскаля, гектопаскалей
#   - скорость ветра в узлах ("unit_kt") - узел, узла, узлов
#   - период в часах ("hour") - час, часа, часов
#   - ("unit_mb") - 
#   - величина в дюймах ("unit_inch") - дюйм, дюйма, дюймов
proc _speakNumber {msg unit} {
  variable module_name;
  ::speakNumber $module_name $msg $unit;
}

# no airport defined
proc _no_airport_defined {} {
   playMsg "no_airport_defined";
   playSilence 200;
}
# no airport defined
proc _no_such_airport {} {
   playMsg "no_such_airport";
   playSilence 200;
}
# METAR not valid
proc _metar_not_valid {} {
  playMsg "metar_not_valid";
   playSilence 200;
}
# airport is closed due to snow
proc _snowclosed {} {
   playMag "aiport_closed_due_to_sn";
   playSilence 200;
}
# RWY is clear
proc _all_rwy_clear {} {
  playMsg "all_runways_clr";
  playSilence 200;
}

# MET-report TIME
proc _metreport_time item {
   playMsg "metreport_time"
   set hr [string range $item 0 1]
   set mn [string range $item 2 3]
   playTime $hr $mn
   playSilence 200
}


# temperature
proc _temperature {temp} {
  playMsg "temperature"
  playSilence 100
  if {$temp == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {
    speakNumber $temp "unit_degree"
  }
  playSilence 200
}

# dewpoint
proc _dewpoint {dewpt} {
  playMsg "dewpoint"
  playSilence 100
  if {$dewpt == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {
    speakNumber $dewpt "unit_degree"
    playSilence 100
  }
  playSilence 200
}

# sea level pressure
proc _slp {slp} {
  playMsg "slp"
  speakNumber $slp "unit_hPa"
  playSilence 200
}

# flightlevel
proc _flightlevel {level} {
  playMsg "flightlevel"
  speakNumber $level ""
  playSilence 200
}

# wind
proc _wind {deg {vel 0 } {unit 0} {gusts 0} {gvel 0}} {
  playMsg "wind"
  if {$deg == "calm"} {
    playMsg "calm"
  } elseif {$deg == "variable"} {
    playMsg "variable"
    playSilence 200
    speakNumber $vel $unit
  } else {
    # ветер ... м/сек на ... градусов
    speakNumber $vel $unit
    playSilence 100
    playMsg "at"
    playSilence 100
    speakNumber $deg "unit_degree"
    playSilence 100
    if {$gusts > 0} {
      playMsg "gusts_up"
      speakNumber $gusts $gvel
    }
  }
  playSilence 200
}

# weather actually
proc _actualWX args {
  foreach item $args {
    if [regexp {(\d+)} $item] {
      playNumber $item
    } else {
      playMsg $item
    }
  }
  playSilence 200
}

# wind varies $from $to
proc _windvaries {from to} {
   playMsg "wind"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   playNumber $from
   playSilence 100
   playMsg "to"
   playSilence 100
   speakNumber $to "unit_degree"
   playSilence 200
}

# Peak WIND
proc _peakwind {deg kts hh mm} {
   playMsg "pk_wnd"
   playMsg "from"
   playSilence 100
   speakNumber $deg "unit_degree"
   playSilence 100
   speakNumber $kts "unit_kt"
   playSilence 100
   playMsg "at"
   if {$hh != "XX"} {
      speakNumber $hh "hour"
   }
   speakNumber $mm "minute"
   playMsg "utc"
   playSilence 200
}

# ceiling varies $from $to
proc _ceilingvaries {from to} {
   playMsg "ca"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   set from [expr {int($from) * 100}]
   playNumber $from
   playSilence 100
   playMsg "to"
   playSilence 100
   set to [expr {int($to)*100}]
   speakNumber $to "unit_feet"
   playSilence 200
}

# time
proc _utime {utime} {
   set hr [string range $utime 0 1]
   set mn [string range $utime 2 3]
   playTime $hr $mn
   playSilence 100
   playMsg "utc"
   playSilence 200
}

# vv100 -> "vertical view (ceiling) 1000 feet"
proc _ceiling {param} {
   playMsg "ca"
   playSilence 100
   speakNumber $param "unit_feet"
   playSilence 200
}

# QNH
proc _qnh {value} {
  playMsg "qnh"
  speakNumber $value "unit_hPa"
  playSilence 200
}

# altimeter
proc _altimeter {value} {
  playMsg "altimeter"
  playSilence 100
  speakNumber $value "unit_inch"
  playSilence 200
}

# clouds with arguments
proc _clouds {obs height {cbs ""}} {
  playMsg $obs
  playSilence 100
  speakNumber $height "unit_feet"
  if {[string length $cbs] > 0} {
    playMsg $cbs
  }
  playSilence 200
}

# max day temperature
proc _max_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "maximal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# min day temperature
proc _min_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "minimal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# Maximum temperature in RMK section
proc _rmk_maxtemp {val} {
  playMsg "maximal"
  playMsg "temperature"
  playMsg "last"
  speakNumber 6 "hour"
  playSilence 50
  speakNumber $val "unit_degree"
  playSilence 200
}

# Minimum temperature in RMK section
proc _rmk_mintemp {val} {
  playMsg "minimal"
  playMsg "temperature"
  playMsg "last"
  speakNumber 6 "hour"
  playSilence 50
  speakNumber $val "unit_degree"
  playSilence 200
}

# RMK section pressure trend next 3 h
proc _rmk_pressure {val args} {
  playMsg "pressure"
  playMsg "tendency"
  playMsg "next"
  speakNumber 3 "hour"
  playSilence 50
  speakNumber $val "unit_mb"
  playSilence 200
  foreach item $args {
     if [regexp {(\d+)} $item] {
       playNumber $item
     } else {
       playMsg $item
     }
     playSilence 100
  }
  playSilence 200
}

# precipitation last hours in RMK section
proc _rmk_precipitation {hour val} {
  playMsg "precipitation"
  playMsg "last"
  speakNumber $hour "hour"
  playSilence 50
  speakNumber $val "unit_inch"
  playSilence 200
}

# precipitations in RMK section
proc _rmk_precip {args} {
  foreach item $args {
     if [regexp {(\d+)} $item] {
       playNumber $item
     } else {
       playMsg $item
     }
     playSilence 100
  }
  playSilence 200
}

# daytime minimal/maximal temperature
proc _rmk_minmaxtemp {max min} {
  playMsg "daytime"
  playMsg "temperature"
  playMsg "maximum"
  speakNumber $min "unit_degree"
  playMsg "minimum"
  speakNumber $max "unit_degree"
  playSilence 200
}

# recent temperature and dewpoint in RMK section
proc _rmk_tempdew {temp dewpt} {
  playMsg "re"
  playMsg "temperature"
  speakNumber $temp "unit_degree"
  playSilence 200
  playMsg "dewpoint"
  speakNumber $dewpt "unit_degree"
  playSilence 200
}

# QFE value
proc _qfe {val} {
  playMsg "qfe"
  speakNumber $val "unit_hPa"
  playSilence 200
}

# announce airport at the beginning of the MEATAR
proc announce_airport {icao} {
  global langdir;

  playMsg "airport";
  playSilence 100;
  if [file exists "$langdir/MetarInfo/$icao.wav"] {
    playMsg $icao;
  } else {
    spellWord $icao;
  }

}
}
