
client_script 'zonos/pistol.lua'
client_script 'zonos/stambiu.lua'
client_script 'zonos/third.lua'
client_script 'zonos/headshot.lua'
client_script 'KillRewards.lua'
server_script 'server.lua'
game 'gta5'
fx_version 'bodacious'


author "onecodes"
version "1.6.5"
description 'some bs zones for kaunopvp.lt with some more stuff idk'

lua54 "yes"

shared_script '@ox_lib/init.lua'
shared_script '@es_extended/imports.lua'

dependencies {
	'oxmysql',
	'ox_lib',
	'ox_inventory',
}
