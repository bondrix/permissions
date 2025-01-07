function BondrixPermissions.Commands.Role(source, args)
    if #args < 1 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end

    local subCommands = {
        ["add"] = BondrixPermissions.Commands.RoleAdd,
        ["remove"] = BondrixPermissions.Commands.RoleRemove,
        ["permission"] = BondrixPermissions.Commands.RolePermission
    }

    local label = args[1]:lower()
    if not subCommands[label] then
        print('Unknown subcommand! Use "/bp role help" for help.')
        return
    end

    subCommands[label](source, ExcludeLabel(args))
end

function BondrixPermissions.Commands.RoleAdd(source, args)
    if #args ~= 1 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end

    local name = args[1]:lower()
    if not name:match("^[a-z]+$") then
        print('Role names must consist of latin letters exclusively!')
        return
    end

    BondrixPermissions.Functions.ContainsRole(name, function(response)
        if response then
            print('A role with that name already exists!')
            return
        end
        MySQL.insert('INSERT INTO `roles` (name) VALUES (?)', {
            name
        }, function(response)
            print('Role ' .. name .. ' ' .. 'has been added!')
        end)
    end)
end

function BondrixPermissions.Commands.RoleRemove(source, args)
    if #args ~= 1 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end

    local name = args[1]:lower()

    BondrixPermissions.Functions.ContainsRole(name, function(response)
        if not response then
            print('A role with that name does not exist!')
            return
        end
        
        MySQL.rawExecute('DELETE FROM `roles` WHERE name=?', {
            name
        }, function(response) end)
        MySQL.rawExecute('DELETE FROM `role_permissions` WHERE name=?', {
            name
        }, function(response) end)
        MySQL.rawExecute('DELETE FROM `player_permissions` WHERE permission=?', {
            'role.' .. name
        }, function(response)
            print('Role ' .. name .. ' ' .. 'has been removed!')
        end)

    end)
end

function BondrixPermissions.Commands.RolePermission(source, args)
    if #args < 1 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end
    
    local subCommands = {
        ["allow"] = BondrixPermissions.Commands.RolePermissionAllow,
        ["deny"] = BondrixPermissions.Commands.RolePermissionDeny
    }

    local label = args[1]:lower()
    if not subCommands[label] then
        print('Unknown subcommand! Use "/bp role help" for help.')
        return
    end

    subCommands[label](source, ExcludeLabel(args))
end

function BondrixPermissions.Commands.RolePermissionAllow(source, args)
    if #args ~= 2 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end

    local name = args[1]
    local permission = args[2]

    BondrixPermissions.Functions.ContainsRole(name, function(contains)
        if not contains then
            print('A role with that name does not exist!')
            return
        end
        
        BondrixPermissions.Functions.RoleStrictlyHasPermission(name, permission, function(hasPermission)
            if hasPermission then
                print(name .. ' already has permission: ' .. permission .. '!')
                return
            end

            MySQL.insert('INSERT INTO `role_permissions` (name, permission) VALUES (?, ?)', {
                name, permission
            }, function(response)
                print(permission .. ' added successfully!')
            end)
        end)
    end)
end

function BondrixPermissions.Commands.RolePermissionDeny(source, args)
    if #args ~= 2 then
        print('Invalid syntax! Use "/bp role help" for help.')
        return
    end

    local name = args[1]
    local permission = args[2]

    BondrixPermissions.Functions.ContainsRole(name, function(contains)
        if not contains then
            print('A role with that name does not exist!')
            return
        end
        
        BondrixPermissions.Functions.RoleStrictlyHasPermission(name, permission, function(hasPermission)
            if not hasPermission then
                print(name .. ' already does not has permission: ' .. permission .. '!')
                return
            end

            MySQL.rawExecute('DELETE FROM `role_permissions` WHERE permission=?', {
                permission
            }, function(response)
                print(permission .. ' removed successfully!')
            end)
        end)
    end)
end