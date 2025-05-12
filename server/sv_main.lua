local function LoadPlayerAnimations(source)
    local playerId = GetPlayerIdentifier(source, 0)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ton_player_shortcuts WHERE identifier = @identifier", {
        ['@identifier'] = playerId
    })
    return result
end

local function reloadShorcut(source)
    local animations = LoadPlayerAnimations(source)
    TriggerClientEvent("ton_radial:reloadShorcut", source, animations)
end

RegisterNetEvent("ton_radial:saveAnimation")
AddEventHandler("ton_radial:saveAnimation", function(animation)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    MySQL.query("INSERT INTO ton_player_shortcuts (identifier, label, anim) VALUES (@identifier, @label, @anim)", {
        ['@identifier'] = playerId,
        ['@label'] = animation.label,
        ['@anim'] = animation.anim
    }, function(result)
        reloadShorcut(source)
    end)
end)

RegisterNetEvent("ton_radial:removeAnimations")
AddEventHandler("ton_radial:removeAnimations", function(id)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    MySQL.query("DELETE FROM ton_player_shortcuts WHERE  `id`=@id;", {
        ['@id'] = id
    }, function(result)
        reloadShorcut(source)
    end)
end)

RegisterNetEvent("ton_radial:getAnimations")
AddEventHandler("ton_radial:getAnimations", function()
    local source = source
    reloadShorcut(source)
end)
