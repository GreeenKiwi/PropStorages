ESX = nil

if Config.OldESX then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
else
    ESX = exports['es_extended']:getSharedObject()
end

local function debugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

local entityStashIds = {}
local stashCounter = 0
local currentOpenStash = nil
local lastSaveTime = {}

local function generateUniqueStashId(entity, model)
    local coords = GetEntityCoords(entity)
    local modelString = type(model) == 'number' and tostring(model) or model
    modelString = modelString:gsub('`', '')
    
    stashCounter = stashCounter + 1
    
    local stashId = string.format('storage_%s_%.2f_%.2f_%.2f_%d', 
        modelString, 
        coords.x, 
        coords.y, 
        coords.z, 
        stashCounter
    )
    
    entityStashIds[entity] = stashId
    
    debugPrint('Generated unique stash ID: ' .. stashId .. ' for entity: ' .. entity)
    return stashId
end

local function getEntityStashId(entity, model)
    if entityStashIds[entity] then
        debugPrint('Using existing stash ID: ' .. entityStashIds[entity] .. ' for entity: ' .. entity)
        return entityStashIds[entity]
    else
        return generateUniqueStashId(entity, model)
    end
end

local function findClosestStashId(entity, model)
    local entityCoords = GetEntityCoords(entity)
    local modelString = type(model) == 'number' and tostring(model) or model
    modelString = modelString:gsub('`', '')
    
    local closestStashId = nil
    ESX.TriggerServerCallback('storage_system:getClosestStash', function(stashId)
        closestStashId = stashId
    end, modelString, entityCoords)
    
    local timeout = 0
    while closestStashId == nil and timeout < 50 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if closestStashId then
        debugPrint('Found closest stash ID: ' .. closestStashId .. ' for entity: ' .. entity)
        entityStashIds[entity] = closestStashId
        return closestStashId
    else
        debugPrint('No existing stash found, generating new ID')
        return generateUniqueStashId(entity, model)
    end
end

local function openStorage(entity, model, storageType)
    if not entity then
        debugPrint('No entity provided to openStorage')
        return
    end

    if not DoesEntityExist(entity) then
        debugPrint('Entity does not exist: ' .. tostring(entity))
        return
    end

    local stashId = entityStashIds[entity]
    if not stashId then
        stashId = findClosestStashId(entity, model)
    end
    
    local propData = Config.StorageProps[model] or {}
    local coords = GetEntityCoords(entity)

    debugPrint('Opening storage with stash ID: ' .. stashId)

    currentOpenStash = {
        id = stashId,
        model = model,
        entity = entity,
        openTime = GetGameTimer()
    }

    TriggerServerEvent('storage_system:registerStash', stashId, propData.label, propData.slots, propData.weight, coords, model)
    Wait(200)
    
    exports.ox_inventory:openInventory('stash', { id = stashId })
end

AddEventHandler('ox_inventory:closedInventory', function(inventoryId)
    if currentOpenStash and currentOpenStash.id == inventoryId then
        debugPrint('Saving inventory for closed stash: ' .. inventoryId)
        
        local currentTime = GetGameTimer()
        if not lastSaveTime[inventoryId] or (currentTime - lastSaveTime[inventoryId]) > 1000 then
            lastSaveTime[inventoryId] = currentTime
            TriggerServerEvent('storage_system:saveInventory', currentOpenStash.id, currentOpenStash.model)
        else
            debugPrint('Skipping save due to rate limit for: ' .. inventoryId)
        end
        
        currentOpenStash = nil
    end
end)

local function forceSaveCurrentInventory()
    if currentOpenStash then
        debugPrint('Force saving current inventory: ' .. currentOpenStash.id)
        TriggerServerEvent('storage_system:forceSave', currentOpenStash.id)
    else
        debugPrint('No inventory currently open to save')
    end
end

local function handleWardrobeOptions(model)
    debugPrint('Opening wardrobe options menu')
    lib.registerContext({
        id = 'wardrobe_menu',
        title = 'Wardrobe Options',
        options = {
            {
                title = 'Kleiderschrank öffnen',
                icon = 'tshirt',
                onSelect = function()
                    debugPrint('Opening wardrobe')
                    exports['vms_clothestore']:OpenWardrobe()
                end
            },
            {
                title = 'Outfits verwalten',
                icon = 'gear',
                onSelect = function()
                    debugPrint('Opening outfit management')
                    exports['vms_clothestore']:OpenManage()
                end
            },
            {
                title = 'Outifts teilen',
                icon = 'share',
                onSelect = function()
                    debugPrint('Opening outfit sharing')
                    exports['vms_clothestore']:OpenShare()
                end
            }
        }
    })
    lib.showContext('wardrobe_menu')
end

local function initializeProps()
    debugPrint('Initializing storage props')
    for model, data in pairs(Config.StorageProps) do
        local options = {
            {
                name = 'open_storage_'..model,
                label = 'Open '..data.label,
                icon = 'fas fa-box-open',
                distance = Config.InteractionDistance,
                onSelect = function(targetData)
                    local entity = targetData.entity
                    if not entity then
                        debugPrint('No entity found for targetData')
                        return
                    end

                    local storageData = Config.StorageProps[model]
                    if not storageData then
                        debugPrint('No storage data found for model: ' .. tostring(model))
                        return
                    end

                    if storageData.type == 'wardrobe' then
                        handleWardrobeOptions(model)
                    else
                        openStorage(entity, model, storageData.type)
                    end
                end
            }
        }

        if data.type == 'wardrobe' then
            options[1].icon = 'fas fa-tshirt'
        elseif data.type == 'fridge' then
            options[1].icon = 'fas fa-snowflake'
        elseif data.type == 'shelf' then
            options[1].icon = 'fa-solid fa-box'
        end

        debugPrint('Adding target for model: ' .. model .. ' with distance: ' .. Config.InteractionDistance)
        exports.ox_target:addModel(model, options)
    end
end

CreateThread(function()
    while true do
        Wait(30000)
        
        local toRemove = {}
        for entity, stashId in pairs(entityStashIds) do
            if not DoesEntityExist(entity) then
                debugPrint('Entity ' .. entity .. ' no longer exists, removing stash ID: ' .. stashId)
                table.insert(toRemove, entity)
            end
        end
        
        for _, entity in ipairs(toRemove) do
            entityStashIds[entity] = nil
        end
    end
end)

if Config.Debug then
    RegisterCommand('forcesave', function()
        forceSaveCurrentInventory()
    end, false)
    
    RegisterCommand('listclientstashes', function()
        print('^3[Storage System Debug]^7 Client Stash Mappings:')
        for entity, stashId in pairs(entityStashIds) do
            print(string.format('  - Entity %d: %s', entity, stashId))
        end
    end, false)
end

CreateThread(function()
    debugPrint('Resource starting...')
    initializeProps()
    debugPrint('Storage props initialized')
end)
