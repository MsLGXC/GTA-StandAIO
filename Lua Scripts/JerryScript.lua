--[[coded by Jerry123#4508

    skids from:
    LanceScript by lance#8213
    WiriScript by Nowiry#2663
    KeramisScript by scriptCat#6566
    Heist control by IceDoomfist#0001
    Meteor by RulyPancake the 5th#1157

    thx to Sai, ren, aaron, Nowry, JayMontana, IceDoomfist and scriptCat and everyone else that helped me in #programming :)
]]

local LOADING_START = util.current_time_millis()
LOADING_SCRIPT = true

util.ensure_package_is_installed('lua/ScaleformLib')
util.require_natives('1660775568-uno')

local nativeNameSpaces = {
    'SYSTEM',
    'APP',
    'AUDIO',
    'BRAIN',
    'CAM',
    'CLOCK',
    'CUTSCENE',
    'DATAFILE',
    'DECORATOR',
    'DLC',
    'ENTITY',
    'EVENT',
    'FILES',
    'FIRE',
    'GRAPHICS',
    'HUD',
    'INTERIOR',
    'ITEMSET',
    'LOADINGSCREEN',
    'LOCALIZATION',
    'MISC',
    'MOBILE',
    'MONEY',
    'NETSHOPPING',
    'NETWORK',
    'OBJECT',
    'PAD',
    'PATHFIND',
    'PED',
    'PHYSICS',
    'PLAYER',
    'RECORDING',
    'REPLAY',
    'SAVEMIGRATION',
    'SCRIPT',
    'SECURITY',
    'SHAPETEST',
    'SOCIALCLUB',
    'STATS',
    'STREAMING',
    'TASK',
    'VEHICLE',
    'WATER',
    'WEAPON',
    'ZONE'
}
local nativesIntact = true
for _, nameSpace in ipairs(nativeNameSpaces) do
    if not _G[nameSpace] then
        nativesIntact = false
        util.toast('Detected bad natives, staring fix.')
        break
    end
end

if not nativesIntact and not menu.get_value(menu.ref_by_path('Stand>Lua Scripts>Settings>Disable Internet Access', 38)) then
    local done
    async_http.init('raw.githubusercontent.com', '/Jerrrry123/JerryScript/main/lib/natives-1660775568-uno.lua', function(fileContent)
        local f = assert(io.open(filesystem.scripts_dir() ..'/lib/natives-1660775568-uno.lua', 'w'))
        f:write(fileContent)
        f:close()

        local loadNatives, err = load(fileContent)
        if not err then
            loadNatives()
        end

        done = true
    end, function()
        done = true
    end)
    async_http.dispatch()
    while not done do
        util.yield_once()
    end
end

LANG_SETTINGS = {}

LANG_SETTINGS.LANG_DIR = filesystem.store_dir() .. 'JerryScript\\Language\\'

LANG_SETTINGS.STRING_FILES = {
    filesystem.scripts_dir() ..'JerryScript.lua',
}

LANG_SETTINGS.VAR_NAME = 'JSlang'

local JSlang = require 'JSlangLib'

local JSkey = require 'JSkeyLib'

local scaleForm = require'ScaleformLib'
local SF = scaleForm('instructional_buttons')

--list refs
local _LR = {}
function JSlang.list(root, name, tableCommands, description, ...)
    local ref = menu.list(root, JSlang.trans(name), if tableCommands then tableCommands else {}, JSlang.trans(description), ...)
        _LR[name] = ref
    return ref
end

----------------------------------
-- Tables
----------------------------------
local JS_tbls = {}
do
    --Transition points
    -- 49  -> 50
    -- 87  -> 88
    -- 159 -> 160
    -- 207 -> 208
    JS_tbls.alphaPoints = {0, 87, 159, 207, 255}

    local joaat = util.joaat
    JS_tbls.effects = {
        ['Explosion'] = {
            exp = 1
        },
        ['Clown Explosion'] = {
            asset  	= 'scr_rcbarry2',
            name	= 'scr_exp_clown',
            colour 	= false,
            exp     = 31,
        },
        ['Clown Appears'] = {
            asset	= 'scr_rcbarry2',
            name 	= 'scr_clown_appears',
            colour  = false,
            exp     = 71,
        },
        ['FW Trailburst'] = {
            asset 	= 'scr_rcpaparazzo1',
            name 	= 'scr_mich4_firework_trailburst_spawn',
            colour 	= true,
            exp     = 66,
        },
        ['FW Starburst'] = {
            asset	= 'scr_indep_fireworks',
            name	= 'scr_indep_firework_starburst',
            colour 	= true,
        },
        ['FW Fountain'] = {
            asset 	= 'scr_indep_fireworks',
            name	= 'scr_indep_firework_fountain',
            colour 	= true,
        },
        ['Alien Disintegration'] = {
            asset	= 'scr_rcbarry1',
            name 	= 'scr_alien_disintegrate',
            colour 	= false,
            exp     = 3,
        },
        ['Clown Flowers'] = {
            asset	= 'scr_rcbarry2',
            name	= 'scr_clown_bul',
            colour 	= false,
        },
        ['FW Ground Burst'] = {
            asset 	= 'proj_indep_firework',
            name	= 'scr_indep_firework_grd_burst',
            colour 	= false,
            exp     = 25,
        }
    }
    local pistolMk2Ammo = {
        [joaat('AMMO_PISTOL_TRACER')]      = 'WCT_CLIP_TR',
        [joaat('AMMO_PISTOL_INCENDIARY')]  = 'WCT_CLIP_INC',
        [joaat('AMMO_PISTOL_HOLLOWPOINT')] = 'WCT_CLIP_HP',
        [joaat('AMMO_PISTOL_FMJ')]         = 'WCT_CLIP_FMJ',
    }
    local rifleMk2Ammo = {
        [joaat('AMMO_RIFLE_TRACER')]        = 'WCT_CLIP_TR',
        [joaat('AMMO_RIFLE_INCENDIARY')]    = 'WCT_CLIP_INC',
        [joaat('AMMO_RIFLE_ARMORPIERCING')] = 'WCT_CLIP_AP',
        [joaat('AMMO_RIFLE_FMJ')]           = 'WCT_CLIP_FMJ',
    }
    JS_tbls.mkIIammoTable = {
        [joaat('weapon_pistol_mk2')] = pistolMk2Ammo,
        [joaat('weapon_snspistol_mk2')] = pistolMk2Ammo,
        [joaat('weapon_revolver_mk2')] = pistolMk2Ammo,
        [joaat('weapon_smg_mk2')] = {
            [joaat('AMMO_SMG_TRACER')]      = 'WCT_CLIP_TR',
            [joaat('AMMO_SMG_INCENDIARY')]  = 'WCT_CLIP_INC',
            [joaat('AMMO_SMG_HOLLOWPOINT')] = 'WCT_CLIP_HP',
            [joaat('AMMO_SMG_FMJ')]         = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_combatmg_mk2')] = {
            [joaat('AMMO_MG_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_MG_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_MG_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_MG_FMJ')]           = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_assaultrifle_mk2')] = rifleMk2Ammo,
        [joaat('weapon_bullpuprifle_mk2')] = {
            [joaat('AMMO_RIFLE_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_RIFLE_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_RIFLE_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_RIFLE_FMJ')]           = 'WCT_CLIP_FMJ',
        },
        [joaat('weapon_carbinerifle_mk2')] = rifleMk2Ammo,
        [joaat('weapon_specialcarbine_mk2')] = rifleMk2Ammo,
        [joaat('weapon_pumpshotgun_mk2')] = {
            [joaat('AMMO_SHOTGUN_INCENDIARY')]    = 'WCT_SHELL_INC',
            [joaat('AMMO_SHOTGUN_HOLLOWPOINT')]   = 'WCT_SHELL_HP',
            [joaat('AMMO_SHOTGUN_ARMORPIERCING')] = 'WCT_SHELL_AP',
            [joaat('AMMO_SHOTGUN_EXPLOSIVE')]     = 'WCT_SHELL_EX',
        },
        [joaat('weapon_heavysniper_mk2')] = {
            [joaat('AMMO_SNIPER_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_SNIPER_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_SNIPER_FMJ')]           = 'WCT_CLIP_FMJ',
            [joaat('AMMO_SNIPER_EXPLOSIVE')]     = 'WCT_CLIP_EX',
        },
        [joaat('weapon_marksmanrifle_mk2')] = {
            [joaat('AMMO_SNIPER_TRACER')]        = 'WCT_CLIP_TR',
            [joaat('AMMO_SNIPER_INCENDIARY')]    = 'WCT_CLIP_INC',
            [joaat('AMMO_SNIPER_ARMORPIERCING')] = 'WCT_CLIP_AP',
            [joaat('AMMO_SNIPER_FMJ')]           = 'WCT_CLIP_FMJ',
        },
    }
    local vehWeaponLabels = {
        missiles = 'WT_V_PLANEMSL',
        machineGun = 'WT_V_TURRET',
        machineGun2 = 'WT_V_PLRBUL', --returns the same text as the one above
        cannon  = 'WT_V_LZRCAN',
        rockets = 'WT_V_SPACERKT',
        tankCannon = 'WT_V_TANK',
        laser = 'WT_V_PLRLSR',
        grenadeLauncher = 'WT_V_KHA_GL',
        minigun = 'WT_MINIGUN',
        flameThrower = 'WT_V_FLAME',
        dual50cal = 'WT_V_MG50_2',
        dualLasers = 'WT_V_MG50_2L',
        explosiveCannon = 'WT_V_ROG_CANN',
        mine = 'WT_VEHMINE',
    }
    --i assume many of these are accurate, but many of them aren't tested
    JS_tbls.vehicleWeaponHashToLabel = {
        [joaat('vehicle_weapon_cannon_blazer')] = vehWeaponLabels.machineGun2, --tested
        [joaat('vehicle_weapon_enemy_laser')] = 'WT_A_ENMYLSR',
        [joaat('vehicle_weapon_plane_rocket')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_player_bullet')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_buzzard')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_hunter')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_player_laser')] = vehWeaponLabels.laser,
        [joaat('vehicle_weapon_player_lazer')] = vehWeaponLabels.cannon,   --tested on the hydra, and lazer
        [joaat('vehicle_weapon_rotors')] = 'WT_INVALID',
        [joaat('vehicle_weapon_ruiner_bullet')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_ruiner_rocket')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_searchlight')] = 'WT_INVALID',
        [joaat('vehicle_weapon_radar')] = 'WT_INVALID',
        [joaat('vehicle_weapon_space_rocket')] = vehWeaponLabels.missiles, --tested on seasparrow, seems weird that it isnt rocket
        [joaat('vehicle_weapon_turret_boxville')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_tank')] = vehWeaponLabels.tankCannon,          --tested
        [joaat('vehicle_weapon_akula_missile')] = vehWeaponLabels.missiles,
        [joaat('vehicle_weapon_ardent_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_comet_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_granger2_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_menacer_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_nightshark_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_revolter_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_savestra_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_viseris_mg')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_akula_turret_single')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_avenger_cannon')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_mobileops_cannon')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_akula_minigun')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_insurgent_minigun')] = vehWeaponLabels.minigun,   --tested
        [joaat('vehicle_weapon_technical_minigun')] = vehWeaponLabels.minigun,
        [joaat('vehicle_weapon_brutus_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_dominator4_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_impaler2_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_imperator_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_slamvan4_50cal')] = vehWeaponLabels.dual50cal, --tested
        [joaat('vehicle_weapon_zr380_50cal')] = vehWeaponLabels.dual50cal,   --tested
        [joaat('vehicle_weapon_brutus2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_impaler3_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_imperator2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_slamvan5_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_zr3802_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_dominator5_50cal_laser')] = vehWeaponLabels.dualLasers,
        --pretty much 99% accurate
        [joaat('vehicle_weapon_khanjali_cannon_heavy')] = 'WT_V_KHA_HCA',
        [joaat('vehicle_weapon_khanjali_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_khanjali_mg')] = 'WT_V_KHA_MG',
        [joaat('vehicle_weapon_khanjali_cannon')] = 'WT_V_KHA_CA',
        [joaat('vehicle_weapon_volatol_dualmg')] = 'WT_V_VOL_MG',
        [joaat('vehicle_weapon_akula_barrage')] = 'WT_V_AKU_BA',
        [joaat('vehicle_weapon_akula_turret_dual')] = 'WT_V_AKU_TD',
        [joaat('vehicle_weapon_tampa_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_tampa_dualminigun')] = 'WT_V_TAM_DMINI',
        [joaat('vehicle_weapon_tampa_fixedminigun')] = 'WT_V_TAM_FMINI',
        [joaat('vehicle_weapon_tampa_mortar')] = 'WT_V_TAM_MORT',
        [joaat('vehicle_weapon_apc_cannon')] = 'WT_V_APC_C',
        [joaat('vehicle_weapon_apc_missile')] = 'WT_V_APC_M',
        [joaat('vehicle_weapon_apc_mg')] = 'WT_V_APC_S',
        [joaat('vehicle_weapon_kosatka_torpedo')] = 'WT_V_KOS_TO',
        [joaat('vehicle_weapon_seasparrow2_minigun')] = 'WT_V_SPRW_MINI',
        [joaat('vehicle_weapon_annihilator2_barrage')] = 'WT_V_ANTOR_BA',
        [joaat('vehicle_weapon_annihilator2_missile')] = 'WT_V_ANTOR_MI',
        [joaat('vehicle_weapon_annihilator2_mini')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_rctank_gun')] = 'WT_V_RCT_MG',
        [joaat('vehicle_weapon_rctank_flame')] = 'WT_V_RCT_FL',
        [joaat('vehicle_weapon_rctank_rocket')] = 'WT_V_RCT_RK',
        [joaat('vehicle_weapon_rctank_lazer')] = 'WT_V_RCT_LZ',
        [joaat('vehicle_weapon_cherno_missile')] = 'WT_V_CHE_MI',
        [joaat('vehicle_weapon_barrage_top_mg')] = 'WT_V_BAR_TMG',
        [joaat('vehicle_weapon_barrage_top_minigun')] = 'WT_V_BAR_TMI',
        [joaat('vehicle_weapon_barrage_rear_mg')] = 'WT_V_BAR_RMG',
        [joaat('vehicle_weapon_barrage_rear_minigun')] = 'WT_V_BAR_RMI',
        [joaat('vehicle_weapon_barrage_rear_gl')] = 'WT_V_BAR_RGL',
        [joaat('vehicle_weapon_deluxo_mg')] = 'WT_V_DEL_MG',
        [joaat('vehicle_weapon_deluxo_missile')] = 'WT_V_DEL_MI',
        [joaat('vehicle_weapon_subcar_mg')] = 'WT_V_SUB_MG',
        [joaat('vehicle_weapon_subcar_missile')] = 'WT_V_SUB_MI',
        [joaat('vehicle_weapon_subcar_torpedo')] = 'WT_V_SUB_TO',
        [joaat('vehicle_weapon_thruster_mg')] = 'WT_V_THR_MG',
        [joaat('vehicle_weapon_thruster_missile')] = 'WT_V_THR_MI',
        [joaat('vehicle_weapon_mogul_nose')] = 'WT_V_MOG_NOSE',
        [joaat('vehicle_weapon_mogul_dualnose')] = 'WT_V_MOG_DNOSE',
        [joaat('vehicle_weapon_mogul_dualturret')] = 'WT_V_MOG_DTURR',
        [joaat('vehicle_weapon_mogul_turret')] = 'WT_V_MOG_TURR',
        [joaat('vehicle_weapon_tula_mg')] = 'WT_V_TUL_MG',
        [joaat('vehicle_weapon_tula_minigun')] = 'WT_V_TUL_MINI',
        [joaat('vehicle_weapon_tula_nosemg')] = 'WT_V_TUL_NOSE',
        [joaat('vehicle_weapon_tula_dualmg')] = 'WT_V_TUL_DUAL',
        [joaat('vehicle_weapon_vigilante_mg')] = 'WT_V_VGL_MG',
        [joaat('vehicle_weapon_vigilante_missile')] = 'WT_V_VGL_MISS',
        [joaat('vehicle_weapon_seabreeze_mg')] = 'WT_V_SBZ_MG',
        [joaat('vehicle_weapon_bombushka_cannon')] = 'WT_V_BSHK_CANN',
        [joaat('vehicle_weapon_bombushka_dualmg')] = 'WT_V_BSHK_DUAL',
        [joaat('vehicle_weapon_hunter_mg')] = 'WT_V_HUNT_MG',
        [joaat('vehicle_weapon_hunter_missile')] = 'WT_V_HUNT_MISS',
        [joaat('vehicle_weapon_hunter_barrage')] = 'WT_V_HUNT_BARR',
        [joaat('vehicle_weapon_hunter_cannon')] = 'WT_V_HUNT_CANN',
        [joaat('vehicle_weapon_microlight_mg')] = 'WT_V_MCRL_MG',
        [joaat('vehicle_weapon_caracara_mg')] = 'WT_V_TURRET',
        [joaat('vehicle_weapon_caracara_minigun')] = 'WT_V_TEC_MINI',
        [joaat('vehicle_weapon_deathbike_dualminigun')] = 'WT_V_DBK_MINI',
        [joaat('vehicle_weapon_deathbike2_minigun_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_trailer_quadmg')] = 'WT_V_TR_QUADMG',
        [joaat('vehicle_weapon_trailer_dualaa')] = 'WT_V_TR_DUALAA',
        [joaat('vehicle_weapon_trailer_missile')] = 'WT_V_TR_MISS',
        [joaat('vehicle_weapon_halftrack_dualmg')] = 'WT_V_HT_DUALMG',
        [joaat('vehicle_weapon_halftrack_quadmg')] = 'WT_V_HT_QUADMG',
        [joaat('vehicle_weapon_oppressor_mg')] = 'WT_V_OP_MG',
        [joaat('vehicle_weapon_oppressor_missile')] = 'WT_V_OP_MISS',
        [joaat('vehicle_weapon_dune_mg')] = 'WT_V_DU_MG',
        [joaat('vehicle_weapon_dune_grenadelauncher')] = 'WT_V_DU_GL',
        [joaat('vehicle_weapon_dune_minigun')] = 'WT_V_DU_MINI',
        [joaat('vehicle_weapon_nose_turret_valkyrie')] = vehWeaponLabels.machineGun2,
        [joaat('vehicle_weapon_turret_valkyrie')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_turret_technical')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_player_savage')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_turret_limo')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_speedo4_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_speedo4_turret_mg')] = 'WT_V_SPD_TMG',
        [joaat('vehicle_weapon_speedo4_turret_mini')] = 'WT_V_SPD_TMI',
        [joaat('vehicle_weapon_pounder2_mini')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_pounder2_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_pounder2_barrage')] = 'WT_V_POU_BA',
        [joaat('vehicle_weapon_pounder2_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_rogue_mg')] = 'WT_V_ROG_MG',
        [joaat('vehicle_weapon_rogue_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_rogue_missile')] = 'WT_V_ROG_MISS',
        [joaat('vehicle_weapon_monster3_glkin')] = 'WT_V_GREN_KIN',
        [joaat('vehicle_weapon_mortar_kinetic')] = 'WT_V_MORTAR_KIN', --??? idk
        [joaat('vehicle_weapon_mortar_explosive')] = 'WT_V_TAM_MORT', --??? idk
        [joaat('vehicle_weapon_scarab_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_scarab2_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_strikeforce_barrage')] = 'WT_V_HUNT_BARR',
        [joaat('vehicle_weapon_strikeforce_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_strikeforce_missile')] = 'WT_V_HUNT_MISS',
        [joaat('vehicle_weapon_hacker_missile')] = vehWeaponLabels.cannon, --(hacker means terrorbyte, im gonna have to test if these are accuate)
        [joaat('vehicle_weapon_hacker_missile_homing')] = vehWeaponLabels.cannon,
        [joaat('vehicle_weapon_flamethrower')] = vehWeaponLabels.flameThrower,     --tested
        [joaat('vehicle_weapon_flamethrower_scifi')] = vehWeaponLabels.flameThrower,    --tested, this is the flamethrower on the future shock cerberus
        [joaat('vehicle_weapon_havok_minigun')] = 'WT_V_HAV_MINI',
        [joaat('vehicle_weapon_dogfighter_mg')] = 'WT_V_DGF_MG',
        [joaat('vehicle_weapon_dogfighter_missile')] = 'WT_V_DGF_MISS',
        [joaat('vehicle_weapon_paragon2_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_scramjet_mg')] = 'WT_V_VGL_MG',
        [joaat('vehicle_weapon_scramjet_missile')] = 'WT_V_VGL_MISS',
        [joaat('vehicle_weapon_oppressor2_mg')] = 'WT_V_OP_MG',
        [joaat('vehicle_weapon_oppressor2_cannon')] = vehWeaponLabels.explosiveCannon,
        [joaat('vehicle_weapon_oppressor2_missile')] = 'WT_V_OP_MISS',
        [joaat('vehicle_weapon_mule4_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_mule4_missile')] = 'WT_V_TAM_MISS',
        [joaat('vehicle_weapon_mule4_turret_gl')] = vehWeaponLabels.grenadeLauncher,
        [joaat('vehicle_weapon_mine')] = vehWeaponLabels.mine, --unsure about these mines
        [joaat('vehicle_weapon_mine_emp')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_emp_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_kinetic')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_kinetic_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_slick')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_slick_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_spike')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_spike_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_tar')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_mine_tar_rc')] = vehWeaponLabels.mine,
        [joaat('vehicle_weapon_issi4_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_issi5_50cal_laser')] = vehWeaponLabels.dualLasers,
        [joaat('vehicle_weapon_turret_insurgent')] = vehWeaponLabels.machineGun,
        [joaat('vehicle_weapon_jb700_mg')] = 'WT_V_COM_MG',
        [joaat('vehicle_weapon_patrolboat_dualmg')] = 'WT_V_PAT_DUAL',
        [joaat('vehicle_weapon_turret_dinghy5_50cal')] = 'WT_V_PAT_TURRET',
        [joaat('vehicle_weapon_turret_patrolboat_50cal')] = 'WT_V_PAT_TURRET',
        [joaat('vehicle_weapon_bruiser_50cal')] = vehWeaponLabels.dual50cal,
        [joaat('vehicle_weapon_bruiser2_50cal_laser')] = vehWeaponLabels.dualLasers,
    }
    JS_tbls.vehicleWeaponHashToString = {
        [joaat('vehicle_weapon_bomb')] = 'Bomb',
        [joaat('vehicle_weapon_bomb_cluster')] = 'Cluster Bomb',
        [joaat('vehicle_weapon_bomb_gas')] = 'Gas Bomb',
        [joaat('vehicle_weapon_bomb_incendiary')] = 'Incendiary Bomb',
        [joaat('vehicle_weapon_bomb_standard_wide')] = 'Standard Wide Bomb',
        [joaat('vehicle_weapon_sub_missile_homing')] = 'Homing Missiles',
        [joaat('vehicle_weapon_water_cannon')] = 'Water Cannon',
    }
