# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# Руский синтаксис для воспроизведения времени
proc playTime {hour minute} {
	variable Logic::CFG_TIME_FORMAT

	# Проверка корректности формата времени
	if {$hour < 0 || $hour > 24 } {
		puts "*** WARNING: Function playTime received invlalid argument hour: $hour (0-$CFG_TIME_FORMAT)"
		return
	}
	if {$minute < 0 || $minute > 59  } {
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

	playNumberRu $hour "male"
	playUnit "Default" $hour "hour" 
	playSilence 100

	# Обработка минут
	if {$minute == 0} {
		playMsg "Default" "equal"
	} else {
		playNumberRu $minute "male"
		playUnit "Default" $minute "minute" 
	}

	# Добавление am/pm для 12-часового формата
	if {$CFG_TIME_FORMAT == 12} {
		playMsg "Core" "$ampm"
	}
	playSilence 100
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
