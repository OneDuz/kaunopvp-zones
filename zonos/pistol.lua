local redZone = { coords = vector3(8.9480, -1736.0505, 29.5599), radius = 50.0 }
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
                    title = 'SNS Pistol MK2',
                    image = 'https://i.postimg.cc/8P7rnDM4/WEAPON-SNSPISTOL-MK2.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_snspistol_mk2')
                        end
                    end,
                  },
                  {
                    title = 'Heavy Pistol',
                    image = 'https://i.postimg.cc/G234P1bk/WEAPON-HEAVYPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_heavypistol')
                        end
                    end,
                  },
                  {
                    title = 'Vintage Pistol',
                    image = 'https://i.postimg.cc/VL20xTF8/WEAPON-VINTAGEPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_vintagepistol')
                        end
                    end,
                  },
                  {
                    title = 'Ceramic Pistol',
                    image = 'https://i.postimg.cc/YCgLM3Xm/WEAPON-CERAMICPISTOL.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_ceramicpistol')
                        end
                    end,
                  },
                  {
                    title = 'WM 29 Pistol',
                    image = 'https://i.postimg.cc/90Mq2HSW/WEAPON-PISTOLXM3.png',
                    onSelect = function()
                        if isInZone then
                            lib.callback('redzone:sentserver1', source, function(data)
                                selected = data
                            end, 'weapon_pistolxm3')
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
            elseif (not inZone or inVehicle) and isInZone then
            isInZone = false
            selected = false
            wasInZoneOnDeath = false
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

        if isInZone and not inVehicle then
            exports.ox_inventory:closeInventory()
        end
    end
end)


-- lib.callback.register('redzone:isPlayerInRedzonePistol', function()
--     return isInZone
-- end)