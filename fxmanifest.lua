fx_version 'cerulean'
game 'gta5'

author 'GreeenKiwi'
description 'Storage System for OxTarget & OxInventory'
version '1.0.0'

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
    'server/server.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_target',
    'ox_lib',
    'vms_clothestore'
    --'CodeForge-ClotheShop-ResourceName'
    --'AK47-ClotheShop-ResourceName'
    --'RCore-ClotheShop-ResourceName'    
}