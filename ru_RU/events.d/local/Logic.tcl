namespace eval Logic {
	proc startup {} {
		# Подготовить переменные для ананса текущего времени
		set current_time [clock seconds]
    	set hour [clock format $current_time -format "%H"]
    	set minute [clock format $current_time -format "%M"]
  		# Сообщить что программа запущена, передать короткий ананс и сообщить текущее время
		playMsg "Core" "online"
  		send_short_ident
		playSilence 250;
  		playMsg "Core" "the_time_is";
		playTime $hour $minute;
		playSilence 500;
	}
}