end

-- JS functions

----------------------------------
-- table functions
----------------------------------
    local function toFloat(num)
        return (num / 10) * 10
    end

    --og function written by me
    local function removeValues(t, removeT)
        for _, r in ipairs(removeT) do
            for i, v in ipairs(t) do
                if v == r then
                    table.remove(t, i)
                end
            end
        end
    end

    --this function is from wiriScripts functions
    local function pairsByKeys(t, f)
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0
        local iter = function()
            i += 1
            if a[i] == nil then return nil
            else return a[i], t[a[i]]
            end
        end
        return iter
    end

----------------------------------
-- Misc
----------------------------------
    local function getLatestRelease()
        local version
        async_http.init('api.github.com', '/repos/Jerrrry123/JerryScript/tags', function(res)
            for match in string.gmatch(res, '"(.-)"') do
                local firstCharacter = string.sub(match, 0, 1)
                if tonumber(firstCharacter) then
                    version = match
                    break
                end
            end
        end, function()
            JSlang.toast('Failed to get latest release.')
            version = ''
        end)
        async_http.dispatch()
        while version == nil do util.yield_once() end
        return version
    end

    --returns weather or not the user is in the current vehicles drivers seat
    local function is_user_driving_vehicle()
        return (PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and VEHICLE.GET_PED_IN_VEHICLE_SEAT(entities.get_user_vehicle_as_handle(), -1, false) == players.user_ped())
    end

    local function loadModel(hash)
        STREAMING.REQUEST_MODEL(hash)
        while not STREAMING.HAS_MODEL_LOADED(hash) do util.yield_once() end
    end

    local function getTotalDelay(delayTable)
        return (delayTable.ms + (delayTable.s * 1000) + (delayTable.min * 1000 * 60))
    end

    local function startBusySpinner(message)
        HUD.BEGIN_TEXT_COMMAND_BUSYSPINNER_ON('STRING')
        HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(message)
        HUD.END_TEXT_COMMAND_BUSYSPINNER_ON(5)
    end

    local new = {}

    function new.colour(R, G, B, A)
        return {r = R / 255, g = G / 255, b = B / 255, a = A or 1}
    end

    function new.hudSettings(X, Y, ALIGNMENT)
        return {xOffset = X, yOffset = Y, scale = 0.5, alignment = ALIGNMENT, textColour = new.colour( 255, 255, 255 )}
    end

    function new.delay(MS, S, MIN)
        return {ms = MS, s = S, min = MIN}
    end

----------------------------------
-- Memory
----------------------------------
    --function skidded from murtens utils
    local function address_from_pointer_chain(address, offsets)
        local addr = address
        for k = 1, (#offsets - 1) do
            addr = memory.read_long(addr + offsets[k])
            if addr == 0 then
                return 0
            end
        end
        addr += offsets[#offsets]
        return addr
    end

    --memory stuff skidded from heist control
    local Int_PTR = memory.alloc_int()

    local function getMPX()
        return 'MP'.. util.get_char_slot() ..'_'
    end

    local function STAT_GET_INT(Stat)
        STATS.STAT_GET_INT(util.joaat(getMPX() .. Stat), Int_PTR, -1)
        return memory.read_int(Int_PTR)
    end

    local function STAT_GET_INT_MPPLY(Stat)
        STATS.STAT_GET_INT(util.joaat(Stat), Int_PTR, -1)
        return memory.read_int(Int_PTR)
    end

    local function STAT_GET_FLOAT(Stat)
        STATS.STAT_GET_FLOAT(util.joaat(getMPX() .. Stat), Int_PTR, true)
        return memory.read_float(Int_PTR)
    end

    local function STAT_SET_INCREMENT(Stat, Value)
        STATS.STAT_INCREMENT(util.joaat(getMPX() .. Stat), Value)
    end

    local function GET_INT_GLOBAL(Global)
        return memory.read_int(memory.script_global(Global))
    end

----------------------------------
-- Whitelist
----------------------------------
    --returns a table of all players that aren't whitelisted
    local function getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        local playerList = players.list(whitelistGroups.user, whitelistGroups.friends, whitelistGroups.strangers)
        local notWhitelisted = {}
        for i = 1, #playerList do
            if not whitelistListTable[playerList[i]] and not (players.get_name(playerList[i]) == whitelistedName) then
                notWhitelisted[#notWhitelisted + 1] = playerList[i]
            end
        end
        return notWhitelisted
    end

----------------------------------
-- Generating menu options
----------------------------------
    local function getLabelTableFromKeys(keyTable)
        local labelTable = {}
        for k, v in pairsByKeys(keyTable) do
            table.insert(labelTable, {k})
        end
        return labelTable
    end

    local function generateHudSettings(root, prefix, settingsTable)
        JSlang.slider(root, 'X 位置', {prefix..'XPos'}, '', -200, 0, settingsTable.xOffset, 1, function(value)
            settingsTable.xOffset = value
        end)
        JSlang.slider(root, 'Y 位置', {prefix..'YPos'}, '', -5, 195, settingsTable.yOffset, 1, function(value)
            settingsTable.yOffset = value
        end)
        JSlang.slider(root, 'Scale', {prefix..'scale'}, '文字大小', 200, 1500, 500, 1, function(value)
            settingsTable.scale = value / 1000
        end)
        JSlang.slider(root, '文本对齐', {prefix..'alignment'}, '1居中,2居左,3居右.', 1, 3, settingsTable.alignment, 1, function(value)
            settingsTable.alignment = value
        end)
        JSlang.colour(root, '文本颜色', {prefix..'colour'}, '设置文本覆盖的颜色.', settingsTable.textColour, true, function(colour)
            settingsTable.textColour = colour
        end)
    end

    local function generateDelaySettings(root, name, delayTable)
        JSlang.slider(root, '毫秒', {'JS'..name..'DelayMs'}, '延迟是毫秒、秒和最小值的总和.', 1, 999, delayTable.ms, 1, function(value)
            delayTable.ms = value
        end)
        JSlang.slider(root, '秒', {'JS'..name..'DelaySec'}, '延迟是毫秒、秒和最小值的总和.', 0, 59, delayTable.s, 1, function(value)
            delayTable.s = value
        end)
        JSlang.slider(root, '分钟', {'JS'..name..'DelayMin'}, '延迟是毫秒、秒和最小值的总和.', 0, 60, delayTable.min, 1, function(value)
            delayTable.min = value
        end)
    end

    local function generateToggles(table, root, reversed)
        for i = 1, #table do
            if not reversed then
                JSlang.toggle(root, table[i].name, {table[i].command}, table[i].description, function(toggle)
                    table[i].toggle = toggle
                end, table[i].toggle)
            else
                JSlang.toggle(root, table[i].name, {table[i].command}, table[i].description, function(toggle)
                    table[i].toggle = not toggle
                end, not table[i].toggle)
            end

        end
    end

    function menu.mutually_exclusive_toggle(root, name, commands, help, exclusive_toggles, func)
        local this_toggle
        this_toggle = JSlang.toggle(root, name, commands, help, function(toggle)
            if toggle then
                for _, ref in pairs(exclusive_toggles) do
                    if ref != this_toggle and menu.get_value(ref) then
                        menu.set_value(ref, false)
                    end
                end
            end
            func(toggle)
        end)
        return this_toggle
    end

    local function is_any_exclusive_toggle_on(exclusive_toggles)
        local on = false

        for _, ref in pairs(exclusive_toggles) do
            on = menu.get_value(ref)
            if on then break end
        end

        return on
    end

    --only warns on the first opening, credit to sai for providing this workaround
    local function listWarning(listRoot, firstOpening)
        if not firstOpening[1] then return end
        menu.show_warning(listRoot, CLICK_MENU, JSlang.str_trans('我不能保证这些选项是100%安全的. 我在我的大号测试了它们,但我太蠢了.'), function()
            firstOpening[1] = false
            menu.focus(listRoot, '')
        end)
    end

    function string.capitalize(str)
        return str:sub(1,1):upper()..str:sub(2):lower()
    end

----------------------------------
-- Stuff for aiming and guns
----------------------------------
    --aiming functions are skidded from lanceScript, credit to nowiry for probably helping lance with them
    local function get_offset_from_gameplay_camera(distance)
        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(2)
        local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
        local direction = v3.toDir(cam_rot)
        local destination = v3(direction)
        destination:mul(distance)
        destination:add(cam_pos)

        return destination
    end

    local function raycast_gameplay_cam(distance)
        local result = {}
        local didHit = memory.alloc(1)
        local endCoords = v3()
        local surfaceNormal = v3()
        local hitEntity = memory.alloc_int()

        local cam_rot = CAM.GET_GAMEPLAY_CAM_ROT(2)
        local cam_pos = CAM.GET_GAMEPLAY_CAM_COORD()
        local direction = v3.toDir(cam_rot)

        local destination = v3(direction)
        destination:mul(distance)
        destination:add(cam_pos)

        local handle = SHAPETEST.START_EXPENSIVE_SYNCHRONOUS_SHAPE_TEST_LOS_PROBE(cam_pos, destination, -1, players.user_ped(), 4)
        SHAPETEST.GET_SHAPE_TEST_RESULT(handle, didHit, memory.addrof(endCoords), memory.addrof(surfaceNormal), hitEntity)

        result.didHit = memory.read_byte(didHit) ~= 0
        result.endCoords = endCoords
        result.surfaceNormal = surfaceNormal
        result.hitEntity = memory.read_int(hitEntity)
        return result
    end

    local function direction(offset)
        local c1 = get_offset_from_gameplay_camera(offset or 5)
        local res = raycast_gameplay_cam(1000)
        local c2

        if res.didHit then
            c2 = res.endCoords
        else
            c2 = get_offset_from_gameplay_camera(1000)
        end
        c2:sub(c1)
        c2:mul(1000)

        return c2, c1
    end

----------------------------------
-- Functions for exploding a player
----------------------------------
    local function addFx(pos, currentFx, colour)
        STREAMING.REQUEST_NAMED_PTFX_ASSET(currentFx.asset)
        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(currentFx.asset) do util.yield_once() end
        GRAPHICS.USE_PARTICLE_FX_ASSET(currentFx.asset)
        if currentFx.colour then
            GRAPHICS.SET_PARTICLE_FX_NON_LOOPED_COLOUR(colour.r, colour.g, colour.b)
        end
        GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
            currentFx.name,
            pos,
            0,
            0,
            0,
            1.0,
            false, false, false, false
        )
    end

    local function explosion(pos, expSettings)
        if expSettings.currentFx then
            if expSettings.currentFx.exp then
                FIRE.ADD_EXPLOSION(pos, expSettings.currentFx.exp, 10.0, expSettings.audible, true, 0, expSettings.noDamage)
                FIRE.ADD_EXPLOSION(pos, 1, 10.0, false, true, expSettings.camShake, expSettings.noDamage)
            else
                FIRE.ADD_EXPLOSION(pos, 1, 10.0, false, true, expSettings.camShake, expSettings.noDamage)
            end
            if not expSettings.invisible then
                addFx(pos, expSettings.currentFx, expSettings.colour)
            end
        else
            FIRE.ADD_EXPLOSION(pos, 1, 10.0, expSettings.audible, expSettings.invisible, expSettings.camShake, expSettings.noDamage)
        end
    end

    local function ownedExplosion(ped, pos, expSettings)
        if expSettings.currentFx then
            if expSettings.currentFx.exp then
                FIRE.ADD_OWNED_EXPLOSION(ped, pos, expSettings.currentFx.exp, 10.0, expSettings.audible, true, expSettings.camShake)
                FIRE.ADD_OWNED_EXPLOSION(ped, pos, 1, 10.0, false, true, expSettings.camShake)
            else
                FIRE.ADD_OWNED_EXPLOSION(ped, pos, 1, 10.0, false, true, expSettings.camShake)
            end
            if not expSettings.invisible then
                addFx(pos, expSettings.currentFx, expSettings.colour)
            end
        else
            FIRE.ADD_OWNED_EXPLOSION(ped, pos, 1, 10.0, expSettings.audible, expSettings.invisible, expSettings.camShake)
        end
    end

    local function explodePlayer(ped, loop, expSettings)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        --if any blame is enabled this decides who should be blamed
        local blamedPlayer = players.user_ped()
        if expSettings.blamedPlayer and expSettings.blamed then
            blamedPlayer = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(expSettings.blamedPlayer)
        elseif expSettings.blamed then
            local playerList = players.list(true, true, true)
            blamedPlayer = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[math.random(1, #playerList)])
        end
        if not loop and PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            for i = 0, 50, 1 do --50 explosions to account for most armored vehicles
                if expSettings.owned or expSettings.blamed then
                    ownedExplosion(blamedPlayer, pos, expSettings)
                else
                    explosion(pos, expSettings)
                end
                util.yield(10)
            end
        elseif expSettings.owned or expSettings.blamed then
            ownedExplosion(blamedPlayer, pos, expSettings)
        else
            explosion(pos, expSettings)
        end
        util.yield(10)
    end

----------------------------------
-- player info functions
----------------------------------
    function getMk2Rounds(ped, weaponHash)
        local ammoType = WEAPON.GET_PED_AMMO_TYPE_FROM_WEAPON(ped, weaponHash)
        if JS_tbls.mkIIammoTable[weaponHash] and JS_tbls.mkIIammoTable[weaponHash][ammoType] then
            return util.get_label_text(JS_tbls.mkIIammoTable[weaponHash][ammoType])
        end
    end

    JS_tbls.weaponTypes = {
        [0] = 'Unknown',
        [1] = 'No damage',
        [2] = 'Melee',
        [3] = function(ped, weaponHash)
                return getMk2Rounds(ped, weaponHash) or 'Bullets'
            end,
        [4] = 'Force ragdoll fall',
        [5] = 'Explosive',
        [6] = 'Fire',
        [8] = 'Fall',
        [10] = 'Electric',
        [11] = 'Barbed wire',
        [12] = 'Extinguisher',
        [13] = 'Gas',
        [14] = 'Water',
    }

    local function getDamageType(ped, weaponHash)
        local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)

        local final = JS_tbls.weaponTypes[damageType]
        return type(final) == 'string' and final or final(ped, weaponHash)
    end

    local function getWeaponHash(ped)
        local wpn_ptr = memory.alloc_int()
        if WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(ped, wpn_ptr) then -- only returns true if the weapon is a vehicle weapon
            return memory.read_int(wpn_ptr), true
        end
        return WEAPON.GET_SELECTED_PED_WEAPON(ped), false
    end

    local function getWeaponName(weaponHash)
        if JS_tbls.vehicleWeaponHashToLabel[weaponHash] then
            return util.get_label_text(JS_tbls.vehicleWeaponHashToLabel[weaponHash])
        elseif JS_tbls.vehicleWeaponHashToString[weaponHash] then
            return JS_tbls.vehicleWeaponHashToString[weaponHash]
        else
            for k, v in pairs(util.get_weapons()) do
                if v.hash == weaponHash then
                    return util.get_label_text(v.label_key)
                end
            end
        end
    end

    local function getPlayerVehicleName(ped)
        local playersVehicle = PED.GET_VEHICLE_PED_IS_IN(ped)
        local vehHash = ENTITY.GET_ENTITY_MODEL(playersVehicle)
        if vehHash == 0 then return end
        return util.get_label_text(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(vehHash))
    end

    local function isMoving(ped)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, true) and ENTITY.GET_ENTITY_SPEED(ped) > 1 then return true end
        if ENTITY.GET_ENTITY_SPEED(PED.GET_VEHICLE_PED_IS_IN(ped, false)) > 1 then return true end
    end

    local taskTable = {
        [1] = {1,  JSlang.str_trans('爬梯')},
        [2] = {2,  JSlang.str_trans('离开载具')},
        [3] = {160,  JSlang.str_trans('进入载具')},
        [4] = {335, JSlang.str_trans('跳伞')},
        [5] = {422,  JSlang.str_trans('跳跃')},
        [6] = {423,  JSlang.str_trans('坠落')},
    }
    local function getMovementType(ped)
        if PED.IS_PED_RAGDOLL(ped) then
            return  JSlang.str_trans('摔倒')
        elseif PED.IS_PED_CLIMBING(ped) then
            return  JSlang.str_trans('攀登')
        elseif PED.IS_PED_VAULTING(ped) then
            return  JSlang.str_trans('越过障碍物')
        end
        for i = 1, #taskTable do
            if TASK.GET_IS_TASK_ACTIVE(ped, taskTable[i][1]) then return taskTable[i][2] end
        end
        if not isMoving(ped) then return end
        if PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            if PED.IS_PED_IN_ANY_PLANE(ped) then
                return  JSlang.str_trans('驾驶飞机')
            elseif PED.IS_PED_IN_ANY_HELI(ped) then
                return  JSlang.str_trans('驾驶直升机')
            elseif PED.IS_PED_IN_ANY_BOAT(ped) then
                return  JSlang.str_trans('驾驶船只')
            elseif PED.IS_PED_IN_ANY_SUB(ped) then
                return  JSlang.str_trans('驾驶潜艇')
            elseif PED.IS_PED_ON_ANY_BIKE(ped) then
                return  JSlang.str_trans('驾驶摩托车/自行车')
            end
            return  JSlang.str_trans('驾驶')
        elseif PED.IS_PED_SWIMMING(ped) then
            return  JSlang.str_trans('游泳')
        elseif TASK.IS_PED_STRAFING(ped) then
            return  JSlang.str_trans('扫射')
        elseif TASK.IS_PED_SPRINTING(ped) then
            return  JSlang.str_trans('冲刺')
        elseif PED.GET_PED_STEALTH_MOVEMENT(ped) then
            return  JSlang.str_trans('潜行')
        elseif TASK.IS_PED_GETTING_UP(ped) then
            return  JSlang.str_trans('起身')
        elseif PED.IS_PED_GOING_INTO_COVER(ped) then
            return  JSlang.str_trans('进入掩护')
        elseif PED.IS_PED_IN_COVER(ped) then
            return  JSlang.str_trans('在掩体中移动')
        else
            return  JSlang.str_trans('移动')
        end
    end

----------------------------------
-- Safe monitor functions
----------------------------------
    local function getNightclubDailyEarnings()
        local popularity = math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)
        if popularity == 100 then return 50000
        elseif popularity >= 90 then return 45000
        elseif popularity >= 80 then return 24000
        elseif popularity >= 70 then return 22000
        elseif popularity >= 60 then return 20000
        elseif popularity >= 50 then return 9500
        elseif popularity >= 40 then return 8500
        elseif popularity >= 30 then return 2500
        elseif popularity >= 20 then return 2000
        elseif popularity >= 10 then return 1600
        else return 1500
        end
    end

    local function getAgencyDailyEarnings(securityContracts)
        if securityContracts >= 200 then return 20000 end
        return math.floor(securityContracts / 5) * 500
    end

----------------------------------
-- Dirs and colors setup
----------------------------------

local script_store_dir = filesystem.store_dir() ..'JerryScript\\'
if not filesystem.is_dir(script_store_dir) then
    filesystem.mkdirs(script_store_dir)
end

local face_profiles_dir = script_store_dir ..'Face Feature Profiles\\'
if not filesystem.is_dir(face_profiles_dir) then
    filesystem.mkdirs(face_profiles_dir)
end

local lang_dir = script_store_dir ..'Language\\'
if not filesystem.is_dir(lang_dir) then
    filesystem.mkdirs(lang_dir)
end

local JS_logo = directx.create_texture(filesystem.resources_dir() ..'JS.png')

local darkBlue = new.colour( 0, 0, 12 )
local black = new.colour( 0, 0, 1 )
local white = new.colour( 255, 255, 255 )
local mildOrangeFire = new.colour( 255, 127, 80 )

local levitationCommand = menu.ref_by_path('Self>Movement>Levitation>Levitation', 38)

----------------------------------
-- Start message
----------------------------------
    local function rotatePoint(x, y, center, degrees)

        local radians = math.rad(degrees)

        local new_x = (x - center.x) * math.cos(radians) - (y - center.y) * math.sin(radians)
        local new_y = (x - center.x) * math.sin(radians) + (y - center.y) * math.cos(radians)

        return center.x + new_x, center.y + new_y * 1920 / 1080
    end

    function directx.draw_triangle_from_center_point(center, base, rotDegrees, colour)
        local halfHeight = (base * 0.866) / 2
        local halfBase = base / 2

        local tx, ty = rotatePoint(center.x, center.y - halfBase, center, rotDegrees)
        local lx, ly = rotatePoint(center.x - halfBase, center.y + halfHeight, center, rotDegrees)
        local rx, ry = rotatePoint(center.x + halfBase, center.y + halfHeight, center, rotDegrees)

        directx.draw_triangle(tx, ty --[[top]], lx, ly --[[left]], rx, ry --[[right]], colour)
    end

    function directx.draw_circle(center, diameter, colour)
        for i = 0, 260 do
            directx.draw_triangle_from_center_point(center, diameter, i, colour)
        end
    end

    function directx.draw_rect_with_rounded_corner(x, y, width, height, colour)
        directx.draw_circle({ x = x + width, y = y + height / 2 }, (height / 2.35), colour)
        directx.draw_rect(x, y, width, height, colour)
    end

    if not SCRIPT_SILENT_START then
        util.create_thread(function()
            local js_size = 0.017

            local l = 1
            while l < 50 do
                directx.draw_texture(JS_logo, js_size, js_size, 0.5, 0.5, 0.5, (1 - l / 250) + 0.03, 0, {r = 1, g = 1, b = 1, a = l / 50})
                util.yield_once()
                l += 5 - math.abs(math.floor(l / 10))
            end

            l = 1
            while l < 50 do
                directx.draw_rect_with_rounded_corner(0.5 - l / 500, 0.8, l / 250, 0.06, darkBlue)
                directx.draw_texture(JS_logo, js_size, js_size, 0.5, 0.5, 0.5 - l / 500, 0.83, 0, white)
                util.yield_once()
                l += 5 - math.abs(math.floor(l / 10))
            end

            AUDIO.PLAY_SOUND(-1, 'signal_on', 'DLC_GR_Ambushed_Sounds', 0, 0, 1)

            for i = 1, 360 do
                directx.draw_rect_with_rounded_corner(0.4, 0.8, 0.2, 0.06, darkBlue)
                directx.draw_texture(JS_logo, js_size, js_size, 0.5, 0.5, 0.4, 0.83, i / 360, white)
                if i < 150 then
                    directx.draw_text(0.5, 0.81 + (i / 25000), JSlang.str_trans('Achievement Unlocked'), ALIGN_TOP_CENTRE, 0.6, white, false)
                elseif i > 170 then
                    directx.draw_text(0.5, 0.81 + ((i - 150) / 25000), JSlang.str_trans('Load JerryScript'), ALIGN_TOP_CENTRE, 0.6, white, false)
                end
                util.yield_once()
            end

            l = 50
            while l >= 0 do
                directx.draw_rect_with_rounded_corner(0.5 - l / 500, 0.8, l / 250, 0.06, darkBlue)
                directx.draw_texture(JS_logo, js_size, js_size, 0.5, 0.5, 0.5 - l / 500, 0.83, 0, white)
                util.yield_once()
                l -= 6 - math.abs(math.floor(l / 10))
            end

            l = 50
            while l >= 0 do
                directx.draw_texture(JS_logo, js_size, js_size, 0.5, 0.5, 0.5, (1 - l / 250) + 0.03, 0, {r = 1, g = 1, b = 1, a = l / 50})
                util.yield_once()
                l -= 6 - math.abs(math.floor(l / 10))
            end
        end)
    end
----------------------------------


local menu_root = menu.my_root()

local whitelistGroups = {user = true, friends = true, strangers  = true}
local whitelistListTable = {}
local whitelistedName = false
----------------------------------
-- Settings
----------------------------------
    JSlang.list(menu_root, 'Settings', {}, '')

    ----------------------------------
    -- Script settings
    ----------------------------------
        JSlang.list(_LR['Settings'], '脚本设置', {'JSsettings'}, '')

        notifications = true
        JSlang.toggle(_LR['脚本设置'], '禁用Jerry脚本的通知', {'JSnoNotify'}, '使脚本在运行时不进行通知. 这些可能非常有用,所以我不建议将它们关闭.', function(toggle)
            notifications = not toggle
            if notifications then
                JSlang.toast('Notifications on')
            end
        end)

        local maxTimeBetweenPress = 300
        JSlang.slider(_LR['脚本设置'], '双击间隔', {'JSdoubleTapInterval'}, '让您以毫秒为单位设置双击之间的最长时间.', 1, 1000, 300, 1, function(value)
            maxTimeBetweenPress = value
        end)

        JSlang.action(_LR['脚本设置'], '创建翻译模板', {'JStranslationTemplate'}, '在 store/JerryScript/Language 中创建用于翻译的模板文件', function()
            async_http.init('raw.githubusercontent.com', '/Jerrrry123/JerryScript/'.. getLatestRelease() ..'/store/JerryScript/Language/template.lua', function(fileContent)
                local i = ''
                if filesystem.exists(lang_dir ..'template.lua') then
                    i = 1
                    while filesystem.exists(lang_dir ..'template'.. i ..'.lua') do
                        i += 1
                    end
                end

                local f = assert(io.open(lang_dir ..'template'.. i ..'.lua', 'w'))
                f:write(fileContent)
                f:close()

                if type(i) == 'number' and i >= 100 then
                    JSlang.toast('Stop creating template files, you have way too many!')
                else
                    JSlang.toast('Successfully created file.')
                end

            end, function()
                JSlang.toast('Failed to create file.')
            end)
            async_http.dispatch()
        end)

        JSlang.hyperlink(_LR['脚本设置'], '命令列表', 'https://raw.githubusercontent.com/Jerrrry123/JerryScript/main/commandList.txt', '所有脚本功能和命令的列表.')

    ----------------------------------
    -- Player info settings
    ----------------------------------
        JSlang.list(_LR['Settings'], '玩家信息设置', {'JSplayerInfoSettings'}, '')

        local piSettings = new.hudSettings(-151, 1, 3)
        generateHudSettings(_LR['玩家信息设置'], 'PI', piSettings)

        ----------------------------------
        -- Player info toggles
        ----------------------------------
            JSlang.list(_LR['玩家信息设置'], '显示选项', {'PIDisplay'}, '')

            local playerInfoTogglesOptions = {
                {
                    name = '禁用名称', command = 'PIdisableName', description = '', toggle = true,
                    displayText = function(pid)
                        return JSlang.str_trans('Player') ..': '.. players.get_name(pid)
                    end
                },
                {
                    name = '禁用武器', command = 'PIdisableWeapon', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local weaponName = getWeaponName(weaponHash)
                        return weaponName and JSlang.str_trans('武器') ..': '.. weaponName
                    end
                },
                {
                    name = '禁用子弹信息', command = 'PIdisableAmmo', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                        if (damageType == 2 or damageType == 1 or damageType == 12) or WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) == util.joaat('GROUP_THROWN') or util.joaat('weapon_raypistol') == weaponHash then return end

                        local ammoCount
                        local ammo_ptr = memory.alloc_int()
                        if WEAPON.GET_AMMO_IN_CLIP(ped, weaponHash, ammo_ptr) and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) != util.joaat('GROUP_THROWN') then
                            ammoCount = memory.read_int(ammo_ptr)
                            local clipSize = WEAPON.GET_MAX_AMMO_IN_CLIP(ped, weaponHash, 1)
                            return ammoCount and JSlang.str_trans('弹夹') ..': '.. ammoCount ..' / '.. clipSize
                        end
                    end
                },
                {
                    name = '禁用伤害类型', command = 'PIdisableDamage', description = '显示玩家武器造成的伤害类型,例如: 近战/火/子弹/mk2弹药', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = getDamageType(ped, weaponHash)
                        return damageType and JSlang.str_trans('伤害类型') ..': '.. damageType
                    end
                },
                {
                    name = '禁用载具', command = 'PIdisableVehicle', description = '', toggle = true,
                    displayText = function(pid, ped)
                        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then return end
                        local vehicleName = getPlayerVehicleName(ped)
                        return vehicleName and JSlang.str_trans('Vehicle') ..': '.. vehicleName
                    end
                },
                {
                    name = '禁用比分', command = 'PIdisableScore', description = '仅在您或他被击杀时显示.', toggle = true,
                    displayText = function(pid)
                        local myScore = GET_INT_GLOBAL(2870058 + 386 + 1 + pid)
                        local theirScore = GET_INT_GLOBAL(2870058 + 353 + 1 + pid)
                        return (myScore > 0 or theirScore > 0) and (myScore ..' '.. JSlang.str_trans('Vs') ..' '.. theirScore) --only returns score if either part has kills
                    end
                },
                {
                    name = '禁用移动指示器', command = 'PIdisableMovement', description = '', toggle = true,
                    displayText = function(pid, ped)
                        local movement = getMovementType(ped)
                        return movement and JSlang.str_trans('玩家正在') ..' '.. movement
                    end
                },
                {
                    name = '禁用瞄准指示器', command = 'PIdisableAiming', description = '', toggle = true,
                    displayText = function(pid)
                        return PLAYER.IS_PLAYER_TARGETTING_ENTITY(pid, players.user_ped()) and JSlang.str_trans('玩家在瞄准您')
                    end
                },
                {
                    name = '禁用重新加载指示器', command = 'PIdisableReload', description = '', toggle = true,
                    displayText = function(pid, ped)
                        return PED.IS_PED_RELOADING(ped) and JSlang.str_trans('玩家正在重新装弹')
                    end
                },
            }
            generateToggles(playerInfoTogglesOptions, _LR['显示选项'], true)

    -----------------------------------
    -- Safe monitor settings
    -----------------------------------
        JSlang.list(_LR['Settings'], '保险箱监视器设置', {'SMsettings'}, '屏幕文字信息设置')

        smSettings = new.hudSettings(-3, 0, 2)
        generateHudSettings(_LR['保险箱监视器设置'], 'SM', smSettings)

    -----------------------------------
    -- Explosion settings
    -----------------------------------
        JSlang.list(_LR['Settings'], '爆炸设置', {'JSexpSettings'}, '修改脚本中爆炸玩家的选项设置.')

        local expLoopDelay = new.delay(250, 0, 0)

        JSlang.list(_LR['爆炸设置'], '循环延迟', {'JSexpDelay'}, '让您在循环爆炸之间设置自定义延迟.')
        generateDelaySettings(_LR['循环延迟'], '循环延迟', expLoopDelay)

        -----------------------------------
        -- Fx explosion settings
        -----------------------------------
            local expSettings = {
                camShake = 0, invisible = false, audible = true, noDamage = false, owned = false, blamed = false, blamedPlayer = false,
                --stuff for fx explosions
                currentFx = JS_tbls.effects['Clown_Explosion'],
                colour = new.colour( 255, 0, 255 )
            }

            JSlang.list(_LR['爆炸设置'], '爆炸特效', {'JSfxExp'}, '让您选择爆炸效果而不是爆炸类型.')

            local function getEffectLabelTableFromKeys(keyTable)
                local labelTable = {}
                for k, v in pairsByKeys(keyTable) do
                    local helpText = ''
                    if keyTable[k].colour and not JS_tbls.effects[k].exp then
                        helpText ..= JSlang.str_trans('Colour can be changed.') ..'\n'.. JSlang.str_trans('Can\'t be silenced.')
                    elseif keyTable[k].colour then
                        helpText ..=  JSlang.str_trans('Colour can be changed.')
                    elseif not keyTable[k].exp then
                        helpText ..= JSlang.str_trans('Can\'t be silenced.')
                    end
                    table.insert(labelTable, {k, {}, helpText})
                end
                return labelTable
            end

            JSlang.list_select(_LR['爆炸特效'], '特效类型', {'JSfxExpType'}, '选择一个特效爆炸类型.', getEffectLabelTableFromKeys(JS_tbls.effects), 5, function(index, name)
                if name == 'Explosion' then
                    expSettings.currentFx = nil
                else
                    expSettings.currentFx = JS_tbls.effects[name]
                end
            end)

            menu.rainbow(JSlang.colour(_LR['爆炸特效'], '特效颜色', {'JSPfxColour'}, '只适用于某些特效',  new.colour( 255, 0, 255 ), false, function(colour)
                expSettings.colour = colour
            end))
        -----------------------------------

        JSlang.slider(_LR['爆炸设置'], '画面抖动', {'JSexpCamShake'}, '多少次爆炸用于画面抖动.', 0, 1000, expSettings.camShake, 1, function(value)
            expSettings.camShake = toFloat(value)
        end)

        JSlang.toggle(_LR['爆炸设置'], '隐形爆炸', {'JSexpInvis'}, '', function(toggle)
            expSettings.invisible = toggle
        end)

        JSlang.toggle(_LR['爆炸设置'], '无声爆炸', {'JSexpSilent'}, '', function(toggle)
            expSettings.audible = not toggle
        end)

        JSlang.toggle(_LR['爆炸设置'], '禁用爆炸伤害', {'JSnoExpDamage'}, '', function(toggle)
            expSettings.noDamage = toggle
        end)

        JSlang.list(_LR['爆炸设置'], '栽赃设置', {'JSblameSettings'}, '让爆炸显示的发送者为自己或其他玩家,前往玩家列表选择要栽赃的特定玩家')

        local runningToggling = false
        local function mutuallyExclusiveToggles(toggle)
            if menu.get_value(toggle) then
                runningToggling = true
                menu.trigger_command(toggle)
                util.yield_once()
                runningToggling = false
            end
        end

        local exp_blame_toggle
        local exp_own_toggle = JSlang.toggle(_LR['栽赃设置'], '署名爆炸', {'JSownExp'}, '将覆盖"禁用爆炸伤害".', function(toggle)
            expSettings.owned = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_blame_toggle)
            end
        end)

        exp_blame_toggle = menu.toggle(_LR['栽赃设置'], JSlang.str_trans('栽赃') ..': '.. JSlang.str_trans('Random'), {'JSblameExp'}, JSlang.str_trans('将会覆盖"禁用爆炸伤害",如果您没有选择玩家,将会默认为栽赃随机的玩家.'), function(toggle)
            expSettings.blamed = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_own_toggle)
            end
        end)

        JSlang.list(_LR['栽赃设置'], '栽赃玩家列表', {'JSblameList'}, '用于选择栽赃目标的玩家列表.')

        local blamesTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            blamesTogglesTable[pid] = menu.action(_LR['栽赃玩家列表'], playerName, {'JSblame'.. playerName}, JSlang.str_trans('Blames your explosions on them.'), function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('栽赃') ..': '.. playerName)
                menu.focus(_LR['栽赃玩家列表'])
            end)
        end)

        players.on_leave(function(pid)
            if blamesTogglesTable[pid] then
                menu.delete(blamesTogglesTable[pid])
            end

            if expSettings.blamedPlayer == pid then
                local playerList = players.list(true, true, true)
                for _, pid in pairs(playerList) do
                    menu.trigger_commands('JSexplodeLoop'.. players.get_name(pid) ..' off')
                end
                menu.trigger_command(explodeLoopAll, 'off')
                expSettings.blamedPlayer = false
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('栽赃') ..': '.. JSlang.str_trans('Random'))
                if notifications then
                    JSlang.toast('Explosions stopped because the player you\'re blaming left.')
                end
            end
        end)

        JSlang.action(_LR['栽赃设置'], '随机栽赃', {'JSblameRandomExp'}, '如果您已经选择了栽赃的玩家,将会把栽赃目标设置为随机.', function()
            expSettings.blamedPlayer = false
            if not menu.get_value(exp_blame_toggle) then
                menu.trigger_command(exp_blame_toggle)
            end
            menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('栽赃') ..': '.. JSlang.str_trans('Random'))
        end)

        local hornBoostMultiplier = 1.000
        JSlang.slider(_LR['Settings'], '喇叭加速速度修改', {'JShornBoostMultiplier'}, '设置您或其他玩家使用喇叭加速时的速度.', -100000, 100000, hornBoostMultiplier * 1000, 1, function(value)
            hornBoostMultiplier = value / 1000
        end)

