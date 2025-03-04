#!/usr/bin/env tclsh

proc playNumberRuss { value gender } {
    
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
    if {$integerPart != 0} {
        # Тысячи
        set thousands [expr {$integerPart / 1000}]
        set remainder [expr {$integerPart % 1000}]
        
        if {$thousands > 0} {
            playNumberBlock $thousands "female" 1
            playMsg "Default" [GetThousandForm $thousands]
            set integerPart $remainder
        }

        # Обработка остатка
        playNumberBlock $integerPart $gender 0

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

proc playNumberBlock { number gender isThousand } {
    set num [expr {int($number)}]
    set values {900 800 700 600 500 400 300 200 100 90 80 70 60 50 40 30 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1}

    foreach val $values {
        while {$num >= $val} {
            set block $val
            # Добавляем суффикс только для 1 и 2 в нужных контекстах
            if {($val == 1 || $val == 2) && ($gender eq "female" || $gender eq "neuter")} {
                append block [expr {$gender eq "female" ? "f" : "o"}]
            }
            playMsg "Default" $block
            set num [expr {$num - $val}]
        }
    }
}

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


# Для отладки
proc playMsg { param1 param2 } {
	puts "DEBUG: playMsg playing audio $param2"	
}

# Процедура для получения параметров из командной строки и вызова playNumberRuss
proc main {} {
    global argv

    # Проверяем, что передано два аргумента: час и минута
    if {[llength $argv] != 2} {
        puts "Использование: playNumberRussTest.tcl <value> <gender>"
        exit 1
    }

    # Получаем час и минуту из аргументов командной строки
    set param1 [lindex $argv 0]
    set param2 [lindex $argv 1]

    # Вызываем процедуру playTime с полученными аргументами
    playNumberRuss $param1 $param2
}

# Вызов основной процедуры
main






# Воспроизведения чисел в соответствием с правилами произношения цифр в русском языке.
# Поскольку после числа может произноситься и единица измерения (минута, метр итд), важно предусмотреть это при формировании произношения числа (для этого нужен $gender)

# Далее в описании приведены русские слова для понимания. В теле процедуры используй такие эквиваленты:
# тысяча - thousand
# тысячи - thousands
# тысяч - thousand1
# целая - integer
# целых - integers
# десятая - tenth
# десятых - tenths
# сотая - hundredth
# сотых - hundredths
# и - and


# Параметры:
#  number число целое или десятичная дробь, положительное или отрицательное менее миллиона
#  gender строка - род единицы измерения ("male","female","neuter")
# Результат:
# Вызов одной или нескольких процедур playMsg {"Default" $stringValue}, где stringValue формируется следующим образом:




# Правила формирования переменной (stringValue):
# Если value отрицательное, сначала вызывается playMsg {"Default" "minus"}
# Потом разбирается значение value

# value разбирается на блоки (тысячи, сотни, единицы и дробную часть (дробная часть максимум 2 знака после запятой))
# Лидирующие (незначащие) нули игнорируй как для целых, так и для дробных частей $number

# Блок тысяч:
# После блока с тысячами вызывается playMsg {"Default" block_name} где block_name = [тысяча, тысячи или тысяч]
# вариант выбирается по последней цифре в числе тысяч (1-тысяча, 2-4-тысячи, иначе-тысяч)
# Пример: 901 - "тысяча", 900 - тысяч, 704-тысячи

# Для композиции stringValue можно использовать только такие строки: 1...20, 30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900
# Для чисел, которые нельзя выразить вышеперечисленными строками вызывается несколько команд playMsg {"Default" $stringValue}

# Например
# playNumberRuss { 415 "male|female|neuter"} => playMsg {"Default" "400"}; playMsg {"Default" "15"}
# playNumberRuss { 731 "male|female|neuter"} => playMsg {"Default" "700"}; playMsg {"Default" "30"}; playMsg {"Default" "1"} 
# playNumberRuss { 1731 "male|female|neuter"} => playMsg {"Default" "1f"};  playMsg {"Default" "thousand"}; playMsg {"Default" "700"}; playMsg {"Default" "30"}; playMsg {"Default" "1"} 
# playNumberRuss { 2731 "male|female|neuter"} => playMsg {"Default" "2f"};  playMsg {"Default" "thousands"}; playMsg {"Default" "700"}; playMsg {"Default" "30"}; playMsg {"Default" "1"} 
# playNumberRuss { 5731 "male|female|neuter"} => playMsg {"Default" "5"};  playMsg {"Default" "thousand1"}; playMsg {"Default" "700"}; playMsg {"Default" "30"}; playMsg {"Default" "1"} 

# Относится только к блоку тысяч и блоку единиц:
# если gender=female и последняя цифра = 1 или 2, к ней добавляется "f" напр. playNumberRuss { 701 "female" } -> playMsg {"Default" "700"}; playMsg {"Default" "1f"};
# если gender=neuter и последняя цифра = 1 или 2, к ней добавляется "o" напр. playNumberRuss { 701 "female" } -> playMsg {"Default" "700"}; playMsg {"Default" "1o"};


# Для дробных числе действуют особые условия:

# Между целой и дробной частями вставляется значение (целая, целых) и термин "и" ("and")
# Для чисел целой части заканчивающихся на 1 или используется "integer", для остальных - "integers"

# Если целая или дробная часть заказчивается на 1 или 2 для такой части используй правила для gender=female (относитcя как к единицам, так и к тысячам)
# Обрати внимание
# Для сотых и десятых долей используй "десятая" или "сотая" когда дробная часть заканчивается на 1, иначе используй "десятых" или "сотых" соответстренно
# playNumberRuss { 2.01 "female" } -> playMsg {"Default" "2f"}; playMsg {"Default" "integer"}; playMsg {"Default" "and"}; playMsg {"Default" "1f"}; playMsg {"Default" "hundredth"}
# playNumberRuss { 91.1 "female" } -> playMsg {"Default" "90"}; playMsg {"Default" "1f"}; playMsg {"Default" "integer"}; playMsg {"Default" "and"}; playMsg {"Default" "1f"}; playMsg {"Default" "tenths"}
# playNumberRuss { 52.1 "female" } -> playMsg {"Default" "590"}; playMsg {"Default" "1f"}; playMsg {"Default" "integer"}; playMsg {"Default" "and"}; playMsg {"Default" "1f"}; playMsg {"Default" "tenths"}


# Для чисел дробной части дополняей указанием разрядности (десятые доли - "tenth", сотые - "hundredth")
# Десятые доли обозначаются термином "tenth" в единственном числе, "tenths" в множественном числе "одна десятая" ("1f"+"tenth") или "пять десятых" ("5"+"tenths")
# Сотые доли обозначаются термином "hundredth" в единственном числе, "hundredths" в множественном числе
# Например: 2571.11 - "две тысячи пятьсот семьдесят одна целая и одинадцать сотых" ("2f"+"thousands"+"500"+"70"+"1f"+"integer"+"11"+"hundredths")
