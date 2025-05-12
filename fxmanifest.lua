fx_version "cerulean"
game "gta5"

name "fivem_ton_radial"
description "Permet de personnaliser sont menu radial pour y mettre les annimations en favorie"
author "tontonCasi@twitch"
version "1.0.0"

lua54 "yes"

client_scripts {
    "client/cl_main.lua"
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/sv_main.lua"
}

shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/imports.lua'
}