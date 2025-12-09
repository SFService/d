fx_version 'adamant'
games { 'gta5' }

author 'Falcon'
description 'Bandebuy - Weapon Shop System'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'weaponConfig.lua',
}

client_scripts {
    '@PolyZone/client.lua',
}

client_scripts {
    'client/main.lua',
    'client/weaponShop.lua',
    'client/utils.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/logs.lua'
}

ui_page {
    'dist/index.html'
}

files {
    '*.json',
    'dist/index.html',
    'dist/css/*.css',
    'dist/font/*.ttf',
    'dist/*.css',
    'dist/js/*.js',
    'dist/js/*.js.map',
    'dist/img/*.png',
    'dist/img/*.jpg',
    'dist/img/*.gif',
    'dist/bck/*.png',
    'dist/bck/*.jpg',
    'dist/bck/*.gif',
}