# @author vladimir@tsurkanenko.ru
# aka circool
# aka R2ADU



namespace eval ReflectorLogic {

#
# A helper function for announcing a talkgroup.
# If there is an audio clip matching the name talk_group-<tg> it will be played
# instead of spelling the digits. Look at the documentation for playMsg for
# more information on where to put the audio clip.
#
#   tg - The talkgroup to announce
#
proc say_talkgroup {tg} {
  # Пытаемся воспроизвести сообщение "talk_group-$tg"
  if {[playMsg "Core" "talk_group-$tg" 0]} {
    return
  }

  # Преобразуем число в строку
  set tg_str [format "%d" $tg]
  set len [string length $tg_str]

  # Если число содержит 3 или меньше цифр, произносим его целиком
  if {$len <= 3} {
    playNumberRus $tg "male"
    return
  }

  # Разбиваем строку на группы по 3 цифры, начиная с начала
  set result ""
  for {set i 0} {$i < $len} {set i [expr {$i + 3}]} {
    set end [expr {$i + 3 > $len ? $len : $i + 3}]
    set group [string range $tg_str $i $end-1]
    lappend result $group
  }

  # Произносим каждую группу отдельно
  foreach group $result {
    playNumberRus $group "male"
    playSilence 100  # Добавляем небольшую паузу между группами
  }
}


}