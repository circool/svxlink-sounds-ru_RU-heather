#!/bin/bash
scp ru_RU/events.d/local/*.tcl 192.168.40.83:/usr/share/svxlink/sound/events.d/local/
scp -r ru_RU/* 192.168.40.83:/usr/share/svxlink/sound/events.d/local/