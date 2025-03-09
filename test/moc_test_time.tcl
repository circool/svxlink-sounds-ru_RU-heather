#!/usr/bin/env tclsh

# Процедура для запуска timeTest.tcl с заданными параметрами
# Возвращает 1, если тест не пройден, и 0, если тест пройден успешно
proc runTimeTest { hour minute expected format } {
	# Форматируем строку с ожидаемым результатом
	set expectedLabel "Ожидаемый результат:  "
	set expectedFormatted [format "%-20s %s" $expectedLabel $expected]
	# puts $expectedFormatted

	# Запускаем timeTest.tcl и захватываем его вывод
	set result [exec ./timeTest.tcl $hour $minute $format]

	# Удаляем пробелы в конце результата
	set result [string trimright $result]

	# Форматируем строку с фактическим результатом
	set resultLabel "Фактический результат:"
	set resultFormatted [format "%-20s %s" $resultLabel $result]
	# puts $resultFormatted

	# Сравниваем ожидаемый и фактический результат
	if {$result eq $expected} {
		# puts "Тест пройден успешно!"
		return 0
		# Возвращаем 0 для успешного теста
	} else {
		puts "Тест не пройден: ожидалось '$expected', получено '$result'"
		return 1
		# Возвращаем 1 для неудачного теста
	}

	puts "----------------------------------------"
}

# Основной код

# Флаг для отслеживания ошибок
set testFailed 0

# Запуск тестов для 24-часового формата
set format 24

# Тестируем все часы с 0 по 23 с 0 минутами
for {set hour 0} {$hour < 24} {incr hour} {
	set expected ""
	if {$hour == 0} {
		set expected "ноль часов ровно"
	} elseif {$hour == 1} {
		set expected "один час ровно"
	} elseif {$hour == 2} {
		set expected "два часа ровно"
	} elseif {$hour == 3} {
		set expected "три часа ровно"
	} elseif {$hour == 4} {
		set expected "четыре часа ровно"
	} elseif {$hour == 5} {
		set expected "пять часов ровно"
	} elseif {$hour == 6} {
		set expected "шесть часов ровно"
	} elseif {$hour == 7} {
		set expected "семь часов ровно"
	} elseif {$hour == 8} {
		set expected "восемь часов ровно"
	} elseif {$hour == 9} {
		set expected "девять часов ровно"
	} elseif {$hour == 10} {
		set expected "десять часов ровно"
	} elseif {$hour == 11} {
		set expected "одиннадцать часов ровно"
	} elseif {$hour == 12} {
		set expected "двенадцать часов ровно"
	} elseif {$hour == 13} {
		set expected "тринадцать часов ровно"
	} elseif {$hour == 14} {
		set expected "четырнадцать часов ровно"
	} elseif {$hour == 15} {
		set expected "пятнадцать часов ровно"
	} elseif {$hour == 16} {
		set expected "шестнадцать часов ровно"
	} elseif {$hour == 17} {
		set expected "семнадцать часов ровно"
	} elseif {$hour == 18} {
		set expected "восемнадцать часов ровно"
	} elseif {$hour == 19} {
		set expected "девятнадцать часов ровно"
	} elseif {$hour == 20} {
		set expected "двадцать часов ровно"
	} elseif {$hour == 21} {
		set expected "двадцать один час ровно"
	} elseif {$hour == 22} {
		set expected "двадцать два часа ровно"
	} elseif {$hour == 23} {
		set expected "двадцать три часа ровно"
	}

	if {[runTimeTest $hour 0 $expected $format]} { set testFailed 1 }
}

