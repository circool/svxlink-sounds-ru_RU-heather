#!/usr/bin/env tclsh

proc parse_metar_1 {metar_str} {
	set result [dict create]
	set tokens [split $metar_str " "]
	set token_index 0
	set num_tokens [llength $tokens]
	set state "INIT"

	# Словари для нормализации данных
	set position_map {L left R right C center}
	set cloud_map {FEW FEW SCT SCT BKN BKN OVC OVC}
	set weather_map {RA DZ SN SG PL GR GS UP BR FG FU VA DU SA HZ PO SQ FC TS DS SS}

	# Основные структуры данных
	set runway [dict create]
	set wind [dict create]
	set visibility [dict create]
	set clouds [list]
	set temperature ""
	set dew_point ""
	set qnh ""
	set weather [list]
	set trends [list]

	while {$token_index < $num_tokens} {
		set token [lindex $tokens $token_index]
		incr token_index

		switch $state {
			"INIT" {
				# Обработка кода аэропорта (пример: "KJFK")
				if {[regexp {^[A-Z]{4}$} $token]} {
					dict set result station $token
				} elseif {[regexp {^(\d{3}|VRB)(\d{2,3})G?(\d{2,3})?KT$} $token -> dir speed gust]} {
					dict set wind direction $dir
					dict set wind speed $speed
					if {$gust ne ""} {
						dict set wind gust $gust
					}
				} elseif {[regexp {^(\d+)(SM)?$} $token -> vis unit]} {
					dict set visibility value $vis
					if {$unit ne ""} {
						dict set visibility unit $unit
					}
				} elseif {[lsearch $weather_map $token] != -1} {
					lappend weather $token
				} elseif {[regexp {^(FEW|SCT|BKN|OVC)(\d{3})(CB|TCU)?$} $token -> type height cloud_type]} {
					set layer [dict create]
					dict set layer type $type
					dict set layer height [expr {$height * 100}]
					if {$cloud_type ne ""} {
						dict set layer cloud_type $cloud_type
					}
					lappend clouds $layer
				} elseif {[regexp {^(M?\d{2})/(M?\d{2})$} $token -> temp dew]} {
					set temperature [string map {M -} $temp]
					set dew_point [string map {M -} $dew]
				} elseif {[regexp {^Q(\d{4})$} $token -> qnh_val]} {
					set qnh "Q$qnh_val"
				} elseif {$token eq "runway"} {
					set state "RUNWAY"
					set runway [dict create]
				} elseif {$token in {TEMPO BECMG}} {
					set trend [dict create]
					dict set trend type $token
					set state "TREND"
				}
			}

			"RUNWAY" {
				# Код из предыдущей версии (обработка номера, позиции, состояний ВПП)
				# ... (см. предыдущий ответ) ...
			}

			"TREND" {
				# Обработка временных изменений (пример: TEMPO 4000 RA)
				if {[regexp {^\d{4}$} $token]} {
					dict set trend visibility $token
				} elseif {[lsearch $weather_map $token] != -1} {
					dict set trend weather $token
				} else {
					lappend trends $trend
					set state "INIT"
					incr token_index -1
				}
			}
		}
	}

	# Сохранение данных
	if {[dict size $wind] > 0} {
		dict set result wind $wind
	}
	if {[dict size $visibility] > 0} {
		dict set result visibility $visibility
	}
	if {[llength $clouds] > 0} {
		dict set result clouds $clouds
	}
	if {$temperature ne ""} {
		dict set result temperature $temperature
		dict set result dew_point $dew_point
	}
	if {$qnh ne ""} {
		dict set result qnh $qnh
	}
	if {[llength $weather] > 0} {
		dict set result weather $weather
	}
	if {[llength $trends] > 0} {
		dict set result trends $trends
	}

	return $result
}

proc parse_metar {metar_str} {
	set result [dict create]
	set tokens [split $metar_str " "]
	set token_index 0
	set num_tokens [llength $tokens]
	set state "INIT"

	# Словари для нормализации данных
	set position_map {L left R right C center}
	set runway_conditions {
		clrd snow ice wet damp contaminated
		closed covered friction_less dry
	}

	# Основные структуры данных
	set wind [dict create]
	set visibility [dict create]
	set clouds [list]
	set temperature ""
	set dew_point ""
	set qnh ""
	set weather [list]
	set trends [list]
	set runways [list]

	while {$token_index < $num_tokens} {
		set token [lindex $tokens $token_index]
		incr token_index

		switch $state {
			"INIT" {
				# Обработка кода аэропорта (пример: "UUEE")
				if {[regexp {^[A-Z]{4}$} $token]} {
					dict set result station $token
				} elseif {[regexp {^(\d{3}|VRB)(\d{2,3})MPS$} $token -> dir speed]} {
					dict set wind direction $dir
					dict set wind speed $speed
				} elseif {$token eq "CAVOK"} {
					dict set visibility value "9999"
					dict set visibility unit "M"
				} elseif {[regexp {^(M?\d{2})/(M?\d{2})$} $token -> temp dew]} {
					set temperature [string map {M -} $temp]
					set dew_point [string map {M -} $dew]
				} elseif {[regexp {^Q(\d{4})$} $token -> qnh_val]} {
					set qnh "Q$qnh_val"
				} elseif {[regexp {^R(\d{2}[LRC])/([A-Z]+)(\d{2})$} $token -> runway condition value]} {
					set runway_data [dict create]
					dict set runway_data number $runway
					dict set runway_data condition $condition
					dict set runway_data value $value
					lappend runways $runway_data
				}
			}
		}
	}

	# Сохранение данных
	if {[dict size $wind] > 0} {
		dict set result wind $wind
	}
	if {[dict size $visibility] > 0} {
		dict set result visibility $visibility
	}
	if {$temperature ne ""} {
		dict set result temperature $temperature
		dict set result dew_point $dew_point
	}
	if {$qnh ne ""} {
		dict set result qnh $qnh
	}
	if {[llength $runways] > 0} {
		dict set result runways $runways
	}

	return $result
}