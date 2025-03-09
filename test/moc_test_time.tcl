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

# Запуск тестов для различных комбинаций часов и минут
# Если хотя бы один тест не пройден, устанавливаем флаг testFailed в 1

# Тестируем 24-часовой формат
set format 24

if {[runTimeTest "1" "1" "один час одна минута" $format]} { set testFailed 1 }
if {[runTimeTest "2" "2" "два часа две минуты" $format]} { set testFailed 1 }
if {[runTimeTest "3" "3" "три часа три минуты" $format]} { set testFailed 1 }
if {[runTimeTest "4" "4" "четыре часа четыре минуты" $format]} { set testFailed 1 }
if {[runTimeTest "5" "5" "пять часов пять минут" $format]} { set testFailed 1 }

if {[runTimeTest "11" "1" "одиннадцать часов одна минута" $format]} { set testFailed 1 }
if {[runTimeTest "12" "2" "двенадцать часов две минуты" $format]} { set testFailed 1 }
if {[runTimeTest "13" "3" "тринадцать часов три минуты" $format]} { set testFailed 1 }
if {[runTimeTest "14" "4" "четырнадцать часов четыре минуты" $format]} { set testFailed 1 }
if {[runTimeTest "15" "5" "пятнадцать часов пять минут" $format]} { set testFailed 1 }

if {[runTimeTest "21" "1" "двадцать один час одна минута" $format]} { set testFailed 1 }
if {[runTimeTest "22" "2" "двадцать два часа две минуты" $format]} { set testFailed 1 }
if {[runTimeTest "23" "3" "двадцать три часа три минуты" $format]} { set testFailed 1 }
if {[runTimeTest "0" "5" "ноль часов пять минут" $format]} { set testFailed 1 }

# Тестируем 12-часовой формат
set format 12

if {[runTimeTest "1" "1" "один час одна минута до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "2" "2" "два часа две минуты до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "3" "3" "три часа три минуты до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "4" "4" "четыре часа четыре минуты до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "5" "5" "пять часов пять минут до полудня" $format]} { set testFailed 1 }

if {[runTimeTest "11" "1" "одиннадцать часов одна минута до полудня" $format]} { set testFailed 1 }
if {[runTimeTest "12" "2" "двенадцать часов две минуты после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "13" "3" "один час три минуты после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "14" "4" "два часа четыре минуты после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "15" "5" "три часа пять минут после полудня" $format]} { set testFailed 1 }

if {[runTimeTest "21" "1" "девять часов одна минута после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "22" "2" "десять часов две минуты после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "23" "3" "одиннадцать часов три минуты после полудня" $format]} { set testFailed 1 }
if {[runTimeTest "0" "5" "двенадцать часов пять минут до полудня" $format]} { set testFailed 1 }

# Итоговое сообщение
if {$testFailed} {
	puts "Тест не пройден"
} else {
	puts "Тест пройден успешно"
}