-----------------------------------
-- Self
-----------------------------------
do
    JSlang.list(menu_root, 'Self', {'JSself'}, '')

    local startViewMode
    local scope_scaleform
    local gaveHelmet = false
    JSlang.toggle_loop(_LR['Self'], '钢铁侠模式', {'JSironman'}, '赋予你钢铁侠的能力 :)', function()
        if not menu.get_value(levitationCommand) then
            menu.trigger_command(levitationCommand)
        end

        if not PED.IS_PED_WEARING_HELMET(players.user_ped()) then
            PED.GIVE_PED_HELMET(players.user_ped(), true, 4096, -1)
            gaveHelmet = true
        end

        local context = CAM._GET_CAM_ACTIVE_VIEW_MODE_CONTEXT()
        if startViewMode == nil then
            startViewMode = CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(context)
        end

        if CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(context) != 4 then
            CAM.SET_CAM_VIEW_MODE_FOR_CONTEXT(context, 4)
        end

        scope_scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE('REMOTE_SNIPER_HUD')
        GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scope_scaleform, 'REMOTE_SNIPER_HUD')
        GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scope_scaleform, 255, 255, 255, 255, 0)
        GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

        local barrageInput = 'INPUT_PICKUP'
        if not PAD._IS_USING_KEYBOARD(0) then
            barrageInput = 'INPUT_COVER'
        end

        memory.write_int(memory.script_global(1649593 + 1163), 1)
        SF.CLEAR_ALL()
        SF.TOGGLE_MOUSE_BUTTONS(false)
        SF.SET_DATA_SLOT(2, JSkey.get_control_instructional_button(0, 'INPUT_ATTACK'), JSlang.str_trans('Explode'))
        SF.SET_DATA_SLOT(1, JSkey.get_control_instructional_button(0, 'INPUT_AIM'), JSlang.str_trans('光束'))
        SF.SET_DATA_SLOT(0, JSkey.get_control_instructional_button(0, barrageInput), JSlang.str_trans('弹幕'))
        SF.DRAW_INSTRUCTIONAL_BUTTONS()

        JSkey.disable_control_action(0, 'INPUT_VEH_MOUSE_CONTROL_OVERRIDE')
        JSkey.disable_control_action(0, 'INPUT_VEH_FLY_MOUSE_CONTROL_OVERRIDE')
        JSkey.disable_control_action(0, 'INPUT_VEH_SUB_MOUSE_CONTROL_OVERRIDE')

        JSkey.disable_control_action(0, 'INPUT_ATTACK')
        JSkey.disable_control_action(0, 'INPUT_AIM')

        if not (JSkey.is_disabled_control_pressed(0, 'INPUT_ATTACK') or JSkey.is_disabled_control_pressed(0, 'INPUT_AIM') or JSkey.is_disabled_control_pressed(0, barrageInput)) then return end

        local a = players.get_position(players.user())
        local b = get_offset_from_gameplay_camera(80)

        local hash
        if JSkey.is_disabled_control_pressed(0, 'INPUT_ATTACK') then
            hash = util.joaat('VEHICLE_WEAPON_PLAYER_LAZER')
            if not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
                WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 26)
                while not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) do
                    util.yield_once()
                end
            end
        elseif JSkey.is_disabled_control_pressed(0, 'INPUT_AIM') then
            hash = util.joaat('WEAPON_RAYPISTOL')
            if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), hash, false) then
                WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), hash, 9999, false, false)
            end
        else
            hash = util.joaat('WEAPON_RPG')
            if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), hash, false) then
                WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), hash, 9999, false, false)
            end
            a.x += math.random(0, 100) / 100
            a.y += math.random(0, 100) / 100
            a.z += math.random(0, 100) / 100
        end

        WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), util.joaat('WEAPON_UNARMED'), true)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(
            a,
            b,
            200,
            true,
            hash,
            players.user_ped(),
            true, true, -1.0
        )
    end, function()
        if gaveHelmet then
            PED.REMOVE_PED_HELMET(players.user_ped(), true)
            gaveHelmet = false
        end
        HUD._HUD_WEAPON_WHEEL_IGNORE_CONTROL_INPUT(false)
        local pScaleform = memory.alloc_int()
        memory.write_int(pScaleform, scope_scaleform)
        GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(pScaleform)
        menu.trigger_command(levitationCommand, 'off')
        util.yield_once()
        CAM.SET_CAM_VIEW_MODE_FOR_CONTEXT(CAM._GET_CAM_ACTIVE_VIEW_MODE_CONTEXT(), startViewMode)
        startViewMode = nil
    end)

    -----------------------------------
    -- Fire wings
    -----------------------------------
        JSlang.list(_LR['Self'], '火翅膀', {}, '')

        local fireWings = {
            [1] = {pos = {[1] = 120.0, [2] =  75.0}},
            [2] = {pos = {[1] = 120.0, [2] = -75.0}},
            [3] = {pos = {[1] = 135.0, [2] =  75.0}},
            [4] = {pos = {[1] = 135.0, [2] = -75.0}},
            [5] = {pos = {[1] = 180.0, [2] =  75.0}},
            [6] = {pos = {[1] = 180.0, [2] = -75.0}},
            [7] = {pos = {[1] = 195.0, [2] =  75.0}},
            [8] = {pos = {[1] = 195.0, [2] = -75.0}},
        }

        local fireWingsSettings = {
            scale = 0.3,
            colour = mildOrangeFire,
            on = false
        }

        local ptfxEgg
        JSlang.toggle(_LR['火翅膀'], '火翅膀', {'JSfireWings'}, '将火制成的翅膀附加在您的背上.', function (toggle)
            fireWingsSettings.on = toggle
            if fireWingsSettings.on then
                ENTITY.SET_ENTITY_PROOFS(players.user_ped(), false, true, false, false, false, false, 1, false)
                if ptfxEgg == nil then
                    local eggHash = 1803116220
                    loadModel(eggHash)
                    ptfxEgg = entities.create_object(eggHash, players.get_position(players.user()))
                    ENTITY.SET_ENTITY_VISIBLE(ptfxEgg, false)
                    ENTITY.SET_ENTITY_COLLISION(ptfxEgg, false, false)
                    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(eggHash)
                end
                for i = 1, #fireWings do
                    while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('weap_xs_vehicle_weapons') do
                        STREAMING.REQUEST_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
                        util.yield_once()
                    end
                    GRAPHICS.USE_PARTICLE_FX_ASSET('weap_xs_vehicle_weapons')
                    fireWings[i].ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY('muz_xs_turret_flamethrower_looping', ptfxEgg, 0, 0, 0.1, fireWings[i].pos[1], 0, fireWings[i].pos[2], fireWingsSettings.scale, false, false, false)

                    util.create_tick_handler(function()
                        if not ptfxEgg then return end
                        local rot = ENTITY.GET_ENTITY_ROTATION(players.user_ped(), 2)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(ptfxEgg, players.user_ped(), -1, 0, 0, 0, rot, false, false, false, false, 0, false)
                        ENTITY.SET_ENTITY_ROTATION(ptfxEgg, rot, 2, true)
                        for i = 1, #fireWings do
                            if not fireWings[i].ptfx then return end
                            GRAPHICS.SET_PARTICLE_FX_LOOPED_SCALE(fireWings[i].ptfx, fireWingsSettings.scale)
                            GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(fireWings[i].ptfx, fireWingsSettings.colour.r, fireWingsSettings.colour.g, fireWingsSettings.colour.b)
                        end

                        ENTITY.SET_ENTITY_VISIBLE(ptfxEgg, false)
                        return fireWingsSettings.on
                    end)
                end
            else
                for i = 1, #fireWings do
                    if fireWings[i].ptfx then
                        GRAPHICS.REMOVE_PARTICLE_FX(fireWings[i].ptfx, true)
                        fireWings[i].ptfx = nil
                    end
                    if ptfxEgg then
                        entities.delete_by_handle(ptfxEgg)
                        ptfxEgg = nil
                    end
                end
                STREAMING.REMOVE_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
            end
        end)

        JSlang.slider(_LR['火翅膀'], '火翅膀比例', {'JSfireWingsScale'}, '', 1, 100, 3, 1, function(value)
            fireWingsSettings.scale = value / 10
        end)

        menu.rainbow(JSlang.colour(_LR['火翅膀'], '火翅膀颜色', {'JSfireWingsColour'}, '', fireWingsSettings.colour, false, function(colour)
            fireWingsSettings.colour = colour
        end))

    -----------------------------------
    -- Fire breath
    -----------------------------------
        JSlang.list(_LR['Self'], '喷火', {}, '')

        local fireBreathSettings = {
            scale = 0.3,
            colour = mildOrangeFire,
            on = false,
            y = { value = 0.12, still = 0.12, walk =  0.22, sprint = 0.32, sneak = 0.35 },
            z = { value = 0.58, still = 0.58, walk =  0.45, sprint = 0.38, sneak = 0.35 },
        }

        local function transitionValue(value, target, step)
            if value == target then return value end
            return value + step * ( value > target and -1 or 1 )
        end

        function fireBreathSettings:changePos(movementType)
            self.z.value = transitionValue(self.z.value, self.z[movementType], 0.01)
            self.y.value = transitionValue(self.y.value, self.y[movementType], 0.01)
        end

        JSlang.toggle(_LR['喷火'], '喷火', {'JSfireBreath'}, '', function(toggle)
            fireBreathSettings.on = toggle
            if toggle then
                while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('weap_xs_vehicle_weapons') do
                    STREAMING.REQUEST_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
                    util.yield_once()
                end
                GRAPHICS.USE_PARTICLE_FX_ASSET('weap_xs_vehicle_weapons')
                fireBreathSettings.ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE('muz_xs_turret_flamethrower_looping', players.user_ped(), 0, 0.12, 0.58, 30, 0, 0, 0x8b93, fireBreathSettings.scale, false, false, false)
                util.create_tick_handler(function()
                    if not fireBreathSettings.ptfx then return end
                    local user_ped = players.user_ped()
                    if PED.GET_PED_PARACHUTE_STATE(user_ped) == 0 and ENTITY.IS_ENTITY_IN_AIR(user_ped) then
                        GRAPHICS.SET_PARTICLE_FX_LOOPED_OFFSETS(fireBreathSettings.ptfx, 0, 0.81, 0, -10.0, 0, 0)
                    elseif menu.get_value(levitationCommand) then
                        GRAPHICS.SET_PARTICLE_FX_LOOPED_OFFSETS(fireBreathSettings.ptfx, 0, -0.12, 0.58, 150.0, 0, 0)
                    else
                        local movementType = 'still'
                        if TASK.IS_PED_SPRINTING(user_ped) then
                            movementType = 'sprint'
                        elseif TASK.IS_PED_WALKING(user_ped) then
                            movementType = 'walk'
                        elseif PED.GET_PED_STEALTH_MOVEMENT(user_ped) then
                            movementType = 'sneak'
                        end

                        fireBreathSettings:changePos(movementType)
                        GRAPHICS.SET_PARTICLE_FX_LOOPED_OFFSETS(fireBreathSettings.ptfx, 0, fireBreathSettings.y.value, fireBreathSettings.z.value, 30.0, 0, 0)
                    end
                    GRAPHICS.SET_PARTICLE_FX_LOOPED_SCALE(fireBreathSettings.ptfx, fireBreathSettings.scale)
                    GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(fireBreathSettings.ptfx, fireBreathSettings.colour.r, fireBreathSettings.colour.g, fireBreathSettings.colour.b)
                    return fireBreathSettings.on
                end)
            else
                GRAPHICS.REMOVE_PARTICLE_FX(fireBreathSettings.ptfx, true)
                fireBreathSettings.ptfx = nil
                STREAMING.REMOVE_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
            end
        end)

        JSlang.slider(_LR['喷火'], '喷火比例', {'JSfireBreathScale'}, '', 1, 100, fireBreathSettings.scale * 10, 1, function(value)
            fireBreathSettings.scale = value / 10
        end)

        menu.rainbow(JSlang.colour(_LR['喷火'], '喷火颜色', {'JSfireBreathColour'}, '', fireBreathSettings.colour, false, function(colour)
            fireBreathSettings.colour = colour
        end))

    -----------------------------------
    -- Ped customization
    -----------------------------------
        local faceFeatures = {
            [0]  = '鼻子 宽度',
            [1]  = '鼻尖 高度',
            [2]  = '鼻尖 长度',
            [3]  = '鼻隔 高度',
            [4]  = '鼻尖 缩小',
            [5]  = '鼻子',
            [6]  = '眉毛 高度',
            [7]  = '眉毛 前倾',
            [8]  = '脸颊 高度',
            [9]  = '脸颊 宽度',
            [10] = '脸颊 宽度',
            [11] = '眼睛 睁开程度',
            [12] = '嘴唇 厚度',
            [13] = '颧骨 宽度',
            [14] = '颧骨 长度',
            [15] = '下巴 缩小',
            [16] = '下巴 长度',
            [17] = '下巴 宽度',
            [18] = '下巴 形状',
            [19] = '脖子 宽度',
        }
        JSlang.list(_LR['Self'], '容貌功能', {}, '')
        JSlang.list(_LR['容貌功能'], '自定义容貌功能', {}, '重启游戏后,外貌功能将被重置.')

        local face_sliders = {}
        for i = 0, #faceFeatures do
            local faceValue = (util.is_session_started() and math.floor(STAT_GET_FLOAT('FEATURE_'.. i) * 100) or 0)
            face_sliders[faceFeatures[i]] = JSlang.slider(_LR['自定义容貌功能'], faceFeatures[i], {'JSset'.. string.gsub(faceFeatures[i], ' ', '')}, '', -1000, 1000, faceValue, 1, function(value)
                PED._SET_PED_MICRO_MORPH_VALUE(players.user_ped(), i, value / 100)
            end)
        end

        menu.divider(_LR['容貌功能'], '', {}, '')

        local function getProfileName(fullPath, removePath)
            local path = string.sub(fullPath, #removePath + 1)
            return string.gsub(path, '.txt', '')
        end

        local profileReferences = {}
        local function loadProfiles(root)
            local faceProfiles = filesystem.list_files(face_profiles_dir)
            for _, profilePath in pairs(faceProfiles) do
                local profileName = getProfileName(profilePath, face_profiles_dir)
                profileReferences[#profileReferences + 1] = menu.action(root, profileName, {'loadface'.. profileName}, '', function()
                    if not filesystem.exists(profilePath) then JSlang.toast('Profile not found.') end

                    local settings = util.read_colons_and_tabs_file(face_profiles_dir .. profileName ..'.txt')
                    for k, value in pairs(settings) do
                        menu.set_value(face_sliders[k], value)
                    end
                end)
            end
        end

        local function reloadProfiles(root)
            for i = 1, #profileReferences do
                menu.delete(profileReferences[i])
                profileReferences[i] = nil
            end
            loadProfiles(root)
        end

        JSlang.action(_LR['容貌功能'], '创建容貌功能配置文件', {'JSsaveFaceFeatures'}, '将您的自定义容貌保存在一个文件中,以便您可以加载它.', function()
            menu.show_command_box('JSsaveFaceFeatures ')
        end, function(fileName)
            local f = assert(io.open(face_profiles_dir .. fileName ..'.txt', 'w'))
            for i = 0, #faceFeatures do
                f:write(faceFeatures[i] ..': '.. menu.get_value(face_sliders[faceFeatures[i]]) ..'\n')
            end
            f:close()
            reloadProfiles(_LR['容貌功能'])
        end)

        JSlang.action(_LR['容貌功能'], '重新加载配置', {'JSreLoadFaceFeatureProfiles'}, '无需重新运行脚本即可刷新您的配置文件.', function()
            reloadProfiles(_LR['容貌功能'])
        end)

        JSlang.divider(_LR['容貌功能'], 'Profiles')

        if filesystem.is_dir(face_profiles_dir) then
            loadProfiles(_LR['容貌功能'])
        end

        local faceOverlays = {
            [0]  = { name = '面部斑点',          min = -1, max = 23 },
            [1]  = { name = 'Facial Hair',        min = -1, max = 28 },
            [2]  = { name = '眉毛',           min = -1, max = 33 },
            [3]  = { name = '皮肤老化',             min = -1, max = 14 },
            [4]  = { name = '眼妆',             min = -1, max = 74 },
            [5]  = { name = '脸红晕',              min = -1, max = 6  },
            [6]  = { name = '肤色',         min = -1, max = 11 },
            [7]  = { name = '皮肤损伤',         min = -1, max = 10 },
            [8]  = { name = '唇膏',           min = -1, max = 9  },
            [9]  = { name = '痣和雀斑',     min = -1, max = 17 },
            [10] = { name = '胸部',         min = -1, max = 16 },
            [11] = { name = '身体斑点',     min = -1, max = 11 },
            [12] = { name = '添加身体斑点', min = -1, max = 1  },
        }
        JSlang.list(_LR['Self'], '外貌功能', {}, '重启游戏后,外貌功能将被重置.')

        for i = 0, #faceOverlays do
            local overlayValue = PED._GET_PED_HEAD_OVERLAY_VALUE(players.user_ped(), i)
            JSlang.slider(_LR['外貌功能'], faceOverlays[i].name, {}, '', faceOverlays[i].min, faceOverlays[i].max, (overlayValue == 255 and -1 or overlayValue), 1, function(value)
                PED.SET_PED_HEAD_OVERLAY(players.user_ped(), i, (value == 255 and -1 or value), 1)
            end)
        end

    -----------------------------------
    -- Ragdoll options
    -----------------------------------
        JSlang.list(_LR['Self'], '摔倒选项', {'JSragdollOptions'}, '选择不同的摔倒选项.')

        JSlang.toggle_loop(_LR['摔倒选项'], '笨拙', {'JSclumsy'}, '让您的人物很容易摔倒.', function()
            if PED.IS_PED_RAGDOLL(players.user_ped()) then util.yield(3000) return end
            PED.SET_PED_RAGDOLL_ON_COLLISION(players.user_ped(), true)
        end)

        JSlang.action(_LR['摔倒选项'], '绊倒', {'JSstumble'}, '让你绊倒,很可能会摔倒.', function()
            local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
            PED.SET_PED_TO_RAGDOLL_WITH_FALL(players.user_ped(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
        end)

        -- credit to LAZScript for inspiring this
        local fallTimeout = false
        JSlang.toggle(_LR['摔倒选项'], '倒下', {'JSfallOver'}, '让您绊倒、跌倒并阻止您站起来.', function(toggle)
            if toggle then
                local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
                PED.SET_PED_TO_RAGDOLL_WITH_FALL(players.user_ped(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
            end
            fallTimeout = toggle
            while fallTimeout do
                PED.RESET_PED_RAGDOLL_TIMER(players.user_ped())
                util.yield_once()
            end
        end)

        -- credit to aaron for telling me this :p
        JSlang.toggle_loop(_LR['摔倒选项'], '摔倒', {'JSragdoll'}, '让您的人物摔倒.', function()
            PED.SET_PED_TO_RAGDOLL(players.user_ped(), 2000, 2000, 0, true, true, true)
        end)
    -----------------------------------

    JSlang.list(_LR['Self'], '自定义复活', {}, '')

    local wasDead = false
    local respawnPos
    local respawnRot
    local custom_respawn_toggle = menu.toggle_loop(_LR['自定义复活'], JSlang.str_trans('自定义复活') ..': '.. JSlang.str_trans('none'), {}, JSlang.str_trans('设置一个您死后复活的位置.'), function()
        if respawnPos == nil then return end
        local isDead = PLAYER.IS_PLAYER_DEAD(players.user())
        if wasDead and not isDead then
            while PLAYER.IS_PLAYER_DEAD(players.user()) do
                util.yield_once()
            end
            for i = 0, 30 do
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), respawnPos, false, false, false)
                ENTITY.SET_ENTITY_ROTATION(players.user_ped(), respawnRot, 2, true)
                util.yield_once()
            end
        end
        wasDead = isDead
    end)

    local function getZoneName(pid)
        return util.get_label_text(ZONE.GET_NAME_OF_ZONE(v3.get(players.get_position(pid))))
    end

    local custom_respawn_location custom_respawn_location = JSlang.action(_LR['自定义复活'], '保存位置', {}, '未设置位置.', function()
        respawnPos = players.get_position(players.user())
        respawnRot = ENTITY.GET_ENTITY_ROTATION(players.user_ped(), 2)
        menu.set_menu_name(custom_respawn_toggle, JSlang.str_trans('自定义复活') ..': '.. getZoneName(players.user()))
        local pos = 'X: '.. respawnPos.x ..'\nY: '.. respawnPos.y ..'\nZ: '.. respawnPos.z
        menu.set_help_text(custom_respawn_toggle,  pos)
        menu.set_help_text(custom_respawn_location,  JSlang.str_trans('当前位置') ..':\n'.. pos)
    end)

    JSlang.slider(_LR['Self'], '幽灵', {'JSghost'}, '修改您人物的不透明度.', 0, 100, 100, 25, function(value)
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), JS_tbls.alphaPoints[value / 25 + 1], false)
    end)

    JSlang.toggle_loop(_LR['Self'], '自动加血', {'JSfullRegen'}, '一直加血直到您的血被加满.', function()
        local health = ENTITY.GET_ENTITY_HEALTH(players.user_ped())
        if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) == health then return end
        ENTITY.SET_ENTITY_HEALTH(players.user_ped(), health + 5, 0)
        util.yield(255)
    end)

    JSlang.toggle(_LR['Self'], '冷血', {'JScoldBlooded'}, '移除您的热信号.\n其他人仍然可以看到它.', function(toggle)
        PED.SET_PED_HEATSCALE_OVERRIDE(players.user_ped(), (toggle and 0 or 1.0))
    end)

    JSlang.toggle(_LR['Self'], '无声脚步', {'JSquietSteps'}, '禁用您的脚步声.', function(toggle)
        AUDIO._SET_PED_AUDIO_FOOTSTEP_LOUD(players.user_ped(), not toggle)
    end)
