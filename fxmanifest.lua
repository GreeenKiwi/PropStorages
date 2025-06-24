fx_version 'cerulean'
game 'gta5'

author 'KIWI'
description 'Storage System w/ oxTarget'
version '1.1.0'

lua54 "yes"

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    'server/servercallback.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_target',
    'ox_lib',
    'vms_clothestore'
}