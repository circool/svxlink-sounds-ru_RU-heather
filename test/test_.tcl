#!/usr/bin/env tclsh
# Моковая реализация playMsg для тестирования
proc playMsg {module message} {
    puts "playMsg $module $message"
}

# Глобальная переменная для формата времени
set ::CFG_TIME_FORMAT 24

# Процедура playTime (скопирована из основного скрипта)
proc playTime {hour minute} {
    global CFG_TIME_FORMAT

    # Проверка корректности формата времени
    if {$CFG_TIME_FORMAT != 12 && $CFG_TIME_FORMAT != 24} {
        error "Ошибка: CFG_TIME_FORMAT должен быть 12 или 24"
    }

    # Корректировка часа для 12-часового формата
    if {$CFG_TIME_FORMAT == 12} {
        if {$hour == 0} {
            set hour 12
            set ampm "am"
        } elseif {$hour < 12} {
            set ampm "am"
        } else {
            if {$hour > 12} {
                set hour [expr {$hour - 12}]
            }
            set ampm "pm"
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
        playMsg "Default" "$hour"
        playMsg "Default" "hour1"
    } elseif {$hour >= 5 && $hour <= 20} {
        playMsg "Default" "$hour"
        playMsg "Default" "hours"
    } elseif {$hour >= 21 && $hour <= 24} {
        set hourTens [expr {$hour / 10}]
        set hourUnits [expr {$hour % 10}]
        if {$hourTens > 0} {
            playMsg "Default" "${hourTens}0X"
        }
        if {$hourUnits > 0} {
            playMsg "Default" "$hourUnits"
        }
        if {$hour == 21} {
            playMsg "Default" "hour"
        } else {
            playMsg "Default" "hour1"
        }
    } else {
        playMsg "Default" "$hour"
        playMsg "Default" "hours"
    }

    # Обработка минут
    if {$minute == 0} {
        playMsg "Default" "rovno"
    } else {
        set minuteTens [expr {$minute / 10}]
        set minuteUnits [expr {$minute % 10}]
        if {$minute >= 10 && $minute <= 19} {
            playMsg "Default" "$minute"
        } else {
            if {$minuteTens > 0} {
                playMsg "Default" "${minuteTens}0X"
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

# Тестовые случаи

# Тест 1: 24-часовой формат, 15:45
puts "Тест 1: 24-часовой формат, 15:45"
set ::CFG_TIME_FORMAT 24
playTime 15 45
puts ""

# Тест 2: 12-часовой формат, 15:45
puts "Тест 2: 12-часовой формат, 15:45"
set ::CFG_TIME_FORMAT 12
playTime 15 45
puts ""

# Тест 3: 24-часовой формат, 0:00
puts "Тест 3: 24-часовой формат, 0:00"
set ::CFG_TIME_FORMAT 24
playTime 0 0
puts ""

# Тест 4: 12-часовой формат, 0:00
puts "Тест 4: 12-часовой формат, 0:00"
set ::CFG_TIME_FORMAT 12
playTime 0 0
puts ""

# Тест 5: 24-часовой формат, 21:05
puts "Тест 5: 24-часовой формат, 21:05"
set ::CFG_TIME_FORMAT 24
playTime 21 5
puts ""

# Тест 6: 12-часовой формат, 21:05
puts "Тест 6: 12-часовой формат, 21:05"
set ::CFG_TIME_FORMAT 12
playTime 21 5
puts ""