# Тестируем все минуты с 0 по 59 для 1 часа
for {set minute 0} {$minute < 60} {incr minute} {
	set expected ""
	if {$minute == 0} {
		set expected "один час ровно"
	} elseif {$minute == 1} {
		set expected "один час одна минута"
	} elseif {$minute == 2} {
		set expected "один час две минуты"
	} elseif {$minute == 3} {
		set expected "один час три минуты"
	} elseif {$minute == 4} {
		set expected "один час четыре минуты"
	} elseif {$minute == 5} {
		set expected "один час пять минут"
	} elseif {$minute == 6} {
		set expected "один час шесть минут"
	} elseif {$minute == 7} {
		set expected "один час семь минут"
	} elseif {$minute == 8} {
		set expected "один час восемь минут"
	} elseif {$minute == 9} {
		set expected "один час девять минут"
	} elseif {$minute == 10} {
		set expected "один час десять минут"
	} elseif {$minute == 11} {
		set expected "один час одиннадцать минут"
	} elseif {$minute == 12} {
		set expected "один час двенадцать минут"
	} elseif {$minute == 13} {
		set expected "один час тринадцать минут"
	} elseif {$minute == 14} {
		set expected "один час четырнадцать минут"
	} elseif {$minute == 15} {
		set expected "один час пятнадцать минут"
	} elseif {$minute == 16} {
		set expected "один час шестнадцать минут"
	} elseif {$minute == 17} {
		set expected "один час семнадцать минут"
	} elseif {$minute == 18} {
		set expected "один час восемнадцать минут"
	} elseif {$minute == 19} {
		set expected "один час девятнадцать минут"
	} elseif {$minute == 20} {
		set expected "один час двадцать минут"
	} elseif {$minute == 21} {
		set expected "один час двадцать одна минута"
	} elseif {$minute == 22} {
		set expected "один час двадцать две минуты"
	} elseif {$minute == 23} {
		set expected "один час двадцать три минуты"
	} elseif {$minute == 24} {
		set expected "один час двадцать четыре минуты"
	} elseif {$minute == 25} {
		set expected "один час двадцать пять минут"
	} elseif {$minute == 26} {
		set expected "один час двадцать шесть минут"
	} elseif {$minute == 27} {
		set expected "один час двадцать семь минут"
	} elseif {$minute == 28} {
		set expected "один час двадцать восемь минут"
	} elseif {$minute == 29} {
		set expected "один час двадцать девять минут"
	} elseif {$minute == 30} {
		set expected "один час тридцать минут"
	} elseif {$minute == 31} {
		set expected "один час тридцать одна минута"
	} elseif {$minute == 32} {
		set expected "один час тридцать две минуты"
	} elseif {$minute == 33} {
		set expected "один час тридцать три минуты"
	} elseif {$minute == 34} {
		set expected "один час тридцать четыре минуты"
	} elseif {$minute == 35} {
		set expected "один час тридцать пять минут"
	} elseif {$minute == 36} {
		set expected "один час тридцать шесть минут"
	} elseif {$minute == 37} {
		set expected "один час тридцать семь минут"
	} elseif {$minute == 38} {
		set expected "один час тридцать восемь минут"
	} elseif {$minute == 39} {
		set expected "один час тридцать девять минут"
	} elseif {$minute == 40} {
		set expected "один час сорок минут"
	} elseif {$minute == 41} {
		set expected "один час сорок одна минута"
	} elseif {$minute == 42} {
		set expected "один час сорок две минуты"
	} elseif {$minute == 43} {
		set expected "один час сорок три минуты"
	} elseif {$minute == 44} {
		set expected "один час сорок четыре минуты"
	} elseif {$minute == 45} {
		set expected "один час сорок пять минут"
	} elseif {$minute == 46} {
		set expected "один час сорок шесть минут"
	} elseif {$minute == 47} {
		set expected "один час сорок семь минут"
	} elseif {$minute == 48} {
		set expected "один час сорок восемь минут"
	} elseif {$minute == 49} {
		set expected "один час сорок девять минут"
	} elseif {$minute == 50} {
		set expected "один час пятьдесят минут"
	} elseif {$minute == 51} {
		set expected "один час пятьдесят одна минута"
	} elseif {$minute == 52} {
		set expected "один час пятьдесят две минуты"
	} elseif {$minute == 53} {
		set expected "один час пятьдесят три минуты"
	} elseif {$minute == 54} {
		set expected "один час пятьдесят четыре минуты"
	} elseif {$minute == 55} {
		set expected "один час пятьдесят пять минут"
	} elseif {$minute == 56} {
		set expected "один час пятьдесят шесть минут"
	} elseif {$minute == 57} {
		set expected "один час пятьдесят семь минут"
	} elseif {$minute == 58} {
		set expected "один час пятьдесят восемь минут"
	} elseif {$minute == 59} {
		set expected "один час пятьдесят девять минут"
	}

	if {[runTimeTest 1 $minute $expected $format]} { set testFailed 1 }
}

# Запуск тестов для 12-часового формата
set format 12

# Тестируем 3 условия для 12-часового формата
if {[runTimeTest "1" "0" "один час ровно до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "13" "0" "один час ровно после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "0" "0" "двенадцать часов ровно до полудня" $format]} { set testFailed 1 }

# Итоговое сообщение
if {$testFailed} {
	puts "Тест не пройден"
} else {
	puts "Тест пройден успешно"
}