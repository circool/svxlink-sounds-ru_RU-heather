# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# Руский синтаксис для воспроизведения времени
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

# Блок playNumber
# Воспроизведение чисел в соответствием с правилами произношения цифр в русском языке.
proc playNumberRu { value gender } {

	# Обработка отрицательных чисел
	set isNegative [expr {$value < 0}]
	if {$isNegative} {
		playMsg "Default" "minus"
	}
	set absValue [expr {abs($value)}]

	# Проверка на ноль (включая 0.0, -0, -0.0)
	if {$absValue == 0} {
		playMsg "Default" "0"
		return ;# Прекращаем выполнение
	}

	# Разделение на целую и дробную части
	set integerPart [expr {int($absValue)}]
	set fractionalPart [expr {round(($absValue - $integerPart) * 100)}]
	set fractionalPart [string trimright [format "%02d" $fractionalPart] "0"]
	set hasFraction [expr {[string length $fractionalPart] > 0}]

	# Обработка целой части
	if {$integerPart != 0 || $hasFraction} {
		# Если целая часть нулевая, но есть дробная, добавляем "0 целых"
		if {$integerPart == 0 && $hasFraction} {
			playMsg "Default" "0"
			playMsg "Default" "integers"
		} else {
			# Тысячи
			set thousands [expr {$integerPart / 1000}]
			set remainder [expr {$integerPart % 1000}]

			if {$thousands > 0} {
				playNumberBlock $thousands "female" 1
				playMsg "Default" [GetThousandForm $thousands]
				set integerPart $remainder
			}

			# Обработка остатка
			if {$integerPart != 0} {
				playNumberBlock $integerPart $gender 0
			}

			# Добавление "целая/целых"
			if {$hasFraction} {
				set lastTwo [expr {$integerPart % 100}]
				if {$lastTwo >= 11 && $lastTwo <= 14} {
					set suffix "integers"
				} else {
					set lastDigit [expr {$integerPart % 10}]
					set suffix [expr {$lastDigit == 1 ? "integer" : "integers"}]
				}
				playMsg "Default" $suffix
			}
		}
	}

	# Дробная часть
	if {$hasFraction} {
		playMsg "Default" "and"
		set fractionalNum [scan $fractionalPart "%d"]
		playNumberBlock $fractionalNum $gender 0

		# Определение суффикса
		set fractionalLen [string length $fractionalPart]
		set lastTwoFrac [expr {$fractionalNum % 100}]
		if {$fractionalLen == 1} {
			set suffix [expr {$lastTwoFrac == 1 ? "tenth" : "tenths"}]
		} else {
			set suffix [expr {$lastTwoFrac == 1 ? "hundredth" : "hundredths"}]
		}
		playMsg "Default" $suffix
	}
}

# Вспомогательная процедура для обработки чисел в диапазоне 0-999
proc playNumberBlock { number gender isThousand } {
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
# Вспомогательная процедура для определения формы слова ТЫСЯЧА
proc GetThousandForm { number } {
	set lastTwo [expr {$number % 100}]
	if {$lastTwo >= 11 && $lastTwo <= 14} {
		return "thousand1"
	}
	set lastDigit [expr {$number % 10}]
	return [expr {
		$lastDigit == 1 ? "thousand" :
		($lastDigit >= 2 && $lastDigit <= 4) ? "thousands" : "thousand1"
		}]
	}
	# /блок playNumber

	# Произношение формы единицы измерения (градус/градуса|метр/метра)
	# Используется в модулях MetarInfo, EchoLink
	# Звуковые файлы уже учитвают род единицы измерения, так что нам остается только понять, это единственная или множественная форма
	proc playUnit {modulename value unit} {
		# Проверяем, есть ли дробная часть (для дробный частей используем форму от слова "целая/целых" - одна целая | семь целых)
		if {[regexp {\.} $value]} {
			set unit "${unit}1"
		} else {
			# Получаем последнюю цифру числа
			set lastDigit [string index $value end]

			# Определяем правильную форму единицы измерения
			if {$lastDigit == 1} {
				# градус, минута
				set unit "${unit}"
			} elseif {$lastDigit == 2 || $lastDigit == 3 || $lastDigit == 4} {
				# градуса, минуты
				set unit "${unit}1"
			} else {
				# градусов, минут
				set unit "${unit}s"
			}
		}
		playMsg $modulename $unit
	}
