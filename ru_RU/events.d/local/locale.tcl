###############################################################################
# Руский синтаксис для воспроизведения времени
# by R2ADU
# Процедура для формирования строки времени (без текстовых представлений)
proc playTime {hour minute} {

    variable Logic::CFG_TIME_FORMAT
    # Проверка корректности формата времени
    if {$CFG_TIME_FORMAT != 12 && $CFG_TIME_FORMAT != 24} {
        error "Ошибка: CFG_TIME_FORMAT должен быть 12 или 24"
    }

    # Корректировка часа для 12-часового формата
    if {$CFG_TIME_FORMAT == 12} {
        if {$hour == 0} {
            set hour 12
            set ampm "AM"
        } elseif {$hour < 12} {
            set ampm "AM"
        } else {
            if {$hour > 12} {
                set hour [expr {$hour - 12}]
            }
            set ampm "PM"
        }
    }

    # Обработка часов
    if {$hour == 0} {
        playMsg "Default" "0"
        playMsg "Default" "hours"
    } elseif {$hour == 1} {
        playMsg "Default" "1"
        playMsg "Default" "hour"
    } elseif {$hour >= 2 && $hour <= 4} {
        playMsg "Default" $hour
        playMsg "Default" "hour1"
    } elseif {$hour >= 5 && $hour <= 20} {
        playMsg "Default" $hour
        playMsg "Default" "hours"
    } elseif {$hour >= 21 && $hour <= 24} {
        set hourTens [expr {$hour / 10}]
        set hourUnits [expr {$hour % 10}]
        if {$hourTens > 0} {
            playMsg "Default" "${hourTens}0"
        }
        if {$hourUnits > 0} {
            playMsg "Default" $hourUnits
        }
        if {$hour == 21} {
            playMsg "Default" "hour"
        } else {
            playMsg "Default" "hour1"
        }
    } else {
        playMsg "Default" $hour
        playMsg "Default" "hours"
    }

    # Обработка минут
    if {$minute == 0} {
        playMsg "Default" "equal"
    } else {
        set minuteTens [expr {$minute / 10}]
        set minuteUnits [expr {$minute % 10}]
        if {$minute >= 10 && $minute <= 19} {
            playMsg "Default" $minute
        } else {
            if {$minuteTens > 0} {
                playMsg "Default" "${minuteTens}0"
            }
            if {$minuteUnits > 0} {
                playMsg "Default" "$minuteUnits"
            }
        }

        if {$minute % 10 == 1 && $minute != 11} {
            playMsg "Default" "minute"
        } elseif {($minute % 10 >= 2 && $minute % 10 <= 4) && ($minute < 10 || $minute > 20)} {
            playMsg "Default" "minute1"
        } else {
            playMsg "Default" "minutes"
        }
    }

    # Добавление am/pm для 12-часового формата
    if {$CFG_TIME_FORMAT == 12} {
        playMsg "Core" "$ampm"
    }
}
