

local redZone = { coords = vector3(189.4077, -935.5965, 30.6867), radius = 50.0 }
local isInZone = false
local redZoneBlip
local renderDistance = 300.0
local selected = false

function IsPlayerInZone(playerCoords, zone)
    local distance = #(playerCoords - zone.coords)
    return distance < zone.radius
end

function IsPlayerNearZone(playerCoords, zone, distanceThreshold)
    local distance = #(playerCoords - zone.coords)
    return distance < distanceThreshold
end

function CreateRedZoneBlip(zone)
    local blip = AddBlipForRadius(zone.coords, zone.radius)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 80)
    return blip
end

function GetSafeRespawnCoords(zone, buffer)
    buffer = buffer or 10 
    local maxRadius = zone.radius - buffer

    local safeCoords = GetRandomPointInZone(zone, buffer)
    local attempts = 0
    while not IsPointInsideZone(safeCoords, zone) do
        safeCoords = GetRandomPointInZone(zone, buffer)
        attempts = attempts + 1
        if attempts > 10 then
            return zone.coords
        end
    end

    return safeCoords
end

function IsPointInsideZone(point, zone)
    local distance = #(point - zone.coords)
    return distance < zone.radius
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if isInZone then
        Wait(1000)
        local safeCoords = GetRandomPointInZone(redZone, 10)
        NetworkResurrectLocalPlayer(safeCoords.x, safeCoords.y, safeCoords.z + 5, 0.0, false, false)
        TriggerEvent('esx_ambulancejob:revive')
        Wait(1000)
    end
end)


Citizen.CreateThread(function()
    --redZoneBlip = CreateRedZoneBlip(redZone)

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local inZone = IsPlayerInZone(playerCoords, redZone)
        local nearZone = IsPlayerNearZone(playerCoords, redZone, renderDistance)

        if nearZone then
            Citizen.Wait(0)
            DrawMarker(28, redZone.coords.x, redZone.coords.y, redZone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, redZone.radius, redZone.radius, redZone.radius, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        else
            Citizen.Wait(1000)
        end
        if inZone and not isInZone then
            isInZone = true
            lib.registerContext({
                id = 'changepistolgun',
                title = 'Pasirink ginkla',
                canClose = false,
                onExit = function ()
                    if not selected then
                        lib.showContext('changepistolgun')
                    end
                end,
                options = {
                  {
                    title = 'Pistol',
                    image = 'https://i.postimg.cc/hv6hqzTr/WEAPON-PISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_pistol')
                        end
                    end,
                  },
                  {
                    title = 'Pistol MK2',
                    image = 'https://i.postimg.cc/VNWSbNPf/WEAPON-PISTOL-MK2.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_pistol_mk2')
                        end
                    end,
                  },
                  {
                    title = 'Combat Pistol',
                    image = 'https://i.postimg.cc/25Db6ZJ9/WEAPON-COMBATPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_combatpistol')
                        end
                    end,
                  },
                  {
                    title = 'Pistol50/Deagle',
                    image = 'https://i.postimg.cc/C1vzm6K9/WEAPON-PISTOL50.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_pistol50')
                        end
                    end,
                  },
                  {
                    title = 'SNS Pistol',
                    image = 'https://i.postimg.cc/C5QnL6Tb/WEAPON-SNSPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_snspistol')
                        end
                    end,
                  },
                  {
                    title = 'Bullpup Rifle',
                    image = 'https://i.postimg.cc/BQSQhPwH/WEAPON-BULLPUPRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_bullpuprifle')
                        end
                    end,
                  },
                  {
                    title = 'Assault Rifle',
                    image = 'https://i.postimg.cc/y6X8Xyn7/weapon-assaultrifle.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_assaultrifle')
                        end
                    end,
                  },
                  {
                    title = 'Tactical Rifle',
                    image = 'https://i.postimg.cc/43736C20/WEAPON-TACTICALRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_tacticalrifle')
                        end
                    end,
                  },
                  {
                    title = 'Military Rifle',
                    image = 'https://i.postimg.cc/Mp46KPZm/WEAPON-MILITARYRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_militaryrifle')
                        end
                    end,
                  },
                  {
                    title = 'Special Carbine Rifle',
                    image = 'https://i.postimg.cc/tgK4DrL4/WEAPON-SPECIALCARBINE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_specialcarbine')
                        end
                    end,
                  },
                  {
                    title = 'Glock 22 Pistol',
                    image = 'https://i.postimg.cc/NF5LV79F/weapon-glock22.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_glock22')
                        end
                    end,
                  },
                  {
                    title = 'M9 Pistol',
                    image = 'https://i.postimg.cc/9X87pzRz/weapon-m9.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_m9')
                        end
                    end,
                  }
                }
              })
              lib.showContext('changepistolgun')
        elseif not inZone and isInZone then
            isInZone = false
            selected = false
            -- print("Exited zone")
            lib.callback('redzone:sentserver2', source, function(data)
                -- print(data)
            end)
        end

        -- if lib.getOpenContextMenu() == nil and not selected and isInZone then
        --     Wait(250)
        --     if not selected then
        --         lib.showContext('some_menu')
        --     end
        -- end

        if isInZone then
            exports.ox_inventory:closeInventory()
        end
    end
end)

-- shit optimization legit 0 optimized

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not cache.weapon then
           -- print("1")
            DisableControlAction(1, 24, true)
            DisableControlAction(1, 25, true)
        else
           -- print("2")
            Citizen.Wait(1000)
        end
    end
end)

AddEventHandler('gameEventTriggered', function(eventName, eventData)
    print("0")
    if eventName == 'CEventNetworkEntityDamage' and isInZone then
        print("1")
        local victim = eventData[1]
        local attacker = eventData[2]
        local weaponHash = eventData[3]
        local isMeleeDamage = eventData[4]
        local boneIndex = eventData[5]
        local isFatalDamage = eventData[6]

        if DoesEntityExist(victim) and IsEntityAPed(victim) and IsPedAPlayer(victim) then
            print("2")
            if boneIndex ~= 31086 then 
                print("3")
                SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
                CancelEvent()
            end
        end
    end
end)

-- lib.callback.register('redzone:isPlayerInRedzonePistol', function()
--     return isInZone
-- end)


