ESX = exports["es_extended"]:getSharedObject()

local allowedGuns = {
    pistolzone = {
        ["weapon_pistol"] = true,
        ["weapon_pistol_mk2"] = true,
        ["weapon_combatpistol"] = true,
        ["weapon_pistol50"] = true,
        ["weapon_snspistol"] = true,
        ["weapon_snspistol_mk2"] = true,
        ["weapon_heavypistol"] = true,
        ["weapon_vintagepistol"] = true,
        ["weapon_ceramicpistol"] = true,
        ["weapon_pistolxm3"] = true,
        ["weapon_glock22"] = true,
        ["weapon_m9"] = true,
    },
    riflezone = {
        ["weapon_pumpshotgun"] = true,
        ["weapon_bullpuprifle"] = true,
        ["weapon_assaultrifle"] = true,
        ["weapon_tacticalrifle"] = true,
        ["weapon_militaryrifle"] = true,
        ["weapon_specialcarbine"] = true,
        ["weapon_carbinerifle"] = true,
        ["weapon_compactrifle"] = true,
        ["weapon_precisionrifle"] = true,
        ["weapon_heavyrifle"] = true,
        ["weapon_machinepistol"] = true,
        ["weapon_smg"] = true,
        ["weapon_ar15"] = true,
        ["weapon_ak47"] = true,
        ["weapon_m4"] = true,
        ["weapon_m70"] = true,
    },
}

lib.callback.register('redzone:sentserver1', function(src, weaponName)
    if allowedGuns.pistolzone[weaponName] then
        local inventory = exports.ox_inventory:ConfiscateInventory(src)
        if not inventory then
            exports.ox_inventory:AddItem(src, weaponName, 1)
            exports.ox_inventory:AddItem(src, "ammo-9", 900)
            return true 
        end
    elseif not allowedGuns.pistolzone[weaponName] then
        print("[BANNED] Tried spawning gun via lib.callback('redzone:sentserver1', "..src..", "..weaponName..") or something")
        exports["KaunasPvP-Direction"]:fg_BanPlayer(src, "Tried spawning gun via lib.callback('redzone:sentserver1', "..src..", "..weaponName..") or something", true)
    end
    return false
end)

lib.callback.register('redzone:sentserver3', function(src, weaponName)
    if allowedGuns.riflezone[weaponName] then
        local inventory = exports.ox_inventory:ConfiscateInventory(src)
        if not inventory then
            exports.ox_inventory:AddItem(src, weaponName, 1)
            exports.ox_inventory:AddItem(src, "ammo-9", 900)
            return true 
        end
    elseif not allowedGuns.riflezone[weaponName] then
        print("[BANNED] Tried spawning gun via lib.callback('redzone:sentserver1', "..src..", "..weaponName..") or something")
        exports["KaunasPvP-Direction"]:fg_BanPlayer(src, "Tried spawning gun via lib.callback('redzone:sentserver1', "..src..", "..weaponName..") or something", true)
    end
    return false
end)

lib.callback.register('redzone:sentserver2', function()
    local inventory = exports.ox_inventory:ReturnInventory(source)
    if inventory then
        return false
    else
        return true
    end
end)


local allEvents = {
    ["your_custom_event:rewardKiller"] = true
}
local fiveguard_resource = ""
AddEventHandler("fg:ExportsLoaded", function(fiveguard_res, res)
    if res == "*" or res == GetCurrentResourceName() then
        fiveguard_resource = fiveguard_res
        for event,cross_scripts in pairs(allEvents) do
            local retval, errorText = exports[fiveguard_res]:RegisterSafeEvent(event, {
                ban = true,
                log = true
            }, cross_scripts)
            if not retval then
                print("[fiveguard safe-events] "..errorText)
            end
        end
    end
end)



local playerRewards = {}
local INITIAL_REWARD = 100
local NORMAL_REWARD = 100
local BONUS_REWARD = 200
local MAX_REWARD = 10000

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local deceasedServerId = source
    if playerRewards[deceasedServerId] then
        playerRewards[deceasedServerId].kills = 0
        playerRewards[deceasedServerId].reward = INITIAL_REWARD
    end
end)

RegisterNetEvent('your_custom_event:rewardKiller')
AddEventHandler('your_custom_event:rewardKiller', function(killerServerId, isKillInZone)
    local source = source
    if not exports[fiveguard_resource]:VerifyToken(source) then return end
    if not playerRewards[killerServerId] then
        playerRewards[killerServerId] = {
            reward = INITIAL_REWARD,
            kills = 0
        }
    end

    playerRewards[killerServerId].kills = playerRewards[killerServerId].kills + 1
    local killReward = INITIAL_REWARD

    if isKillInZone then
        killReward = math.min(MAX_REWARD, playerRewards[killerServerId].reward + BONUS_REWARD)
    else
        killReward = math.min(MAX_REWARD, playerRewards[killerServerId].reward + NORMAL_REWARD)
    end

    playerRewards[killerServerId].reward = killReward

    local xPlayer = ESX.GetPlayerFromId(killerServerId)
    if xPlayer then
        xPlayer.addAccountMoney('bank', killReward)
        TriggerClientEvent('esx:showNotification', killerServerId, 'Jūs gavote €' .. killReward .. ' į banko sąskaita už nužudymą zonoje.')
        TriggerClientEvent('your_custom_event:restoreHealthAndArmor', killerServerId)
    else
        print("Failed to find player with server ID: " .. tostring(killerServerId))
    end
end)
