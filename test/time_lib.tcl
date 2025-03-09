#!/usr/bin/env tclsh
# Библиотека процедур для работы с временем

proc playTime {hour minute} {
	global CFG_TIME_FORMAT

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

	# Проигрываем часы и минуты
	playNumberRu $hour "male"
	playUnit "Default" $hour "hour"
	if {$minute != 0} {
		playNumberRu $minute "female"
		playUnit "Default" $minute "minute"
	} else {
		playMsg "Default" "equal"
	}

	# Добавление am/pm для 12-часового формата
	if {$CFG_TIME_FORMAT == 12} {
		playMsg "Core" "$ampm"
	}
	puts ""
}