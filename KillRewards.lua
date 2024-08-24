local zones = {
    redZone1 = { coords = vector3(35.2719, -406.0125, 39.7682), radius = 80.0 },
    redZone2 = { coords = vector3(192.6595, -928.3923, 30.6867), radius = 50.0 }
}

local playerMoneyReward = 100
local maxReward = 10000 

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    if data.killedByPlayer then
        local killerServerId = data.killerServerId
        local killerPed = GetPlayerPed(GetPlayerFromServerId(killerServerId))
        local killerCoords = GetEntityCoords(killerPed)

        local inZone = false
        for _, zone in pairs(zones) do
            if IsPlayerInZone(killerCoords, zone) then
                inZone = true
                break
            end
        end
        exports["KaunasPvP-Direction"]:ExecuteServerEvent("your_custom_event:rewardKiller", killerServerId, inZone)
        --TriggerServerEvent('your_custom_event:rewardKiller', killerServerId, inZone)
    end
end)

RegisterNetEvent('your_custom_event:restoreHealthAndArmor')
AddEventHandler('your_custom_event:restoreHealthAndArmor', function()
    lib.callback('one-codes:levels:AddXP', source, function() end, 10, false, "Del Killo")
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    if health < 200 then
        SetEntityHealth(playerPed, math.min(200, health + 50))
    else
        local armor = GetPedArmour(playerPed)
        SetPedArmour(playerPed, math.min(100, armor + 50))
    end
end)

function IsPlayerInZone(playerCoords, zone)
    local distance = #(playerCoords - zone.coords)
    return distance < zone.radius
end
