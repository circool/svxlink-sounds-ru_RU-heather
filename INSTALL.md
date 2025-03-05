# Процедура установки

## Вариант А
1. Установите пакет SVXLINK (например из оригинального репозитория https://github.com/sm0svx/svxlink)
2. Поместите папку ru_RU в каталог /usr/share/svxlink/sound/
3. Задайте параметр **DEFAULT_LANG=ru_RU** в разделе указанном в параметре **LOGICS** раздела **[GLOBAL]**

## Вариант Б
1. Установите пакет SVXLINK (например из оригинального репозитория https://github.com/sm0svx/svxlink)
2. перейдите в папку назначения и клонируйте репозиторий
```bash
cd /usr/share/svxlink/sound/
git clone https://github.com/sm0svx/svxlink
```