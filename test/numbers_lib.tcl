#!/usr/bin/env tclsh
# Библиотека процедур для работы с числами


# Загрузка словаря из файла dict.tcl
source [file join [file dirname [info script]] dict.tcl]

# Процедура для воспроизведения сообщения
proc playMsg { param1 param2 } {
	# puts "*** playMsg receive param1: $param1, param2: $param2"
	global wordMap

	# Проверяем, существует ли указанный каталог и файл в словаре
	if {[dict exists $wordMap $param1 $param2]} {
		set content [dict get $wordMap $param1 $param2]

		# Выводим содержимое файла
		foreach line $content {
			puts -nonewline "$line "
		}
	} else {
		puts "Ошибка: Каталог '$param1' или файл '$param2' не найдены в словаре."
	}
}


# Процедура для обработки числа (0-999)
proc playNumberBlock { number gender } {
	set num [expr {int($number)}]
	set values {900 800 700 600 500 400 300 200 100 90 80 70 60 50 40 30 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1}

	foreach val $values {
		while {$num >= $val} {
			# Обработка десятков 20-90, которые заканчиваются на 0
			if {$val >= 20 && $val <= 90 && $val % 10 == 0} {
				set remainder_after [expr {$num - $val}]
				if {$remainder_after > 0} {
					set tens [expr {$val / 10}]
					set block "${tens}X"
					playMsg "Default" $block
					set num [expr {$num - $val}]
					continue
				} else {
					playMsg "Default" $val
					set num [expr {$num - $val}]
					continue
				}
			}

			# Стандартная обработка для остальных значений
			set block $val
			# Обработка чисел 1 и 2 в зависимости от рода
			if {$val == 1 || $val == 2} {
				# Женский род: добавляем суффикс "f"
				if {$gender eq "female"} {
					append block "f"
				}
				# Средний род: добавляем суффикс "o" только для числа 1, исключая числа, оканчивающиеся на 11
				if {$gender eq "neuter" && $val == 1} {
					set lastTwoDigits [expr {$num % 100}]
					if {$lastTwoDigits != 11} {
						append block "o"
					}
				}
			}
			playMsg "Default" $block
			set num [expr {$num - $val}]
		}
	}
}


# Процедура для добавления единицы измерения
proc playUnit {modulename value unit} {
	# puts "playUnit receive modulename: $modulename, value: $value, unit: $unit"
	# Remove leading zeros to avoid octal interpretation
	set value [string trimleft $value "0"]
	if {$value eq ""} {
		set value 0
	}

	# Ensure value is a valid integer after removing leading zeros
	if {![string is integer -strict $value]} {
		error "Invalid value: $value is not an integer"
	}

	set lastDigit [expr {$value % 10}]
	set lastTwo [expr {$value % 100}]

	# Определение правильной формы единицы измерения
	if {$lastTwo >= 11 && $lastTwo <= 14} {
		# Для чисел 11-14 используется форма множественного числа
		set unit "${unit}s"
	} else {
		switch -- $lastDigit {
			1 { set unit "${unit}" }
			2 - 3 - 4 { set unit "${unit}1" }
			default { set unit "${unit}s" }
		}
	}

	# Воспроизведение единицы измерения
	playMsg $modulename $unit
}

# Процедура для воспроизведения числа на русском языке
# Процедура для воспроизведения числа на русском языке
proc playNumberRu { value gender } {
	# Разделение числа на целую и дробную части
	set parts [split $value "."]
	set integerPart [lindex $parts 0]
	set fractionalPart [lindex $parts 1]

	# Преобразование целой части в число
	set integerPart [scan $integerPart %d]

	# Обработка отрицательных чисел
	set isNegative [expr {$value < 0}]
	if {$isNegative} {
		playMsg "Default" "minus"
	}
	set absValue [expr {abs($integerPart)}]

	# Проверка на ноль
	if {$absValue == 0 && ($fractionalPart eq "" || $fractionalPart == 0)} {
		playMsg "Default" "0"
		return
	}

	# Разделение целой части на тысячи и единицы
	set thousands [expr {$absValue / 1000}]
	set units [expr {$absValue % 1000}]

	# Обработка тысяч
	if {$thousands > 0} {
		playNumberBlock $thousands "female"  
		# Тысячи всегда женского рода
		playUnit "Default" $thousands "thousand"
	}

	# Обработка единиц
	if {$units > 0 || ($thousands == 0 && ($fractionalPart eq "" || $fractionalPart == 0))} {
		# Если есть дробная часть, род целой части должен быть женским
		if {$fractionalPart ne "" && $fractionalPart != 0} {
			playNumberBlock $units "female"  
			# Женский род для целой части
		} else {
			playNumberBlock $units $gender  
			# Общий род для целых чисел
		}

		if {$fractionalPart ne "" && $fractionalPart != 0} {
			playUnit "Default" $units "integer"  
			# "целых"
		}
	}

	# Обработка дробной части
	if {$fractionalPart ne "" && $fractionalPart != 0} {
		# Для дробных чисел с нулевой целой частью
		if {$integerPart == 0} {
			playMsg "Default" "0"
			playUnit "Default" $integerPart "integer"
		}

		playMsg "Default" "and"
		set fractionalNum [scan $fractionalPart "%d"]
		set lastDigit [expr {$fractionalNum % 10}]
		if {$lastDigit == 1 || $lastDigit == 2} {
			playNumberBlock $fractionalNum "female"  
			# Женский род для дробной части
		} else {
			playNumberBlock $fractionalNum $gender  
			# Общий род для дробной части
		}

		if {[string length $fractionalPart] == 1} {
			playUnit "Default" $fractionalNum "tenth"  
			# "десятых"
		} else {
			playUnit "Default" $fractionalNum "hundredth"  
			# "сотых"
		}
	}
}

