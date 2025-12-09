function IsResourceLoaded(resource)
    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local currentResource = GetResourceByFindIndex(i)
        if currentResource == resource then
            return true
        end
    end
    return false
end

local function addDeferral(err)
    err = err:gsub("%^%d", "")

    AddEventHandler('playerConnecting', function(_, _, deferrals)
        deferrals.defer()
        deferrals.done(err)
    end)
end

local function spamError(err)
    CreateThread(function()
        while true do
            Wait(5000)
            CreateThread(function()
                error(err, 0)
            end)
        end
    end)

    addDeferral(err)
    error(err, 0)
end

local resourceToCheck = "ox_lib"

if IsResourceLoaded(resourceToCheck) then
    loaded = true
else
    loaded = nil
end

if not loaded then
    return spamError('drp_bandebuy requires the '..resourceToCheck..' resource.')
end

if not loaded then return end

local isWeaponPedSpawned = false

peds = {}
objects = {}

ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    ESX.PlayerData = ESX.GetPlayerData()

    Citizen.Wait(5000) -- Det skal være der ellers kan JS drille

    
    SendNUIMessage({
        init = true,
        NameResource = {GetCurrentResourceName(), GetCurrentServerEndpoint()},
    })

    SetupMissionNPC()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

SetupMissionNPC = function()
    ESX.TriggerServerCallback("drp_illegaljobs:GetWeaponNPC", function(location)
        if location then
            local coords = vector3(location.x, location.y, location.z - 1.0)

            RequestModel(`s_m_y_blackops_02`)
            while not HasModelLoaded(`s_m_y_blackops_02`) do
                Wait(5)
            end

            local ped = CreatePed(4, `s_m_y_blackops_02`, coords, location.w, false, true)
            SetEntityHeading(ped, heading)
            SetEntityAsMissionEntity(ped, true, true)
            SetPedHearingRange(ped, 0.0)
            SetPedSeeingRange(ped, 0.0)
            SetPedAlertness(ped, 0.0)
            SetPedFleeAttributes(ped, 0, 0)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCombatAttributes(ped, 46, true)
            SetPedFleeAttributes(ped, 0, 0)
            TriggerEvent('blockdrugs', ped)
            
            SetModelAsNoLongerNeeded(hash)
        
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)

            exports.ox_target:addBoxZone({
                coords = vector3(location.x, location.y, location.z + 0.2),
                size = vec3(0.8, 0.8, 4),
                rotation = location.w,
                options = {
                    {
                        name = 'weaponNPC',
                        icon = "fas fa-shopping-cart",
                        label = "Våben Shop",
                        distance = 1.5,
                        canInteract = function()
                            return not hasTask and HasValidGangJob() and not GlobalState.isInWeaponMenu
                        end,
                        onSelect = function(data)
                            OpenWeaponShop(data.entity)
                        end
                    },
                }
            })

            table.insert(peds, ped)
        end
    end)

    collectgarbage()
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false)
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        for i = 1, #peds, 1 do
            if DoesEntityExist(peds[i]) then
                DeletePed(peds[i])
            end
        end

        for i = 1, #objects, 1 do
            if DoesEntityExist(objects[i]) then
                DeleteEntity(objects[i])
            end
        end

        DoScreenFadeIn(100)
        Citizen.Wait(100)

        CleanScenario()
	end
end)

RegisterCommand(Config.Command, function()
    ESX.TriggerServerCallback('jf_bandebuycmd:checkAdmin', function(isAdmin)
        if isAdmin then
            openBandeMenu()
        end
    end)
end)

function openBandeMenu()
    ESX.TriggerServerCallback('jf_bandebuycmd:getGangs', function(gangs)
        local GangOptions = {}

        GangOptions[#GangOptions + 1] = {
            title = 'Tilføj Bande',
            icon = 'fa-solid fa-plus',
            description = 'Tryk for at tilføje en bande til Våben Systemet',
            onSelect = function()
                local input = lib.inputDialog('Tilføj Bande til Våben Systemet', {'Banden Database Navn'})
                if not input then return end

                TriggerServerEvent("jf_bandebuycmd:bandeaddgang", input[1])
            end,
        }

        for _, gang in ipairs(gangs) do
            GangOptions[#GangOptions + 1] = {
                title = gang.gang,
                icon = 'fa-solid fa-users',
                description = 'Level: ' .. gang.lvl .. ' | Reputation: ' .. gang.repitation,
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Bekræft Sletning',
                        content = 'Er du sikker på, at du vil slette ' .. gang.gang .. '?',
                        centered = true,
                        cancel = true,
                        labels = {
                            cancel = 'Annuller',
                            confirm = 'Slet',
                        }
                    })
                
                    if alert == 'confirm' then
                        TriggerServerEvent('jf_bandebuycmd:banderemovegang', gang.gang)
                    end
                end,
            }
        end

        lib.registerContext({
            id = 'bande_gang_menu',
            title = 'Bande System',
            options = GangOptions,
        })

        lib.showContext('bande_gang_menu')
    end)
end
