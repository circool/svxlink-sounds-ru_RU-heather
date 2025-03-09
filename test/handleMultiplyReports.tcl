#!/usr/bin/env tclsh
proc handleMultiplyReports {args {anounce ""}} {

	# Если анонс не пустой, воспроизводим его
	if {$anounce ne ""} {
		playMsg $anounce
	}

	set i 0
	while {$i < [llength $args]} {
		set item [lindex $args $i]
		# За числом может идти единица измерения или какое-либо другое слово
		if {[regexp {\d+} $item]} {
			# Обработка числового значения
			set val $item
			incr i

			if {$i < [llength $args]} {
				set unit [lindex $args $i]

				# Устанавливаем gender в зависимости от значения unit
				if {[string match "unit_*" $unit]} {
					set gender [getGender $unit]
				} else {
					set gender "male"
				}

				playNumberRu $val $gender

				# Для слов выражающих единицу измерения
				if {[string match "unit_*" $unit]} {
					# Удаляем принудительно заданную логикой множественную форму
					if {[string index $unit end] eq "s"} {
						set unit [string range $unit 0 end-1]
					}
					playUnit "MetarInfo" $val $unit
					playSilence 100
				} else {
					# Вызываем playMsg для слов не выражающих единицы измерения
					playMsg "MetarInfo" $unit
				}
				incr i
			} else {
				playNumberRu $val "male"
			}
		} else {
			# Обработка нечисловых значений
			playMsg "MetarInfo" $item
			incr i
		}
	}
	playSilence 200
}