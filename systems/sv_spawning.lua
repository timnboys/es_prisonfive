RegisterNetEvent("pf_sv:requestRespawn")

AddEventHandler("pf_sv:spawnPlayer", function(id, coords)
    TriggerClientEvent("pf_cl:spawnPlayer", id, coords.x, coords.y, coords.z)
end)

AddEventHandler("pf_sv:requestRespawn", function()
    local _source = source

    print("Received request to spawn: " .. GetPlayerName(_source))

    TriggerEvent("es:getPlayerFromId", _source, function(user)
        local role = user.getPrisonRole()

        TriggerEvent("pf_sv:spawnPlayer", _source, {
            x = roles[role].spawns[math.random(#roles[role].spawns)][1],
            y = roles[role].spawns[math.random(#roles[role].spawns)][2],
            z = roles[role].spawns[math.random(#roles[role].spawns)][3]
        })
    end)
end)