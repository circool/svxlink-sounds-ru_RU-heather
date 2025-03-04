#!/usr/bin/env tclsh

proc playTime {hours minutes} {
    puts "playTime: hours=$hours, minutes=$minutes"
}

proc playSilence {duration} {
    puts "playSilence: duration=$duration ms"
}

proc metreport_time {item} {
    # Проверка длины и формата входной строки
    if {[string length $item] != 4 || ![regexp {^\d+$} $item]} {
        error "Неверный формат времени. Ожидается 4 цифры (HHMM)."
    }
    
    scan [string range $item 0 1] %d hr
    scan [string range $item 2 3] %d mn
    playTime $hr $mn
    playSilence 200
}

proc main {} {
    global argv

    if {[llength $argv] != 1} {
        puts "Использование: metreport_time.tcl <HHMM>"
        exit 1
    }

    metreport_time [lindex $argv 0]
}

# Вызов основной процедуры
main