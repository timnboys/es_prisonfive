roles = {}
currentWarden = -1

RegisterNetEvent("pf_sv:selectRole")

AddEventHandler("es:playerLoaded", function(source, user)
    user.setGlobal("prisonRole", "menu")
end)

AddEventHandler("es:playerDropped", function(user)
    if(user.getPrisonRole() ~= "menu")then
        roles[user.getPrisonRole()].current = roles[user.getPrisonRole()].current - 1

        -- If resource is restarted and people leave before getting a role it will remove them again making stuff go into minus.
        if(roles[user.getPrisonRole()].current < 0)then
            roles[user.getPrisonRole()].current = 0
        end
    end
end)

AddEventHandler("pf_sv:selectRole", function(role)
    local _source = source

    print("User wants role: " .. role)

    TriggerEvent("es:getPlayerFromId", _source, function(user)
        if(user.getPrisonRole() == role and roles[role].limit > roles[role].current)then
            print("User already has this role. Continueing to spawn...")

            TriggerClientEvent("es:activateMoney", _source, user.getMoney())

            -- Refunding the dollar it costed to select a new role
            user.addMoney(1)

            if(role == "warden")then
                currentWarden = _source
                TriggerClientEvent("pf_cl:setWarden", -1, _source)
            else
                TriggerClientEvent("pf_cl:setWarden", _source, currentWarden)
            end

            TriggerClientEvent("pf_cl:setPlayerRole", _source, role)
            TriggerEvent("pf_sv:spawnPlayer", _source, {
                x = roles[role].spawns[math.random(#roles[role].spawns)][1],
                y = roles[role].spawns[math.random(#roles[role].spawns)][2],
                z = roles[role].spawns[math.random(#roles[role].spawns)][3]
            })
        else
            if(roles[role])then
                if(roles[role].limit > roles[role].current)then

                    roles[role].current = roles[role].current + 1
                    
                    -- Limiting user role joins, so we dont get 100 wardens
                    if(user.getPrisonRole() ~= "menu")then
                        roles[role].current = roles[role].current - 1
                    end

                    user.setPrisonRole(role)
                    print("User added to role. Continueing to spawn...")

                    TriggerClientEvent("es:activateMoney", _source, user.getMoney())

                    if(role == "warden")then
                        currentWarden = _source
                        TriggerClientEvent("pf_cl:setWarden", -1, _source)
                    else
                        TriggerClientEvent("pf_cl:setWarden", _source, currentWarden)
                    end

                    TriggerClientEvent("pf_cl:setPlayerRole", _source, role)
                    TriggerEvent("pf_sv:spawnPlayer", _source, {
                        x = roles[role].spawns[math.random(#roles[role].spawns)][1],
                        y = roles[role].spawns[math.random(#roles[role].spawns)][2],
                        z = roles[role].spawns[math.random(#roles[role].spawns)][3]
                    })
                else
                    print("User selected full role")
                end
            end
        end
    end)
end)