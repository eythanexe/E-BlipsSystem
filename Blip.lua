local ESX = nil
local activeBlips = {}
local playerJob = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
    
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end
    
    playerJob = ESX.GetPlayerData().job.name
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    
    if playerJob then
        for _, blipData in ipairs(Config.Blips) do
            if isJobAllowed(playerJob, blipData.jobs) then
                local blip = createBlip(blipData)
                table.insert(activeBlips, blip)
            end
        end
    end
    
    while true do
        Citizen.Wait(1000)
        
        if playerJob then
            for _, blipData in ipairs(Config.Blips) do
                if isJobAllowed(playerJob, blipData.jobs) then
                    if not isBlipActive(blipData) then
                        local blip = createBlip(blipData)
                        table.insert(activeBlips, blip)
                    end
                else
                    removeBlip(blipData)
                end
            end
        end
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    playerJob = job.name
    
    for _, blip in ipairs(activeBlips) do
        RemoveBlip(blip)
    end
    activeBlips = {}
    
    for _, blipData in ipairs(Config.Blips) do
        if isJobAllowed(playerJob, blipData.jobs) then
            local blip = createBlip(blipData)
            table.insert(activeBlips, blip)
        end
    end
end)

function createBlip(blipData)
    local blip = AddBlipForCoord(blipData.BlipCoords.x, blipData.BlipCoords.y, blipData.BlipCoords.z)
    SetBlipSprite(blip, blipData.BlipID)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, blipData.BlipColor)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, blipData.BlipScale)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.BlipName)
    EndTextCommandSetBlipName(blip)
    
    return blip
end

function isJobAllowed(playerJob, allowedJobs)
    if not allowedJobs or #allowedJobs == 0 then return true end
    for _, job in ipairs(allowedJobs) do
        if playerJob == job then
            return true
        end
    end
    return false
end

function removeBlip(blipData)
    for i, blip in ipairs(activeBlips) do
        if GetBlipCoords(blip) == blipData.BlipCoords then
            RemoveBlip(blip)
            table.remove(activeBlips, i)
            break
        end
    end
end

function isBlipActive(blipData)
    for _, blip in ipairs(activeBlips) do
        if GetBlipCoords(blip) == blipData.BlipCoords then
            return true
        end
    end
    return false
end