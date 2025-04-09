local ESX = exports['es_extended']:getSharedObject()

-- Local debug function
local function debugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

-- Initialize ox_inventory stashes for storage props
CreateThread(function()
    debugPrint('Initializing stashes...')
    for model, data in pairs(Config.StorageProps) do
        if data.type ~= 'wardrobe' then
            -- Convert model to string if it's a hash
            local modelString = type(model) == 'number' and tostring(model) or model
            modelString = modelString:gsub('`', '')
            
            local stashId = 'storage_'..modelString
            debugPrint('Registering stash: ' .. stashId)
            
            -- Register stash with proper parameters
            exports.ox_inventory:RegisterStash(stashId, data.label, data.slots, data.weight, nil)
        end
    end
    debugPrint('Stash initialization complete')
end)