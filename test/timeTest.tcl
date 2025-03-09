#!/usr/bin/env tclsh
# Оболочка для тестирования процедуры playTime

# Исходные процедуры
source "numbers_lib.tcl"
source "time_lib.tcl"

# Процедура для получения параметров из командной строки
proc main {} {
  global argv

  # Проверяем, что передано три аргумента: час, минута и формат времени
  if {[llength $argv] != 3} {
    puts "Использование: playTimeTest.tcl <час> <минута> <формат (12 или 24)>"
    exit 1
  }

  # Получаем час, минуту и формат из аргументов командной строки
  set hour [lindex $argv 0]
  set minute [lindex $argv 1]
  set format [lindex $argv 2]

  # Устанавливаем глобальную переменную CFG_TIME_FORMAT
  global CFG_TIME_FORMAT
  set CFG_TIME_FORMAT $format

  # Вызываем процедуру playTime с полученными аргументами
  playTime $hour $minute
}

# Вызов основной процедуры
main