end

-----------------------------------
-- Weapons
-----------------------------------
do
    JSlang.list(menu_root, 'Weapons', {'JSweapons'}, '')

    local thermal_command = menu.ref_by_path('Game>Rendering>Thermal Vision', 37)
    JSlang.toggle_loop(_LR['Weapons'], '热成像枪', {'JSthermalGuns'}, '当您瞄准时按"E"可以启用热成像功能.', function()
        local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user_ped())
        if GRAPHICS.GET_USINGSEETHROUGH() and not aiming then
            menu.trigger_command(thermal_command, 'off')
            GRAPHICS._SEETHROUGH_SET_MAX_THICKNESS(1) --default value is 1
        elseif JSkey.is_key_just_down('VK_E') then
            local state = menu.get_value(thermal_command)
            menu.trigger_command(thermal_command, if state or not aiming then 'off' else 'on')
            GRAPHICS._SEETHROUGH_SET_MAX_THICKNESS(if state or not aiming then 1 else 50)
        end
    end)

    ----------------------------------
    -- Weapon settings
    ----------------------------------
        JSlang.list(_LR['Weapons'], '武器设置', {}, '')

        local function readWeaponAddress(storeTable, offset, stopIfModified)
            if util.is_session_transition_active() then return 0 end

            local userPed = players.user_ped()
            local weaponHash, vehicleWeapon = getWeaponHash(userPed)

            if stopIfModified and storeTable[weaponHash] then return 0 end

            local pointer = (vehicleWeapon and 0x70 or 0x20)
            local address = address_from_pointer_chain(entities.handle_to_pointer(userPed), {0x10D8, pointer, offset})
            if address == 0 then JSlang.toast('Failed to find memory address.') return 0 end

            if storeTable[weaponHash] == nil then
                storeTable[weaponHash] = {
                    address = address,
                    original = memory.read_float(address)
                }
            end
            return weaponHash
        end

        local function resetWeapons(modifiedWeapons)
            for hash, _ in pairs(modifiedWeapons) do
                memory.write_float(modifiedWeapons[hash].address, modifiedWeapons[hash].original)
                modifiedWeapons[hash] = nil
            end
        end

        local modifiedRecoil = {}
        JSlang.toggle_loop(_LR['武器设置'], '无后坐力', {'JSnoRecoil'}, '使用武器射击时不会抖动游戏画面.', function()
            local weaponHash = readWeaponAddress(modifiedRecoil, 0x2F4, true)
            if weaponHash == 0 then return end
            memory.write_float(modifiedRecoil[weaponHash].address, 0)
        end, function()
            resetWeapons(modifiedRecoil)
        end)

        local modifiedSpread = {}
        JSlang.toggle_loop(_LR['武器设置'], '无扩散', {'JSnoSpread'}, '', function()
            local weaponHash = readWeaponAddress(modifiedSpread, 0x74, true)
            if weaponHash == 0 then return end
            memory.write_float(modifiedSpread[weaponHash].address, 0)
        end, function()
            resetWeapons(modifiedSpread)
        end)

        local modifiedSpinup = {
            [1] = {hash = util.joaat('weapon_minigun')},
            [2] = {hash = util.joaat('weapon_rayminigun')},
        }
        JSlang.toggle_loop(_LR['武器设置'], '移除前摇', {'JSnoSpinUp'}, '移除加特林和寡妇制造者的前摇.', function()
            local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
            for i = 1, #modifiedSpinup do
                if weaponHash == modifiedSpinup[i].hash then
                    modifiedSpinup[i].address = address_from_pointer_chain(entities.handle_to_pointer(players.user_ped()), {0x10D8, 0x20, 0x144})
                    if modifiedSpinup[i].address == 0 then return end
                    memory.write_float(modifiedSpinup[i].address, 0)
                end
            end
        end, function()
            for i = 1, #modifiedSpinup do
                if modifiedSpinup[i].address then
                    memory.write_float(modifiedSpinup[i].address, 0.5)
                end
            end
        end)

        local modifiedCarForce = {}
        local modifiedHeliForce = {}
        local modifiedPedForce = {}
        JSlang.toggle_loop(_LR['武器设置'], '子弹伤害修改', {'JSbulletForceMultiplier'}, '从正面射击载具时效果最佳.\n显示的值以百分比为单位.', function()
            local weaponHash = readWeaponAddress(modifiedCarForce, 0x0E0, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedCarForce[weaponHash].address, modifiedCarForce[weaponHash].original * 99999999999999)

            weaponHash = readWeaponAddress(modifiedHeliForce, 0x0E4, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedHeliForce[weaponHash].address, modifiedHeliForce[weaponHash].original * 99999999999999)

            weaponHash = readWeaponAddress(modifiedPedForce, 0x0DC, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedPedForce[weaponHash].address, modifiedPedForce[weaponHash].original * 99999999999999)
        end, function()
            resetWeapons(modifiedCarForce)
            resetWeapons(modifiedHeliForce)
            resetWeapons(modifiedPedForce)
        end)

        JSlang.divider(_LR['武器设置'], '瞄准视野')

        local extraZoom2 = 0
        local modifiedAimFov = {}
        JSlang.toggle_loop(_LR['武器设置'], '启用瞄准视野缩放', {'JSenableAimFov'}, '让您在瞄准时修改视野大小.', function()
            JSkey.disable_control_action(0, 'INPUT_SNIPER_ZOOM_IN_ONLY')
            JSkey.disable_control_action(0, 'INPUT_SNIPER_ZOOM_OUT_ONLY')

            if not JSkey.is_control_pressed(0, 'INPUT_AIM') then
                extraZoom2 = 0
                return
            end

            local step = if extraZoom2 > 60 or extraZoom2 < -5 then 3 else 6

            if not (extraZoom2 <= -35) and JSkey.is_disabled_control_just_pressed(0, 'INPUT_SNIPER_ZOOM_IN_ONLY') then
                extraZoom2 -= step
            elseif not (extraZoom2 >= 100) and JSkey.is_disabled_control_just_pressed(0, 'INPUT_SNIPER_ZOOM_OUT_ONLY') then
                extraZoom2 += step
            end

            local weaponHash = readWeaponAddress(modifiedAimFov, 0x2FC, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedAimFov[weaponHash].address, modifiedAimFov[weaponHash].original + extraZoom2)
        end, function()
            resetWeapons(modifiedAimFov)
        end)

        JSlang.divider(_LR['武器设置'], '放大瞄准视野')

        local extraZoom = 0
        local modifiedZoomFov = {}
        JSlang.toggle_loop(_LR['武器设置'], '启用放大瞄准视野缩放', {'JSenableZoomFov'}, '让您在瞄准放大时修改视野大小.', function()
            local weaponHash = readWeaponAddress(modifiedZoomFov, 0x410, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedZoomFov[weaponHash].address,  modifiedZoomFov[weaponHash].original + extraZoom)
        end, function()
            resetWeapons(modifiedZoomFov)
        end)

        JSlang.slider_float(_LR['武器设置'], '放大瞄准视野', {'JSzoomAimFov'}, '', 100, 9999999999, 100, 1, function(value)
            extraZoom = (value - 100) / 100
            modifiedZoomWeapon = nil
        end)

    -----------------------------------
    -- Proxy stickys
    -----------------------------------
        JSlang.list(_LR['Weapons'], '粘弹自动爆炸', {}, '')

        local proxyStickySettings = {players = true, npcs = false, radius = 2.0}
        local function autoExplodeStickys(ped)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
            if MISC.IS_PROJECTILE_TYPE_WITHIN_DISTANCE(pos, util.joaat('weapon_stickybomb'), proxyStickySettings.radius, true) then
                WEAPON.EXPLODE_PROJECTILES(players.user_ped(), util.joaat('weapon_stickybomb'))
            end
        end

        JSlang.toggle_loop(_LR['粘弹自动爆炸'], '粘弹自动爆炸', {'JSproxyStickys'}, '使您的粘弹在玩家或NPC附近时自动引爆,可与玩家白名单一起使用.', function()
            if proxyStickySettings.players then
                local specificWhitelistGroup = {user = false,  friends = whitelistGroups.friends, strangers = whitelistGroups.strangers}
                local playerList = getNonWhitelistedPlayers(whitelistListTable, specificWhitelistGroup, whitelistedName)
                for _, pid in pairs(playerList) do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    autoExplodeStickys(ped)
                end
            end
            if proxyStickySettings.npcs then
                local pedHandles = entities.get_all_peds_as_handles()
                for _, ped in pairs(pedHandles) do
                    if not PED.IS_PED_A_PLAYER(ped) then
                        autoExplodeStickys(ped)
                    end
                end
            end
        end)

        JSlang.toggle(_LR['粘弹自动爆炸'], '引爆附近的玩家', {'JSProxyStickyPlayers'}, '如果您的粘性炸弹在玩家附近时自动引爆.', function(toggle)
            proxyStickySettings.players = toggle
        end, proxyStickySettings.players)

        JSlang.toggle(_LR['粘弹自动爆炸'], '引爆附近的NPC', {'JSProxyStickyNpcs'}, '如果您的粘性炸弹在NPC附近时自动引爆.', function(toggle)
            proxyStickySettings.npcs = toggle
        end, proxyStickySettings.npcs)

        JSlang.slider(_LR['粘弹自动爆炸'], '爆炸半径', {'JSstickyRadius'}, '粘性炸弹必须离目标多近才会引爆.', 1, 10, proxyStickySettings.radius, 1, function(value)
            proxyStickySettings.radius = toFloat(value)
        end)

        JSlang.action(_LR['粘弹自动爆炸'], '移除所有粘性炸弹', {'JSremoveStickys'}, '移除所有存在的粘性炸弹(不仅仅是你的).', function()
            WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(util.joaat('weapon_stickybomb'), false)
        end)
    -----------------------------------

    local remove_projectiles = false
    local function disableProjectileLoop(projectile)
        util.create_thread(function()
            util.create_tick_handler(function()
                WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(projectile, false)
                return remove_projectiles
            end)
        end)
    end

    local mutually_exclusive_weapons = {}

    local nuke_height = 40
    local function executeNuke(pos)
        for a = 0, nuke_height, 4 do
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z + a, 8, 10.0, true, false, 1.0, false)
            util.yield(50)
        end
        FIRE.ADD_EXPLOSION(pos.x +8, pos.y +8, pos.z + nuke_height, 82, 10.0, true, false, 1.0, false)
        FIRE.ADD_EXPLOSION(pos.x -8, pos.y +8, pos.z + nuke_height, 82, 10.0, true, false, 1.0, false)
        FIRE.ADD_EXPLOSION(pos.x -8, pos.y -8, pos.z + nuke_height, 82, 10.0, true, false, 1.0, false)
        FIRE.ADD_EXPLOSION(pos.x +8, pos.y -8, pos.z + nuke_height, 82, 10.0, true, false, 1.0, false)
    end

    --credit to lance for the entity gun, but i edited it a bit
    JSlang.list(_LR['Weapons'], '核弹选项', {}, '')

    local nuke_gun_option
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['核弹选项'], '核弹枪', {'JSnukeGun'}, '使火箭炮发出的子弹变成核弹.', mutually_exclusive_weapons, function(toggle)
        nuke_gun_option = toggle
        util.create_tick_handler(function()
            if WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped()) == -1312131151 then --if holding homing launcher
                if PED.IS_PED_SHOOTING(players.user_ped()) then
                    if not remove_projectiles then
                        remove_projectiles = true
                        disableProjectileLoop(-1312131151)
                    end
                    util.create_thread(function()
                        local hash = util.joaat('w_arena_airmissile_01a')
                        loadModel(hash)

                        local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)
                        local dir, pos = direction()

                        local bomb = entities.create_object(hash, pos)
                        ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, dir, 0.0, 0.0, 0.0, 0.0, true, false, true, false, true)
                        ENTITY.SET_ENTITY_ROTATION(bomb, cam_rot, 1, true)

                        while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do
                            util.yield_once()
                        end
                        local nukePos = ENTITY.GET_ENTITY_COORDS(bomb, true)
                        entities.delete_by_handle(bomb)
                        executeNuke(nukePos)
                    end)
                else
                    remove_projectiles = false
                end
            else
                remove_projectiles = false
            end
            return nuke_gun_option
        end)
    end)

    --credit to scriptCat (^-^)
    local function get_waypoint_v3()
        if HUD.IS_WAYPOINT_ACTIVE() then
            local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
            local waypoint_pos = HUD.GET_BLIP_COORDS(blip)

            local success, Zcoord = util.get_ground_z(waypoint_pos.x, waypoint_pos.y)
            local tries = 0
            while not success or tries <= 100 do
                success, Zcoord = util.get_ground_z(waypoint_pos.x, waypoint_pos.y)
                tries += 1
                util.yield_once()
            end
            if success then
                waypoint_pos.z = Zcoord
            end

            return waypoint_pos
        else
            JSlang.toast('No waypoint set.')
        end
    end

    JSlang.action(_LR['核弹选项'], '核弹标记点', {'JSnukeWP'}, '掉落一颗核弹在您标记的位置.', function ()
        local waypointPos = get_waypoint_v3()
        if waypointPos then
            local hash = util.joaat('w_arena_airmissile_01a')
            loadModel(hash)

            waypointPos.z += 30
            local bomb = entities.create_object(hash, waypointPos)
            waypointPos.z -= 30
            ENTITY.SET_ENTITY_ROTATION(bomb, -90, 0, 0,  2, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(bomb, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)

            while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(bomb) do
                util.yield_once()
            end
            entities.delete_by_handle(bomb)
            executeNuke(waypointPos)
        end
    end)

    JSlang.slider(_LR['核弹选项'], '核弹高度', {'JSnukeHeight'}, '投下核弹的高度.', 10, 100, nuke_height, 10, function(value)
        nuke_height = value
    end)

    --this is heavily skidded from wiriScript so credit to wiri
    local launcherThrowable = util.joaat('weapon_grenade')
    JSlang.list(_LR['Weapons'], '投掷物发射器', {}, '')

    local throwables_launcher
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['投掷物发射器'], '投掷物发射器', {'JSgrenade'}, '使榴弹发射器能够发射可选的投掷物.', mutually_exclusive_weapons, function(toggle)
        throwables_launcher = toggle
        util.create_tick_handler(function()
            if WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped()) == -1568386805 then --if holding grenade launcher
                if PED.IS_PED_SHOOTING(players.user_ped()) then
                    if not remove_projectiles then
                        remove_projectiles = true
                        disableProjectileLoop(-1568386805)
                    end
                    util.create_thread(function()
                        local currentWeapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(players.user_ped(), false)
                        local pos1 = ENTITY._GET_ENTITY_BONE_POSITION_2(currentWeapon, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(currentWeapon, 'gun_muzzle'))
                        local pos2 = get_offset_from_gameplay_camera(30)
                        if not WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(), launcherThrowable, false) then
                            WEAPON.GIVE_WEAPON_TO_PED(players.user_ped(), launcherThrowable, 9999, false, false)
                        end
                        util.yield_once()
                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos1, pos2, 200, true, launcherThrowable, players.user_ped(), true, false, 2000.0)
                    end)
                else
                    remove_projectiles = false
                end
            else
                remove_projectiles = false
            end
            return throwables_launcher
        end)
    end)

    local throwablesTable = {
        ['Grenade']  = util.joaat('weapon_grenade'),
        ['Sticky Bomb']  = util.joaat('weapon_stickybomb'),
        ['Proximity Mine']  = util.joaat('weapon_proxmine'),
        ['BZ Gas']  = util.joaat('weapon_bzgas'),
        ['Tear Gas']  = util.joaat('weapon_smokegrenade'),
        ['Molotov']  = util.joaat('weapon_molotov'),
        ['Flare']  = util.joaat('weapon_flare'),
        ['Snowball']  = util.joaat('weapon_snowball'),
        ['Ball']  = util.joaat('weapon_ball'),
        ['Pipe Bomb'] = util.joaat('weapon_pipebomb'),
    }
    JSlang.list_select(_LR['投掷物发射器'], '当前投掷物', {'JSthrowablesLauncher'}, '选择榴弹发射器发射的投掷物.', getLabelTableFromKeys(throwablesTable), 4, function(index, text)
        launcherThrowable = throwablesTable[text]
    end)

    local disable_firing = false
    local function disableFiringLoop()
        util.create_tick_handler(function()
            PLAYER.DISABLE_PLAYER_FIRING(players.user_ped(), true)
            return disable_firing
        end)
    end

    JSlang.list(_LR['Weapons'], '爆炸动物枪', {}, '')

    local exp_animal = 'a_c_killerwhale'
    local explosive_animal_gun
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['爆炸动物枪'], '爆炸动物枪', {'JSexpAnimalGun'}, '灵感来自爆炸鲸鱼枪,但您也可以将子弹变成其他动物.', mutually_exclusive_weapons, function(toggle)
        explosive_animal_gun = toggle
        while explosive_animal_gun do
            local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
            local weaponType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
            if weaponType == 3 or (weaponType == 5 and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) != 1548507267) then --weapons that shoot bullets or explosions and isn't in the throwables category (grenades, proximity mines etc...)
                disable_firing = true
                disableFiringLoop()
                if JSkey.is_disabled_control_pressed(2, 'INPUT_ATTACK') and PLAYER.IS_PLAYER_FREE_AIMING(players.user_ped()) then
                    util.create_thread(function()
                        local hash = util.joaat(exp_animal)
                        loadModel(hash)

                        local dir, pos = direction(10)
                        local animal = entities.create_ped(28, hash, pos, 0)
                        local cam_rot = CAM.GET_FINAL_RENDERED_CAM_ROT(2)

                        ENTITY.APPLY_FORCE_TO_ENTITY(animal, 1, dir, 0.0, 0.0, 0.0, 0, true, false, true, false, true)
                        ENTITY.SET_ENTITY_ROTATION(animal, cam_rot, 2, true)

                        while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(animal) do
                            util.yield_once()
                        end
                        local animalPos = ENTITY.GET_ENTITY_COORDS(animal, true)
                        entities.delete_by_handle(animal)
                        FIRE.ADD_EXPLOSION(animalPos, 1, 10.0, true, false, 1.0, false)
                    end)
                end
            else
                disable_firing = false
            end
            util.yield(200)
        end
        disable_firing = false
    end)

    local animalsTable = {
        ['Cat'] = 'a_c_cat_01',
        ['Pug'] = 'a_c_pug',
        ['Killerwhale'] = 'a_c_killerwhale',
        ['Dolphin'] = 'a_c_dolphin',
        ['Hen'] = 'a_c_hen',
        ['Pig'] = 'a_c_pig',
        ['Chimp'] = 'a_c_chimp',
        ['Rat'] = 'a_c_rat',
        ['Fish'] = 'a_c_fish',
        ['Retriever'] = 'a_c_retriever',
        ['Rottweiler'] = 'a_c_rottweiler',
    }
    JSlang.list_select(_LR['爆炸动物枪'], '当前动物', {'JSexplosiveAnimalGun'}, '选择爆炸动物枪发射时使用的动物.', getLabelTableFromKeys(animalsTable), 6, function(index, text)
        exp_animal = animalsTable[text]
    end)

    JSlang.list(_LR['Weapons'], '我的世界枪', {}, '')

    local impactCords = v3()
    local blocks = {}
    JSlang.toggle_loop(_LR['我的世界枪'], '我的世界枪', {'JSminecraftGun'}, '当您射击时生成阻挡物.', function()
        if WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), memory.addrof(impactCords)) then
            local hash = util.joaat('prop_mb_sandblock_01')
            loadModel(hash)
            blocks[#blocks + 1] = entities.create_object(hash, impactCords)
        end
    end)

    JSlang.action(_LR['我的世界枪'], '删除最后一个阻挡物', {'JSdeleteLastBlock'}, '', function()
        if blocks[#blocks] != nil then
            entities.delete_by_handle(blocks[#blocks])
            blocks[#blocks] = nil
        end
    end)

    JSlang.action(_LR['我的世界枪'], '删除所有阻挡物', {'JSdeleteBlocks'}, '', function()
        for i = 1, #blocks do
            entities.delete_by_handle(blocks[i])
            blocks[i] = nil
        end
    end)

    local flameThrower = {
        colour = mildOrangeFire
    }
    JSlang.toggle_loop(_LR['Weapons'], '喷火器', {'JSflamethrower'}, '将加特林变成火焰喷射器.', function()
        if WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped()) != 1119849093 or not JSkey.is_control_pressed(2, 'INPUT_AIM') then
            if not flameThrower.ptfx then return end

            GRAPHICS.REMOVE_PARTICLE_FX(flameThrower.ptfx, true)
            STREAMING.REMOVE_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
            flameThrower.ptfx = nil
            return
        end

        PLAYER.DISABLE_PLAYER_FIRING(players.user_ped(), true)

        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('weap_xs_vehicle_weapons') do
            STREAMING.REQUEST_NAMED_PTFX_ASSET('weap_xs_vehicle_weapons')
            util.yield_once()
        end
        GRAPHICS.USE_PARTICLE_FX_ASSET('weap_xs_vehicle_weapons')
        if flameThrower.ptfx == nil then
            flameThrower.ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE('muz_xs_turret_flamethrower_looping', WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(players.user_ped()), 0.8, 0, 0, 0, 0, 270.0, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(players.user_ped()), 'Gun_Nuzzle'), 0.5, false, false, false)
            GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(flameThrower.ptfx, flameThrower.colour.r, flameThrower.colour.g, flameThrower.colour.b)
        end
    end)

    JSlang.toggle(_LR['Weapons'], '友好枪', {'JSfriendlyFire'}, '使您射击NPC时让他们不会攻击您.', function(toggle)
        PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), toggle, false)
    end)

    JSlang.toggle_loop(_LR['Weapons'], '翻滚自动装弹', {'JSrollReload'}, '当您翻滚时自动装填弹夹.', function()
        if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 4) and JSkey.is_control_pressed(2, 'INPUT_JUMP') and not PED.IS_PED_SHOOTING(players.user_ped())  then --checking if player is rolling
            util.yield(900)
            WEAPON.REFILL_AMMO_INSTANTLY(players.user_ped())
        end
    end)
