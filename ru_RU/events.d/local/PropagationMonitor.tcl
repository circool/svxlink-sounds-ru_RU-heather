# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# Прогноз прохождения
namespace eval PropagationMonitor {

#
# Это "перегруженная" форма вызова playUnit которая использует текущее простаранство имен как первый параметр,
# позволяя упростить вызов из разных пространств, не указывая модуль из которого она вызывается
#
proc playUnit {value unit} {
  variable module_name;
  ::playUnit $module_name $value $unit;
}

#
# Say the specified band name (e.g. two meters, seventy centimeters etc)
#
#   band - The band (e.g. 2m, 70cm etc) / 2 метра, 70 сантиметров
#
proc sayBand {band} {
  if [regexp {^(\d+)(c?m)$} $band -> number unit] {
    playNumberRus $number "male"
    playUnit $number unit_$unit
  }
  
}


#
# Say the specified locator
#
#   loc - The locator (e.g. JP79 or JP79XI)
#
proc sayLocator {loc} {
  if [regexp {^(\w\w)(?:(\d\d)(\w\w)?)?$} $loc -> part1 part2 part3] {
    spellWord $part1
    playNumberRus $part2 "male"
    spellWord $part3
  }
}



#
# Handle E-skip alert from Good DX.
#
#   hour - The hour of the alert
#   min  - The minute of the alert
#   band - The band it occured on. E.g 2m, 4m, 6m.
#   from - From locator
#   to   - To locator
#
proc dxrobot_eskip_alert {hour min band {from ""} {to ""}} {
  playAlertSound
  playSilence 500
  
  playTime $hour $min
  playSilence 200
  
  playMsg "sporadic_e_opening"
  sayBand $band
  playSilence 500
  playMsg "sporadic_e_opening"
  sayBand $band
  
  if {"$from" ne "" && "$to" ne ""} {
    playSilence 500
    playMsg "band_open_from"
    spellWord $from
    playSilence 100
    playMsg "to"
    playSilence 100
    spellWord $to
  }
  playSilence 200
}


#
# Handle sporadic E alert from VHFDX.
#
#   band    - The band the alert is for (e.g. 2m, 70cm etc)
#   muf     - Maximum usable frequency
#   locator - The locator the alert applies to
proc vhfdx_sporadic_e_opening {band muf locator} {
  playAlertSound
  for {set i 0} {$i < 2} {set i [expr $i + 1]} {
    playMsg sporadic_e_opening
    sayBand $band
    playSilence 500
    playMsg MUF
    playSilence 100
    playNumberRu $muf "male"
    playUnit $muf unit_MHz
    playSilence 200
    playMsg above
    playSilence 200
    sayLocator $locator
    playSilence 1000
  }
}



#
# Handle aurora opening alert from VHFDX.
#
#   band - The band the alert is for (e.g. 2m, 70cm etc)
#   lat  - Lowest latitude where aurora is active
#   call - The call of the reporting station
#   loc  - The locator of the reporting station
# TODO: ТУТ НУЖНО ИСПОЛЬЗОВАТЬ КОНСТРУКЦИЮ "ДО .... ГРАДСА/ГРАДУСОВ"
proc vhfdx_aurora_opening {band lat call loc} {
  playAlertSound
  for {set i 0} {$i < 2} {set i [expr $i + 1]} {
    playMsg aurora_opening
    sayBand $band
    playSilence 200
    playMsg down_to_lat
    playNumber $lat
    playMsg unit_deg
    playSilence 1000
  }
}




# end of namespace
}


#
# This file has not been truncated
#
