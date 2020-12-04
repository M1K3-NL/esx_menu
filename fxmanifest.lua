fx_version 'adamant'
game 'gta5'

description 'Personal Menu by Strin'

client_scripts {
	'client.lua',
	'@es_extended/locale.lua',
	'locales/cs.lua',
	'locales/en.lua',
	'locales/nl.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/cs.lua',
	'locales/en.lua',
	'locales/nl.lua',
    	'server.lua',
	'config.lua'
}