end

-----------------------------------
-- Vehicle
-----------------------------------
local my_cur_car = entities.get_user_vehicle_as_handle() --gets updated in the tick loop at the bottom of the script
do
    JSlang.list(menu_root, 'Vehicle', {'JSVeh'}, '')

    local carDoors = {
        'Driver Door',
        'Passenger Door',
        'Rear Left',
        'Rear Right',
        'Hood',
        'Trunk',
    }

    local carSettings carSettings = { --makes carSettings available inside this table
        disableExhaustPops = {on = false, setOption = function(toggle)
            AUDIO.ENABLE_VEHICLE_EXHAUST_POPS(my_cur_car, not toggle)
        end},
        launchControl = {on = false, setOption = function(toggle)
            if PED.IS_PED_IN_ANY_PLANE(players.user_ped()) then
                toggle = false
            end
            PHYSICS._SET_LAUNCH_CONTROL_ENABLED(toggle)
        end},
        ghostCar = {on = true, value = 4, setOption = function(toggle)
            local index = toggle and carSettings.ghostCar.value + 1 or 5
            ENTITY.SET_ENTITY_ALPHA(my_cur_car, JS_tbls.alphaPoints[index], true)
        end},
        indestructibleDoors = {on = false, setOption = function(toggle)
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end},
        npcHorn = {on = false, setOption = function(toggle)
            VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
        end},
        lowTraction = {on = false, setOption = function(toggle)
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(my_cur_car, toggle)
            VEHICLE._SET_VEHICLE_REDUCE_TRACTION(my_cur_car, toggle and 0 or 3)
        end},
    }

    function setCarOptions(toggle)
        for k, option in pairs(carSettings) do
            if option.on then option.setOption(toggle) end
        end
    end

    -----------------------------------
    -- Speed and handling
    -----------------------------------
        JSlang.list(_LR['Vehicle'], '速度和操控', {'JSspeedHandling'}, '')

        JSlang.toggle(_LR['速度和操控'], '低牵引力', {'JSlowTraction'}, '降低您载具的牵引力,我建议为其设置一个快捷键.', function(toggle)
            carSettings.lowTraction.on = toggle
            carSettings.lowTraction.setOption(toggle)
        end)

        JSlang.toggle(_LR['速度和操控'], '启动控制', {'JSlaunchControl'}, '限制您的载具在加速时施加的力,使其不会摧毁,在跑车艾梅鲁斯中非常明显.', function(toggle)
            carSettings.launchControl.on = toggle
            carSettings.launchControl.setOption(toggle)
        end)

        local my_torque = 100
        JSlang.slider_float(_LR['速度和操控'], '设置扭矩', {'JSsetSelfTorque'}, '修改您载具的速度.', -1000000, 1000000, my_torque, 1, function(value)
            my_torque = value
            util.create_tick_handler(function()
                VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(my_cur_car, my_torque/100)
                return (my_torque != 100)
            end)
        end)

        local quickBrakeLvL = 1.5
        JSlang.toggle_loop(_LR['速度和操控'], '快速刹车', {'JSquickBrake'}, '按"S"时会进一步减慢您的速度.', function(toggle)
            if JSkey.is_control_just_pressed(2, 'INPUT_VEH_BRAKE') and ENTITY.GET_ENTITY_SPEED(my_cur_car) >= 0 and not ENTITY.IS_ENTITY_IN_AIR(my_cur_car) and VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() then
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) / quickBrakeLvL)
                util.yield(250)
            end
        end)

        JSlang.slider_float(_LR['速度和操控'], '强制快速刹车', {'JSquickBrakeForce'}, '1.00是普通刹车.', 100, 999, 150, 1,  function(value)
            quickBrakeLvL = value / 100
        end)

    -----------------------------------
    -- Boosts
    -----------------------------------
        JSlang.list(_LR['Vehicle'], '加速', {'JSboosts'}, '')

        JSlang.toggle_loop(_LR['加速'], '喇叭加速', {'JShornBoost'}, '当您按喇叭或激活警报器时,加速您的载具.', function()
            if not (AUDIO.IS_HORN_ACTIVE(my_cur_car) or VEHICLE.IS_VEHICLE_SIREN_ON(my_cur_car)) then return end
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) + hornBoostMultiplier)
        end)

        JSlang.toggle_loop(_LR['加速'], '载具跳跃', {'JSVehJump'}, '当您双击 "W" 时跳跃载具.', function()
            if not is_user_driving_vehicle() then return end

            local prevPress = JSkey.get_ms_since_control_last_pressed(2, 'INPUT_MOVE_UP_ONLY')
            if JSkey.is_control_just_pressed(2, 'INPUT_MOVE_UP_ONLY') and prevPress != -1 and prevPress <= maxTimeBetweenPress then
                local mySpeed = ENTITY.GET_ENTITY_SPEED(my_cur_car)
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, 0, 2, (mySpeed / 10) + 14, 0, true, true, true)
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', players.user_ped(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
            end
        end)

        -----------------------------------
        -- Nitro
        -----------------------------------
            JSlang.divider(_LR['加速'], '氮气加速')

            local nitroSettings = {level = new.delay(500, 2, 0), power = 1, rechargeTime = new.delay(200, 1, 0)}

            JSlang.toggle_loop(_LR['加速'], '启用氮气加速', {'JSnitro'}, '在任何载具上使用氮气加速,按"X"启用.', function(toggle)
                if JSkey.is_control_just_pressed(2, 'INPUT_VEH_TRANSFORM') and PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) then
                    repeat
                        util.yield_once()
                    until not JSkey.is_control_just_pressed(2, 'INPUT_VEH_TRANSFORM')

                    --request the nitro ptfx because _SET_VEHICLE_NITRO_ENABLED does not load it
                    if not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') then
                        STREAMING.REQUEST_NAMED_PTFX_ASSET('veh_xs_vehicle_mods')
                        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED('veh_xs_vehicle_mods') do
                            util.yield_once()
                        end
                    end

                    VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, true, getTotalDelay(nitroSettings.level) / 10, nitroSettings.power, 999999999999999999, false)

                    local startTime = util.current_time_millis()
                    while util.current_time_millis() < startTime + getTotalDelay(nitroSettings.level) do
                        if JSkey.is_control_just_pressed(2, 'INPUT_VEH_TRANSFORM') then
                            break
                        end
                        util.yield_once()
                    end
                    VEHICLE._SET_VEHICLE_NITRO_ENABLED(my_cur_car, false)
                    startTime = util.current_time_millis()
                    while util.current_time_millis() < startTime + getTotalDelay(nitroSettings.rechargeTime) do
                        util.yield_once()
                    end
                end
            end)

            JSlang.list(_LR['加速'], '持续时间', {'JSnitroDuration'}, '让您自定义设置氮气加速的持续时间.')
            generateDelaySettings(_LR['持续时间'], '持续时间', nitroSettings.level)

            JSlang.list(_LR['加速'], '充能时间', {'JSnitroRecharge'}, '让您自定义设置氮气加速的充能时间.')
            generateDelaySettings(_LR['充能时间'], '充能时间', nitroSettings.rechargeTime)

        -----------------------------------
        -- Shunt boost
        -----------------------------------
            JSlang.divider(_LR['加速'], '助推')

            local shuntSettings = {
                maxForce = 30.0, force = 30.0, disableRecharge = false,
            }

            local function forceRecharge()
                util.create_thread(function()
                    shuntSettings.force = 0.0
                    while shuntSettings.force < shuntSettings.maxForce and not shuntSettings.disableRecharge do
                        shuntSettings.force += 1
                        util.yield(100)
                    end
                    shuntSettings.force = shuntSettings.maxForce
                    if notifications and not shuntSettings.disableRecharge then
                        JSlang.toast('Shunt boost fully recharged')
                    end
                    return false
                end)
            end

            local function shunt(dir)
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(my_cur_car, 1, shuntSettings.force * dir, 0, 0, 0, true, true, true)
                AUDIO.PLAY_SOUND_FROM_ENTITY(-1, 'Hydraulics_Down', players.user_ped(), 'Lowrider_Super_Mod_Garage_Sounds', true, 20)
                forceRecharge()
            end

            JSlang.toggle_loop(_LR['加速'], '助推', {'JSshuntBoost'}, '通过按"A"或"D"来推动载具.', function()
                util.create_thread(function()
                    if not is_user_driving_vehicle() then return end

                    local prevDPress = JSkey.get_ms_since_last_press('VK_D')
                    local prevAPress = JSkey.get_ms_since_last_press('VK_A')

                    if not PAD._IS_USING_KEYBOARD(0) then
                        prevDPress = JSkey.get_ms_since_control_last_pressed(0, 'INPUT_COVER')
                        prevAPress = JSkey.get_ms_since_control_last_pressed(0, 'INPUT_PICKUP')
                    end

                    if (JSkey.is_key_just_down('VK_D') or JSkey.is_control_just_pressed(0, 'INPUT_COVER')) and prevDPress != -1 and prevDPress <= maxTimeBetweenPress then
                        shunt(1)
                    elseif (JSkey.is_key_just_down('VK_A') or JSkey.is_control_just_pressed(0, 'INPUT_PICKUP')) and prevAPress != -1 and prevAPress <= maxTimeBetweenPress then
                        shunt(-1)
                    end
                end)
            end)

            JSlang.toggle(_LR['加速'], '禁用充能', {'JSnoShutRecharge'}, '禁用充能.', function(toggle)
                shuntSettings.disableRecharge = toggle
            end)
            JSlang.slider(_LR['加速'], '力量', {'JSshuntForce'}, '多少力量施加在您的载具上.', 0, 1000, 30, 1, function(value)
                shuntSettings.maxForce = value
            end)

    -----------------------------------
    -- Shunt boost
    -----------------------------------
        JSlang.divider(_LR['加速'], '载具弹跳')

        local wasInAir
        local bouncy = 50
        JSlang.toggle_loop(_LR['加速'], '载具弹跳', {'JSvehBounce'}, '载具落地时增加一些弹性.', function()
            local isInAir = ENTITY.IS_ENTITY_IN_AIR(entities.get_user_vehicle_as_handle())
            if wasInAir and not isInAir then
                local vec = ENTITY.GET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle())
                ENTITY.SET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle(), vec.x, vec.y, (vec.z * -1 * bouncy / 100))
            end
            wasInAir = isInAir
        end)

        JSlang.slider_float(_LR['加速'], '弹性倍数', {'JSbounceMult'}, '', 1, 1000, bouncy, 1, function(value)
            bouncy = value
        end)

    -----------------------------------
    -- Vehicle doors
    -----------------------------------
        JSlang.list(_LR['Vehicle'], '载具车门', {'JSvehDoors'}, '')

        JSlang.toggle(_LR['载具车门'], '无敌车门', {'JSinvincibleDoors'}, '让您的车门不会脱落.', function(toggle)
            carSettings.indestructibleDoors.on = toggle
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end)

        JSlang.toggle_loop(_LR['载具车门'], '驾驶时关门', {'JSautoClose'}, '开始驾驶时关闭所有车门.', function()
            if not (is_user_driving_vehicle() and ENTITY.GET_ENTITY_SPEED(my_cur_car) > 1) then return end  --over a speed of 1 because car registers as moving then doors move

            if ENTITY.GET_ENTITY_SPEED(my_cur_car) < 10 then
                util.yield(800)
            else
                util.yield(600)
            end

            local closed = false
            for i, door in ipairs(carDoors) do
                if VEHICLE.GET_VEHICLE_DOOR_ANGLE_RATIO(my_cur_car, i - 1) > 0 and not VEHICLE.IS_VEHICLE_DOOR_DAMAGED(my_cur_car, i - 1) then
                    VEHICLE.SET_VEHICLE_DOOR_SHUT(my_cur_car, i - 1, false)
                    closed = true
                end
            end
            if notifications and closed then
                JSlang.toast('Closed your car doors.')
            end
        end)

        --credit to Wiri, I couldn't get the trunk to close/open so I copied him
        JSlang.action(_LR['载具车门'], '打开所有门', {'JScarDoorsOpen'}, '做这个来测试关于门的东西.', function()
            for i, door in ipairs(carDoors) do
                VEHICLE.SET_VEHICLE_DOOR_OPEN(my_cur_car, i - 1, false, false)
            end
        end)

        JSlang.action(_LR['载具车门'], '关闭所有门', {'JScarDoorsClosed'}, '做这个来测试关于门的东西.', function()
            VEHICLE.SET_VEHICLE_DOORS_SHUT(my_cur_car, false)
        end)

    -----------------------------------
    -- Plane options
    -----------------------------------
        JSlang.list(_LR['Vehicle'], '飞机选项', {'JSplane'}, '')

        local afterBurnerState = false
        JSlang.toggle_loop(_LR['飞机选项'], '飞机高温燃气切换', {'JSafterburner'}, '使您能够通过按"左shift"来切换飞机的高温燃气.', function()
            if JSkey.is_key_just_down('VK_LSHIFT') then
                afterBurnerState = not afterBurnerState
                VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, afterBurnerState)
            end
            if afterBurnerState then
                VEHICLE.SET_HELI_BLADES_FULL_SPEED(my_cur_car)
            end
        end, function()
            VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(my_cur_car, false)
        end)

        JSlang.toggle(_LR['飞机选项'], '锁定垂直起降', {'JSlockVtol'}, '锁定平面垂直起降螺旋桨的角度', function(toggle)
            VEHICLE._SET_DISABLE_VEHICLE_FLIGHT_NOZZLE_POSITION(my_cur_car, toggle)
        end)
    -----------------------------------

    local ghost_vehicle_option = JSlang.slider(_LR['Vehicle'], '幽灵载具', {'JSghostVeh'}, '修改您载具的不透明度.', 0 , 100, 100, 25, function(value)
        carSettings.ghostCar.on = value != 100
        carSettings.ghostCar.value = value / 25
        carSettings.ghostCar.setOption(value != 100)
    end)
    carSettings.ghostCar.on = menu.get_value(ghost_vehicle_option) != 100

    -----------------------------------
    -- Vehicle sounds
    -----------------------------------
        JSlang.list(_LR['Vehicle'], '载具声音', {'JSvehSounds'}, '')

        JSlang.toggle(_LR['载具声音'], '禁用偏时点火', {'JSdisablePops'}, '如果您的载具有偏时点火系统,将禁用那些烦人的排气爆裂声音.', function(toggle)
            carSettings.disableExhaustPops.on = toggle
            carSettings.disableExhaustPops.setOption(toggle)
        end)

        local car_sounds = {
            ['Default'] = function()
                return VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(ENTITY.GET_ENTITY_MODEL(my_cur_car))
            end,
            ['Silent'] = 'MINITANK',
            ['Electric'] = 'CYCLONE',
        }
        JSlang.slider_text(_LR['载具声音'], '引擎声音', {'JSengineSound'}, '', {'Default', 'Silent', 'Electric'}, function(index, value)
            AUDIO._FORCE_VEHICLE_ENGINE_AUDIO(entities.get_user_vehicle_as_handle(), if type(car_sounds[value]) == 'string' then car_sounds[value] else car_sounds[value]())
        end)

        JSlang.toggle_loop(_LR['载具声音'], '沉浸式电台', {'JSemersiveRadio'}, '当您不在第一人称模式下时,降低电台的声音.', function()
            AUDIO.SET_FRONTEND_RADIO_ACTIVE(CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(1) == 4)
        end, function()
            AUDIO.SET_FRONTEND_RADIO_ACTIVE(true)
        end)

        JSlang.toggle(_LR['载具声音'], 'NPC喇叭', {'JSnpcHorn'}, '让您按喇叭像NPC一样. 也能让您的车门静音.', function(toggle)
            carSettings.npcHorn.on = toggle
            VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
        end)
    -----------------------------------

    JSlang.toggle(_LR['Vehicle'], '姿态', {'JSstance'}, '在支持切换的载具上激活姿态', function(toggle)
        VEHICLE._SET_REDUCE_DRIFT_VEHICLE_SUSPENSION(my_cur_car, toggle)
    end)

    JSlang.toggle_loop(_LR['Vehicle'], '飞到月球', {'JStoMoon'}, '如果您在载具内,强制您飞向高空.', function(toggle)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
        ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, 100.0, 0, 0, 0.5, 0, false, false, true)
    end)

    JSlang.toggle_loop(_LR['Vehicle'], '锚', {'JSanchor'}, '如果您的载具在空中,会强制您回到地面.', function(toggle)
        if ENTITY.IS_ENTITY_IN_AIR(my_cur_car) then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
            ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, -100.0, 0, 0, 0.5, 0, false, false, true)
        end
    end)
