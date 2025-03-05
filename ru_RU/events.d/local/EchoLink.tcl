# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# EchoLink
namespace eval EchoLink {

  #
  # Это "перегруженная" форма вызова playUnit которая использует текущее пространство имен как первый параметр,
  # позволяя упростить вызов из разных пространств, не указывая модуль из которого она вызывается
  #
  proc playUnit {value unit} {
    variable module_name;
    ::playUnit $module_name $value $unit;
  }


  # Spell an EchoLink callsign

  # Сообщает количество подключенных станций и перечисляет их позывные
  proc list_connected_stations {connected_stations} {
    set quantity_connected [llength $connected_stations]
    playNumberRu $quantity_connected "female"
    playSilence 50
    playUnit $quantity_connected "connected_station"
    playSilence 200
    foreach {call} "$connected_stations" {
      spellEchoLinkCallsign $call
      playSilence 250
    }
  }


  # Отчет о состоянии (при получении DTMF *)
  proc status_report {} {
    printInfo "status_report called..."
    variable num_connected_stations
    variable module_name
    global active_module
  
    if {$active_module == $module_name} {
      playNumberRu $num_connected_stations "female"
      playUnit $num_connected_stations "connected_station"
      playSilence 200
    }
  }

}