namespace eval Frn {

	proc playUnit {value unit} {
	variable module_name;
	::playUnit $module_name $value $unit;
	}

	# Не найдено причин для изменения стандартной логики


	# Восемь подключенные клиенты
	#
	# Executed when command to count nodes on the channel is called
	#
	proc count_clients {count_clients} {
	playNumberRu $count_clients "male";
	playSilence 50;
	playUnit	 $count_clients "connected_client";
	playSilence 250;
	}

}