end

-----------------------------------
-- Online
-----------------------------------
do
    JSlang.list(menu_root, 'Online', {'JSonline'}, '')

    -----------------------------------
    -- Fake money
    -----------------------------------
        JSlang.list(_LR['Online'], '假钱', {'JSfakeMoney'}, '添加假钱,只能看不能花.')

        local cashFakeMoney = 0
        local bankFakeMoney = 0
        local fakeMoneyLoopDelay = new.delay(250, 0, 0)
        local fakeMoneyTransactionPending = true

        local function transactionPending()
            if not fakeMoneyTransactionPending then return end
            startBusySpinner('Transaction pending')
            util.yield(math.random(1, 1000))
            HUD.BUSYSPINNER_OFF()
        end

        JSlang.action(_LR['假钱'], '添加假钱', {'JSaddFakeMoney'}, '添加假钱1次.', function()
            HUD.CHANGE_FAKE_MP_CASH(cashFakeMoney, bankFakeMoney)
            transactionPending()
        end)

        JSlang.toggle_loop(_LR['假钱'], '循环假钱', {'JSloopFakeMoney'}, '设置循环添加钱的延迟.', function()
            HUD.CHANGE_FAKE_MP_CASH(cashFakeMoney, bankFakeMoney)
            transactionPending()
            util.yield(getTotalDelay(fakeMoneyLoopDelay))
        end)

        JSlang.toggle(_LR['假钱'], '显示"交易处理中"', {'JSfakeTransaction'}, '添加假钱的时候在右下角显示"交易处理中"的信息.', function(toggle)
            fakeMoneyTransactionPending = toggle
        end, fakeMoneyTransactionPending)

        JSlang.list(_LR['假钱'], '假钱循环延迟', {'JSexpDelay'}, '让您为假钱循环设置自定义延迟.')
        generateDelaySettings(_LR['假钱循环延迟'], '假钱循环延迟', fakeMoneyLoopDelay)

        JSlang.slider(_LR['假钱'], '银行假钱', {'JSbankFakeMoney'}, '将会有多少假钱被添加到您的银行.', -2000000000, 2000000000, bankFakeMoney, 1, function(value)
            bankFakeMoney = value
        end)

        JSlang.slider(_LR['假钱'], '现金假钱', {'JScashFakeMoney'}, '将会有多少假钱以现金形式添加.', -2000000000, 2000000000, cashFakeMoney, 1, function(value)
            cashFakeMoney = value
        end)

    -----------------------------------
    -- Safe monitor
    -----------------------------------
        JSlang.list(_LR['Online'], '保险箱监视器', {'JSsm'}, '保险箱监视器允许您监视您的保险箱. 它不会影响正在增加的钱')

        safeMonitorToggle = false
        JSlang.toggle(_LR['保险箱监视器'], '启用监视', {'SMtoggleAllSelected'}, '启用监视所有已选择的选项.', function(toggle)
            safeMonitorToggle = toggle
        end)

        JS_tbls.safeManagerToggles = {
            {
                name = '夜总会保险箱',
                command = 'SMclub',
                description = '监视夜总会保险箱的现金,这不会影响收入.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Nightclub Cash') ..': '.. STAT_GET_INT('CLUB_SAFE_CASH_VALUE')  / 1000  ..'k / 210k'
                end
            },
            {
                name = '夜总会人气',
                command = 'SMclubPopularity',
                description = '',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('夜总会人气') ..': '.. math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)  ..'%'
                end
            },
            {
                name = '夜总会每日收入',
                command = 'SMnightclubEarnings',
                description = '夜总会每日收入.\n每日最高收入为1万.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('夜总会每日收入') ..': '.. getNightclubDailyEarnings() / 1000  ..'k / day'
                end
            },
            {
                name = '游戏厅保险箱',
                command = 'SMarcade',
                description = '监视游戏厅保险箱的现金,这不会影响收入.\n如果您拥有所有街机游戏,则每日最高收入为5000.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Arcade Cash') ..': '.. STAT_GET_INT('ARCADE_SAFE_CASH_VALUE') / 1000  ..'k / 100k'
                end
            },
            {
                name = '事务所保险箱',
                command = 'SMagency',
                description = '监视事务所保险箱的现金,这不会影响收入.\n每日最高收入为2万.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Agency Cash') ..': '.. STAT_GET_INT('FIXER_SAFE_CASH_VALUE') / 1000  ..'k / 250k'
                end
            },
            {
                name = '安保合约',
                command = 'SMsecurity',
                description = '显示您已完成的事务所安保合约的任务数量.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('安保合约') ..': '.. STAT_GET_INT('FIXER_COUNT')
                end
            },
            {
                name = '事务所每日收入',
                command = 'SMagencyEarnings',
                description = '事务所每日收入.\n如果您已完成200份合约,则每日最高收入为2万',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('事务所每日收入') ..': '.. getAgencyDailyEarnings(STAT_GET_INT('FIXER_COUNT')) / 1000 ..'k / day'
                end
            },
        }
        generateToggles(JS_tbls.safeManagerToggles, _LR['保险箱监视器'], false)

        local first_open_SM_earnings = {true}
        JSlang.list(_LR['保险箱监视器'], '增加保险箱收益', {'SMearnings'}, '可能有风险.', function()
            listWarning(_LR['增加保险箱收益'], first_open_SM_earnings)
        end)

        local nightclubpopularity_command = menu.ref_by_path('Online>Quick Progress>Set Nightclub Popularity', 37)
        JSlang.toggle_loop(_LR['增加保险箱收益'], '自动增加夜总会人气', {'SMautoClubPop'}, '如果低于每日最大收入,则自动将夜店人气设置为100', function(toggle)
            if getNightclubDailyEarnings() < 50000 then
                menu.trigger_command(nightclubpopularity_command, 100)
            end
        end)

        local fixer_count_cooldown = false
        local soloPublic_command = menu.ref_by_path('Online>New Session>Create Public Session', 37)
        JSlang.action(_LR['增加保险箱收益'], '增加安保合约完成数量', {'SMsecurityComplete'}, '会让您进入一个新的公开战局以使增加生效.\n我在按钮上添加了冷却时间,所以您不能一直按它.\n超过200时将不会有效果.', function()
            if fixer_count_cooldown then JSlang.toast('Cooldown active') return end
            if util.is_session_transition_active() then JSlang.toast('You can only use this while in a session.') return end
            if STAT_GET_INT('FIXER_COUNT') >= 200 then JSlang.toast('You already reached 200 completions.') return end

            fixer_count_cooldown = true
            STAT_SET_INCREMENT('FIXER_COUNT', 1)
            util.yield(10)
            menu.trigger_command(soloPublic_command)
            util.yield(7000)
            fixer_count_cooldown = false
        end)

    -----------------------------------
    -- Property tp
    -----------------------------------
        -- warehouse = 473
        -- vehicle cargo = 524
        local propertyBlips = {
            [1] = { name = JSlang.str_trans('Ceo办公室'),   sprite = 475 },
            [2] = { name = JSlang.str_trans('摩托帮会所'), sprite = 492,
                subProperties = {listName = JSlang.str_trans('摩托帮产业'), properties = {
                    [1] = { name = JSlang.str_trans('大麻'),           sprite = 496 },
                    [2] = { name = JSlang.str_trans('可卡因'),      sprite = 497 },
                    [3] = { name = JSlang.str_trans('假证件'),    sprite = 498 },
                    [4] = { name = JSlang.str_trans('冰毒'), sprite = 499 },
                    [5] = { name = JSlang.str_trans('假钞'),    sprite = 500 },
                }}
            },
            [3] = { name = JSlang.str_trans('Bunker'),     sprite = 557 },
            [4] = { name = JSlang.str_trans('机库'),     sprite = 569 },
            [5] = { name = JSlang.str_trans('设施'),   sprite = 590 },
            [6] = { name = JSlang.str_trans('夜总会'), sprite = 614 },
            [7] = { name = JSlang.str_trans('游戏厅'),     sprite = 740 },
            [8] = { name = JSlang.str_trans('改装铺'),  sprite = 779 },
            [9] = { name = JSlang.str_trans('事务所'),     sprite = 826 },
        }

        local function getUserPropertyBlip(sprite)
            local blip = HUD.GET_FIRST_BLIP_INFO_ID(sprite)
            while blip ~= 0 do
                local blipColour = HUD.GET_BLIP_COLOUR(blip)
                if HUD.DOES_BLIP_EXIST(blip) and blipColour != 55 and blipColour != 3 then return blip end
                blip = HUD.GET_NEXT_BLIP_INFO_ID(sprite)
            end
        end

        local function tpToBlip(blip)
            local pos = HUD.GET_BLIP_COORDS(blip)
            local tpEntity = (PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), true) and my_cur_car or players.user_ped())
            ENTITY.SET_ENTITY_COORDS(tpEntity, pos, false, false, false, false)
        end

        local propertyTpRefs = {}
        local function regenerateTpLocations(root)
            for k, _ in pairs(propertyTpRefs) do
                menu.delete(propertyTpRefs[k])
                propertyTpRefs[k] = nil
            end
            for i = 1, #propertyBlips do
                local propertyBlip = getUserPropertyBlip(propertyBlips[i].sprite)
                if propertyBlip == nil then continue end

                propertyTpRefs[propertyBlips[i].name] = menu.action(root, propertyBlips[i].name, {}, '', function()
                    if not HUD.DOES_BLIP_EXIST(propertyBlip) then
                        JSlang.toast('Couldn\'t find property.')
                        return
                    end
                    tpToBlip(propertyBlip)
                end)
                if propertyBlips[i].subProperties then
                    local subProperties = propertyBlips[i].subProperties
                    local listName = subProperties.listName
                    propertyTpRefs[listName] = menu.list(root, listName, {}, '')
                    for j = 1, #subProperties.properties do
                        local subPropertyBlip = getUserPropertyBlip(subProperties.properties[j].sprite)
                        if propertyBlip == nil then continue end

                        menu.action(propertyTpRefs[listName], subProperties.properties[j].name, {}, '', function() --no need to have refs to these because they get deleted with the sublist
                            if not HUD.DOES_BLIP_EXIST(propertyBlip) then
                                JSlang.toast('Couldn\'t find property.')
                                return
                            end
                            tpToBlip(subPropertyBlip)
                        end)
                    end
                end
            end
        end

        JSlang.list(_LR['Online'], '资产传送', {'JSpropertyTp'}, '让您传送到您拥有的资产.', function()
            regenerateTpLocations(_LR['资产传送'])
        end)

        propertyTpRefs['tmp'] = menu.action(_LR['资产传送'], '', {}, '', function()end)

    ----------------------------------
    -- Casino
    ----------------------------------
        JSlang.list(_LR['Online'], 'Casino', {'JScasino'}, '这里没有刷钱选项.')

        local last_LW_seconds = 0
        JSlang.toggle_loop(_LR['Casino'], '幸运转盘冷却', {'JSlwCool'}, '告诉您幸运转盘是否可用或距离它还有多长冷却时间.', function()
            if STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') < util.current_unix_time_seconds() then JSlang.toast('Lucky wheel is available.') return end
            local secondsLeft = STAT_GET_INT_MPPLY('mpply_lucky_wheel_usage') - util.current_unix_time_seconds()
            local hours = math.floor(secondsLeft / 3600)
            local minutes = math.floor((secondsLeft / 60) % 60)
            local seconds = secondsLeft % 60
            if last_LW_seconds != seconds then
                util.toast((hours < 10 and ('0'.. hours) or hours) ..':'.. (minutes < 10 and ('0'.. minutes) or minutes) ..':'.. (seconds < 10 and ('0'.. seconds) or seconds))
                last_LW_seconds = seconds
            end
        end)

        JSlang.action(_LR['Casino'], '赌场 赢/输', {'JScasinoLP'}, '告诉您在赌场赚了多少或输了多少.', function()
            local chips = STAT_GET_INT_MPPLY('mpply_casino_chips_won_gd')
            if chips > 0 then
                util.toast(JSlang.str_trans('You\'ve made') ..' '.. chips ..' '.. JSlang.str_trans('chips.'))
            elseif chips < 0 then
                util.toast(JSlang.str_trans('You\'ve lost') ..' '.. chips * -1 ..' '.. JSlang.str_trans('chips.'))
            else
                JSlang.toast('You haven\'t made or lost any chips.')
            end
        end)

    ----------------------------------
    -- Time trial
    ----------------------------------
        JSlang.list(_LR['Online'], '时间挑战赛', {'JStt'}, '')

        local function ttTimeToString(time)
            local min = math.floor(time / 60000)
            local sec = (time % 60000) / 1000
            return (min == 0 and '' or min ..'min ') .. sec ..'s'
        end

        JSlang.divider(_LR['时间挑战赛'], '时间挑战赛')

        JSlang.toggle_loop(_LR['时间挑战赛'], '时间挑战赛 最佳记录', {'JSbestTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString((STAT_GET_INT_MPPLY('mpply_timetrialbesttime'))))
            util.yield(100)
        end)

        JSlang.action(_LR['时间挑战赛'], '传送到时间挑战赛', {'JStpToTT'}, '', function()
            local ttBlip = HUD._GET_CLOSEST_BLIP_OF_TYPE(430)
            if not HUD.DOES_BLIP_EXIST(ttBlip) then
                JSlang.toast('Couldn\'t find time trial.')
                return
            end
            tpToBlip(ttBlip)
        end)

        JSlang.divider(_LR['时间挑战赛'], 'RC匪徒时间挑战赛')

        JSlang.toggle_loop(_LR['时间挑战赛'], 'RC匪徒时间挑战赛 最佳记录', {'JSbestRcTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString(STAT_GET_INT_MPPLY('mpply_rcttbesttime')))
            util.yield(100)
        end)

        JSlang.action(_LR['时间挑战赛'], '传送到RC匪徒时间挑战赛', {'JStpToRcTT'}, '', function()
            local ttBlip = HUD._GET_CLOSEST_BLIP_OF_TYPE(673)
            if not HUD.DOES_BLIP_EXIST(ttBlip) then
                JSlang.toast('Couldn\'t find rc time trial.')
                return
            end
            tpToBlip(ttBlip)
        end)

    ----------------------------------
    -- Block areas
    ----------------------------------

        --skidded from keramisScript
        local function netItAll(entity)
            local netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
            while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            end
            NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(netID)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(netID)
            NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netID, false)
            local playerList = players.list(true, true, true)
            for i = 1, #playerList do
                if NETWORK.NETWORK_IS_PLAYER_CONNECTED(i) then
                    NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(netID, playerList[i], true)
                end
            end
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(entity, true, false)
            ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(entity, false)
            if ENTITY.IS_ENTITY_AN_OBJECT(entity) then
                NETWORK.OBJ_TO_NET(entity)
            end
            ENTITY.SET_ENTITY_VISIBLE(entity, false)
        end

        local function block(cord)
            local hash = 309416120
            loadModel(hash)
            for i = 0, 180, 8 do
                local wall = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, cord[1], cord[2], cord[3], true, true, true)
                ENTITY.SET_ENTITY_HEADING(wall, toFloat(i))
                netItAll(wall)
                util.yield(10)
            end
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        end

        JSlang.list(_LR['Online'], '阻挡区域', {'JSblock'}, '用隐形墙阻挡某些区域,让其他人无法进入. 但如果您在加入战局的时候使用它,它会让你崩溃哈哈.')

        local blockInProgress = false
        local function blockAvailable(areaBlocked, areaName)
            if blockInProgress then JSlang.toast('A block is already being run.') return false end
            if areaBlocked then util.toast(JSlang.str_trans(areaName) ..' '.. JSlang.str_trans('is already blocked.')) return false end
            return true
        end

        local function setBlockStatus(on, areaName)
            if on then
                blockInProgress = true
                startBusySpinner(JSlang.str_trans('Blocking'))
                return
            end
            HUD.BUSYSPINNER_OFF()
            if notifications then util.toast(JSlang.str_trans('Successfully blocked') ..' '.. JSlang.str_trans(areaName) ..'.') end
            blockInProgress = false
        end

        JSlang.toggle_loop(_LR['阻挡区域'], '自定义阻挡', {}, '使您能够通过按"B"来阻挡您面前的区域.', function()
            local dir = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, 5.0, 0)
            GRAPHICS._DRAW_SPHERE(dir, 0.3, 52, 144, 233, 0.5)
            if JSkey.is_key_down('VK_B') then
                if blockInProgress then JSlang.toast('A block is already being run.') return end
                setBlockStatus(true)
                block({dir.x, dir.y, dir.z - 0.6})
                setBlockStatus(false, 'area')
            end
        end)

        JSlang.list(_LR['阻挡区域'], '阻挡洛圣都改车王', {'JSblockLSC'}, '阻挡进入洛圣都改车王.')
        JSlang.list(_LR['阻挡区域'], '阻挡赌场', {'JSblockCasino'}, '阻挡进入赌场.')
        JSlang.list(_LR['阻挡区域'], '阻挡花园银行', {'JSblockCasino'}, '阻挡进入花园银行.')

        local blockAreasActions = {
            --Orbital block
            {root = _LR['阻挡区域'], name = '天基炮发射室', coordinates = {{335.95837, 4834.216, -60.99977}}, blocked = false},
            -- Lsc blocks
            {root = _LR['阻挡洛圣都改车王'], name = '伯顿', coordinates = {{-357.66544, -134.26419, 38.23775}}, blocked = false},
            {root = _LR['阻挡洛圣都改车王'], name = 'LSIA', coordinates = {{-1144.0569, -1989.5784, 12.9626}}, blocked = false},
            {root = _LR['阻挡洛圣都改车王'], name = '梅萨', coordinates = {{721.08496, -1088.8752, 22.046721}}, blocked = false},
            {root = _LR['阻挡洛圣都改车王'], name = '布莱恩县', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = _LR['阻挡洛圣都改车王'], name = '佩立托湾', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = _LR['阻挡洛圣都改车王'], name = '本尼车坊', coordinates = {{-205.6571, -1309.4313, 31.093222}}, blocked = false},
            -- Casino blocks
            {root = _LR['阻挡赌场'], name = '赌场入口', coordinates = {{924.3438, 49.19933, 81.10636}, {922.5348, 45.917263, 81.10635}}, blocked = false},
            {root = _LR['阻挡赌场'], name = '赌场车库', coordinates = {{935.29553, -0.5328601, 78.56404}}, blocked = false},
            {root = _LR['阻挡赌场'], name = '幸运转盘', coordinates = {{1110.1014, 228.71582, -49.935845}}, blocked = false},
            --Maze bank block
            {root = _LR['阻挡花园银行'], name = '花园银行入口', coordinates = {{-81.18775, -795.82874, 44.227295}}, blocked = false},
            {root = _LR['阻挡花园银行'], name = '花园银行车库', coordinates = {{-77.96956, -780.9376, 38.473335}, {-82.82901, -781.81635, 38.50093}}, blocked = false},
            --Mc block
            {root = _LR['阻挡区域'], name = '霍伊会所', coordinates = {{-17.48541, -195.7588, 52.370953}, {-23.452509, -193.01324, 52.36245}}, blocked = false},
            --Arena war garages
            {root = _LR['阻挡区域'], name = '竞技场车库', coordinates = {
                {-362.912, -1870.2249, 20.527836}, {-367.41855, -1872.5348, 20.527836},
                {-375.58344, -1874.6719, 20.527828},  {-379.9853, -1876.0894, 20.527828},
                {-386.49762, -1880.2793, 20.527842},  {-390.3558, -1883.0833, 20.527842},
                {-396.9259, -1883.9537, 21.542086}
            }, blocked = false},
        }

        for i = 1, #blockAreasActions do
            local areaName = blockAreasActions[i].name
            menu.action(blockAreasActions[i].root, JSlang.str_trans('Block') ..' '.. JSlang.str_trans(areaName), {}, '', function ()
                if not blockAvailable(blockAreasActions[i].blocked, (JSlang.str_trans(areaName) == JSlang.str_trans('LSIA') and areaName or string.capitalize(areaName))) then return end
                setBlockStatus(true)
                blockAreasActions[i].blocked = true
                for j = 1, #blockAreasActions[i].coordinates do
                    block(blockAreasActions[i].coordinates[j])
                end
                setBlockStatus(false, areaName)
            end)
        end
