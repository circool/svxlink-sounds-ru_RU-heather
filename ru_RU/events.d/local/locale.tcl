# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


###############################################################################
# Руский синтаксис для воспроизведения времени
# Процедура для формирования строки времени (без текстовых представлений)
# TODO: 
# ошибки при формировании минут (одна (1f) минута (minute), две (2f) минуты (minute1), три-четыре (3-4) минуты (minute1), далее пять-девятнадцать (5-19) минут(minuts))
# для значений 20-59 повторяется - 21 минута, 25 минут, 41 минута, 59 минут

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

    # Убираем ведущий ноль для часов
    set hour [expr {$hour + 0}]

    # Обработка часов
    if {$hour == 0} {
        playMsg "Default" "0"
        playMsg "Default" "hours"
    } elseif {$hour == 1 || $hour == 21} {
        playMsg "Default" $hour
        playMsg "Default" "hour"  ;# 1 час, 21 час
    } elseif {($hour >= 2 && $hour <= 4) || ($hour >= 22 && $hour <= 24)} {
        playMsg "Default" $hour
        playMsg "Default" "hour1"  ;# 2-4 часа, 22-24 часа
    } elseif {$hour >= 5 && $hour <= 20} {
        playMsg "Default" $hour
        playMsg "Default" "hours"  ;# 5-20 часов
    } else {
        playMsg "Default" $hour
        playMsg "Default" "hours"
    }

    # Обработка минут
    if {$minute == 0} {
        playMsg "Default" "equal"
    } else {
        # Убираем ведущий ноль для минут
        set minute [expr {$minute + 0}]

        if {$minute < 20} {
            # Для чисел от 0 до 19 используем одностроковое значение
            playMsg "Default" $minute
        } elseif {$minute % 10 == 0} {
            # Если минуты кратны 10, используем одностроковое значение
            playMsg "Default" $minute
        } else {
            set minuteTens [expr {$minute / 10}]
            set minuteUnits [expr {$minute % 10}]
            if {$minuteTens > 0} {
                playMsg "Default" "${minuteTens}X"
            }
            if {$minuteUnits > 0} {
                # Для минут 1, 2, 21, 22, 31, 32 и т.д. добавляем "f"
                if {$minuteUnits == 1 || $minuteUnits == 2} {
                    playMsg "Default" "${minuteUnits}f"
                } else {
                    playMsg "Default" "$minuteUnits"
                }
            }
        }

        # Склонение слова "минута" в зависимости от значения минут
        if {$minute % 10 == 1 && $minute != 11} {
            playMsg "Default" "minute"  ;# 1 минута, 21 минута, 31 минута и т.д.
        } elseif {($minute % 10 >= 2 && $minute % 10 <= 4) && ($minute < 10 || $minute > 20)} {
            playMsg "Default" "minute1"  ;# 2-4 минуты, 22-24 минуты и т.д.
        } else {
            playMsg "Default" "minutes"  ;# 5-19, 20, 25-29, ..., 59 минут
        }
    }

    # Добавление am/pm для 12-часового формата
    if {$CFG_TIME_FORMAT == 12} {
        playMsg "Core" "$ampm"
    }
}

# Руский синтаксис для воспроизведения чисел
# Параметры:
#  number число
#  gender строка - род единицы измерения (male,female,neuter)
#
# Правила формирования результата (аргумент для playMsg):
# числа от 0 до 19: одно строковое значение ("0","2","3"..."19")
# числа от 20: 
# если число кратно 10, используются одностроковые значения (30 - "30", 50 - "50") 
# иначе десятки дополняются символом "X" b создается составное значение (25 - "20X" + "5", 530 - "500"+"30", 431 - "400"+"30X"+"1" )
#
# Для gender=male:
# без изменения
#
# Для gender=female:
# если последняя цифра = 1 или 2: добавляется "f" (121 - "100"+"20X"+"1f")
#
# Для gender=neuter:
# если последняя цифра = 1 или 2: добавляется "o" (121 - "100"+"20X"+"1o")
#
# Для чисел более 999 тысячи выражаются отдельно, добавлением "thoustand" соответствии с гендерным правилом
# тысяча - "thoustand", тысяч - "thoustand1", тысячи - "thoustands"
# 1000 - одна тысяча ("1f"+"thoustand"), 
# 2000 -  две тысячи ("2f"+"thoustands"), 
# 3000,4000 - три(четыре) тысячи ("3"("4")+"thoustands"), 
# 5000 и более - пять тысяч ("5"+"thoustand1")

# Десятичные дроби:
# Если целая или дробная часть заказчивается на 1 или 2 используются правила для gender=female
# Между целой и дробной частями вставляется значение (целая, целых) ("integer" ("integer1", "integers") плюс термин "и" ("and")
# Для чисел заканчивающихся на 1 или используется "integer1", для остальных - "integers"

# Дробная часть дополняется указанием разрядности (десятые доли - "tenth", сотые - "hundredth")
# Десятые доли обозначаются термином "tenth" в единственном числе, "tenths" в множественном числе "одна десятая" ("1f"+"tenth") или "пять десятых" ("5"+"tenths")
# Сотые доли обозначаются термином "hundredth" в единственном числе, "hundredths" в множественном числе
# Например: 2571.11 - "две тысячи пятьсот семьдесят одна целая и одинадцать сотых" ("2f"+"thoustands"+"500"+"70"+"1f"+"integer"+"11"+"hundredths")
#


