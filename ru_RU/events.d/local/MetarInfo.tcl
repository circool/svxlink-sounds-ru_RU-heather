# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU

# MetarInfo
namespace eval MetarInfo {

# Это "перегруженная" форма вызова playUnit которая использует текущее простаранство имен как первый параметр,
# позволяя упростить вызов из разных пространств, не указывая модуль из которого она вызывается
#
proc playUnit {value unit} {
  variable module_name;
  ::playUnit $module_name $value $unit;
}

# Для улучшения восприятия для ходовых фраз подготовлены фразы вместо коипоновки отдельных слов

# status_report


# METAR as raw txt to make them available in a file


# no airport defined
proc _no_airport_defined {} {
   playMsg "no_airport_defined";
   playSilence 200;
}


# no such airport
proc _no_such_airport {} {
  playMsg "no_such_airport";
  playSilence 200;
}


# METAR not valid
proc _metar_not_valid {} {
  playMsg "metar_not_valid";
  playSilence 200;
}


# MET-report TIME / Время отчета
proc metreport_time item {
  playMsg "metreport_time"
  scan [string range $item 0 1] %d hr
  scan [string range $item 2 3] %d mn
  playTime $hr $mn   
  playSilence 200
}


# visibility / Видимость 5 километров 900 метров 
# !!! тут разобраться, 
# значения состоят из нескольких аргументов, цифровые и буквенные
# например 5 units_kms 500 units_ms
proc visibility args {
  playMsg "visibility";
  foreach item $args {
    if [regexp {(\d+)} $item] {
         playNumberRu $item "male";
    } else {
      playMsg $item;
    }   
    playSilence 100;
  }
  playSilence 200;
}


# temperature
proc temperature {temp} {
  playMsg "temperature"
  playSilence 100
  if {$temp == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {
    if { int($temp) < 0} {
       playMsg "minus";
       set temp [string trimleft $temp "-"];
    }   
    playNumberRu $temp "male"
    playUnit $temp "unit_degree"
    playSilence 100;
  }
  playSilence 200
}


# dewpoint / Точка росы
proc dewpoint {dewpt} {
  playMsg "dewpoint"
  playSilence 100
  if {$dewpt == "not"} {
    playMsg "not"
    playMsg "reported"
  } else {   
    playNumberRu $dewpt "male"
    playUnit $dewpt "unit_degree"
    playSilence 100;    
  }
  playSilence 200
}


# sea level pressure // нет примера
proc slp {slp} {
  playMsg "slp"
  puts "sea level pressure: $slp" 
  
  playNumberRu $slp "male"
  puts $slp

  playUnit $slp "unit_hPa"
  puts "unit_hPa"
  
  playSilence 200
}

# flightlevel
proc flightlevel {level} {
  playMsg "flightlevel"
  puts "flightlevel:"
  playNumberRu $level "male"
  # puts $level
  playSilence 200
}


# No specific reports taken


# peakwind
proc peakwind {val} {
  playMsg "pk_wnd";
  playSilence 100;
  playNumberRu $val "male";
  playSilence 200;
}



# wind
proc wind {deg {vel 0 } {unit 0} {gusts 0} {gvel 0}} {
  # puts "Wind has: deg=$deg vel=$vel unit=$unit gusts=$gusts gvel=$gvel"
  set vel [scan $vel %d]
  set gusts [scan $gusts %d]
  
  playMsg "wind"
  if {$deg == "calm"} {
    playMsg "calm"
  } elseif {$deg == "variable"} {
    playMsg "variable"
    playSilence 200
    playNumberRu $vel "male"
    playUnit $vel $unit


  } else {
    # ветер ... м/сек на ... градусов
    playNumberRu $vel "male"
    playUnit $vel $unit
    # speakNumber $vel $unit
    playSilence 100
    
    playMsg "at"
    playSilence 100
    playNumberRu $deg "male"
    playUnit $deg "unit_degree" 
    #speakNumber $deg "unit_degree"
    playSilence 100
    
    if {$gusts > 0} {
      playMsg "gusts_up"
      playNumberRu $gusts "male"
      playUnit $gusts $gvel
      #speakNumber $gusts $gvel
    }
  }
  playSilence 200
}


# Процедура определения рода для единицы измерения
proc getGender { unit } {
    # Проверяем единицы женского рода
    if {$unit eq "unit_mile"} {
        return "female"
    } elseif {$unit eq "unit_mph"} {
        return "female"
    }
    
    # Все остальные случаи - мужской род
    return "male"
}



# weather actually
# Несколько пар значений
proc actualWX args {
    set i 0
    while {$i < [llength $args]} {
        set item [lindex $args $i]
        # Проверяем является ли текущий элемент числовым значением
        if {[regexp {\d+} $item]} {
            # Обрабатываем как значение
            set val $item
            incr i
            
            # Проверяем наличие единицы измерения следом
            if {$i < [llength $args]} {
                set unit [lindex $args $i]
                set gender [getGender $unit]
                playNumberRu $val $gender
                playUnit $val $unit
                incr i
            } else {
                # Если единицы нет - используем male и не вызываем playUnit
                playNumberRu $val "male"
            }
        } else {
            # Обработка нечисловых значений как простых сообщений
            playMsg $item
            incr i
        }
    }
    playSilence 200
}


# wind varies $from $to
proc windvaries {from to} {
   playMsg "wind"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   playNumberRu $from "male"
  #  playNumber $from
   playSilence 100
   playMsg "to"
   playSilence 100
   playNumberRu $to "male"
   playUnit $to "unit_degree"
  #  speakNumber $to "unit_degree"
   playSilence 200
}


# Peak WIND
proc peakwind {deg kts hh mm} {
   playMsg "pk_wnd"
   playMsg "from"
   playSilence 100
   playNumberRu $deg "male"
   playUnit $deg "unit_kt"
  #  speakNumber $deg "unit_degree"
   playSilence 100
   
   playNumberRu $kts "male"
   playUnit $kts "unit_kt"
  #  speakNumber $kts "unit_kt"
   playSilence 100
   
   playMsg "at"
  #  if {$hh != "XX"} {
  #     speakNumber $hh "hour"
  #  }
  #  speakNumber $mm "minute"
   playTime $hh $mm

   playMsg "utc"
   playSilence 200
}


# ceiling varies $from $to
proc ceilingvaries {from to} {
   playMsg "ca"
   playSilence 50
   playMsg "varies_from"
   playSilence 100
   set from [expr {int($from) * 100}]
   playNumberRu $from "male"
   playSilence 100
   playMsg "to"
   playSilence 100
   set to [expr {int($to)*100}]
   playNumberRu $to "male"
   playUnit $to "unit_feet"
   playSilence 200
}


# airport is closed due to snow / Аэропорт закрыт из-за снега
proc snowclosed {} {
   playMag "aiport_closed_due_to_sn";
   playSilence 200;
}

# RWY is clear / Все ВВП чисты (звучит ужастно)
proc all_rwy_clear {} {
  playMsg "all_runways_clr";
  playSilence 200;
}


# runway visual range
proc rvr args {
    set i 0
    while {$i < [llength $args]} {
        set item [lindex $args $i]
        # Проверяем является ли текущий элемент числовым значением
        if {[regexp {\d+} $item]} {
            # Обрабатываем как значение
            set val $item
            incr i
            
            # Проверяем наличие единицы измерения следом
            if {$i < [llength $args]} {
                set unit [lindex $args $i]
                set gender [getGender $unit]
                playNumberRu $val $gender
                playUnit $val $unit
                incr i
            } else {
                # Если единицы нет - используем male и не вызываем playUnit
                playNumberRu $val "male"
            }
        } else {
            # Обработка нечисловых значений как простых сообщений
            playMsg $item
            incr i
        }
    }
    playSilence 200
}


# airport is closed due to snow

# RWY is clear

# Runway designator

# time
proc utime {utime} {
   set hr [string range $utime 0 1]
   set mn [string range $utime 2 3]
   playTime $hr $mn
   playSilence 100
   playMsg "utc"
   playSilence 200
}

# vv100 -> "vertical view (ceiling) 1000 feet"
proc ceiling {param} {
   playMsg "ca"
   playSilence 100
   playNumberRu $param "male"
   playUnit $param "unit_feet"
   playSilence 200
}

# QNH
proc qnh {value} {
  playMsg "qnh"
  playNumberRu $value "male"
  playUnit $value "unit_hPa"
  playSilence 200
}

# altimeter
proc altimeter {value} {
  playMsg "altimeter"
  playSilence 100
  playNumberRu $value "male"
  playUnit $value "unit_inch"
  playSilence 200
}

# trend

# clouds with arguments
proc clouds {obs height {cbs ""}} {
  playMsg $obs
  playSilence 100
  playNumberRu $height "male"
  playUnit $height "unit_feet"
  if {[string length $cbs] > 0} {
    playMsg $cbs
  }
  playSilence 200
}

# temporary weather obscuration


# max day temperature
proc max_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "maximal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  playNumberRu $deg "male"
  playUnit $deg "unit_degree"
  # speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# min day temperature
proc min_daytemp {deg time} {
  playMsg "predicted"
  playSilence 50
  playMsg "minimal"
  playSilence 50
  playMsg "daytime_temperature"
  playSilence 150
  playNumberRu $deg "male"
  playUnit $deg "unit_degree"
  # speakNumber $deg "unit_degree"
  playSilence 150
  playMsg "at"
  playSilence 50
  set hr [string range $time 0 1]
  set mn [string range $time 2 3]
  playTime $hr $mn
  playSilence 200
}

# Maximum temperature in RMK section
proc rmk_maxtemp {val} {
  playMsg "maximal"
  playMsg "temperature"
  playMsg "last"
  playNumberRu 6 "male"
  playUnit 6 "hour"

  playSilence 50
  playNumberRu $val "male"
  playUnit $val "unit_degree"
  playSilence 200
}

# Minimum temperature in RMK section
proc rmk_mintemp {val} {
  playMsg "minimal"
  playMsg "temperature"
  playMsg "last"
  playNumberRu 6 "male"
  playUnit 6 "hour"
  playSilence 50
  playNumberRu $val "male"
  playUnit $val "unit_degree"
  playSilence 200
}

# the begin of RMK section





# RMK section pressure trend next 3 h
proc rmk_pressure {val args} {
  playMsg "pressure"
  playMsg "tendency"
  playMsg "next"
  playNumberRu 3 "male"
  playUnit 3 "hour"
  playSilence 50

  playNumberRu $val "male"
  playUnit $val "unit_mb"
  playSilence 200
  puts "rmk_pressure: val=$val args=$args"
  # foreach item $args {
  #    if [regexp {(\d+)} $item] {
  #      puts $item
  #      playNumberRu $item "male"
       
  #    } else {
  #      puts $item
  #      playMsg $item
  #    }
  #    playSilence 100
  # }
  set i 0
    while {$i < [llength $args]} {
        set item [lindex $args $i]
        # Проверяем является ли текущий элемент числовым значением
        if {[regexp {\d+} $item]} {
            # Обрабатываем как значение
            set val $item
            incr i
            
            # Проверяем наличие единицы измерения следом
            if {$i < [llength $args]} {
                set unit [lindex $args $i]
                set gender [getGender $unit]
                playNumberRu $val $gender
                playUnit $val $unit
                incr i
            } else {
                # Если единицы нет - используем male и не вызываем playUnit
                playNumberRu $val "male"
            }
        } else {
            # Обработка нечисловых значений как простых сообщений
            playMsg $item
            incr i
        }
    }
  playSilence 200
}

# precipitation last hours in RMK section
proc rmk_precipitation {hour val} {
  playMsg "precipitation"
  playMsg "last"
  playNumberRu $hour "male"
  playUnit $hour "hour"
  
  playSilence 50
  playNumberRu $val "male"
  playUnit $val "unit_inch"
  # speakNumber $val "unit_inch"
  playSilence 200
}

# precipitations in RMK section
proc rmk_precip {args} {
  puts "rmk_precip: $args"
  # foreach item $args {
  #    if [regexp {(\d+)} $item] {
  #      playNumber $item
  #      puts $item
  #    } else {
  #      playMsg $item
  #      puts $item
  #    }
  #    playSilence 100
  # }
  set i 0
    while {$i < [llength $args]} {
        set item [lindex $args $i]
        # Проверяем является ли текущий элемент числовым значением
        if {[regexp {\d+} $item]} {
            # Обрабатываем как значение
            set val $item
            incr i
            
            # Проверяем наличие единицы измерения следом
            if {$i < [llength $args]} {
                set unit [lindex $args $i]
                set gender [getGender $unit]
                playNumberRu $val $gender
                playUnit $val $unit
                incr i
            } else {
                # Если единицы нет - используем male и не вызываем playUnit
                playNumberRu $val "male"
            }
        } else {
            # Обработка нечисловых значений как простых сообщений
            playMsg $item
            incr i
        }
    }
  playSilence 200
}

# daytime minimal/maximal temperature
proc _rmk_minmaxtemp {max min} {
  playMsg "daytime"
  playMsg "temperature"
  playMsg "maximum"
  if { $max < 0} {
     playMsg "minus";
     set max [string trimleft $max "-"];
  }
  playNumberRu $min "male"
  playUnit $min "unit_degree"
  # speakNumber $min "unit_degree"
  
  playMsg "minimum"
  if { $max < 0} {
     playMsg "minus";
     set max [string trimleft $max "-"];
  }
  playNumberRu $max "male"
  playUnit $max "unit_degree"
  # speakNumber $max "unit_degree"
  playSilence 200
}

# recent temperature and dewpoint in RMK section
proc _rmk_tempdew {temp dewpt} {
  playMsg "re"
  playMsg "temperature"
  playNumberRu $temp "male"
  playUnit $temp "unit_degree"
  # speakNumber $temp "unit_degree"
  playSilence 200
  
  playMsg "dewpoint"
  playNumberRu $dewpt "male"
  playUnit $dewpt "unit_degree"
  # speakNumber $dewpt "unit_degree"
  playSilence 200
}

# wind shift
proc windshift {val} {
  playMsg "wshft";
  playSilence 100;
  playMsg "at";
  playSilence 100;
  playNumberRu $val "male";
  playSilence 200;
}


# QFE value
proc _qfe {val} {
  playMsg "qfe"
  playNumberRu $val "male"
  playUnit $val "unit_hPa"
  # speakNumber $val "unit_hPa"
  playSilence 200
}


# runwaystate
# runway 24 left wet_or_water_patches contamination 51 to 100 percent deposit_depth 1 unit_mms friction_coefficient 0.36
proc runwaystate args {
  puts "runwaystate: $args"
  set i 0
    while {$i < [llength $args]} {
        set item [lindex $args $i]
        if {[regexp {\d+} $item]} {
            # Обработка числового значения
            set val $item
            incr i
            
            if {$i < [llength $args]} {
                set unit [lindex $args $i]
                set gender [getGender $unit]
                playNumberRu $val $gender
                
                # Проверяем префикс unit_
                if {[string match "unit_*" $unit]} {
                    playUnit $val $unit
                } else {
                    playMsg $unit ;# Вызываем playMsg для слов
                }
                incr i
            } else {
                playNumberRu $val "male"
            }
        } else {
            # Обработка нечисловых значений
            playMsg $item
            incr i
        }
    }
    playSilence 200

}






# output numbers

# output

# part 1 of help #01

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

# say preconfigured airports

#  global lang;

# say clouds with covering


# end of namespace

}
#
# This file has not been truncated
#
