fx_version 'cerulean'
lua54 'yes'
game 'gta5' --shared_script "@renzu_shield/init.lua"
ui_page {
    'web/index.html',
}
shared_script '@ox_lib/init.lua'
client_scripts {
	'config.lua',
	'client/main.lua'
}
server_scripts {
	'config.lua',
	'server/main.lua'
}
files {
	'web/index.html',
	'web/script.js',
	'web/style.css',
	'web/image/*.png',
}
