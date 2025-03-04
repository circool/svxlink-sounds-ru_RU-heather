# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# EchoLink
namespace eval EchoLink {

#
# Это "перегруженная" форма вызова playUnit которая использует текущее простаранство имен как первый параметр,
# позволяя упростить вызов из разных пространств, не указывая модуль из которого она вызывается
#
proc playUnit {value unit} {
  variable module_name;
  ::playUnit $module_name $value $unit;
}

# Произносит полученное число и добавляет (1 подключенная станция = "", 2...4 подключенные станции - ""+1, 5... подключенных станций = ""+s)
proc playQuantityConnectedStations {qty} {
  playNumberRu $qty "female"
  playUnit $qty "connected_station"
}	

# Отчет о состоянии
proc status_report {} {
  variable num_connected_stations;
  variable module_name;
  global active_module;
 
  if {$active_module == $module_name} {
    playQuantityConnectedStations $num_connected_stations
    playSilence 200
  }
}

#
# Executed when a request to list all connected stations is received.
# That is, someone press DTMF "1#" when the EchoLink module is active.
#
# 
# Сообщает количество подключенных станций и перечисляет их позывные
proc list_connected_stations {connected_stations} {
  playQuantityConnectedStations $connected_stations
  
  if {[llength $connected_stations] != 0} {
    playSilence 50;
    playMsg "connected_station_list";
    foreach {call} "$connected_stations" {
      spellEchoLinkCallsign $call;
      playSilence 250;
    }
  }
}

}