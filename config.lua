Config = {}

Config.OldESX = false -- If u use old ESX GetSharedObject event set true
Config.Debug = false 

function Config.DebugPrint(message)
    if Config.Debug then
        print('^3[Storage System Debug]^7: ' .. message)
    end
end

Config.AutoSaveInterval = 60000 -- Auto-save alle 60 sekunden 
Config.InteractionDistance = 2.0 

-- Props definieren die ein Lager beinhalten sollen (Label = Anzeigename, Slots = Inventarslots, type = Typ des Inventars, ist wegen symbolen beim alt drücken wichtig, weight = gewicht im gramm umrechnen zu kg)
-- type = "wardrobe", bedeutet mit alt kann man an diesem Prop den Kleiderschrank öffnen, Outfits verwalten, und outfits teilen, nur eben KEINE kaufen
Config.StorageProps = {

-- Kleiderschränke
    [`prop_coathook_01`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`ch_prop_ch_service_locker_01a`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`ch_prop_ch_service_locker_02a`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`bkr_prop_biker_garage_locker_01`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`p_cs_locker_01_s`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`bkr_prop_gunlocker_01a`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`apa_mp_h_str_shelffloorm_02`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

    [`v_serv_cupboard_01`] = {
        label = "Kleiderschrank",
        type = "wardrobe",
    },

-- Kühlschränke

    [`ba_prop_battle_bar_fridge_02`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 25,
        weight = 60000, -- 60kg capacity
    },
    [`prop_bar_fridge_03`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 25,
        weight = 60000, -- 60kg capacity
    },
    [`prop_bar_fridge_04`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 25,
        weight = 60000, -- 60kg capacity
    },
    [`prop_fridge_01`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`v_res_fridgemodsml`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`prop_fridge_03`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`prop_trailr_fridge`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`ba_prop_battle_bar_beerfridge_01`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`prop_bar_fridge_01`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`v_ilev_mm_fridgeint`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`prop_vend_fridge01`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`v_res_tre_fridge`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 60,
        weight = 160000, -- 160kg
    },
    [`v_res_fridgemoda`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 100,
        weight = 250000, -- 250kg capacity
    },
    [`v_med_lab_fridge`] = {
        label = "Kühlschrank",
        type = "fridge",
        slots = 100,
        weight = 250000, -- 250kg capacity
    },

-- Sideboards
    [`apa_mp_h_str_sideboardl_06`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`apa_mp_h_str_sideboardm_03`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 35000
    },

    [`apa_mp_h_str_sideboardl_09`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`apa_mp_h_str_sideboardl_14`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`apa_mp_h_str_sideboardl_13`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`apa_mp_h_str_sideboardm_02`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 30000
    },

    [`hei_heist_bed_chestdrawer_04`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 20000
    },

    [`hei_heist_str_sideboardl_04`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`hei_heist_str_sideboardl_02`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`hei_heist_str_sideboardl_03`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`v_res_tre_smallbookshelf`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 15,
        weight = 15000
    },

    [`apa_mp_h_bed_chestdrawer_02`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 35000
    },

    [`apa_mp_h_str_sideboardl_11`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`v_res_d_sideunit`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 15,
        weight = 15000
    },

    [`v_res_fh_sidebrdlngb`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`v_res_fh_sidebrddine`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`v_res_tre_storageunit`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 15,
        weight = 15000
    },

    [`hokaido_dresser_a`] = {
        label = "Sideboard",
        type = "shelf",
        slots = 20,
        weight = 35000
    },


-- Werkstatt
    [`ex_prop_ex_toolchest_01`] = {
        label = "Werkzeugschrank",
        type = "shelf",
        slots = 20,
        weight = 20000
    },

    [`gr_prop_gr_tool_draw_01a`] = {
        label = "Werkzeugschrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },

    [`gr_prop_gr_tool_draw_01b`] = {
        label = "Werkzeugschrank",
        type = "shelf",
        slots = 20,
        weight = 20000
    },

    [`gr_prop_gr_tool_draw_01d`] = {
        label = "Werkzeugschrank",
        type = "shelf",
        slots = 30,
        weight = 50000
    },

    [`prop_toolchest_05`] = {
        label = "Werkzeugschrank",
        type = "shelf",
        slots = 20,
        weight = 20000
    },

    [`gr_prop_gr_tool_chest_01a`] = {
        label = "Werkzeugkiste",
        type = "shelf",
        slots = 10,
        weight = 10000
    },

    [`imp_prop_impexp_parts_rack_03a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_parts_rack_04a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_parts_rack_05a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`v_ret_ml_shelfrk`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 20,
        weight = 50000
    },

    [`prop_boxpile_02b`] = {
        label = "Lager",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`prop_boxpile_05a`] = {
        label = "Lager",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_parts_rack_01a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_parts_rack_02a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_half_cut_rack_01a`] = {
        label = "Lagerregal",
        type = "shelf",
        slots = 15,
        weight = 80000
    },

    [`imp_prop_impexp_hub_rack_01a`] = {
        label = "Reifenregal",
        type = "shelf",
        slots = 10,
        weight = 60000
    },

    [`imp_prop_impexp_tyre_01a`] = {
        label = "Reifenregal",
        type = "shelf",
        slots = 10,
        weight = 60000
    },

-- Nachtschrank
    [`v_res_tre_bedsidetable`] = {
        label = "Nachttisch",
        type = "shelf",
        slots = 10,
        weight = 5000
    },

    [`v_res_tre_bedsidetableb`] = {
        label = "Nachttisch",
        type = "shelf",
        slots = 10,
        weight = 5000
    },


-- Büroschrank
    [`v_corp_filecablow`] = {
        label = "Schrank",
        type = "shelf",
        slots = 20,
        weight = 30000
    },

    [`v_corp_filecabtall`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },

    [`v_corp_lowcabdark01`] = {
        label = "Schrank",
        type = "shelf",
        slots = 20,
        weight = 30000
    },

    [`v_corp_tallcabdark01`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },

    [`v_corp_cabshelves01`] = {
        label = "Schrank",
        type = "shelf",
        slots = 25,
        weight = 35000
    },

    [`v_corp_offshelf`] = {
        label = "Aktenregal",
        type = "shelf",
        slots = 20,
        weight = 30000
    },

    [`prop_rub_cabinet`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 15000
    },

-- Safes
    [`p_v_43_safe_s`] = {
        label = "Safe",
        type = "shelf",
        slots = 25,
        weight = 50000
    },

    [`prop_ld_int_safe_01`] = {
        label = "Safe",
        type = "shelf",
        slots = 15,
        weight = 30000
    },

    [`h4_prop_h4_safe_01a`] = {
        label = "Safe",
        type = "shelf",
        slots = 30,
        weight = 80000
    },

    [`sf_prop_v_43_safe_s_bk_01a`] = {
        label = "Safe",
        type = "shelf",
        slots = 25,
        weight = 50000
    },

    [`sf_prop_v_43_safe_s_gd_01a`] = {
        label = "Safe",
        type = "shelf",
        slots = 25,
        weight = 50000
    },

-- Fernsehschrank
    [`prop_tv_cabinet_04`] = {
        label = "Fernsehschrank",
        type = "shelf",
        slots = 10,
        weight = 10000
    },

    [`prop_tv_cabinet_05`] = {
        label = "Fernsehschrank",
        type = "shelf",
        slots = 10,
        weight = 10000
    },

    [`v_res_j_tvstand`] = {
        label = "Fernsehschrank",
        type = "shelf",
        slots = 10,
        weight = 10000
    },

    [`v_res_msoncabinet`] = {
        label = "Fernsehschrank",
        type = "shelf",
        slots = 10,
        weight = 10000
    },

-- Truhen
    [`v_res_tre_storagebox`] = {
        label = "Truhe",
        type = "shelf",
        slots = 20,
        weight = 20000
    },

    [`v_res_mbottoman`] = {
        label = "Truhe",
        type = "shelf",
        slots = 25,
        weight = 25000
    },

    [`prop_devin_box_closed`] = {
        label = "Truhe",
        type = "shelf",
        slots = 30,
        weight = 30000
    },

-- Altbacken
    [`v_res_mcupboard`] = {
        label = "Schrank",
        type = "shelf",
        slots = 10,
        weight = 5000
    },

    [`v_res_m_armoire`] = {
        label = "Schrank",
        type = "shelf",
        slots = 30,
        weight = 50000
    },

    [`v_res_mbbedtable`] = {
        label = "Schrank",
        type = "shelf",
        slots = 10,
        weight = 5000
    },

    [`v_res_mconsolemod`] = {
        label = "Schrank",
        type = "shelf",
        slots = 25,
        weight = 40000
    },

    [`v_res_mbdresser`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 25000
    },


-- Militärkiste
    [`prop_mil_crate_01`] = {
        label = "Kiste",
        type = "shelf",
        slots = 25,
        weight = 100000
    },

    [`prop_mil_crate_02`] = {
        label = "Kiste",
        type = "shelf",
        slots = 25,
        weight = 50000
    },

-- Medical
    [`v_med_bench1`] = {
        label = "Schrank",
        type = "shelf",
        slots = 25,
        weight = 35000
    },

    [`v_med_bench2`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },

    [`v_med_benchcentr`] = {
        label = "Schrank",
        type = "shelf",
        slots = 30,
        weight = 50000
    },

    [`v_med_cor_fileboxa`] = {
        label = "Papierbox",
        type = "shelf",
        slots = 5,
        weight = 3000
    },

    [`v_med_cor_filingcab`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },

    [`v_med_cor_largecupboard`] = {
        label = "Schrank",
        type = "shelf",
        slots = 30,
        weight = 50000
    },

    [`v_med_cor_wallunita`] = {
        label = "Schrank",
        type = "shelf",
        slots = 15,
        weight = 20000
    },



}
