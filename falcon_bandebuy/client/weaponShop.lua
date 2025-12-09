if not loaded then return end

local isInWeaponMenu = false
local hasWeaponDelivery = false
local weaponDeliveryLocation = nil
local weaponDeliveryVehicle = nil
local weaponDeliveryBlip = nil

OpenWeaponShop = function(entity)
    isInWeaponMenu = true

    PlayPedAmbientSpeechWithVoiceNative(entity, "SHOP_GREET", "s_m_m_ammucountry_white_mini_01", "SPEECH_PARAMS_FORCE", 1)
    TriggerServerEvent("drp_illegaljobs:OpenWeaponShop")
end

RegisterNetEvent('drp_illegaljobs:RefreshWeaponUI')
AddEventHandler('drp_illegaljobs:RefreshWeaponUI', function(forceOpen, guns, gang, next, orders, missions)
    if not isInWeaponMenu and not forceOpen then
        return
    end

    if forceOpen then
        isInWeaponMenu = true
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        openWeapon = isInWeaponMenu,
        setGunCategories = guns ~= nil,
        gunCategories = guns,
        setReputation = gang ~= nil,
        reputation = gang,
        setNextReputation = next ~= nil,
        nextReputation = next,
        setOrderedItems = orders ~= nil,
        orderedItems = orders,
        setReputationMissions = missions ~= nil,
        reputationMissions = missions,
        setDeficitMulitplier = true,
        deficitMulitplier = GlobalState.deficitMulitplier,
        setMinimumDelivery = true,
        minimumDelivery = GlobalState.minimumDelivery,
    })
end)

RegisterNUICallback('levelup', function(data, cb)
    TriggerServerEvent("drp_illegaljobs:UpgradeWeaponShop")

    cb('ok')
end)

RegisterNUICallback('refresh', function(data, cb)
    TriggerServerEvent("drp_illegaljobs:RefreshWeaponMissions")

    cb('ok')
end)

RegisterNUICallback('deliver', function(data, cb)
    AddToWeaponMission(tonumber(data.index) + 1)

    cb('ok')
end)

RegisterNUICallback('complete', function(data, cb)
    TriggerServerEvent("drp_illegaljobs:CompleteMissionItem", tonumber(data.index) + 1)

    cb('ok')
end)

