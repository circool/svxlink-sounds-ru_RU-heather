#!/usr/bin/env tclsh

# Исходные процедуры
source "numbers_lib.tcl"


# Процедура для получения параметров из командной строки и вызова playNumberRu
proc main {} {
	global argv

	# Проверяем, что передано два аргумента: значение и род
	if {[llength $argv] != 2} {
		puts "Использование: numberTest.tcl <value> <gender: male|female|neuter >"
		exit 1
	}

	# Получаем аргументы командной строки
	set param1 [lindex $argv 0]  ;# Значение (передается как строка, даже если начинается с 0)
	set param2 [lindex $argv 1]  ;# Род (male, female, neuter)

	# Выводим аргументы для отладки
	# puts "Calling playNumberRu with arguments: param1 = $param1, param2 = $param2"

	# Вызываем процедуру playNumberRu с полученными аргументами без изменений
	playNumberRu $param1 $param2
	puts "" ; # Добавляем перевод строки
}


# Вызов основной процедуры
main