# Исправление для модуля EchoLink
# by R2ADU
#
#

###############################################################################
#
# EchoLink module event handlers
#
###############################################################################


#
# This is the namespace in which all functions and variables below will exist.
# The name must match the configuration variable "NAME" in the
# [ModuleEchoLink] section in the configuration file. The name may be changed
# but it must be changed in both places.
#
namespace eval EchoLink {
	

proc status_report {} {
  variable num_connected_stations;
  variable module_name;
  global active_module;
 
  if {$active_module == $module_name} {
    speakNumber "EchoLink" $num_connected_stations "connected_station"
    playSilence 200
  }
}

#
# Executed when a request to list all connected stations is received.
# That is, someone press DTMF "1#" when the EchoLink module is active.
#
proc list_connected_stations {connected_stations} {
  speakNumber "EchoLink" [llength $connected_stations] "connected_station";
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