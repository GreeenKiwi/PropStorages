Config = {}


Config.OldESX = false -- If u use old ESX GetSharedObject event set true


Config.Debug = false 

function Config.DebugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end




Config.Props = {

    -- Shelf
    [`prop_warehseshelf03`] = {
        label = "WarehouseShelf",  -- What should be displayed after "Open..." when usng target
        type = "shelf", -- What kinda type?
        slots = 10,  -- How many slots does the inventory have?
        weight = 10000,  -- How much can the inventory hold? for example: 10000 = 10kg
    },

    -- Wardrobes
    [`p_cs_locker_01_s`] = {
        label = "Wardrobe", 
        type = "wardrobe",
    },


    -- Fridges
    [`v_res_fridgemodsml`] = {
        label = "Fridge",
        type = "fridge",
        slots = 25,
        weight = 50000,
    },
    [`prop_bar_fridge_04`] = {
        label = "Fridge",
        type = "fridge",
        slots = 15,
        weight = 30000,
    },


}