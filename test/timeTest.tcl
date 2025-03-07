#!/usr/bin/env tclsh
# Оболочка для тестирования процедуры playTime

# Исходные процедуры
source "numbers_lib.tcl"
source "time_lib.tcl" 

# Устанавливаем глобальную переменную CFG_TIME_FORMAT
set CFG_TIME_FORMAT 24

# Процедура для получения параметров из командной строки
proc main {} {
  global argv

  # Проверяем, что передано два аргумента: час и минута
  if {[llength $argv] != 2} {
    puts "Использование: playTimeTest.tcl <час> <минута>"
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