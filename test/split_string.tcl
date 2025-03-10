#!/usr/bin/env tclsh
# Выделение из строки выражений [.._от] ... до ... [unit_единицы]
proc split_string {input} {

	set pattern {([a-z]+_from\s\d+\s*to\s*\d+\s*unit_[a-z]+)}

	# Разбиваем строку на части
	set result [regexp -all -inline $pattern $input]
	puts "Результат разбивки: $result"
	# Если найдено совпадение
	if {[llength $result] > 0} {
		# Получаем основной блок
		set main_block [lindex $result 0]

		# Получаем текст до и после основного блока
		set before [string range $input 0 [expr {[string first $main_block $input] - 1}]]
		set after [string range $input [expr {[string first $main_block $input] + [string length $main_block]}] end]

		# Возвращаем результат в виде списка
		return [list $before $main_block $after]
	} else {
		return {}
	}
}

# Пример использования
set input_string "wind varies_from 100 to 200 unit_degree empty 10 test"
set result [split_string $input_string]
puts "Результат разбивки: $result"
if {[llength $result] > 0} {
	puts "Текст до: [lindex $result 0]"
	puts "Основной блок: [lindex $result 1]"
	puts "Текст после: [lindex $result 2]"
} else {
	puts "Не удалось найти соответствующий блок"
}