# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# Logic
namespace eval Logic {

	# Начальный запуск программы
	proc startup {} {
		global mycall;
		# Подготовить переменные для ананса текущего времени
		set current_time [clock seconds]
		set hour [clock format $current_time -format "%H"]
		set minute [clock format $current_time -format "%M"]
		# Сообщить что программа запущена, передать короткий анонс и сообщить текущее время
		playMsg "Core" "online_short"
		spellWord $mycall
		send_short_ident
		playSilence 250;
		playMsg "Core" "the_time_is";
		playTime $hour $minute;
		playSilence 500;
	}

	# Ручная идентификация
	proc manual_identification {} {
		global mycall;
		global report_ctcss;
		global active_module;
		global loaded_modules;
		variable CFG_TYPE;
		variable prev_ident;

		set epoch [clock seconds];
		set hour [clock format $epoch -format "%k"];
		regexp {([1-5]?\d)$} [clock format $epoch -format "%M"] -> minute;
		set prev_ident $epoch;

		playMsg "Core" "online_short";
		spellWord $mycall;
		if {$CFG_TYPE == "Repeater"} {
			playMsg "Core" "repeater";
		}
		playSilence 250;

		playMsg "Core" "the_time_is";
		playTime $hour $minute;
		playSilence 250;

		if {$report_ctcss > 0} {
			playMsg "Core" "pl_is";
			playFrequencyRu $report_ctcss
			playSilence 300;
		}

		if {$active_module != ""} {
			playMsg "Core" "active_module";
			playMsg $active_module "name";
			playSilence 250;

			set func "::";
			append func $active_module "::status_report";
			if {"[info procs $func]" ne ""} {
				$func;
			}
		} else {
			foreach module [split $loaded_modules " "] {
				set func "::";
				append func $module "::status_report";
				if {"[info procs $func]" ne ""} {
					$func;
				}
			}
		}

		foreach module [split $loaded_modules " "] {
			if { $module ==  "Help"} {
				playMsg "Default" "press_0_for_help"
				playSilence 250;
			}
		}
	}

	proc playFrequencyRu {fq} {
		if {$fq < 1000} {
			set unit "Hz"
		} elseif {$fq < 1000000} {
			set fq [expr {$fq / 1000.0}]
			set unit "kHz"
		} elseif {$fq < 1000000000} {
			set fq [expr {$fq / 1000000.0}]
			set unit "MHz"
		} else {
			set fq [expr {$fq / 1000000000.0}]
			set unit "GHz"
		}

		# Форматируем число с тремя знаками после запятой
		set formattedFq [format "%.3f" $fq]

		# Убираем лишние нули и точку
		set trimmedFq [string trimright $formattedFq ".0"]

		# Произносим число и единицу измерения пространство имен "Default"
		playNumberRu $trimmedFq "female"
		playUnit "Default" $trimmedFq $unit
	}

}