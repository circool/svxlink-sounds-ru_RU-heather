#!/usr/bin/env tclsh

# Процедура для запуска numberTest.tcl с заданными параметрами
# Возвращает 1, если тест не пройден, и 0, если тест пройден успешно
proc runTest { value gender expected } {
	# puts "Тестируем число: $value, род: $gender"

	# Форматируем строку с ожидаемым результатом
	set expectedLabel "Ожидаемый результат:  "
	set expectedFormatted [format "%-20s %s" $expectedLabel $expected]
	# puts $expectedFormatted

	# Запускаем numberTest.tcl и захватываем его вывод
	set result [exec ./numberTest.tcl $value $gender]

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

# Запуск тестов для различных чисел и родов
# Если хотя бы один тест не пройден, устанавливаем флаг testFailed в 1

if {[runTest "0" "male" "ноль"]} { set testFailed 1 }
if {[runTest "1" "male" "один"]} { set testFailed 1 }
if {[runTest "1" "neuter" "одно"]} { set testFailed 1 }
if {[runTest "1" "female" "одна"]} { set testFailed 1 }
if {[runTest "2" "male" "два"]} { set testFailed 1 }
if {[runTest "2" "female" "две"]} { set testFailed 1 }
if {[runTest "2" "female" "два"]} { set testFailed 1 }
if {[runTest "5" "neuter" "пять"]} { set testFailed 1 }
if {[runTest "10" "male" "десять"]} { set testFailed 1 }
if {[runTest "11" "female" "одиннадцать"]} { set testFailed 1 }
if {[runTest "12" "neuter" "двенадцать"]} { set testFailed 1 }
if {[runTest "13" "male" "тринадцать"]} { set testFailed 1 }
if {[runTest "14" "female" "четырнадцать"]} { set testFailed 1 }
if {[runTest "15" "neuter" "пятнадцать"]} { set testFailed 1 }
if {[runTest "21" "female" "двадцать одна"]} { set testFailed 1 }
if {[runTest "22" "male" "двадцать два"]} { set testFailed 1 }
if {[runTest "25" "neuter" "двадцать пять"]} { set testFailed 1 }
if {[runTest "100" "neuter" "сто"]} { set testFailed 1 }
if {[runTest "101" "male" "сто один"]} { set testFailed 1 }
if {[runTest "102" "female" "сто две"]} { set testFailed 1 }
if {[runTest "105" "neuter" "сто пять"]} { set testFailed 1 }
if {[runTest "111" "female" "сто одиннадцать"]} { set testFailed 1 }
if {[runTest "112" "male" "сто двенадцать"]} { set testFailed 1 }
if {[runTest "115" "neuter" "сто пятнадцать"]} { set testFailed 1 }
if {[runTest "-123" "male" "минус сто двадцать три"]} { set testFailed 1 }

# Числа с дробной частью (десятые и сотые доли)
if {[runTest "0.5" "male" "ноль целых и пять десятых"]} { set testFailed 1 }
if {[runTest "1.25" "female" "одна целая и двадцать пять сотых"]} { set testFailed 1 }
if {[runTest "2.3" "neuter" "две целых и три десятых"]} { set testFailed 1 }
if {[runTest "10.01" "male" "десять целых и одна сотая"]} { set testFailed 1 }
if {[runTest "11.11" "female" "одиннадцать целых и одиннадцать сотых"]} { set testFailed 1 }
if {[runTest "12.12" "neuter" "двенадцать целых и двенадцать сотых"]} { set testFailed 1 }
if {[runTest "13.13" "male" "тринадцать целых и тринадцать сотых"]} { set testFailed 1 }
if {[runTest "14.14" "female" "четырнадцать целых и четырнадцать сотых"]} { set testFailed 1 }
if {[runTest "15.15" "neuter" "пятнадцать целых и пятнадцать сотых"]} { set testFailed 1 }
if {[runTest "21.21" "female" "двадцать одна целая и двадцать одна сотая"]} { set testFailed 1 }
if {[runTest "22.22" "male" "двадцать две целых и двадцать две сотых"]} { set testFailed 1 }
if {[runTest "25.25" "neuter" "двадцать пять целых и двадцать пять сотых"]} { set testFailed 1 }
if {[runTest "123.45" "female" "сто двадцать три целых и сорок пять сотых"]} { set testFailed 1 }
if {[runTest "-0.75" "neuter" "минус ноль целых и семьдесят пять сотых"]} { set testFailed 1 }

# Числа с нулевой целой частью
if {[runTest "0.0" "male" "ноль"]} { set testFailed 1 }
if {[runTest "0.1" "female" "ноль целых и одна десятая"]} { set testFailed 1 }
if {[runTest "0.2" "female" "ноль целых и две десятых"]} { set testFailed 1 }
if {[runTest "0.3" "female" "ноль целых и три десятых"]} { set testFailed 1 }


if {[runTest "0.01" "neuter" "ноль целых и одна сотая"]} { set testFailed 1 }

# Числа с тысячами
if {[runTest "1000" "female" "одна тысяча"]} { set testFailed 1 }
if {[runTest "1001" "male" "одна тысяча один"]} { set testFailed 1 }
if {[runTest "1002" "female" "одна тысяча две"]} { set testFailed 1 }
if {[runTest "1003" "female" "одна тысяча три"]} { set testFailed 1 }
if {[runTest "1005" "neuter" "одна тысяча пять"]} { set testFailed 1 }
if {[runTest "1011" "female" "одна тысяча одиннадцать"]} { set testFailed 1 }
if {[runTest "1012" "male" "одна тысяча двенадцать"]} { set testFailed 1 }
if {[runTest "1015" "neuter" "одна тысяча пятнадцать"]} { set testFailed 1 }
if {[runTest "1234" "male" "одна тысяча двести тридцать четыре"]} { set testFailed 1 }
if {[runTest "2000.5" "neuter" "две тысячи и пять десятых"]} { set testFailed 1 }
if {[runTest "3001.25" "female" "три тысячи одна целая и двадцать пять сотых"]} { set testFailed 1 }
if {[runTest "10000" "male" "десять тысяч"]} { set testFailed 1 }
if {[runTest "12345.67" "female" "двенадцать тысяч триста сорок пять целых и шестьдесят семь сотых"]} { set testFailed 1 }

# Граничные случаи
if {[runTest "999" "male" "девятьсот девяносто девять"]} { set testFailed 1 }
if {[runTest "1001" "female" "одна тысяча одна"]} { set testFailed 1 }
if {[runTest "999.99" "neuter" "девятьсот девяносто девять целых и девяносто девять сотых"]} { set testFailed 1 }
if {[runTest "100000" "male" "сто тысяч"]} { set testFailed 1 }

# Итоговое сообщение
if {$testFailed} {
	puts "Тест не пройден"
} else {
	puts "Тест пройден успешно"
}