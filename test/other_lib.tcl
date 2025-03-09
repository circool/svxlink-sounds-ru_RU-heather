#!/usr/bin/env tclsh

proc playSilence {param} {
	set value [expr {int($param)}]
	if {$value < 200} {
		puts -nonewline ", "
	} else {
		puts "."
	}
}

proc getGender { unit } {
	# Проверяем единицы женского рода
	if {$unit eq "unit_mile"} {
		return "female"
	} elseif {$unit eq "unit_mph"} {
		return "female"
	}

	# Все остальные случаи - мужской род
	return "male"
}