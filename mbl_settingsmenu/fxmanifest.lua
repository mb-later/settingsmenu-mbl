fx_version 'bodacious'

game 'gta5'

client_script 'client.lua'

server_scripts {
    --'@mysql-async/lib/MySQL.lua',
    'server.lua'
}
ui_page('html/index.html')
files({
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/style.css",
	"html/img/*.svg",
	"html/index.html",
	"html/resim/*.png"
})
--client_script 'fyac.lua'