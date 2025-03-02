#!/usr/bin/env tclsh
# Создаем пространство имен Logic
namespace eval Logic {
    variable CFG_TIME_FORMAT
}

# Мок-функция для playMsg, которая выводит сообщения в консоль
proc playMsg {module message} {
    puts "$module: $message"
}

# Процедура playTime из вашего файла
proc playTime {hour minute} {
    variable Logic::CFG_TIME_FORMAT
    # Проверка корректности формата времени
    if {$Logic::CFG_TIME_FORMAT != 12 && $Logic::CFG_TIME_FORMAT != 24} {
        error "Ошибка: CFG_TIME_FORMAT должен быть 12 или 24"
    }

    # Корректировка часа для 12-часового формата
    if {$Logic::CFG_TIME_FORMAT == 12} {
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
            # минут
            playMsg "Default" $minute
        } else {
            if {$minuteTens > 0} {
                # десятки
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
    if {$Logic::CFG_TIME_FORMAT == 12} {
        playMsg "Core" "$ampm"
    }
}

# Тестовая процедура
proc testPlayTime {hour minute} {
    # Устанавливаем формат времени (12 или 24)
    set Logic::CFG_TIME_FORMAT 12  ;# или 24, в зависимости от теста

    # Вызываем playTime с переданными параметрами
    playTime $hour $minute
}

# Основной код скрипта
if {[llength $argv] != 2} {
    puts "Использование: ./test.tcl <часы> <минуты>"
    exit 1
}

# Извлекаем часы и минуты из аргументов командной строки
set hour [lindex $argv 0]
set minute [lindex $argv 1]

# Проверяем, что часы и минуты являются числами
if {![string is integer $hour] || ![string is integer $minute]} {
    puts "Ошибка: часы и минуты должны быть целыми числами"
    exit 1
}

# Проверяем корректность значений часов и минут
if {$hour < 0 || $hour > 23 || $minute < 0 || $minute > 59} {
    puts "Ошибка: недопустимое значение времени. Часы должны быть от 0 до 23, минуты от 0 до 59"
    exit 1
}

# Вызываем тестовую процедуру с переданными значениями
puts "Тест: $hour:$minute"
testPlayTime $hour $minute
