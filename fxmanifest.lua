fx_version 'bodacious'
game 'gta5'

author 'Bondrix'
version '1.0.0'

client_script ''
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/functions.lua',
    'server/events.lua',
    'server/commands/*.lua',
    'server/commands/subcommands/*.lua'
}
shared_script ''

dependencies 'oxmysql'