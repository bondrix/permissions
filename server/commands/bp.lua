BondrixPermissions.Commands = {}

function ExcludeLabel(args)
    local excludedArgs = {}
    for i = 2, #args do
        table.insert(excludedArgs, args[i])
    end

    return excludedArgs
end

RegisterCommand("bp", function(source, args)
    print(source)
    if #args < 1 then
        print('Invalid syntax! Use "/bp help" for help.')
        return
    end

    local subCommands = {
        ["help"] = BondrixPermissions.Commands.Help,
        ["role"] = BondrixPermissions.Commands.Role,
        ["player"] = BondrixPermissions.Commands.Player
    }

    local label = args[1]:lower()
    if not subCommands[label] then
        print('Unknown subcommand! Use "/bp help" for help.')
        return
    end

    subCommands[label](source, ExcludeLabel(args))
end, false)