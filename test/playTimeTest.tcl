#!/usr/bin/env tclsh

# Правила формирования результата (аргумент для playMsg):

# Результат должен соответствовать правилам русского языка
# числа от 0 до 19: одно строковое значение ("0","2","3"..."19")
# числа от 20:
# если число кратно 10, используются одностроковые значения (30 - "30", 50 - "50")
# иначе десятки дополняются символом "X" и создается составное значение (24 - "2X" + "4")

# Для минут (gender=female):
# если последняя цифра = 1 или 2: добавляется "f" (21 - "2X"+"1f")

# Порядок формирования часов/минут
# минута - minute
# минуты - minute1
# минут - minutes

# час - hour
# часа - hour1
# часов - hours

# Устанавливаем глобальную переменную CFG_TIME_FORMAT
set CFG_TIME_FORMAT 24

# Фейковая процедура playMsg, которая выводит полученные аргументы в консоль
proc playMsg {category message} {
  puts "playMsg: category=$category, message=$message"
}

# Процедура playTime, которая обрабатывает время и вызывает playMsg
proc playTime {hour minute} {
  # variable Logic::CFG_TIME_FORMAT
  global CFG_TIME_FORMAT
  # Проверка корректности формата времени
  if {$CFG_TIME_FORMAT != 12 && $CFG_TIME_FORMAT != 24} {
    puts "Ошибка: CFG_TIME_FORMAT должен быть 12 или 24"
  }
  if {$hour < 0 || $hour > 24 || [string length $hour] > 2} {
    puts "*** WARNING: Function playTime received invlalid argument hour: $hour (0-$CFG_TIME_FORMAT)."
    return
  }
  if {$minute < 0 || $minute > 59 || [string length $hour] > 2} {
    puts "*** WARNING: Function playTime received invlalid argument minute: $minute. Must be 0 до 59"
    return
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
    # Для 1 и 21 часа используем "hour"
    if {$hour == 21} {
      playMsg "Default" "2X"
      playMsg "Default" "1"
    } else {
      playMsg "Default" $hour
    }
    playMsg "Default" "hour"  ;# 1 час, 21 час
  } elseif {($hour >= 2 && $hour <= 4) || ($hour >= 22 && $hour <= 24)} {
    # Для часов от 20 и выше, если число не кратно 10, разбиваем на десятки и единицы
    if {$hour >= 20 && $hour % 10 != 0} {
      set hourTens [expr {$hour / 10}]
      set hourUnits [expr {$hour % 10}]
      playMsg "Default" "${hourTens}X"
      if {$hourUnits > 0} {
        playMsg "Default" "$hourUnits"
      }
    } else {
      playMsg "Default" $hour
    }
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
      if {$minute == 1 || $minute == 2} {
        playMsg "Default" "${minute}f"
      } else {
        playMsg "Default" $minute
      }
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

# Процедура для получения параметров из командной строки и вызова playTime
proc main {} {
  global argv

  # Проверяем, что передано два аргумента: час и минута
  if {[llength $argv] != 2} {
    puts "Использование: playTime.tcl <час> <минута>"
    exit 1
  }

  # Получаем час и минуту из аргументов командной строки
  set hour [lindex $argv 0]
  set minute [lindex $argv 1]

  # Вызываем процедуру playTime с полученными аргументами
  playTime $hour $minute
}

# Вызов основной процедуры
main