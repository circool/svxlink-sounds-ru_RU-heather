#!/usr/bin/env tclsh

# Словарь для текстового представления чисел (мужской род)
set numberToTextMale {
    0 "ноль"
    1 "один"
    2 "два"
    3 "три"
    4 "четыре"
    5 "пять"
    6 "шесть"
    7 "семь"
    8 "восемь"
    9 "девять"
    10 "десять"
    11 "одиннадцать"
    12 "двенадцать"
    13 "тринадцать"
    14 "четырнадцать"
    15 "пятнадцать"
    16 "шестнадцать"
    17 "семнадцать"
    18 "восемнадцать"
    19 "девятнадцать"
    20 "двадцать"
    30 "тридцать"
    40 "сорок"
    50 "пятьдесят"
}

# Словарь для текстового представления чисел (женский род)
set numberToTextFemale {
    0 "ноль"
    1 "одна"
    2 "две"
    3 "три"
    4 "четыре"
    5 "пять"
    6 "шесть"
    7 "семь"
    8 "восемь"
    9 "девять"
    10 "десять"
    11 "одиннадцать"
    12 "двенадцать"
    13 "тринадцать"
    14 "четырнадцать"
    15 "пятнадцать"
    16 "шестнадцать"
    17 "семнадцать"
    18 "восемнадцать"
    19 "девятнадцать"
    20 "двадцать"
    30 "тридцать"
    40 "сорок"
    50 "пятьдесят"
}

# Словарь для текстового представления слов
set wordToText {
    hour "час"
    hour1 "часа"
    hours "часов"
    minute "минута"
    minutes "минут"
    minute1 "минуты"
    rovno "ровно"
    am "до полудня"
    pm "после полудня"
}

# Процедура для разбиения числа на десятки и единицы
proc splitNumber {number} {
    if {$number >= 10 && $number <= 19} {
        return [list $number ""] ;# Возвращаем число как есть
    } else {
        set tens [expr {$number / 10}]
        set units [expr {$number % 10}]
        return [list $tens $units]
    }
}

# Процедура для формирования текстового представления числа
proc getNumberText {number gender} {
    global numberToTextMale numberToTextFemale

    if {$gender == "female"} {
        set dict $numberToTextFemale
    } else {
        set dict $numberToTextMale
    }

    if {$number >= 0 && $number <= 20} {
        return [dict get $dict $number]
    } elseif {$number > 20 && $number < 100} {
        set tens [expr {$number / 10 * 10}]
        set units [expr {$number % 10}]
        if {$units == 0} {
            return [dict get $dict $tens]
        } else {
            return "[dict get $dict $tens] [dict get $dict $units]"
        }
    } else {
        return ""
    }
}

# Процедура для формирования строки времени
proc formatTime {hour minute ampm} {
    global wordToText numberToTextMale numberToTextFemale

    # Проверка на 12-часовой формат
    if {$ampm == 12} {
        if {$hour < 12} {
            set ampmText "am"
            if {$hour == 0} {
                set hour 12
            }
        } else {
            set ampmText "pm"
            if {$hour > 12} {
                set hour [expr {$hour - 12}]
            }
        }
    } else {
        set ampmText ""
    }

    # Формируем строку для часов (мужской род)
    set result ""
    if {$hour == 0} {
        set hourNumber "0"
        set hourWord "hours"
        append result "playMsg module_name $hourNumber ([getNumberText $hourNumber "male"])\n"
    } elseif {$hour == 1} {
        set hourNumber "1"
        set hourWord "hour"
        append result "playMsg module_name $hourNumber ([getNumberText $hourNumber "male"])\n"
    } elseif {$hour >= 2 && $hour <= 4} {
        set hourNumber "$hour"
        set hourWord "hour1"
        append result "playMsg module_name $hourNumber ([getNumberText $hourNumber "male"])\n"
    } elseif {$hour >= 5 && $hour <= 20} {
        set hourNumber "$hour"
        set hourWord "hours"
        append result "playMsg module_name $hourNumber ([getNumberText $hourNumber "male"])\n"
    } elseif {$hour >= 21 && $hour <= 24} {
        # Разбиваем часы на десятки и единицы
        set hourParts [splitNumber $hour]
        set hourTens [lindex $hourParts 0]
        set hourUnits [lindex $hourParts 1]

        if {$hourTens > 0} {
            set tensText [expr {$hourTens * 10}]
            set tensTextFormatted [dict get $numberToTextMale $tensText]
            append result "playMsg module_name ${hourTens}0X ($tensTextFormatted)\n"
        }
        if {$hourUnits > 0} {
            set unitsText [dict get $numberToTextMale $hourUnits]
            append result "playMsg module_name $hourUnits ($unitsText)\n"
        }

        if {$hour == 21} {
            set hourWord "hour"
        } else {
            set hourWord "hour1"
        }
    } else {
        set hourNumber "$hour"
        set hourWord "hours"
        append result "playMsg module_name $hourNumber ([getNumberText $hourNumber "male"])\n"
    }
    append result "playMsg module_name $hourWord ([dict get $wordToText $hourWord])\n"

    # Обработка минут (женский род)
    if {$minute == 0} {
        append result "playMsg module_name rovno ([dict get $wordToText rovno])\n"
    } else {
        # Разбиваем минуты на десятки и единицы
        set minuteParts [splitNumber $minute]
        set minuteTens [lindex $minuteParts 0]
        set minuteUnits [lindex $minuteParts 1]

        if {$minute >= 10 && $minute <= 19} {
            set minuteText [getNumberText $minute "female"]
            append result "playMsg module_name $minute ($minuteText)\n"
        } else {
            if {$minuteTens > 0} {
                set tensText [expr {$minuteTens * 10}]
                set tensTextFormatted [dict get $numberToTextFemale $tensText]
                append result "playMsg module_name ${minuteTens}0X ($tensTextFormatted)\n"
            }
            if {$minuteUnits > 0} {
                set unitsText [getNumberText $minuteUnits "female"]
                append result "playMsg module_name $minuteUnits ($unitsText)\n"
            }
        }

        # Формируем строку для минут
        if {$minute % 10 == 1 && $minute != 11} {
            append result "playMsg module_name minute ([dict get $wordToText minute])\n"
        } elseif {($minute % 10 >= 2 && $minute % 10 <= 4) && ($minute < 10 || $minute > 20)} {
            append result "playMsg module_name minute1 ([dict get $wordToText minute1])\n"
        } else {
            append result "playMsg module_name minutes ([dict get $wordToText minutes])\n"
        }
    }

    # Добавляем "до полудня" или "после полудня", если используется 12-часовой формат
    if {$ampmText ne ""} {
        append result "playMsg module_name $ampmText ([dict get $wordToText $ampmText])\n"
    }

    return $result
}

# Получаем аргументы командной строки
if {$argc != 3} {
    puts "Использование: ./test_time.tcl <часы> <минуты> <12|24>"
    exit 1
}

set hour [lindex $argv 0]
set minute [lindex $argv 1]
set ampm [lindex $argv 2]

# Проверяем формат часов и минут
if {![string is integer -strict $hour] || $hour < 0 || $hour > 24} {
    puts "Ошибка: часы должны быть числом от 0 до 24"
    exit 1
}
if {![string is integer -strict $minute] || $minute < 0 || $minute > 59} {
    puts "Ошибка: минуты должны быть числом от 0 до 59"
    exit 1
}
if {$ampm != 12 && $ampm != 24} {
    puts "Ошибка: третий аргумент должен быть 12 или 24"
    exit 1
}

# Формируем и выводим результат
set result [formatTime $hour $minute $ampm]
puts $result