# Процедура для воспроизведения чисел на русском языке
proc playNumberRuss {number gender} {
    # Проверка на корректность числа
    if {![regexp {^\s*([+-])?(\d*)(?:\.(\d+))?\s*$} $number -> sign integer fraction]} {
        puts "*** ERROR[playNumberRuss]: Invalid number '$number'"
        return
    }

    # Если целая часть пуста, устанавливаем её в "0"
    if {[string length "$integer"] == 0} {
        set integer "0"
    }

    # Обработка отрицательных чисел
    if {$sign == "-"} {
        playMsg "Default" "minus"
    }

    # Обработка дробной части
    if {$fraction != ""} {
        playNumberRuss $integer $gender
        playIntegerSuffix $integer
			  playMsg "Default" "and"
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
			  playMsg "Default" "${tens}X"
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
		playMsg "Default" "${hundreds}00"
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
		playMsg "Default" "${number}f"
    } elseif {$gender == "neuter" && ($lastDigit == "1" || $lastDigit == "2")} {
		playMsg "Default" "${number}o"
    } else {
		playMsg "Default" "$number"
    }
}

# Вспомогательная процедура для добавления суффикса "тысяча", "тысячи" или "тысяч"
proc playThousandSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
		playMsg "Default" "thousand"
    } elseif {$lastDigit == "2" || $lastDigit == "3" || $lastDigit == "4"} {
		playMsg "Default" "thousands"
    } else {
		playMsg "Default" "thousand1"
    }
}

# Вспомогательная процедура для добавления суффикса "целая", "целых"
proc playIntegerSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
		playMsg "Default" "integer1"
    } else {
		playMsg "Default" "integers"
    }
}

# Вспомогательная процедура для воспроизведения дробной части
proc playFraction {fraction gender} {
    set len [string length $fraction]
    if {$len == 1} {
        playNumberWithGender $fraction $gender
        if {$fraction == "1"} {
			  playMsg "Default" "tenth"
        } else {
			  playMsg "Default" "tenths"
        }
    } elseif {$len == 2} {
        set tens [string range $fraction 0 0]
        set units [string range $fraction 1 1]
        if {$tens != "0"} {
			  playMsg "Default" "${tens}X"
        }
        if {$units != "0"} {
            playNumberWithGender $units $gender
        }
        if {$fraction == "01"} {
			  playMsg "Default" "hundredth"
        } else {
            playMsg "Default" "hundredths"
        }
    }
}


# Вспомогательная процедура для воспроизведения числа с учётом рода
proc playNumberWithGender {number gender} {
    set lastDigit [string index $number end]
    if {$gender == "female" && ($lastDigit == "1" || $lastDigit == "2")} {
        playMsg "Default" "${number}f"
    } elseif {$gender == "neuter" && ($lastDigit == "1" || $lastDigit == "2")} {
        playMsg "Default" "${number}o"
    } else {
        playMsg "Default" "$number"
    }
}

# Вспомогательная процедура для добавления суффикса "тысяча", "тысячи" или "тысяч"
proc playThousandSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
        playMsg "Default" "thousand"
    } elseif {$lastDigit == "2" || $lastDigit == "3" || $lastDigit == "4"} {
        playMsg "Default" "thousands"
    } else {
        playMsg "Default" "thousand1"
    }
}

# Вспомогательная процедура для добавления суффикса "целая", "целых"
proc playIntegerSuffix {number} {
    set lastDigit [string index $number end]
    if {$lastDigit == "1"} {
        playMsg "Default" "integer1"
    } else {
        playMsg "Default" "integers"
    }
}

# Вспомогательная процедура для воспроизведения дробной части
proc playFraction {fraction gender} {
    set len [string length $fraction]
    if {$len == 1} {
        playNumberWithGender $fraction $gender
        if {$fraction == "1"} {
            playMsg "Default" "tenth"
        } else {
            playMsg "Default" "tenths"
        }
    } elseif {$len == 2} {
        set tens [string range $fraction 0 0]
        set units [string range $fraction 1 1]
        if {$tens != "0"} {
            playMsg "Default" "${tens}X"
        }
        if {$units != "0"} {
            playNumberWithGender $units $gender
        }
        if {$fraction == "01"} {
            playMsg "Default" "hundredth"
        } else {
            playMsg "Default" "hundredths"
        }
    }
}





# Произносит число и единицу измерения
#   - температура в градусах по Цельсию ("unit_degree") - градус, градуса, градусов
#   - давление в ГектоПаскалях ("unit_hPa") гектопаскаль, гектопаскаля, гектопаскалей
#   - скорость ветра в узлах ("unit_kt") - узел, узла, узлов
#   - период в часах ("hour") - час, часа, часов
#   - ("unit_mb") - 
#   - величина в дюймах ("unit_inch") - дюйм, дюйма, дюймов
# proc speakNumber {value unit}{

# }



