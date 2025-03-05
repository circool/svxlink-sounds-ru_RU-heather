# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU


# Frn
namespace eval Frn {

	#
	# Это "перегруженная" форма вызова playUnit которая использует текущее пространство имен как первый параметр,
	# позволяя упростить вызов из разных пространств, не указывая модуль из которого она вызывается
	#
	proc playUnit {value unit} {
		variable module_name;
		::playUnit $module_name $value $unit;
	}


	#
	# Сообщение о количестве подключенных клиентов
	# Выполняется в рамках информирования о состоянии (при получении DTMF команды *)
	proc count_clients {count_clients} {
		playNumberRu $count_clients "male";
		playSilence 50;
		playUnit	 $count_clients "connected_client";
		playSilence 250;
	}

}