end

-----------------------------------
-- Players options
-----------------------------------
local karma
do
    JSlang.list(menu_root, 'Players', {'JSplayers'}, '')

    -----------------------------------
    -- Whitelist
    -----------------------------------
        JSlang.list(_LR['Players'], '白名单', {'JSwhitelist'}, '适用于此子菜单的大多数选项.')

        JSlang.toggle(_LR['白名单'], '排除自己', {'JSWhitelistSelf'}, '排除爆炸时炸自己.非常酷的选项 ;P', function(toggle)
            whitelistGroups.user = not toggle
        end)

        JSlang.toggle(_LR['白名单'], '排除好友', {'JSWhitelistFriends'}, '排除爆炸时炸到好友...', function(toggle)
            whitelistGroups.friends = not toggle
        end)

        JSlang.toggle(_LR['白名单'], '排除陌生人', {'JSWhitelistStrangers'}, '我猜您如果只想炸您的朋友.', function(toggle)
            whitelistGroups.strangers = not toggle
        end)

        JSlang.text_input(_LR['白名单'], '白名单玩家', {'JSWhitelistPlayer'}, '让您通过名称将单个玩家列入白名单.', function(input)
            whitelistedName = input
        end, '')

        JSlang.list(_LR['白名单'], '白名单玩家列表', {'JSwhitelistList'}, '自定义玩家列表,用于选择您想要加入白名单的玩家.')

        local whitelistTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            whitelistTogglesTable[pid] = menu.toggle(_LR['白名单玩家列表'], playerName, {'JSwhitelist'.. playerName}, JSlang.str_trans('白名单') ..' '.. playerName ..' '.. JSlang.str_trans('将不会被所有玩家的选项所影响.'), function(toggle)
                if toggle then
                    whitelistListTable[pid] = pid
                    if notifications then
                        util.toast(JSlang.str_trans('已白名单') ..' '.. playerName)
                    end
                else
                    whitelistListTable[pid] = nil --removes the player from the whitelist
                end
            end)
        end)
        players.on_leave(function(pid)
            if not whitelistTogglesTable[pid] then return end
            menu.delete(whitelistTogglesTable[pid])
            whitelistListTable[pid] = nil --removes the player from the whitelist
        end)

    -----------------------------------
    -- Anti chat spam
    -----------------------------------
        JSlang.list(_LR['Players'], '反聊天轰炸', {}, '')

        local chatSpamSettings = {
            enabled = false,
            ignoreTeam = true,
            identicalMessages = 5,
        }
        local messageTable = {}
        chat.on_message(function(pid, message_sender, text, team_chat)
            if pid == players.user() then return end
            if not chatSpamSettings.enabled then return end
            if team_chat and chatSpamSettings.ignoreTeam then return end

            if messageTable[pid] == nil then
                messageTable[pid] = {}
            end

            local messageCount = (#messageTable[pid] != nil and #messageTable[pid] or 0)
            messageTable[pid][messageCount + 1] = text

            if #messageTable[pid] < chatSpamSettings.identicalMessages then return end
            for i = 1, #messageTable[pid] - 1 do
                if messageTable[pid][#messageTable[pid]] != messageTable[pid][#messageTable[pid] - i] then
                    messageTable[pid] = {}
                    return
                end
                if i == #messageTable[pid] - 1 then
                    menu.trigger_commands('kick'.. players.get_name(pid))
                    util.toast(JSlang.str_trans('Kicked') ..' '.. players.get_name(pid) ..' '.. JSlang.str_trans('for chat spam.'))
                end
            end
        end)

        JSlang.toggle(_LR['反聊天轰炸'], '反聊天轰炸', {'JSantiChatSpam'}, '如果有人不断发送相同的聊天信息则踢他们.', function(toggle)
            chatSpamSettings.enabled = toggle
        end)

        JSlang.toggle(_LR['反聊天轰炸'], '忽略团队聊天', {'JSignoreTeamSpam'}, '', function(toggle)
            chatSpamSettings.enabled = toggle
        end, chatSpamSettings.ignoreTeam)

        JSlang.slider(_LR['反聊天轰炸'], '相同信息', {'JSidenticalChatMessages'}, '玩家在被踢之前可以发送多少条相同的聊天消息.', 2, 9999, chatSpamSettings.identicalMessages, 1, function(value)
            chatSpamSettings.identicalMessages = value
        end)

    -----------------------------------
    -- Explosions
    -----------------------------------
        JSlang.action(_LR['Players'], '爆炸所有人', {'JSexplodeAll'}, '爆炸所有玩家.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for _, pid in pairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                explodePlayer(playerPed, false, expSettings)
            end
        end)

        explodeLoopAll = JSlang.toggle_loop(_LR['Players'], '循环爆炸所有人', {'JSexplodeAllLoop'}, '不断的爆炸所有玩家.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for _, pid in pairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                explodePlayer(playerPed, true, expSettings)
            end
            util.yield(getTotalDelay(expLoopDelay))
        end)
    -----------------------------------


    local function roundDecimals(float, decimals)
        decimals = 10 ^ decimals
        return math.floor(float * decimals) / decimals
    end

    --clockwise (like the clock is laying on the floor with face upwards) from the left when entering the room
    local orbitalTableCords = {
        [1] = { x = 330.48312, y = 4827.281, z = -59.368515 },
        [2] = { x = 327.5724,  y = 4826.48,  z = -59.368515 },
        [3] = { x = 325.95273, y = 4828.985, z = -59.368515 },
        [4] = { x = 327.79208, y = 4831.288, z = -59.368515 },
        [5] = { x = 330.61765, y = 4830.225, z = -59.368515 },
    }
    JSlang.toggle_loop(_LR['Players'], '天基炮检测', {'JSorbDetection'}, '当有人开始使用天基炮的时候告诉您.', function()
        local playerList = players.list(false, true, true)
        for i = 1, #playerList do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
            if TASK.GET_IS_TASK_ACTIVE(ped, 135) and ENTITY.GET_ENTITY_SPEED(ped) == 0 then
                local pos = NETWORK._NETWORK_GET_PLAYER_COORDS(playerList[i])
                for j = 1, #orbitalTableCords do
                    if roundDecimals(pos.x, 1) == roundDecimals(orbitalTableCords[j].x, 1) and roundDecimals(pos.y, 1) == roundDecimals(orbitalTableCords[j].y, 1) and roundDecimals(pos.z, 1) == roundDecimals(orbitalTableCords[j].z, 1) then
                        util.toast(players.get_name(playerList[i]) ..' '.. JSlang.str_trans('is using the orbital cannon'))
                    end
                end
            end
        end
    end)

    -----------------------------------
    -- Coloured otr reveal
    -----------------------------------
        JSlang.list(_LR['Players'], '标记人间蒸发玩家', {}, '')

        local markedPlayers = {}
        local otrBlipColour = 58
        JSlang.toggle_loop(_LR['标记人间蒸发玩家'], '标记人间蒸发玩家', {'JScolouredOtrReveal'}, '用彩色光点标记人间蒸发的玩家.', function()
            local playerList = players.list(false, true, true)
            for i, pid in pairs(playerList) do
                if players.is_otr(pid) and not markedPlayers[pid] then
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    markedPlayers[pid] = HUD.ADD_BLIP_FOR_ENTITY(ped)
                    HUD.SET_BLIP_COLOUR(markedPlayers[pid], otrBlipColour)
                    HUD.SHOW_HEADING_INDICATOR_ON_BLIP(markedPlayers[pid], true)
                elseif players.is_otr(pid) then
                    HUD.SET_BLIP_COLOUR(markedPlayers[pid], otrBlipColour)
                elseif not players.is_otr(pid) and markedPlayers[pid] then
                    util.remove_blip(markedPlayers[pid])
                    markedPlayers[pid] = nil
                end
            end
        end, function()
            local playerList = players.list(false, true, true)
            for i, pid in pairs(playerList) do
                if markedPlayers[pid] then
                    util.remove_blip(markedPlayers[pid])
                    markedPlayers[pid] = nil
                end
            end
        end)

        local otr_colour_slider = JSlang.slider(_LR['标记人间蒸发玩家'], '人间蒸发 显示颜色', {'JSortRevealColour'}, '',1, 81, otrBlipColour, 1, function(value)
            otrBlipColour = value + (value > 71 and 1 or 0) + (value > 77 and 2 or 0)
        end)

        JSlang.toggle_loop(_LR['标记人间蒸发玩家'], '人间蒸发 rgb颜色', {'JSortRgbReveal'}, '', function()
            menu.set_value(otr_colour_slider, (otrBlipColour == 84 and 1 or otrBlipColour + 1))
            util.yield(250)
        end)

    -----------------------------------
    -- Vehicle
    -----------------------------------
        JSlang.list(_LR['Players'], 'Vehicles', {'JSplayersVeh'}, '对所有玩家的载具进行处理')

        JSlang.toggle(_LR['Vehicles'], '锁定烧胎', {'JSlockBurnout'}, '让所有玩家的载具不能开只能烧胎', function(toggle)
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end
        end)

        local all_torque = 1000
        JSlang.slider(_LR['Vehicles'], '设置扭矩', {'JSsetAllTorque'}, '修改所有玩家载具的速度.', -1000000, 1000000, all_torque, 1, function(value)
            all_torque = value
            util.create_tick_handler(function()
                local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
                for k, playerPid in ipairs(playerList) do
                    local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, all_torque / 1000)
                    end
                end
                return (all_torque != 1000)
            end)
        end)

        JSlang.toggle(_LR['Vehicles'], '强制所有潜艇浮出水面', {'JSforceSurfaceAll'}, '强制让所有虎鲸浮出水面.\n与白名单不兼容.', function(toggle)
            local vehHandles = entities.get_all_vehicles_as_handles()
            local surfaced = 0
            for i = 1, #vehHandles do
                if ENTITY.GET_ENTITY_MODEL(vehHandles[i]) == 1336872304 then -- if Kosatka
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehHandles[i], toggle)
                    surfaced += 1
                end
            end
            if toggle and notifications then util.toast(JSlang.str_trans('Surfaced') ..' '.. surfaced ..' ' .. JSlang.str_trans('submarines.')) end
        end)
    -----------------------------------


    JSlang.toggle_loop(_LR['Players'], '禁飞区域', {'JSnoFly'}, '强迫所有乘坐飞行载具的玩家回到地面.', function()
        local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        for _, pid in pairs(playerList) do
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
            if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -0.8, 0, 0, 0.5, 0, false, false, true)
                if notifications then
                    JSlang.toast('Applied force')
                end
            end
        end
    end)

    JSlang.toggle_loop(_LR['Players'], '射击移除无敌', {'JSshootGods'}, '瞄准其他玩家时禁用他们的无敌. 主要适用于一些垃圾菜单.', function()
        local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
        for k, playerPid in ipairs(playerList) do
            local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
            if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), playerPed)) and players.is_godmode(playerPid) then
                util.trigger_script_event(1 << playerPid, {-1388926377, playerPid, -1762807505, math.random(0, 9999)})
            end
        end
    end)

    -----------------------------------
    -- Aim karma
    -----------------------------------
        JSlang.list(_LR['Players'], '瞄准惩罚', {'JSaimKarma'}, '对瞄准您的玩家做一些事情.')

        karma = {}
        function isAnyPlayerTargetingEntity(playerPed)
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in pairs(playerList) do
                if PLAYER.IS_PLAYER_TARGETTING_ENTITY(playerPid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(playerPid, playerPed) then
                    karma[playerPed] = {
                        pid = playerPid,
                        ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                    }
                    return true
                end
            end
            karma[playerPed] = nil
            return false
        end

        JSlang.toggle_loop(_LR['瞄准惩罚'], '射击', {'JSbulletAimKarma'}, '射击瞄准您的玩家.', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] then
                local pos = ENTITY.GET_ENTITY_COORDS(karma[userPed].ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos, pos.x, pos.y, pos.z + 0.1, 100, true, 100416529, userPed, true, false, 100.0)
                util.yield(getTotalDelay(expLoopDelay))
            end
        end)

        JSlang.toggle_loop(_LR['瞄准惩罚'], 'Explode', {'JSexpAimKarma'}, '使用您的自定义爆炸设置爆炸玩家.', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] then
                explodePlayer(karma[userPed].ped, true, expSettings)
            end
        end)

        JSlang.toggle_loop(_LR['瞄准惩罚'], '禁用无敌', {'JSgodAimKarma'}, '如果开着无敌的玩家瞄准你,这会通过向前推动他们的游戏画面来禁用他们的无敌模式', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] and players.is_godmode(karma[userPed].pid) then
                local karmaPid = karma[userPed].pid
                util.trigger_script_event(1 << karmaPid, {-1388926377, karmaPid, -1762807505, math.random(0, 9999)})
            end
        end)

        local stand_player_aim_punish =  menu.ref_by_path('World>Inhabitants>Player Aim Punishments>Anonymous Explosion', 37)
        JSlang.action(_LR['瞄准惩罚'], 'Stand玩家瞄准惩罚', {}, '连接到Stand的玩家瞄准惩罚', function()
            menu.focus(stand_player_aim_punish)
        end)
end

