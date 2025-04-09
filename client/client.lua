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






-- Local debug function
local function debugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

-- Function to handle storage interaction
local function openStorage(model, storageType)
    debugPrint('Attempting to open storage: ' .. model .. ' of type: ' .. storageType)
    
    -- Translate the modelname to a string, to make config easier
    local modelString = type(model) == 'number' and tostring(model) or model
    modelString = modelString:gsub('`', '')
    
    local stashId = 'storage_' .. modelString
    debugPrint('Opening stash: ' .. stashId)
    
    if storageType == 'shelf' or storageType == 'fridge' or storageType == 'shelf' then
        -- Export to open the OxInventory
        exports.ox_inventory:openInventory('stash', stashId)
    else
        debugPrint('Invalid storage type: ' .. storageType)
    end
end


-- This function is to handle the wardrobe to open it

local function handleWardrobeOptions(model)
    debugPrint('Opening wardrobe options menu')
    lib.registerContext({
        id = 'wardrobe_menu',
        title = 'Wardrobe Options',
        options = {
            {
                title = 'Open Wardrobe',
                icon = 'tshirt',
                onSelect = function()
                    debugPrint('Opening wardrobe')
                    exports['vms_clothestore']:OpenWardrobe()       -- if not using this resource delete from fxmanifest
                    --exports['rcore_clothing']:getPlayerClothing() -- if u use this put ResourceName in fxmanifest and exclude in Script and Manifest
                    --exports['ak47_clothing']:openOutfit()         -- if u use this put ResourceName in fxmanifest and exclude in Script and Manifest
                    --exports['sleek-clothestore']:OpenWardrobe()    -- if u use this put ResourceName in fxmanifest and exclude in Script and Manifest           
                end
            }, -- if you use VMS, esclude following code if needed
            -- { -- Only for VMS Clothestore, dont know any other script that uses this 
            --     title = 'Manage Outfits',
            --     icon = 'gear',
            --     onSelect = function()
            --         debugPrint('Opening outfit management')
            --         exports['vms_clothestore']:OpenManage()
            --     end
            -- },
            -- { -- Only for VMS Clothestore, dont know any other script that uses this 
            --     title = 'Share Outfits',
            --     icon = 'share',
            --     onSelect = function()
            --         debugPrint('Opening outfit sharing')
            --         exports['vms_clothestore']:OpenShare()

            --     end
            -- }
        }
    })
    lib.showContext('wardrobe_menu')
end

local function initializeProps()
    debugPrint('Initializing storage props')
    for model, data in pairs(Config.Props) do
        local options = {
            {
                name = 'open_storage_'..model,
                label = 'Open '..data.label,
                icon = 'fas fa-box-open',
                onSelect = function()
                    debugPrint('Selected storage: ' .. data.label .. ' (Type: ' .. data.type .. ')')
                    if data.type == 'wardrobe' then
                        handleWardrobeOptions(model)
                    else
                        openStorage(model, data.type)
                    end
                end
            }
        }

        -- Set symbols for each type
        if data.type == 'wardrobe' then
            options[1].icon = 'fas fa-tshirt'
        elseif data.type == 'fridge' then
            options[1].icon = 'fas fa-snowflake'
        elseif data.type == 'shelf' then
            options[1].icon = 'fa-solid fa-box'
        end

        debugPrint('Adding target for model: ' .. model)
        exports.ox_target:addModel(model, options)
    end
end


CreateThread(function()
    debugPrint('Resource starting...')
    initializeProps()
    debugPrint('Storage props initialized')
end)