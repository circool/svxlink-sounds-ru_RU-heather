# Процедура установки

## Вариант А
1. Установите пакет SVXLINK (например из оригинального репозитория https://github.com/sm0svx/svxlink)
2. Скачайте последний релиз озвучки https://github.com/circool/svxlink-sounds-ru_RU-milana/releases
3. Разархивируйте скачанный архив
4. Поместите папку ru_RU в каталог /usr/share/svxlink/sound/
5. Задайте параметр **DEFAULT_LANG=ru_RU** в разделе указанном в параметре **LOGICS** раздела **[GLOBAL]**

## Вариант Б
1. Установите пакет SVXLINK (например из оригинального репозитория https://github.com/sm0svx/svxlink)
2. перейдите в папку назначения и клонируйте репозиторий
```bash
cd /usr/share/svxlink/sound/
git clone https://github.com/circool/svxlink-sounds-ru_RU-milana
```
3. Задайте параметр **DEFAULT_LANG=ru_RU** в разделе указанном в параметре **LOGICS** раздела **[GLOBAL]**