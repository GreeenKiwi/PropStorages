local function debugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

ESX.RegisterServerCallback('storage_system:getClosestStash', function(source, cb, model, coords)
    local closestStash = nil
    local closestDistance = 2.0 
    
    exports.oxmysql:execute('SELECT * FROM `propinventories` WHERE prop = ?', {model}, function(results)
        if results and #results > 0 then
            debugPrint('Found ' .. #results .. ' existing stashes for model: ' .. model)
            
            for _, stash in ipairs(results) do
                local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(stash.coords_x, stash.coords_y, stash.coords_z))
                
                debugPrint('Checking stash ' .. stash.id .. ' at distance: ' .. distance)
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestStash = stash.id
                    debugPrint('Found closer stash: ' .. stash.id .. ' at distance: ' .. distance)
                end
            end
            
            if closestStash then
                debugPrint('Returning closest stash: ' .. closestStash .. ' at distance: ' .. closestDistance)
            else
                debugPrint('No stash found within ' .. closestDistance .. ' meters')
            end
        else
            debugPrint('No existing stashes found for model: ' .. model)
        end
        
        cb(closestStash)
    end)
end)
