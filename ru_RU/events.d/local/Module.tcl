# Для отладки отключаем сообщения о включении модуля
#
# Executed when a module is being activated
#
proc activating_module {module_name} {
	# playMsg "Default" "activating";
	# playSilence 100;
	# playMsg $module_name "name";
	# playSilence 200;
	puts "Включается модуль $module_name"
}

proc deactivating_module {module_name} {
	# playMsg "Default" "deactivating";
	# playSilence 100;
	# playMsg $module_name "name";
	# playSilence 200;
	puts "Выключается модуль $module_name"
}

proc timeout {module_name} {
	# playMsg "Default" "timeout";
	# playSilence 100;
	puts "Таймаут модуля $module_name"
}