RegisterNUICallback('addWeaponToCart', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('removeWeaponFromCart', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('buyweapons', function(data, cb)
    local weaponData = {}
    weaponData["items"] = data.weaponCart
    weaponData["isDelivered"] = data.weaponDelivered
    weaponData["totalMinutes"] = data.weapontotalMinutes

    TriggerServerEvent("drp_illegaljobs:BuyCart", weaponData)

    cb('ok')
end)

RegisterNUICallback('cancelorder', function(data, cb)
    TriggerServerEvent("drp_illegaljobs:CancelOrder", tonumber(data.index) + 1)

    cb('ok')
end)

RegisterNUICallback('collectorder', function(data, cb)
    if not hasWeaponDelivery then
        TriggerServerEvent("drp_illegaljobs:CollectOrder", tonumber(data.index) + 1)
    else
        lib.notify({
            title = 'Levering',
            description = 'Du kan ikke have flere i gang på samme tid!',
            type = 'error'
        })
    end

    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    if isInWeaponMenu then
        TriggerServerEvent("drp_illegaljobs:CloseWeaponShop")
    end

    isInWeaponMenu = false

    cb('ok')
end)

AddToWeaponMission = function(index)
    local Options = {}
    local PlayerData = ESX.GetPlayerData()

    if Config.UseOX == true then
        local inventoryElements = {}
        for k, v in pairs(PlayerData.inventory) do
            if v.count > 0 then
                table.insert(Options, {
                    title = v.label,
                    description = 'Antal ' .. v.count .. 'x',
                    onSelect = function ()
                        local input = lib.inputDialog('Aflever ' .. v.label, {
                            { type = 'number', label = 'Antal', min = 1, max = v.count },
                        })
                        if input then
                            TriggerServerEvent("drp_illegaljobs:DeliverMissionItems", index, v.name, input[1])
                        end
                    end
                })
            end
        end

        lib.registerContext({
            id = 'WeaponMissions',
            title = 'Mission Inventar',
            options = Options,
        })

        lib.showContext('WeaponMissions')

    else
        local elements = {}
        
        for k, v in pairs(PlayerData.inventory) do
            if v.count > 0 then
                table.insert(elements, {
                    label = v.label .. ' x' .. v.count,
                    value = v.name,
                })
            end
        end
        
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'trunk_inventory', {
                title = 'Mission Inventar',
                align = 'left',
                elements = elements,
            },
            function(data, menu)
                local selectedItem = data.current.value
                
                local function OpenItemDialog(label, name)
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'put_item_count', {
                            title = 'Aflever ' .. label,
                        },
                        function(data2, menu2)
                            local quantity = tonumber(data2.value)
                            if quantity then
                                TriggerServerEvent("drp_illegaljobs:DeliverMissionItems", index, name, quantity)
                                menu2.close()
                                menu.close()
                            else
                                ESX.ShowNotification('Invalid quantity.')
                            end
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )
                end
                
                local selectedItemData = nil
                for k, v in pairs(PlayerData.inventory) do
                    if v.name == selectedItem then
                        selectedItemData = v
                        break
                    end
                end

                if selectedItemData then
                    OpenItemDialog(selectedItemData.label, selectedItemData.name)
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
end

RegisterNetEvent('drp_illegaljobs:StartWeaponDelivery')
AddEventHandler('drp_illegaljobs:StartWeaponDelivery', function(location, deliverySize)
    weaponDeliveryLocation = location

    local vehicleLocation = vector3(weaponDeliveryLocation.x, weaponDeliveryLocation.y, weaponDeliveryLocation.z)
    CreateBlipRoute(vehicleLocation, 'Find køretøjet', function(blip)
        weaponDeliveryBlip = blip

        if deliverySize < 30 then
            weaponDeliveryVehicle = "burrito"
        end

        if deliverySize >= 30 and deliverySize <= 80 then
            weaponDeliveryVehicle = "mule2"
        end

        if deliverySize > 80 then
            weaponDeliveryVehicle = "pounder"
        end

        StartWeaponDelivery()
    end)
end)

StartWeaponDelivery = function()
    Citizen.CreateThread(function()
        hasWeaponDelivery = true

        while hasWeaponDelivery do
            Citizen.Wait(1000)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            local vehicleLocation = vector3(weaponDeliveryLocation.x, weaponDeliveryLocation.y, weaponDeliveryLocation.z)
            local distance = #(playerCoords - vehicleLocation)

            if not DoesBlipExist(weaponDeliveryBlip) and hasWeaponDelivery then

                lib.notify({
                    title = 'Levering',
                    description = 'Forbindelse til kørtøjet, er genoprettet',
                    type = 'info'
                })

                CreateBlipRoute(vehicleLocation, 'Find køretøjet', function(blip)
                    weaponDeliveryBlip = blip
                end)
            end

            if distance <= Config.CarSpawnDistance then
                hasWeaponDelivery = false

                SpawnVehicle(weaponDeliveryVehicle, vehicleLocation, weaponDeliveryLocation.w, function(vehicle)

                    local truckPlate = 'GAMB'..math.random(1111,9999)

                    SetVehicleNumberPlateText(vehicle, truckPlate)
                    SetVehicleMaxMods(vehicle)
                    Entity(vehicle).state.fuel = 100

                    TriggerServerEvent('drp_illegaljobs:addTrunkitem', GetVehicleClass(vehicle), truckPlate)

                    if DoesBlipExist(weaponDeliveryBlip) then
                        RemoveBlip(weaponDeliveryBlip)
                    end
                end)
            end
        end
    end)
end