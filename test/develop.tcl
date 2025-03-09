
# Функция для выбора правильной формы числа в винительном падеже (для диапазонов от...до)
proc get_number_form {number} {
	set last_digit [expr {$number % 10}]
	set last_two_digits [expr {$number % 100}]

	if {$last_two_digits >= 11 && $last_two_digits <= 19} {
		return "${number}s" ; # "одиннадцати", "двенадцати" и т.д.
	}

	switch $last_digit {
		1 { return "${number}s" } ; # "одного"
		2 - 3 - 4 { return "${number}s" } ; # "двух", "трех", "четырех"
		default { return "${number}s" } ; # "пяти", "шести" и т.д.
	}
}