-----------------------------------
-- World
-----------------------------------
do
    JSlang.list(menu_root, 'World', {'JSworld'}, '')

    local irlTime = false
    local setClockCommand = menu.ref_by_path('World>Atmosphere>Clock>Time', 37)
    local smoothTransitionCommand = menu.ref_by_path('World>Atmosphere>Clock>Smooth Transition', 37)
    JSlang.toggle(_LR['World'], '同步时间', {'JSirlTime'}, '使游戏时间与您的现实时间相匹配. 请禁用Stand的时间 "平滑过渡".', function(toggle)
        irlTime = toggle
        if menu.get_value(smoothTransitionCommand) then menu.trigger_command(smoothTransitionCommand) end
        util.create_tick_handler(function()
            menu.trigger_command(setClockCommand, os.date('%H:%M:%S'))
            return irlTime
        end)
    end)

    local numpadControls = {
        -- plane
            107,
            108,
            109,
            110,
            111,
            112,
            117,
            118,
        --sub
            123,
            124,
            125,
            126,
            127,
            128,
    }
    JSlang.toggle_loop(_LR['World'], '禁用小键盘', {'JSdisableNumpad'}, '禁用小键盘,因此您在操作Stand时不会旋转您的飞机/潜艇', function()
        if not menu.is_open() or JSkey.is_key_down('VK_LBUTTON') or JSkey.is_key_down('VK_RBUTTON') then return end
        for _, control in pairs(numpadControls) do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    local mapZoom = 83
    JSlang.slider(_LR['World'], '地图缩放级别', {'JSmapZoom'}, '', 1, 100, mapZoom, 1, function(value)
        mapZoom = 83
        mapZoom = value
        util.create_tick_handler(function()
            HUD.SET_RADAR_ZOOM_PRECISE(mapZoom)
            return mapZoom != 83
        end)
    end)

    JSlang.toggle(_LR['World'], '启用脚印', {'JSfootSteps'}, '在所有表面上留下脚印.', function(toggle)
        GRAPHICS._SET_FORCE_PED_FOOTSTEPS_TRACKS(toggle)
    end)

    JSlang.toggle(_LR['World'], '启用车辆轨迹', {'JSvehicleTrails'}, '在所有表面上留下车辆的轨迹.', function(toggle)
        GRAPHICS._SET_FORCE_VEHICLE_TRAILS(toggle)
    end)

    JSlang.toggle_loop(_LR['World'], '禁用所有地图通知', {'JSnoMapNotifications'}, '自动删除那些不断发送的通知', function()
        HUD.THEFEED_HIDE_THIS_FRAME()
    end)


    JSlang.list(_LR['World'], '颜色覆盖', {}, '')

    local colourOverlay = new.colour( 0, 0, 10, 0.1 )

    JSlang.toggle_loop(_LR['颜色覆盖'], '颜色覆盖', {'JScolourOverlay'}, '在游戏上应用颜色过滤器.', function()
        directx.draw_rect(0, 0, 1, 1, colourOverlay)
    end)

    menu.rainbow(JSlang.colour(_LR['颜色覆盖']   , '设置覆盖颜色', {'JSoverlayColour'}, '', colourOverlay, true, function(colour)
        colourOverlay = colour
    end))

    -----------------------------------
    -- Trains
    -----------------------------------
        JSlang.list(_LR['World'], 'Trains', {'JStrains'}, '')

        local trainsStopped = false
        local function stopTrain(train)
            util.create_thread(function()
                while trainsStopped do
                    VEHICLE.SET_TRAIN_SPEED(train, -0.05)
                    util.yield_once()
                end
                VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(train, false)
            end)
        end

        JSlang.toggle(_LR['Trains'], '火车脱轨', {'JSderail'}, '使所有火车脱轨并停止.', function(toggle)
            local vehPointers = entities.get_all_vehicles_as_pointers()
            trainsStopped = toggle
            for i = 1, #vehPointers do
                local vehHash = entities.get_model_hash(vehPointers[i])
                if VEHICLE.GET_VEHICLE_CLASS_FROM_NAME(vehHash) == 21 then
                    local trainHandle = entities.pointer_to_handle(vehPointers[i])
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(trainHandle)
                    VEHICLE.SET_RENDER_TRAIN_AS_DERAILED(trainHandle, true)
                    stopTrain(trainHandle)
                end
            end
        end)

        JSlang.action(_LR['Trains'], '删除火车', {'JSdeleteTrain'}, '只是因为每个脚本都有火车选项,我必须也有一个反火车选项.', function()
            VEHICLE.DELETE_ALL_TRAINS()
        end)

        local markedTrains = {}
        local markedTrainBlips = {}
        JSlang.toggle_loop(_LR['Trains'], '标记附近的火车', {'JSnoMapNotifications'}, '用紫色光点标记附近的火车.', function()
            local vehPointers = entities.get_all_vehicles_as_pointers()
            removeValues(vehPointers, markedTrains)

            for i = 1, #vehPointers do
                local vehHash = entities.get_model_hash(vehPointers[i])
                if VEHICLE.GET_VEHICLE_CLASS_FROM_NAME(vehHash) == 21 then
                    if notifications then
                        JSlang.toast('Marked train')
                    end
                    table.insert(markedTrains, vehPointers[i])
                    local blip = HUD.ADD_BLIP_FOR_ENTITY(entities.pointer_to_handle(vehPointers[i]))
                    HUD.SET_BLIP_COLOUR(blip, 58)
                    table.insert(markedTrainBlips, blip)
                end
            end
            util.yield(100)
        end, function()
            for i = #markedTrainBlips, 1, -1 do
                util.remove_blip(markedTrainBlips[i])
                markedTrainBlips[i] = nil
                markedTrains[i] = nil
            end
        end)

    -----------------------------------
    -- Peds
    -----------------------------------
        JSlang.list(_LR['World'], 'NPC', {'JSpeds'}, '')

        local pedToggleLoops = {
            {name = '摔倒NPC', command = 'JSragdollPeds', description = '让附近的所有NPC都摔倒,哈哈.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_TO_RAGDOLL(ped, 2000, 2000, 0, true, true, true)
            end},
            {name = '死亡接触', command = 'JSdeathTouch', description = '杀死所有碰到您的NPC', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) or PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not ENTITY.IS_ENTITY_TOUCHING_ENTITY(ped, players.user_ped()) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
            {name = '寒冷NPC', command = 'JScoldPeds', description = '移除附近NPC的热特征', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_HEATSCALE_OVERRIDE(ped, 0)
            end},
            {name = '静音NPC', command = 'JSmutePeds', description = '因为我不想再听那个家伙谈论他的同性恋狗了.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                AUDIO.STOP_PED_SPEAKING(ped, true)
            end},
            {name = 'NPC喇叭加速', command = 'JSnpcHornBoost', description = '当NPC按喇叭的时候加速它们的载具.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not AUDIO.IS_HORN_ACTIVE(vehicle) then return end
                AUDIO.SET_AGGRESSIVE_HORNS(true) --Makes pedestrians sound their horn longer, faster and more agressive when they use their horn.
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end, onStop = function()
                AUDIO.SET_AGGRESSIVE_HORNS(false)
            end},
            {name = 'NPC警笛加速', command = 'JSnpcSirenBoost', description = '当NPC响起警车的警笛的时候加速它们的载具.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not VEHICLE.IS_VEHICLE_SIREN_ON(vehicle) then return end
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end},
            {name = '自动杀死敌人', command = 'JSautokill', description = '立即击杀NPC敌人.', action = function(ped) --basically copy pasted form wiri script
                local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(players.user_ped(), ped)
                if PED.IS_PED_A_PLAYER(ped) or ENTITY.IS_ENTITY_DEAD(ped) or not( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, players.user_ped()) ) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
        }
        for i = 1, #pedToggleLoops do
            JSlang.toggle_loop(_LR['NPC'], pedToggleLoops[i].name, {pedToggleLoops[i].command}, pedToggleLoops[i].description, function()
                local pedHandles = entities.get_all_peds_as_handles()
                for j = 1, #pedHandles do
                    pedToggleLoops[i].action(pedHandles[j])
                end
                util.yield(10)
            end, function()
                if pedToggleLoops[i].onStop then pedToggleLoops[i].onStop() end
            end)
        end

        JSlang.toggle_loop(_LR['NPC'], '杀死车主', {'JSkillJackedPeds'}, '抢车的时候自动杀死驾驶载具的NPC', function(toggle)
            if not PED.IS_PED_JACKING(players.user_ped()) then return end
            local jackedPed = PED.GET_JACK_TARGET(players.user_ped())
            util.yield(100)
            ENTITY.SET_ENTITY_HEALTH(jackedPed, 0, 0)
        end)

        JSlang.toggle(_LR['NPC'], '暴动模式', {'JSriot'}, '使附近的NPC充满敌意.', function(toggle)
            MISC.SET_RIOT_MODE_ENABLED(toggle)
        end)
end


JSlang.hyperlink(menu_root, '加入Discord服务器', 'https://discord.gg/QzqBdHQC9S', '加入 Jerry脚本 的服务器以建议功能、报告BUG和测试即将推出的新功能.')

local credTxt = {}

credTxt[#credTxt + 1]  = {line = function() return JSlang.str_trans('Coded by') ..' Jerry123#4508' end, bold = true, wait = 85}
credTxt[#credTxt + 1]  = {line = function() return JSlang.str_trans('Some contributions made by') end, bold = false, wait = 25}
credTxt[#credTxt + 1]  = {line = 'scriptcat#6566', bold = true, wait = 90}

credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('Thanks to') ..' zjz#9999 '.. JSlang.str_trans('for helping me with the discord and also donating $5 of BTC') end, bold = true, wait = 100}

credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('Translations made possible with help from:') end, bold = true, wait = 35}
credTxt[#credTxt + 1] = {line = 'zzzz#5116', bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'DumbBird#9143', bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'HIPASS#4090', bold = false, wait = 100}

credTxt[#credTxt + 1]  = {line = function() return JSlang.str_trans('Skids from:') end, bold = true, wait = 35}
credTxt[#credTxt + 1]  = {line = function() return 'LanceScript '.. JSlang.str_trans('by') ..' lance#8213' end, bold = false, wait = 25}
credTxt[#credTxt + 1]  = {line = function() return 'WiriScript '.. JSlang.str_trans('by') ..' Nowiry#2663' end, bold = false, wait = 25}
credTxt[#credTxt + 1]  = {line = function() return 'KeramisScript '.. JSlang.str_trans('by') ..' scriptCat#6566' end, bold = false, wait = 25}
credTxt[#credTxt + 1]  = {line = function() return 'Heist control '.. JSlang.str_trans('by') ..' IceDoomfist#0001' end, bold = false, wait = 25}
credTxt[#credTxt + 1]  = {line = function() return 'Meteor '.. JSlang.str_trans('by') ..' RulyPancake the 5th#1157' end, bold = false, wait = 100}

credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('Thanks to') end, bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = function() return 'Ren#5219 and JayMontana36#9565' end, bold = true, wait = 35}
credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('for reviewing my code') end, bold = false, wait = 100}

credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('Big thanks to all the cool people who helped me in #programming in the stand discord') end, bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'Sapphire#1053', bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'aaronlink127#0127', bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'Fwishky#4980', bold = false, wait = 25}
credTxt[#credTxt + 1] = {line = 'Prism#7717', bold = false, wait = 100}

credTxt[#credTxt + 1] = {line = 'Goddess Sainan#0001', bold = true, wait = 35}
credTxt[#credTxt + 1] = {line = function() return JSlang.str_trans('For making stand and providing such a great api and documentation') end, bold = false, wait = 25}

local playingCredits = false
local creditsSpeed = 1
local play_credits_toggle
local anticrashcam_command = menu.ref_by_path('Game>Camera>Anti-Crash Camera', 37)
local function creditsPlaying(toggle)
    playingCredits = toggle
    menu.trigger_command(anticrashcam_command, if toggle then 'on' else 'off')
    util.create_tick_handler(function()
        directx.draw_rect(0, 0, 1, 1, black)
        directx.draw_texture(JS_logo, 0.25, 0.25, 0.5, 0.5, 0.14, 0.5, 0 , white)
        if (JSkey.is_key_down('VK_ESCAPE') or JSkey.is_key_down('VK_BACK')) and playingCredits then menu.trigger_command(play_credits_toggle, 'off') end
        creditsSpeed = (JSkey.is_key_down('VK_SPACE') and 2.5 or 1)
        HUD.HUD_FORCE_WEAPON_WHEEL(false)
        return playingCredits
    end)
    util.yield(900)
    AUDIO.SET_RADIO_FRONTEND_FADE_TIME(3)
    AUDIO.SET_AUDIO_FLAG('MobileRadioInGame',toggle)
    AUDIO.SET_FRONTEND_RADIO_ACTIVE(toggle)
    AUDIO.SET_RADIO_STATION_MUSIC_ONLY('RADIO_18_90S_ROCK', true)
    AUDIO.SET_RADIO_TO_STATION_NAME('RADIO_16_SILVERLAKE')
    AUDIO._FORCE_RADIO_TRACK_LIST_POSITION('RADIO_16_SILVERLAKE', 'MIRRORPARK_LOCKED', 3 * 61000)
end

local function scrollCreditsLine(textTable, index)
    local i = 0
    while i <= 1000 do
        if not playingCredits then return end
        i += creditsSpeed
        local text = if type(textTable.line) == 'function' then textTable.line() else textTable.line
        directx.draw_text(0.5, 1  - i / 1000, text, 1, textTable.bold and  0.7 or 0.5, white, false)
        util.yield_once()
    end
    if index == #credTxt then
        for i = 0, 500 do
            directx.draw_text(0.5, 0.5, JSlang.str_trans('And thank you') ..' '.. players.get_name(players.user()) ..' '.. JSlang.str_trans('for using JerryScript'), 1, 0.7, white, false)
            util.yield_once()
        end
        util.yield(750)
        menu.trigger_command(play_credits_toggle, 'off')
    end
end

play_credits_toggle = JSlang.toggle(menu_root, '查看鸣谢', {}, '', function(toggle)
    creditsPlaying(toggle)
    if not toggle then return end
    for i = 1, #credTxt do
        if not playingCredits then return end
        util.create_thread(function()
            scrollCreditsLine(credTxt[i], i)
        end)
        local wait = 0
        while wait < credTxt[i].wait / creditsSpeed do -- i determine the line spacing is by this wait so i have to constantly check if credits are speed up to not fuck it up
            util.yield(1)
            wait += 1
        end
    end
end)


local playerInfoPid
local playerInfoToggles = {}
----------------------------------
-- Player options
----------------------------------
    players.on_join(function(pid)

        JSlang.list = function(root, name, tableCommands, description, ...)
            return menu.list(root, JSlang.trans(name), if tableCommands then tableCommands else {}, JSlang.trans(description), ...)
        end

        JSlang.divider(menu.player_root(pid), 'JerryScript') --added a divider here because Holy#9756 was bitching about it in vc
        local player_root = JSlang.list(menu.player_root(pid), 'JS 玩家选项')
        local playerPed = || -> PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerName = players.get_name(pid)

        ----------------------------------
        -- Player info toggle
        ----------------------------------
            playerInfoToggles[pid] = menu.mutually_exclusive_toggle(player_root, '玩家信息', {'JSplayerInfo'}, '显示有关此玩家的信息', playerInfoToggles, function(toggle)
                if toggle then
                    playerInfoPid = pid --hud is visible when this var is truthy
                elseif not is_any_exclusive_toggle_on(playerInfoToggles) then
                    playerInfoPid = nil
                end
            end)

        -----------------------------------
        -- Trolling
        -----------------------------------
            local trolling_root = JSlang.list(player_root, 'Trolling', {'JStrolling'}, '')

            JSlang.action(trolling_root, '爆炸玩家', {'JSexplode'}, '使用您选择的爆炸选项爆炸此玩家.', function()
                explodePlayer(playerPed(), false, expSettings)
            end)

            JSlang.toggle_loop(trolling_root, '循环爆炸玩家', {'JSexplodeLoop'}, '使用您选择的选项循环爆炸.', function()
                explodePlayer(playerPed(), true, expSettings)
                util.yield(getTotalDelay(expLoopDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.action(trolling_root, '栽赃爆炸', {'JSexpBlame'}, '让您的爆炸归咎于他.', function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('栽赃') ..': '.. playerName)
            end)

            local damage_root = JSlang.list(trolling_root, '伤害', {}, '')

            JSlang.action(damage_root, '手榴弹', {'JSprimedGrenade'}, '在他头上丢下1个手榴弹', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.4, pos.x, pos.y, pos.z + 1.3, 100, true, -1813897027, players.user_ped(), true, false, 100.0)
            end)

            JSlang.action(damage_root, '粘弹', {'JSsticky'}, '在他头上丢下1个粘性炸弹,可能会粘在他的载具上,你可以通过按"G"来引爆.', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1 , pos.x, pos.y, pos.z + 1.1, 10, true, 741814745, players.user_ped(), true, false, 100.0)
            end)

            JSlang.toggle_loop(trolling_root, '未被检测的掉钱袋 2022', {'JSfakeMoneyDrop'}, '掉落不会加钱的假钱袋.', function()
                util.create_thread(function()
                    local hash = 2628187989
                    loadModel(hash)
                    local pos = players.get_position(pid)
                    pos.x += math.random(-2, 2) / 10
                    pos.y += math.random(-2, 2) / 10
                    pos.z += math.random(13, 14) / 10
                    local money = entities.create_object(hash, pos)
                    ENTITY.APPLY_FORCE_TO_ENTITY(money, 3, 0, 0, -0.5, 0.0, 0.0, 0.0, true, true)
                    while not ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(money) do
                        util.yield_once()
                    end
                    AUDIO.PLAY_SOUND_FROM_COORD(-1, 'LOCAL_PLYR_CASH_COUNTER_COMPLETE', pos, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true, 2, false)
                    entities.delete_by_handle(money)
                end)
            end)

            --made by scriptcat#6566 ;) || requested by Erstarisk#5763
            local yeetMultiplier = 5
            local yeetRange = 100
            local stormDelay = new.delay(250, 0, 0)
            local function yeetEntities()
                local targetPos = players.get_position(pid)
                local pointerTables = {
                    entities.get_all_peds_as_pointers(),
                    entities.get_all_vehicles_as_pointers()
                }
                local range = yeetRange * yeetRange --squaring it, for VDIST2
                for _, pointerTable in pairs(pointerTables) do
                    for _, entityPointer in pairs(pointerTable) do
                        local entityPos = entities.get_position(entityPointer)
                        local distance = v3.distance(targetPos, entityPos)
                        if distance < range then
                            local entityHandle = entities.pointer_to_handle(entityPointer)
                            --check the entity is a ped in a car
                            if (ENTITY.IS_ENTITY_A_PED(entityHandle) and (not PED.IS_PED_IN_ANY_VEHICLE(entityHandle, true) and (not PED.IS_PED_A_PLAYER(entityHandle)))) or (not ENTITY.IS_ENTITY_A_PED(entityHandle))--[[for the vehicles]] then
                                local playerList = players.list(true, true, true)
                                if not ENTITY.IS_ENTITY_A_PED(entityHandle) then
                                    for _, pid in pairs(playerList) do
                                        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                                        if PED.GET_VEHICLE_PED_IS_IN(ped, false) == entityHandle then goto skip end --if the entity is a players car ignore it
                                    end
                                end
                                local localTargetPos = players.get_position(pid)
                                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entityHandle)
                                v3.sub(localTargetPos, entityPos) --subtract here, for launch.
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(entityHandle, 1, v3.getX(localTargetPos) * yeetMultiplier, v3.getY(localTargetPos) * yeetMultiplier, v3.getZ(localTargetPos) * yeetMultiplier, true, false, true, true)
                                ::skip::
                            end
                        end
                    end
                end
            end

            JSlang.action(trolling_root, '实体击杀', {'JSentityYeet'}, '将他附近的所有NPC和载具砸向他 ;)\n您要靠近他或观看他.', function ()
                yeetEntities()
            end)

            JSlang.toggle_loop(trolling_root, '实体风暴', {'JSentityStorm'}, '不断将他附近的所有NPC和载具砸向他 :p\n您要靠近他或观看他.', function ()
                yeetEntities()
                util.yield(getTotalDelay(stormDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.slider(trolling_root, '击杀/风暴 范围', {'JSpushRange'}, '附近实体必须有多近才会被目标玩家推动.', 1, 1000, yeetRange, 10, function (value)
                yeetRange = value
            end)

            JSlang.slider(trolling_root, '击杀/风暴 倍数', {'JSpushMultiplier'}, '实体被推向实体时施加多少力的倍数', 1, 1000, yeetMultiplier, 5, function(value)
                yeetMultiplier = value
            end)

            local strom_delay_root = JSlang.list(trolling_root, '风暴延迟', {'JSentStormDelay'}, '让您设置实体风暴中实体飞向目标频率的延迟.')
            generateDelaySettings(strom_delay_root, '风暴延迟', stormDelay)
        -----------------------------------

        JSlang.toggle_loop(player_root, '给予 关无敌枪', {'JSgiveShootGods'}, '使该玩家能够在射击玩家时禁用其他玩家的无敌(一些垃圾菜单).', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed)) and players.is_godmode(playerPid) then
                    util.trigger_script_event(1 << playerPid, {-1388926377, playerPid, -1762807505, math.random(0, 9999)})
                end
            end
            if not players.exists(pid) then util.stop_thread() end
        end)

        JSlang.toggle_loop(player_root, '给予 喇叭加速', {'JSgiveHornBoost'}, '使他能够通过按喇叭或激活警报器来加速载具.', function()
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
            if not (AUDIO.IS_HORN_ACTIVE(vehicle) or VEHICLE.IS_VEHICLE_SIREN_ON(vehicle)) then return end
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle)
            if AUDIO.IS_HORN_ACTIVE(vehicle) then
                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(vehicle, 1, 0.0, 1.0, 0.0, true, true, true, true)
            end
            if not players.exists(pid) then util.stop_thread() end
        end)

        -----------------------------------
        -- Give aim karma
        -----------------------------------
            local give_karma_root = JSlang.list(player_root, '给予 瞄准惩罚', {'JSgiveAimKarma'}, '当有人瞄准他时将受到的惩罚')

            --dosnt work on yourself
            JSlang.toggle_loop(give_karma_root, '射击', {'JSgiveBulletAimKarma'}, '射击瞄准他的玩家.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] then
                    local pos = ENTITY.GET_ENTITY_COORDS(karma[playerPed()].ped)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, players.user_ped(), true, false, 100.0)
                    util.yield(getTotalDelay(expLoopDelay))
                end
            end)

            JSlang.toggle_loop(give_karma_root, 'Explode', {'JSgiveExpAimKarma'}, '使用您的自定义爆炸设置进行爆炸.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] then
                    explodePlayer(karma[playerPed()].ped, true, expSettings)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(give_karma_root, '禁用无敌', {'JSgiveGodAimKarma'}, '如果有开着无敌的玩家瞄准了他,这将使瞄准者的无敌失效.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] and players.is_godmode(karma[playerPed()].pid) then
                    util.trigger_script_event(1 << karma[playerPed()].pid, {-1388926377, karma[playerPed()].pid, -1762807505, math.random(0, 9999)})
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

        ----------------------------------
        -- Vehicle
        ----------------------------------
            local player_veh_root = JSlang.list(player_root, 'Vehicle')

            JSlang.toggle(player_veh_root, '锁定烧胎', {'JSlockBurnout'}, '让他的车不能开只能烧胎', function(toggle)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end)

            local player_torque = 1000
            JSlang.slider(player_veh_root, '设置扭矩', {'JSsetTorque'}, '修改他的车辆速度', -1000000, 1000000, player_torque, 1, function(value)
                player_torque = value
                util.create_tick_handler(function()
                    if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                        local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(playerVehicle, player_torque/1000)
                    end
                    return (player_torque != 1000)
                end)
            end)

            JSlang.toggle(player_veh_root, '浮出潜艇', {'JSforceSurface'}, '如果他正在驾驶潜艇,迫使他的潜艇浮出水面.', function(toggle)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) and ENTITY.GET_ENTITY_MODEL(vehicle) == 1336872304 then
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehicle, toggle)
                    if toggle and notifications then
                        util.toast(JSlang.str_trans('Forcing') ..' '.. playerName .. JSlang.str_trans('\'s submarine to the surface.'))
                    end
                end
            end)

            JSlang.toggle_loop(player_veh_root, '飞到月球', {'JStoMoon'}, '迫使他们的载具飞上天空.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, 100.0, 0, 0, 0.5, 0, false, false, true)
                    util.yield(10)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(player_veh_root, '锚', {'JSanchor'}, '如果他在空中飞行的载具中,会强制他回到地面.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                    if ENTITY.IS_ENTITY_IN_AIR(playerVehicle) then
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                        ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, -100.0, 0, 0, 0, 0, false, false, true)
                        util.yield(10)
                    end
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

        -----------------------------------
        -- Entity rain
        -----------------------------------
            local rain_root = JSlang.list(player_root, '实体雨', {'JSrain'}, '')

            local function rain(pid, entity)
                local pos = players.get_position(pid)
                local hash = util.joaat(entity)
                pos.x += math.random(-30,30)
                pos.y += math.random(-30,30)
                pos.z += 30
                loadModel(hash)
                local animal = entities.create_ped(28, hash, pos, 0)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
                ENTITY.SET_ENTITY_INVINCIBLE(animal, true)
                return animal
            end

            local rainOptions = {
                { name = '喵雨',    description = 'UWU',                                          animals = {'a_c_cat_01'},                                 spawned = {} },
                { name = '鲸鱼雨',     description = '<º)))><',                                      animals = {'a_c_fish', 'a_c_dolphin', 'a_c_killerwhale'}, spawned = {} },
                { name = '狗雨',     description = '*傲傲*',                                        animals = {'a_c_retriever', 'a_c_pug', 'a_c_rottweiler'}, spawned = {} },
                { name = '鸡雨', description = '*咯咯咯*',                                   animals = {'a_c_hen'},                                    spawned = {} },
                { name = '猴子雨',  description = '不知道猴子会发出什么声音',                 animals = {'a_c_chimp'},                                  spawned = {} },
                { name = '猪雨',     description = '(> (00) <)',                                   animals = {'a_c_pig'},                                    spawned = {} },
                { name = '老鼠雨',     description = '在您的电脑中植入远程访问木马. (开个玩笑)', animals = {'a_c_rat'},                                    spawned = {} }
            }
            for i = 1, #rainOptions do
                JSlang.toggle_loop(rain_root, rainOptions[i].name, {'JS'.. rainOptions[i].name}, rainOptions[i].description, function()
                    for _, animal in pairs(rainOptions[i].animals) do
                        rainOptions[i].spawned[#rainOptions[i].spawned + 1] = rain(pid, animal)
                        util.yield(500)
                    end
                    if not players.exists(pid) then util.stop_thread() end
                end, function()
                    for j, spawned in ipairs(rainOptions[i].spawned) do
                        entities.delete_by_handle(spawned)
                        rainOptions[i].spawned[j] = nil
                    end
                end)
            end

            JSlang.action(rain_root, '清除实体', {'JSclear'}, '删除所有掉落的实体', function()
                for i = 1, #rainOptions do
                    for j, spawned in ipairs(rainOptions[i].spawned) do
                        entities.delete_by_handle(spawned)
                        rainOptions[i].spawned[j] = nil
                    end
                end
            end)
        -----------------------------------
    end)

    players.on_leave(function(pid)
        playerInfoToggles[pid] = nil
        if pid == playerInfoPid then
            playerInfoPid = nil
        end
    end)

players.dispatch_on_join()

-----------------------------------
-- Script tick loop
-----------------------------------
util.create_tick_handler(function()
    -- car stuff
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 2) then --when exiting a car
        setCarOptions(false)
    elseif TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 160) then --when entering a vehicle
        setCarOptions(true)
    end

    local carCheck = entities.get_user_vehicle_as_handle()
    if my_cur_car != carCheck then
        my_cur_car = carCheck
        setCarOptions(true)
    end

    -- Player info hud
    if playerInfoPid then
        local ct = 0
        local spacing = 0.015 + piSettings.scale * piSettings.scale / 50
        local playerInfoPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerInfoPid)
        local weaponHash = getWeaponHash(playerInfoPed)
        for i = 1, #playerInfoTogglesOptions do
            local text = playerInfoTogglesOptions[i].displayText(playerInfoPid, playerInfoPed, weaponHash) --not all the functions uses all params but i don't wanna check what params i need to pass
            if playerInfoTogglesOptions[i].toggle and text then
                ct += spacing
                directx.draw_text(1 + piSettings.xOffset / 200, ct + piSettings.yOffset / 200, text, piSettings.alignment, piSettings.scale, piSettings.textColour, false)
            end
        end
    end

    -- Safe monitor
    if safeMonitorToggle then
        local ct = 0
        local spacing = 0.015 + smSettings.scale * smSettings.scale / 50
        for i = 1, #JS_tbls.safeManagerToggles do
            if JS_tbls.safeManagerToggles[i].toggle then
                ct += spacing
                directx.draw_text(1 + smSettings.xOffset / 200, ct + smSettings.yOffset / 200, JS_tbls.safeManagerToggles[i].displayText(), smSettings.alignment, smSettings.scale, smSettings.textColour, false)
            end
        end
    end
end)

util.log('Loaded JerryScript main file in '.. util.current_time_millis() - LOADING_START ..' ms.')

LOADING_SCRIPT = false
