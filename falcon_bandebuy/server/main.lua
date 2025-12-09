ESX = exports["es_extended"]:getSharedObject()

GlobalState.deficitMulitplier = 7
GlobalState.minimumDelivery = 60
GlobalState.isInWeaponMenu = false

local randomIndex = math.random(#Config.NPCSpawns)
local loc = Config.NPCSpawns[randomIndex]

ESX.RegisterServerCallback('drp_illegaljobs:GetWeaponNPC', function(src, cb)
    cb(loc)
end)

deliveryJobs = {}

RegisterNetEvent('drp_illegaljobs:OpenWeaponShop')
AddEventHandler('drp_illegaljobs:OpenWeaponShop', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerJob = xPlayer.job.name

    local CurrentTime = os.time()

    MySQL.Async.fetchAll('SELECT * FROM bandelevel WHERE gang = @gang', {
        ['@gang'] = playerJob
    }, function(result)
        if result and #result > 0 then
            local ganglvl = result[1].lvl
            local rep = result[1].repitation

            local unlockedWeapons = {}
            local reputation = {}
            local nextreputation = {}

            for _, category in ipairs(Config.gunCategories) do
                local categoryWeapons = {}
                for _, weapon in ipairs(category.weapons) do
                    local weaponData = Config.reputationRequirements[weapon.name]
                    if weaponData and ganglvl >= weaponData.levelNeeded then
                        weapon.isUnlocked = 1
                        local playerLevel = "level_" .. ganglvl
                        if weaponData.levelUnlocks[playerLevel] then
                            weapon.maxAmount = weaponData.levelUnlocks[playerLevel]
                        end
                    else
                        weapon.isUnlocked = 0
                    end

                    table.insert(categoryWeapons, weapon)
                end

                table.insert(unlockedWeapons, { name = category.name, label = category.label, weapons = categoryWeapons })
            end

            for _, levelSetup in ipairs(Config.levelsSetup) do
                if ganglvl == levelSetup.number then
                    reputation.level = levelSetup.number
                    reputation.value = rep
                    reputation.needed = levelSetup.max
                    nextreputation.level = reputation.level + 1
                    nextreputation.unlocks = {}
  
                    for weaponName, weaponData in pairs(Config.reputationRequirements) do
                        if weaponData.levelNeeded == nextreputation.level then
                            for _, category in ipairs(Config.gunCategories) do
                                for _, weapon in ipairs(category.weapons) do
                                    if weapon.name == weaponName then
                                        table.insert(nextreputation.unlocks, weapon.label)
                                    end
                                end
                            end
                        end
                    end
                end
            end
  
            if not deliveryJobs[playerJob] then
                deliveryJobs[playerJob] = {}
  
                local missionsToAdd = {}
  
                while #missionsToAdd < Config.MissionCount and #missionsToAdd < #Config.MissionsPools do
                    local randomIndex = math.random(1, #Config.MissionsPools)
                    local missionData = Config.MissionsPools[randomIndex]
  

                    local isDuplicate = false
                    for _, mission in pairs(missionsToAdd) do
                        if mission.name == missionData.name then
                            isDuplicate = true
                            break
                        end
                    end
  
                    if not isDuplicate then

                        local randomPoolIndex = math.random(1, #missionData.requiredPool)
                        local requiredPool = missionData.requiredPool[randomPoolIndex]
  

                        local mission = {
                            img = missionData.img,
                            name = missionData.name,
                            reward = requiredPool.reward,
                            itemRequired = requiredPool.amount,
                            itemDelivered = 0,
                            acceptedItems = missionData.acceptedItems,
                            completed = false
                        }
                        table.insert(deliveryJobs[playerJob], mission)
                        table.insert(missionsToAdd, mission)
                    end
                end
            end
  
            MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = @job', {['@job'] = playerJob}, function(result)
                if result then
                    local orders = {}
  
                    for _, row in ipairs(result) do
                        local items = json.decode(row.items)
  

                        for i, item in ipairs(items) do
                            local weaponName = item.item
                            local weaponData = GetWeaponData(weaponName)
                            item.label = weaponData.label
                            item.price = weaponData.price
                            items[i] = item
                        end
  
                        local time = math.floor((row.droptime - CurrentTime) / 60)

                        local order = {
                            id = row.id,
                            items = items,
                            totalPrice = row.price,
                            isDelivered = row.isDelivered,
                            hasCollected = row.hasCollected,
                            totalMinutes = time,
                        }
  
                        table.insert(orders, order)
                    end

                    table.sort(orders, function(a, b)
                        return a.id < b.id
                    end)

                    GlobalState.isInWeaponMenu = true

                    TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', _source, 'true', unlockedWeapons, reputation, nextreputation, orders, deliveryJobs[playerJob])
                end
            end)
        end
    end)
 end)

function GetWeaponData(weaponName)
    for _, category in ipairs(Config.gunCategories) do
        for _, weapon in ipairs(category.weapons) do
            if weapon.name == weaponName then
                return {
                    label = weapon.label,
                    price = weapon.price
                }
            end
        end
    end
    return { label = "Ukendt", price = 0 }
end

RegisterNetEvent('drp_illegaljobs:CloseWeaponShop')
AddEventHandler('drp_illegaljobs:CloseWeaponShop', function()
    GlobalState.isInWeaponMenu = false
end)

RegisterNetEvent('drp_illegaljobs:BuyCart')
AddEventHandler('drp_illegaljobs:BuyCart', function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local CurrentTime = os.time()
    local droptime = os.time() + Config.Days(Config.DropTime)

    local itemarrayting = {}
    local gang = xPlayer.job.name

    MySQL.Async.fetchAll('SELECT COUNT(*) as orderCount FROM weapondrops', {}, function(result)
        if result[1] and result[1].orderCount then

            MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = ? AND isDelivered IS NULL', {gang}, function(existingOrders)
                if #existingOrders > Config.MaxActiveDeliverances-1 then
                    TriggerClientEvent('ox_lib:notify', _source, {
                        description = 'Du kan lægge '..Config.MaxActiveDeliverances..' bestilling af gangen!',
                        type = 'error',
                    })
                else
                    local orderCount = tonumber(result[1].orderCount) + 1
                    local total_price = 0

                    for i = 1, #data["items"] do
                        local item = data["items"][i]["item"]["name"]
                        local quantity = tonumber(data["items"][i]["quantity"])
                        local price = tonumber(data["items"][i]["item"]["price"])
                        local item_price = quantity * price
                        total_price = total_price + item_price
                        itemarrayting[#itemarrayting + 1] = { item = item, amount = quantity }
                    end

                    local itemArrayJson = json.encode(itemarrayting)

                    local spillerid = ESX.GetPlayerFromId(_source).getIdentifier()
                    local base = xPlayer.getAccount('money').money

                    if base >= total_price then

                        for k, v in ipairs(GetPlayerIdentifiers(_source)) do
                            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                                steamid = v
                              elseif string.sub(v, 1, string.len("license:")) == "license:" then
                                license = v
                              elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                                discord  = v    
                            end
                        end

                        sendToDiscord(3389516, 'Våben Shop - Køb', '**Spiller**: '..xPlayer.getName()..'\n**Bande:** '..gang..'\n**Licens**: '..license or 'Ingen Registeret'..'\n**Steam**: '..steamid or 'Ingen Registeret'..'\n**Discord**: '..discord or 'Ingen Registeret'..'\n\n**Pris:** '..ESX.Math.GroupDigits(total_price)..' DKK\n**Våben:** '..itemArrayJson, 'JF Bandebuy | ') 

                        xPlayer.removeAccountMoney('money', total_price)

                        MySQL.insert('INSERT INTO weapondrops (id, gang, orderowner, items, price, droptime) VALUES (?, ?, ?, ?, ?, ?)',
                        {orderCount, gang, tostring(spillerid), itemArrayJson, tonumber(total_price), tonumber(droptime)},
                        function(done)
                            MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = ?', {gang}, function(result)
                                if result then
                                    local orders = {}

                                    for _, row in ipairs(result) do
                                        local items = json.decode(row.items)

                                        for i, item in ipairs(items) do
                                            local weaponName = item.item
                                            local weaponData = GetWeaponData(weaponName)
                                            item.label = weaponData.label
                                            item.price = weaponData.price
                                            items[i] = item
                                        end

                                        local time = math.floor((droptime - CurrentTime) / 60)

                                        local order = {
                                            id = row.id,
                                            items = items,
                                            totalPrice = row.price,
                                            totalMinutes = time,
                                            isDelivered = row.isDelivered,
                                            hasCollected = row.hasCollected,
                                        }

                                        table.insert(orders, order)
                                    end
                                    TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', _source, 'true', nil, nil, nil, orders, nil)
                                end
                            end)
                        end)
                    else
                        TriggerClientEvent('ox_lib:notify', _source, {
                            description = 'Du har ikke nok kontanter på dig!',
                            type = 'error',
                            duration = 10000,
                        })        
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent('drp_illegaljobs:DeliverMissionItems')
AddEventHandler('drp_illegaljobs:DeliverMissionItems', function(mission, item, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local amount = tonumber(amount)

    local playerJob = xPlayer.job.name

    if deliveryJobs[playerJob][mission] then
        local jobMission = deliveryJobs[playerJob][mission]
        for _, acceptedItem in ipairs(jobMission.acceptedItems) do
            if acceptedItem == item then
                local itemsToDeliver = jobMission.itemRequired - jobMission.itemDelivered
                if itemsToDeliver >= amount then
                    jobMission.itemDelivered = jobMission.itemDelivered + amount
                    exports.ox_inventory:RemoveItem(source, item, amount)
                else
                    jobMission.itemDelivered = jobMission.itemRequired
                    exports.ox_inventory:RemoveItem(source, item, itemsToDeliver)
                end
                break
            end
        end
    end
end)

RegisterNetEvent('drp_illegaljobs:CompleteMissionItem')
AddEventHandler('drp_illegaljobs:CompleteMissionItem', function(mission)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerJob = xPlayer.job.name

    local jobMission = deliveryJobs[playerJob][mission]

    if deliveryJobs[playerJob][mission] and jobMission.completed == false then
        jobMission.completed = true

        local repToAdd = jobMission.reward
        MySQL.Async.execute('UPDATE bandelevel SET repitation = repitation + @repToAdd WHERE gang = @job', {
            ['@repToAdd'] = repToAdd,
            ['@job'] = playerJob
        }, function(rowsChanged)
            if rowsChanged > 0 then
                
                MySQL.Async.fetchAll('SELECT * FROM bandelevel WHERE gang = @job', {
                    ['@job'] = playerJob
                }, function(result)
                    if result and #result > 0 then
                        local rep = result[1].repitation
                        local ganglvl = result[1].lvl

                        local reputation = {}
                        local nextreputation = {}

                        for _, levelSetup in ipairs(Config.levelsSetup) do
                            if ganglvl == levelSetup.number then
                                reputation.level = levelSetup.number
                                reputation.value = rep
                                reputation.needed = levelSetup.max
                                nextreputation.level = reputation.level + 1
                                nextreputation.unlocks = {}

                                for weaponName, weaponData in pairs(Config.reputationRequirements) do
                                    if weaponData.levelNeeded == nextreputation.level then
                                        for _, category in ipairs(Config.gunCategories) do
                                            for _, weapon in ipairs(category.weapons) do
                                                if weapon.name == weaponName then
                                                    table.insert(nextreputation.unlocks, weapon.label)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', _source, 'true', nil, reputation, nextreputation, nil, deliveryJobs[playerJob])
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent('drp_illegaljobs:RefreshWeaponMissions')
AddEventHandler('drp_illegaljobs:RefreshWeaponMissions', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerJob = xPlayer.job.name

    if not deliveryJobs[playerJob] then
        deliveryJobs[playerJob] = {}
    else
        deliveryJobs[playerJob] = {}
    end

    local missionsToAdd = {}

    while #missionsToAdd < Config.MissionCount and #missionsToAdd < #Config.MissionsPools do
        local randomIndex = math.random(1, #Config.MissionsPools)
        local missionData = Config.MissionsPools[randomIndex]

        local isDuplicate = false
        for _, mission in pairs(missionsToAdd) do
            if mission.name == missionData.name then
                isDuplicate = true
                break
            end
        end

        if not isDuplicate then

            local randomPoolIndex = math.random(1, #missionData.requiredPool)
            local requiredPool = missionData.requiredPool[randomPoolIndex]

            local mission = {
                img = missionData.img,
                name = missionData.name,
                reward = requiredPool.reward,
                itemRequired = requiredPool.amount,
                itemDelivered = 0,
                acceptedItems = missionData.acceptedItems,
                completed = false
            }

            table.insert(deliveryJobs[playerJob], mission)
            table.insert(missionsToAdd, mission)
        end
    end

    TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', source, 'true', nil, nil, nil, nil, deliveryJobs[playerJob])
end)

local weaponorder = {}

RegisterNetEvent('drp_illegaljobs:addTrunkitem')
AddEventHandler('drp_illegaljobs:addTrunkitem', function(VehicleClass, plate)
    local weaponData = json.decode(weaponorder)

    for _, order in pairs(weaponData) do
        for _, category in pairs(Config.gunCategories) do
            for _, weapon in pairs(category.weapons) do
                if order.item == weapon.name then
                    Wait(100)
                    exports.ox_inventory:AddItem('trunk' .. plate, weapon.item, order.amount)
                    break
                end
            end
        end
    end

    weaponData = {}
    weaponorder = json.encode(weaponData)
end)

RegisterNetEvent('drp_illegaljobs:CollectOrder')
AddEventHandler('drp_illegaljobs:CollectOrder', function(order)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local gang = xPlayer.job.name

    MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = ? ORDER BY id ASC', {gang}, function(result)
        if result then
            local orders = {}

            for _, row in ipairs(result) do
                table.insert(orders, row)
            end

            table.sort(orders, function(a, b)
                return a.id < b.id
            end)

            if orders[order] then
                local orderToCollect = orders[order]
                local totalItemCount = CountItems(orderToCollect.items)
                weaponorder = orderToCollect.items
                local location = Config.GunDelivery[math.random(1, #Config.GunDelivery)]
        
                MarkOrderAsCompleted(orderToCollect.id)
                TriggerClientEvent('drp_illegaljobs:StartWeaponDelivery', _source, location, totalItemCount)

                for k, v in ipairs(GetPlayerIdentifiers(_source)) do
                    if string.sub(v, 1, string.len("steam:")) == "steam:" then
                        steamid = v
                      elseif string.sub(v, 1, string.len("license:")) == "license:" then
                        license = v
                      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                        discord  = v    
                    end
                end

                sendToDiscord(16013590, 'Våben Shop - Afhent', '**Spiller**: '..xPlayer.getName()..'\n**Bande:** '..gang..'\n**Licens**: '..license or 'Ingen Registeret'..'\n**Steam**: '..steamid or 'Ingen Registeret'..'\n**Discord**: '..discord or 'Ingen Registeret'..'\n\n**Våben:** '..weaponorder, 'JF Bandebuy | ') 
        
                TriggerClientEvent('ox_lib:notify', _source, {
                    description = 'Du modtog en GPS til varevognen!',
                    type = 'success',
                    duration = 7500,
                })
            end
        end
    end)
end)

function MarkOrderAsCompleted(id)
    MySQL.Async.execute("UPDATE weapondrops SET hasCollected = 1 WHERE id = @id", {
        ['@id'] = id
    }, function(rowsChanged)
    end)
end

function CountItems(order)
    local totalCount = 0
    for item, data in pairs(json.decode(order)) do
        if data.amount then
            totalCount = totalCount + data.amount
        end
    end
    return totalCount
end

RegisterNetEvent('drp_illegaljobs:CancelOrder')
AddEventHandler('drp_illegaljobs:CancelOrder', function(order)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local gang = xPlayer.job.name 

    local CurrentTime = os.time()

    MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = ? ORDER BY id ASC', {gang}, function(result)

        if result then
            local orders = {}

            for _, row in ipairs(result) do
                table.insert(orders, row)
            end

            if orders[order] then
                local orderToCancel = orders[order]

                if orderToCancel.hasCollected == nil then
                    for k, v in ipairs(GetPlayerIdentifiers(_source)) do
                        if string.sub(v, 1, string.len("steam:")) == "steam:" then
                            steamid = v
                          elseif string.sub(v, 1, string.len("license:")) == "license:" then
                            license = v
                          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                            discord  = v    
                        end
                    end
    
                    sendToDiscord(12845056, 'Våben Shop - Annullering', '**Spiller**: '..xPlayer.getName()..'\n**Bande:** '..gang..'\n**Licens**: '..license or 'Ingen Registeret'..'\n**Steam**: '..steamid or 'Ingen Registeret'..'\n**Discord**: '..discord or 'Ingen Registeret'..'\n\n**Pris:** '..ESX.Math.GroupDigits(orderToCancel.price)..'\n**Returnering:** '..ESX.Math.GroupDigits(orderToCancel.price*(Config.ReturnRate/100)), 'JF Bandebuy | ') 
    
                    xPlayer.addAccountMoney('money', (Config.ReturnRate * orderToCancel.price)/100)
    
                    MySQL.Async.execute('DELETE FROM weapondrops WHERE id = ?', {orderToCancel.id}, function(rowsAffected)
                        if rowsAffected > 0 then
                            MySQL.Async.fetchAll('SELECT * FROM weapondrops WHERE gang = ?', {gang}, function(result)
                                if result then
    
                                    local orders = {}
            
                                    for _, row in ipairs(result) do
                                        local items = json.decode(row.items)
            
                                        for i, item in ipairs(items) do
                                            local weaponName = item.item
                                            local weaponData = GetWeaponData(weaponName)
                                            item.label = weaponData.label
                                            item.price = weaponData.price
                                            items[i] = item
                                        end
            
                                        local time = math.floor((row.droptime - CurrentTime) / 60)
    
                                        local order = {
                                            id = row.id,
                                            items = items,
                                            totalPrice = row.price,
                                            isDelivered = row.isDelivered,
                                            hasCollected = row.hasCollected,
                                            totalMinutes = time,
                                        }
            
                                        table.insert(orders, order)
                                    end
                                    TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', _source, 'true', nil, nil, nil, orders, nil)
                                end
                            end)
                        end
                    end)
                end
            end
        end
    end)
end)

RegisterNetEvent('drp_illegaljobs:UpgradeWeaponShop')
AddEventHandler('drp_illegaljobs:UpgradeWeaponShop', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerJob = xPlayer.job.name

    MySQL.Async.fetchAll('SELECT * FROM bandelevel WHERE gang = @gang', {
        ['@gang'] = playerJob
    }, function(result)
        if result and #result > 0 then
            local ganglvl = result[1].lvl
            local newGangLevel = ganglvl + 1
            MySQL.Async.execute('UPDATE bandelevel SET lvl = @newLvl WHERE gang = @gang', {
                ['@newLvl'] = newGangLevel,
                ['@gang'] = playerJob
            })

            local ganglvl = newGangLevel
            local rep = 0

            local unlockedWeapons = {}
            local reputation = {}
            local nextreputation = {}

            for _, category in ipairs(Config.gunCategories) do
                local categoryWeapons = {}
                for _, weapon in ipairs(category.weapons) do
                    local weaponData = Config.reputationRequirements[weapon.name]
                    if weaponData and ganglvl >= weaponData.levelNeeded then
                        weapon.isUnlocked = 1
                        local playerLevel = "level_" .. ganglvl
                        if weaponData.levelUnlocks[playerLevel] then
                            weapon.maxAmount = weaponData.levelUnlocks[playerLevel]
                        end
                    else
                        weapon.isUnlocked = 0
                    end

                    table.insert(categoryWeapons, weapon)
                end

                table.insert(unlockedWeapons, { name = category.name, label = category.label, weapons = categoryWeapons })
            end

            for _, levelSetup in ipairs(Config.levelsSetup) do
                if ganglvl == levelSetup.number then
                    reputation.level = levelSetup.number
                    reputation.value = rep
                    reputation.needed = levelSetup.max
                    nextreputation.level = reputation.level + 1
                    nextreputation.unlocks = {}


                    for weaponName, weaponData in pairs(Config.reputationRequirements) do
                        if weaponData.levelNeeded == nextreputation.level then
                            for _, category in ipairs(Config.gunCategories) do
                                for _, weapon in ipairs(category.weapons) do
                                    if weapon.name == weaponName then
                                        table.insert(nextreputation.unlocks, weapon.label)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            TriggerClientEvent('drp_illegaljobs:RefreshWeaponUI', _source, 'true', unlockedWeapons, reputation, nextreputation, nil, nil)

        end
    end)
end)

function UpdateDropTimeInDatabase(id, newDroptime)

    CurrentTime = os.time()

    MySQL.Async.fetchAll("SELECT * FROM weapondrops WHERE id = @id", {
        ['@id'] = id
    }, function(rowsChanged)
        MySQL.Async.fetchAll('SELECT * FROM weapondrops', function(result)
            for _, row in ipairs(result) do
                local time = math.floor((row.droptime - CurrentTime) / 60)
                if time < 0 then
                    MySQL.Async.execute("UPDATE weapondrops SET isDelivered = @isDelivered WHERE id = @id", {
                        ['@isDelivered'] = true,
                        ['@id'] = row.id
                    }, function(rowsChanged)
                    end)
                end
            end
        end)
    end)
end

local droparray = {}

function StartCheckThread()
    for i, dataJson in ipairs(droparray) do
        local data = json.decode(dataJson)
        if data then
            UpdateDropTimeInDatabase(data.id, data.droptime)
            Wait(Config.RefreshWeaponTime)
        end
    end

    if not next(droparray) then
        Wait(Config.RefreshWeaponTime)
    end

    local result, err = MySQL.query.await('SELECT * FROM weapondrops WHERE `isDelivered` IS NULL')
    if err then
        print("Database error: " .. err)
        return
    end

    if result then
        for _, v in pairs(result) do
            local itemsJson = json.encode(v.items)
            local insertting = string.format('{"id": %d, "items": %s, "droptime": %d}', v.id, itemsJson, v.droptime)
            table.insert(droparray, insertting)
        end
        StartCheckThread()
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        local result, err = MySQL.query.await('SELECT * FROM weapondrops WHERE `isDelivered` IS NULL')
        if err then
            print("Database error: " .. err)
            return
        end

        if result then
            for _, v in pairs(result) do
                local itemsJson = json.encode(v.items)
                local insertting = string.format('{"id": %d, "items": %s, "droptime": %d}', v.id, itemsJson, v.droptime)
                table.insert(droparray, insertting)
            end
            StartCheckThread()
        end
    end
end)

local function RegisterWeaponUsableItem(caseConfig)
    ESX.RegisterUsableItem(caseConfig.label, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.removeInventoryItem(caseConfig.label, 1)
            exports.ox_inventory:AddItem(source, caseConfig.give, 1)
            exports.ox_inventory:AddItem(source, Config.weaponCases.ammo.label, Config.weaponCases.ammo.give)
        end
    end)
end

if Config.UseCase then
    for _, caseConfig in pairs(Config.weaponCases) do
        RegisterWeaponUsableItem(caseConfig)
    end
end

function sendToDiscord(color, name, message, footer)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer.. " ".. os.date("%x %X %p"),
              },
          }
      }
    PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('jf_bandebuycmd:getGangs', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM bandelevel', {}, function(results)
        if results then
            local allData = {}
            for i, result in ipairs(results) do
                allData[i] = {
                    gang = result.gang,
                    lvl = result.lvl,
                    repitation = result.repitation
                }
            end
            cb(allData)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback('jf_bandebuycmd:checkAdmin', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('jf_bandebuycmd:bandeaddgang', function(gangName)
    local _source = source
    MySQL.Async.execute(
        'INSERT INTO bandelevel (gang, lvl, repitation) VALUES (@gang, 1, 0)',
        {['@gang'] = gangName},
        function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('ox_lib:notify', _source, {
                    description = 'Du tilføjede '..gangName..' til Våben Systemet!',
                    type = 'success',
                    duration = 10000,
                })
            else
                TriggerClientEvent('ox_lib:notify', _source, {
                    description = 'FEJL! Kunne ikke oprette banden',
                    type = 'error',
                    duration = 10000,
                })
                TriggerClientEvent('ox_lib:notify', _source, 'error', 'Failed to add gang.')
            end
        end
    )
end)

RegisterNetEvent('jf_bandebuycmd:banderemovegang', function(gangName)
    local _source = source
    MySQL.Async.execute(
        'DELETE FROM bandelevel WHERE gang = @gang',
        {['@gang'] = gangName},
        function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('ox_lib:notify', _source, {
                    description = 'Du slettede '..gangName..' banden!',
                    type = 'success',
                    duration = 10000,
                })
            else
                TriggerClientEvent('ox_lib:notify', _source, {
                    description = 'FEJL! Fejlede at slette banden eller eksistere banden ikke',
                    type = 'error',
                    duration = 10000,
                })
            end
        end
    )
end)
