local ESX = exports['es_extended']:getSharedObject()

local registeredStashes = {}
local pendingSaves = {}

local function debugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

CreateThread(function()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS `propinventories` (
            `id` VARCHAR(255) NOT NULL,
            `items` LONGTEXT NOT NULL DEFAULT '[]',
            `prop` VARCHAR(50) NOT NULL,
            `coords_x` FLOAT NOT NULL,
            `coords_y` FLOAT NOT NULL,
            `coords_z` FLOAT NOT NULL,
            `last_accessed` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]], {}, function(result)
        debugPrint('Prop inventories database table initialized')
        loadSavedInventories()
    end)
end)

function loadSavedInventories()
    exports.oxmysql:execute('SELECT * FROM `propinventories`', {}, function(results)
        if results and #results > 0 then
            debugPrint('Loading ' .. #results .. ' saved inventories from database')
            for _, inventory in ipairs(results) do

                local propData = nil
                for model, data in pairs(Config.StorageProps) do
                    if tostring(model):gsub('`', '') == inventory.prop then
                        propData = data
                        break
                    end
                end
                
                if propData then
                    local success = pcall(function()
                        exports.ox_inventory:RegisterStash(
                            inventory.id,
                            propData.label or 'Storage',
                            propData.slots or 20,
                            propData.weight or 50000,
                            nil
                        )
                    end)
                    
                    if success then
                        registeredStashes[inventory.id] = {
                            label = propData.label or 'Storage',
                            slots = propData.slots or 20,
                            weight = propData.weight or 50000,
                            registered = os.time(),
                            model = inventory.prop
                        }
                        
                        SetTimeout(1000, function()
                            restoreItemsToStash(inventory.id, inventory.items)
                        end)
                        debugPrint('Loaded inventory from database: ' .. inventory.id)
                    else
                        debugPrint('Failed to register stash for inventory: ' .. inventory.id)
                    end
                else
                    debugPrint('No prop data found for: ' .. inventory.prop)
                end
            end
        else
            debugPrint('No saved inventories found in database')
        end
    end)
end

function restoreItemsToStash(stashId, itemsJson)
    if not itemsJson or itemsJson == '[]' or itemsJson == '' then
        debugPrint('No items to restore for stash: ' .. stashId)
        return
    end
    
    local success, items = pcall(json.decode, itemsJson)
    if not success or not items then
        debugPrint('Failed to decode items for stash: ' .. stashId .. ' - JSON: ' .. tostring(itemsJson))
        return
    end
    
    exports.ox_inventory:ClearInventory(stashId)
    
    for slot, item in pairs(items) do
        if item and item.name and item.count and item.count > 0 then
            local addSuccess = exports.ox_inventory:AddItem(stashId, item.name, item.count, item.metadata or {}, tonumber(slot))
            if addSuccess then
                debugPrint('Restored item: ' .. item.name .. ' x' .. item.count .. ' to stash: ' .. stashId .. ' slot: ' .. slot)
            else
                debugPrint('Failed to restore item: ' .. item.name .. ' to stash: ' .. stashId)
            end
        end
    end
    debugPrint('Finished restoring items to stash: ' .. stashId)
end

function saveInventoryToDatabase(stashId, propModel, retryCount)
    retryCount = retryCount or 0
    
    if pendingSaves[stashId] then
        debugPrint('Save already pending for stash: ' .. stashId)
        return
    end
    
    pendingSaves[stashId] = true
    
    SetTimeout(200, function()
        local inventory = exports.ox_inventory:GetInventory(stashId)
        if not inventory then
            debugPrint('Could not get inventory for stash: ' .. stashId)
            pendingSaves[stashId] = nil
            return
        end
        
        debugPrint('Saving inventory for stash: ' .. stashId)
        
        local items = {}
        local itemCount = 0
        
        if inventory.items then
            for slot, item in pairs(inventory.items) do
                if item and item.name and item.count and item.count > 0 then
                    items[tostring(slot)] = {
                        name = item.name,
                        count = item.count,
                        metadata = item.metadata or {}
                    }
                    itemCount = itemCount + 1
                    debugPrint('Found item in slot ' .. slot .. ': ' .. item.name .. ' x' .. item.count)
                end
            end
        end
        
        local itemsJson = json.encode(items)
        debugPrint('Saving ' .. itemCount .. ' items to database for stash: ' .. stashId)
        
        exports.oxmysql:execute(
            'UPDATE `propinventories` SET items = ?, last_accessed = CURRENT_TIMESTAMP WHERE id = ?',
            {itemsJson, stashId},
            function(result)
                pendingSaves[stashId] = nil
                if result and result.affectedRows and result.affectedRows > 0 then
                    debugPrint('Successfully saved inventory to database: ' .. stashId .. ' with ' .. itemCount .. ' items')
                else
                    debugPrint('Failed to save inventory to database: ' .. stashId .. ' (no rows affected)')
                    if retryCount < 3 then
                        debugPrint('Retrying save for stash: ' .. stashId .. ' (attempt ' .. (retryCount + 1) .. ')')
                        SetTimeout(1000, function()
                            saveInventoryToDatabase(stashId, propModel, retryCount + 1)
                        end)
                    end
                end
            end
        )
    end)
end

RegisterNetEvent('storage_system:registerStash', function(stashId, label, slots, weight, coords, model)
    if not stashId then 
        debugPrint('No stash ID provided')
        return 
    end

    if registeredStashes[stashId] then
        exports.oxmysql:execute('UPDATE `propinventories` SET last_accessed = CURRENT_TIMESTAMP WHERE id = ?', 
            {stashId}, 
            function(result)
                debugPrint('Updated last accessed time for stash: ' .. stashId)
            end
        )
        debugPrint('Stash already registered: ' .. stashId)
        return
    end

    debugPrint('Registering new stash with ID: ' .. stashId)

    local success = pcall(function()
        exports.ox_inventory:RegisterStash(
            stashId,
            label or 'Storage',
            slots or 20,
            weight or 50000,
            nil
        )
    end)

    if success then
        local modelString = type(model) == 'number' and tostring(model) or model
        modelString = modelString:gsub('`', '')
        
        registeredStashes[stashId] = {
            label = label or 'Storage',
            slots = slots or 20,
            weight = weight or 50000,
            registered = os.time(),
            model = modelString
        }
        
        if model and coords then
            exports.oxmysql:execute(
                'INSERT IGNORE INTO `propinventories` (id, items, prop, coords_x, coords_y, coords_z) VALUES (?, ?, ?, ?, ?, ?)',
                {stashId, '[]', modelString, coords.x, coords.y, coords.z},
                function(result)
                    if result and result.affectedRows and result.affectedRows > 0 then
                        debugPrint('Created database entry for stash: ' .. stashId .. ' at coords: ' .. coords.x .. ', ' .. coords.y .. ', ' .. coords.z)
                    else
                        debugPrint('Database entry already exists for stash: ' .. stashId)
                    end
                end
            )
        end
        
        debugPrint('Successfully registered stash: ' .. stashId)
    else
        debugPrint('Failed to register stash: ' .. stashId)
    end
end)

RegisterNetEvent('storage_system:saveInventory', function(stashId, propModel)
    if not stashId then
        debugPrint('Missing stash ID for save')
        return
    end
    
    local modelString = propModel
    if propModel then
        modelString = type(propModel) == 'number' and tostring(propModel) or propModel
        modelString = modelString:gsub('`', '')
    elseif registeredStashes[stashId] then
        modelString = registeredStashes[stashId].model
    end
    
    debugPrint('Received save request for stash: ' .. stashId)
    saveInventoryToDatabase(stashId, modelString)
end)

RegisterNetEvent('storage_system:forceSave', function(stashId)
    if not stashId then return end
    
    local stashData = registeredStashes[stashId]
    if stashData then
        debugPrint('Force saving stash: ' .. stashId)
        saveInventoryToDatabase(stashId, stashData.model)
    else
        debugPrint('Cannot force save - stash not found: ' .. stashId)
    end
end)

CreateThread(function()
    while true do
        Wait(Config.AutoSaveInterval or 60000)
        
        debugPrint('Auto-saving all inventories...')
        local saveCount = 0
        for stashId, data in pairs(registeredStashes) do
            saveInventoryToDatabase(stashId, data.model)
            saveCount = saveCount + 1
        end
        debugPrint('Initiated auto-save for ' .. saveCount .. ' stashes')
    end
end)

if Config.Debug then
    RegisterCommand('liststashes', function(source, args, rawCommand)
        if source == 0 then
            print('^3[Storage System Debug]^7 Registered Stashes:')
            for stashId, data in pairs(registeredStashes) do
                print(string.format('  - %s: %s (Slots: %d, Weight: %d, Model: %s)', stashId, data.label, data.slots, data.weight, data.model or 'unknown'))
            end
        end
    end, true)
    
    RegisterCommand('saveallinventories', function(source, args, rawCommand)
        if source == 0 then
            print('^3[Storage System Debug]^7 Manually saving all inventories...')
            for stashId, data in pairs(registeredStashes) do
                saveInventoryToDatabase(stashId, data.model)
            end
        end
    end, true)
    
    RegisterCommand('checkinventory', function(source, args, rawCommand)
        if source == 0 and args[1] then 
            local stashId = args[1]
            local inventory = exports.ox_inventory:GetInventory(stashId)
            if inventory then
                print('^3[Storage System Debug]^7 Inventory for ' .. stashId .. ':')
                print(json.encode(inventory, {indent = true}))
            else
                print('^3[Storage System Debug]^7 No inventory found for: ' .. stashId)
            end
        end
    end, true)
    
    RegisterCommand('checkdb', function(source, args, rawCommand)
        if source == 0 and args[1] then
            local stashId = args[1]
            exports.oxmysql:execute('SELECT * FROM `propinventories` WHERE id = ?', {stashId}, function(results)
                if results and #results > 0 then
                    print('^3[Storage System Debug]^7 Database entry for ' .. stashId .. ':')
                    print(json.encode(results[1], {indent = true}))
                else
                    print('^3[Storage System Debug]^7 No database entry found for: ' .. stashId)
                end
            end)
        end
    end, true)
end
