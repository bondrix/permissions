AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    local schema = LoadResourceFile(GetCurrentResourceName(), 'schema.sql')
    if not schema then
        return
    end

    local queries = {}
    for query in schema:gmatch("([^;]+);") do
        table.insert(queries, query)
    end
    
    for _, query in ipairs(queries) do
        MySQL.rawExecute(query, {}, function(response)
            if not response then
                print("Error executing query: " .. query)
            end
        end)
        Wait(500)
    end
end)

AddEventHandler('playerConnecting', function(name)
    local player = source

    BondrixPermissions.Functions.ContainsPlayer(player, function(contains)
        if not contains then
            TriggerEvent("BondrixPermissions:Server:InitializePlayer", player)
        end
    end)
end)

RegisterNetEvent("BondrixPermissions:Server:InitializePlayer", function(player)
    MySQL.insert('INSERT INTO `player_permissions` (license, permission) VALUES (?, ?)', {
        BondrixPermissions.Functions.GetPlayerIdentifier(player), 'role.default'
    }, function(response)
        print('Sucessfully added ' .. GetPlayerName(player) .. ' to the database!')
    end)
end)