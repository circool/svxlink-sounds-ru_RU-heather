#!/usr/bin/tclsh

# Процедура для воспроизведения чисел на русском языке
proc playNumberRuss {number gender} {
    # Проверка на корректность числа
    if {![regexp {^\s*([+-])?(\d*)(?:\.(\d+))?\s*$} $number -> sign integer fraction]} {
        puts "*** ERROR[playNumber]: Invalid number '$number'"
        return
    }

    # Если целая часть пуста, устанавливаем её в "0"
    if {[string length "$integer"] == 0} {
        set integer "0"
    }

    # Обработка отрицательных чисел
    if {$sign == "-"} {
        puts "playMsg \"Default\" \"minus\""
    }

    # Обработка дробной части
    if {$fraction != ""} {
        playNumberRuss $integer $gender
        playIntegerSuffix $integer
        puts "playMsg \"Default\" \"and\""
        playFraction $fraction $gender
        return
    }

    # Обработка целой части числа
    set len [string length $integer]
    if {$len == 0} {
        return
    }

    # Обработка чисел от 0 до 19
    if {$len <= 2 && $integer < 20} {
        playNumberWithGender $integer $gender
        return
    }

    # Обработка чисел от 20 до 99
    if {$len == 2} {
        set tens [string range $integer 0 0]
        set units [string range $integer 1 1]
        if {$tens != "0"} {
            puts "playMsg \"Default\" \"${tens}X\""
        }
        if {$units != "0"} {
            playNumberWithGender $units $gender
        }
        return
    }

    # Обработка чисел от 100 до 999
    if {$len == 3} {
        set hundreds [string range $integer 0 0]
        set remainder [string range $integer 1 end]
        puts "playMsg \"Default\" \"${hundreds}00\""
        playNumberRuss $remainder $gender
        return
    }

    # Обработка чисел больше 999
    if {$len > 3} {
        set thousands [string range $integer 0 end-3]
        set remainder [string range $integer end-2 end]
        playNumberRuss $thousands $gender
        playThousandSuffix $thousands
        playNumberRuss $remainder $gender
        return
    }
}

# Вспомогательная процедура для воспроизведения числа с учётом рода
proc playNumberWithGender {number gender} {
    set lastDigit [string index $number end]
    if {$gender == "female" && ($lastDigit == "1" || $lastDigit == "2")} {
        puts "playMsg \"Default\" \"${number}f\""
    } elseif {$gender == "neuter" && ($lastDigit == "1" || $lastDigit == "2")} {
        puts "playMsg \"Default\" \"${number}o\""
    } else {
        puts "playMsg \"Default\" \"$number\""
    }
}

# Вспомогательная процедура для добавления суффикса "thousand", "thousands" или "thousand1"
proc playThousandSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
        puts "playMsg \"Default\" \"thousand\""
    } elseif {$lastDigit == "2" || $lastDigit == "3" || $lastDigit == "4"} {
        puts "playMsg \"Default\" \"thousands\""
    } else {
        puts "playMsg \"Default\" \"thousand1\""
    }
}

# Вспомогательная процедура для добавления суффикса "integer", "integer1" или "integers"
proc playIntegerSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
        puts "playMsg \"Default\" \"integer1\""
    } else {
        puts "playMsg \"Default\" \"integers\""
    }
}

# Вспомогательная процедура для воспроизведения дробной части
proc playFraction {fraction gender} {
    set len [string length $fraction]
    if {$len == 1} {
        playNumberWithGender $fraction $gender
        if {$fraction == "1"} {
            puts "playMsg \"Default\" \"tenth\""
        } else {
            puts "playMsg \"Default\" \"tenths\""
        }
    } elseif {$len == 2} {
        set tens [string range $fraction 0 0]
        set units [string range $fraction 1 1]
        if {$tens != "0"} {
            puts "playMsg \"Default\" \"${tens}X\""
        }
        if {$units != "0"} {
            playNumberWithGender $units $gender
        }
        if {$fraction == "01"} {
            puts "playMsg \"Default\" \"hundredth\""
        } else {
            puts "playMsg \"Default\" \"hundredths\""
        }
    }
}

# Основной код для обработки аргументов командной строки
if {$argc != 2} {
    puts "Usage: playNumberRuss.tcl <number> <gender>"
    exit 1
}

set number [lindex $argv 0]
set gender [lindex $argv 1]

# Вызов основной процедуры
playNumberRuss $number $gender