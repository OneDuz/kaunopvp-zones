local redZone = { coords = vector3(35.2719, -406.0125, 39.7682), radius = 80.0 }
local isInZone = false
local redZoneBlip
local renderDistance = 300.0
local selected = false
local wasInZoneOnDeath = false

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

function GetRandomPointInZone(zone, buffer)
    buffer = buffer or 10 
    local maxRadius = zone.radius - buffer

    local angle = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * maxRadius 
    local x = zone.coords.x + radius * math.cos(angle)
    local y = zone.coords.y + radius * math.sin(angle)
    local z = zone.coords.z 
    return vector3(x, y, z)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if wasInZoneOnDeath then
        Wait(1000)
        local safeCoords = GetRandomPointInZone(redZone, 10)
        NetworkResurrectLocalPlayer(safeCoords.x, safeCoords.y, safeCoords.z + 5, 0.0, false, false)
        TriggerEvent('esx_ambulancejob:revive')
        Wait(1000)
    end
end)

local function addFullAttachmentsToGun()
    local playerPed = GetPlayerPed(-1)
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        local weaponHash = GetSelectedPedWeapon(playerPed)
        
        local attachments = {
            'COMPONENT_AT_AR_FLSH', 
            'COMPONENT_AT_AR_SUPP', 
            'COMPONENT_AT_PI_FLSH', 
            'COMPONENT_AT_SCOPE_MACRO', 
            'COMPONENT_AT_SCOPE_MACRO_02', 
            'COMPONENT_AT_SCOPE_SMALL', 
            'COMPONENT_AT_SCOPE_MEDIUM', 
            'COMPONENT_AT_SCOPE_LARGE', 
            'COMPONENT_AT_SCOPE_MAX',
            'COMPONENT_AT_AR_SUPP_02', 
            'COMPONENT_AT_PI_SUPP', 
            'COMPONENT_AT_CR_BARREL_01', 
            'COMPONENT_AT_CR_BARREL_02', 
            'COMPONENT_SMG_CLIP_03',
            'COMPONENT_ASSAULTRIFLE_CLIP_03',
            'COMPONENT_CARBINERIFLE_CLIP_03',
            'COMPONENT_SPECIALCARBINE_CLIP_03',
            'COMPONENT_BULLPUPRIFLE_CLIP_02',
            'COMPONENT_COMBATMG_CLIP_02',
        }

        for _, attachment in ipairs(attachments) do
            if HasPedGotWeaponComponent(playerPed, weaponHash, GetHashKey(attachment)) == false then
                GiveWeaponComponentToPed(playerPed, weaponHash, GetHashKey(attachment))
            end
        end
    end
end

Citizen.CreateThread(function()
    --redZoneBlip = CreateRedZoneBlip(redZone)

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local inZone = IsPlayerInZone(playerCoords, redZone)
        local nearZone = IsPlayerNearZone(playerCoords, redZone, renderDistance)
        local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
        if nearZone then
            Citizen.Wait(0)
            DrawMarker(28, redZone.coords.x, redZone.coords.y, redZone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, redZone.radius, redZone.radius, redZone.radius, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        else
            Citizen.Wait(1000)
        end

        if inZone and not isInZone and not inVehicle then
            isInZone = true
            wasInZoneOnDeath = true
            lib.registerContext({
                id = 'changestambiugun',
                title = 'Pasirink ginkla',
                canClose = false,
                onExit = function ()
                    if not selected then
                        lib.showContext('changestambiugun')
                    end
                end,
                options = {
                  {
                    title = 'Pump Shotgun',
                    image = 'https://i.postimg.cc/PryNhQ8S/WEAPON-PUMPSHOTGUN.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_pumpshotgun')
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
                    title = 'Compact Rifle',
                    image = 'https://i.postimg.cc/mDB0bC9S/WEAPON-COMPACTRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_compactrifle')
                        end
                    end,
                  },
                  {
                    title = 'Precision Rifle',
                    image = 'https://i.postimg.cc/sXC35MhB/WEAPON-PRECISIONRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_precisionrifle')
                        end
                    end,
                  },
                  {
                    title = 'Machine Pistol',
                    image = 'https://i.postimg.cc/xdz0kvcD/WEAPON-MACHINEPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_machinepistol')
                        end
                    end,
                  },
                  {
                    title = 'SMG',
                    image = 'https://i.postimg.cc/g20j0LVm/WEAPON-SMG.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_smg')
                        end
                    end,
                  },
                  {
                    title = 'AR15',
                    image = 'https://i.postimg.cc/Xq8NjnXr/WEAPON-AR15.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_ar15')
                        end
                    end,
                  },
                  {
                    title = 'AK47',
                    image = 'https://i.postimg.cc/4dpN06gb/weapon-AK47.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_ak47')
                        end
                    end,
                  },
                  {
                    title = 'M4',
                    image = 'https://i.postimg.cc/yNdLnj0t/weapon-M4.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_m4')
                        end
                    end,
                  },
                  {
                    title = 'M70',
                    image = 'https://i.postimg.cc/rwzyTXTp/weapon-m70.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_m70')
                        end
                    end,
                  },
                  {
                    title = 'Heavy Rifle',
                    image = 'https://i.postimg.cc/15vRbRLT/WEAPON-HEAVYRIFLE.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_heavyrifle')
                        end
                    end,
                  },
                  {
                    title = 'Carbine Rifle',
                    image = 'https://i.postimg.cc/GmS2T3KY/weapon-carbinerifle.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver3', source, function(data)
                                selected = data
                            end, 'weapon_carbinerifle')
                        end
                    end,
                  },
                }
              })
              lib.showContext('changestambiugun')
            elseif (not inZone or inVehicle) and isInZone then

            isInZone = false
            -- print("Exited zone")
            selected = false
            wasInZoneOnDeath = false
            lib.callback('redzone:sentserver2', source, function(data)
                -- print(data)
            end)
        end

        
        if isInZone and IsPedArmed(PlayerPedId(), 4) then
            addFullAttachmentsToGun(source)
        end

        if not selected and isInZone then
            --lib.hideContext('some_menu')
        end

        if isInZone and not inVehicle then
            exports.ox_inventory:closeInventory()
        end
    end
end)

-- lib.callback.register('redzone:isPlayerInRedzoneStambiu', function()
--     return isInZone
-- end)


RegisterCommand("pakeistigun", function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local zone1 = { coords = vector3(192.6595, -928.3923, 30.6867), radius = 50.0 }
    local zone2 = { coords = vector3(35.2719, -406.0125, 39.7682), radius = 80.0 }
    if IsPlayerInZone(playerCoords, zone1) then
        lib.showContext('changepistolgun')
    elseif IsPlayerInZone(playerCoords, zone2) then
        lib.showContext('changestambiugun')
    end
end)