BondrixPermissions.Functions = {}

function BondrixPermissions.Functions.GetPlayerRole(player)
end

function BondrixPermissions.Functions.RoleHasPermission(name, permission, callback)
    BondrixPermissions.Functions.ContainsRole(name, function(response)
        if not response then
            print('Role doesnt even exist bro!')
            return
        end

        MySQL.rawExecute('SELECT `permission` FROM `role_permissions` WHERE `name` = ?', {
            name
        }, function(response)
            local roles = {}
            for _, entry in ipairs(response) do
                if entry.permission == '*' or entry.permission:match(permission) then
                    callback(true)
                    return
                elseif entry.permission:match('^role.') and entry.permission ~= 'role.' .. name then
                    local role = entry.permission:match('^role%.(.+)')
                    table.insert(roles, role)
                end
            end

            for i = 1, #roles, 1 do
                BondrixPermissions.Functions.RoleHasPermission(roles[i], permission, callback)
            end

            if #roles == 0 then
                callback(false)
            end
        end)
    end)
end

function BondrixPermissions.Functions.RoleStrictlyHasPermission(name, permission, callback)
    BondrixPermissions.Functions.ContainsRole(name, function(response)
        if not response then
            print('Role doesnt even exist bro!')
            return
        end

        MySQL.rawExecute('SELECT `permission` FROM `role_permissions` WHERE `name` = ?', {
            name
        }, function(response)
            for _, entry in ipairs(response) do
                if entry.permission == '*' or entry.permission:match(permission) then
                    callback(true)
                    return
                end
            end
            
            callback(false)
        end)
    end)
end

function BondrixPermissions.Functions.PlayerHasPermission(player, permission, callback)
    MySQL.rawExecute('SELECT `permission` FROM `player_permissions` WHERE `license` = ?', {
        GetPlayerIdentifierByType(player, 'license')
    }, function(response)
        -- local roles = json.encode(response, { indent = true, sort_keys = true }))
        -- print(roles)
    end)
end

function BondrixPermissions.Functions.ContainsRole(name, callback)
    MySQL.single('SELECT 1 FROM `roles` WHERE `name` = ? LIMIT 1', {
        name
    }, function(response)
        callback(response ~= nil)
    end)
end

function BondrixPermissions.Functions.ContainsPlayer(player, callback)
    MySQL.single('SELECT 1 FROM `player_permissions` WHERE `license` = ? LIMIT 1', {
        BondrixPermissions.Functions.GetPlayerIdentifier(player)
    }, function(response)
        callback(response ~= nil)
    end)
end

function BondrixPermissions.Functions.GetPlayerIdentifier(player)
    -- If the player is the console
    if player == 0 then
        return 0
    else
        return GetPlayerIdentifierByType(player, 'license')
    end
end