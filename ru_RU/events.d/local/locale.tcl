# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU

# Время
proc playTime {hour minute} {
	
	variable Logic::CFG_TIME_FORMAT
	# Установить формат часа и время суток для 12-часового формата
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

	playNumberRu $hour "male";
	playUnit "Default" $hour "hour";
	if {$minute != 0} {
		playNumberRu $minute "female";
		playUnit "Default" $minute "minute";
	} else {
		playMsg "Default" "equal"
	}

	# Добавление am/pm для 12-часового формата
	if {$CFG_TIME_FORMAT == 12} {
		playMsg "Core" "$ampm"
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
			if {($val == 1 || $val == 2) && ($gender eq "female" || $gender eq "neuter")} {
				append block [expr {$gender eq "female" ? "f" : "o"}]
			}
			playMsg "Default" $block
			set num [expr {$num - $val}]
		}
	}
}


# Процедура для добавления единицы измерения
proc playUnit {modulename value unit} {
	# Удаление лидирующих нулей
	set value [string trimleft $value "0"]
	if {$value eq ""} {
		set value 0
	}

	# Убедится что получено целое число
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
proc playNumberRu { value gender } {
	# Преобразование строки в число чтобы не получить восьмеричные числа
	set value [scan $value %d]

	# Обработка отрицательных чисел
	set isNegative [expr {$value < 0}]
	if {$isNegative} {
		playMsg "Default" "minus"
	}
	set absValue [expr {abs($value)}]

	# Проверка на ноль
	if {$absValue == 0} {
		playMsg "Default" "0"
		return
	}

	# Разделение на целую и дробную части
	set integerPart [expr {int($absValue)}]
	set fractionalPart [expr {round(($absValue - $integerPart) * 100)}]
	set fractionalPart [string trimright [format "%02d" $fractionalPart] "0"]
	set hasFraction [expr {[string length $fractionalPart] > 0}]

	# Разделение целой части на тысячи и единицы
	set thousands [expr {$integerPart / 1000}]
	set units [expr {$integerPart % 1000}]

	# Обработка тысяч
	if {$thousands > 0} {
		playNumberBlock $thousands "female"
		playUnit "Default" $thousands "thousand"
	}

	# Обработка единиц
	if {$units > 0 || ($thousands == 0 && !$hasFraction)} {
		playNumberBlock $units $gender
		if {$hasFraction} {
			playUnit "Default" $units "integer"
		}
	}

	# Обработка дробной части
	if {$hasFraction} {
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
		} else {
			playNumberBlock $fractionalNum $gender
		}

		if {[string length $fractionalPart] == 1} {
			playUnit "Default" $fractionalNum "tenth"
		} else {
			playUnit "Default" $fractionalNum "hundredth"
		}
	}
}