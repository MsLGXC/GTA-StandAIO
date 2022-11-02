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
        JSlang.slider(root, 'X position', {prefix..'XPos'}, '', -200, 0, settingsTable.xOffset, 1, function(value)
            settingsTable.xOffset = value
        end)
        JSlang.slider(root, 'Y position', {prefix..'YPos'}, '', -5, 195, settingsTable.yOffset, 1, function(value)
            settingsTable.yOffset = value
        end)
        JSlang.slider(root, 'Scale', {prefix..'scale'}, 'The size of the text.', 200, 1500, 500, 1, function(value)
            settingsTable.scale = value / 1000
        end)
        JSlang.slider(root, 'Text alignment', {prefix..'alignment'}, '1 is center, 2 is left and 3 is right.', 1, 3, settingsTable.alignment, 1, function(value)
            settingsTable.alignment = value
        end)
        JSlang.colour(root, 'Text colour', {prefix..'colour'}, 'Sets the colour of the text overlay.', settingsTable.textColour, true, function(colour)
            settingsTable.textColour = colour
        end)
    end

    local function generateDelaySettings(root, name, delayTable)
        JSlang.slider(root, 'Ms', {'JS'..name..'DelayMs'}, 'The delay is the added total of ms, sec and min values.', 1, 999, delayTable.ms, 1, function(value)
            delayTable.ms = value
        end)
        JSlang.slider(root, 'Seconds', {'JS'..name..'DelaySec'}, 'The delay is the added total of ms, sec and min values.', 0, 59, delayTable.s, 1, function(value)
            delayTable.s = value
        end)
        JSlang.slider(root, 'Minutes', {'JS'..name..'DelayMin'}, 'The delay is the added total of ms, sec and min values.', 0, 60, delayTable.min, 1, function(value)
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
        menu.show_warning(listRoot, CLICK_MENU, JSlang.str_trans('I can\'t guarantee that these options are 100% safe. I tested them on my main, but im stupid.'), function()
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
        [1] = {1,  JSlang.str_trans('climbing Ladder')},
        [2] = {2,  JSlang.str_trans('exiting vehicle')},
        [3] = {160,  JSlang.str_trans('entering vehicle')},
        [4] = {335, JSlang.str_trans('parachuting')},
        [5] = {422,  JSlang.str_trans('jumping')},
        [6] = {423,  JSlang.str_trans('falling')},
    }
    local function getMovementType(ped)
        if PED.IS_PED_RAGDOLL(ped) then
            return  JSlang.str_trans('ragdolling')
        elseif PED.IS_PED_CLIMBING(ped) then
            return  JSlang.str_trans('climbing')
        elseif PED.IS_PED_VAULTING(ped) then
            return  JSlang.str_trans('vaulting')
        end
        for i = 1, #taskTable do
            if TASK.GET_IS_TASK_ACTIVE(ped, taskTable[i][1]) then return taskTable[i][2] end
        end
        if not isMoving(ped) then return end
        if PED.IS_PED_IN_ANY_VEHICLE(ped, true) then
            if PED.IS_PED_IN_ANY_PLANE(ped) then
                return  JSlang.str_trans('flying a plane')
            elseif PED.IS_PED_IN_ANY_HELI(ped) then
                return  JSlang.str_trans('flying a helicopter')
            elseif PED.IS_PED_IN_ANY_BOAT(ped) then
                return  JSlang.str_trans('driving a boat')
            elseif PED.IS_PED_IN_ANY_SUB(ped) then
                return  JSlang.str_trans('driving a submarine')
            elseif PED.IS_PED_ON_ANY_BIKE(ped) then
                return  JSlang.str_trans('biking')
            end
            return  JSlang.str_trans('driving')
        elseif PED.IS_PED_SWIMMING(ped) then
            return  JSlang.str_trans('swimming')
        elseif TASK.IS_PED_STRAFING(ped) then
            return  JSlang.str_trans('strafing')
        elseif TASK.IS_PED_SPRINTING(ped) then
            return  JSlang.str_trans('sprinting')
        elseif PED.GET_PED_STEALTH_MOVEMENT(ped) then
            return  JSlang.str_trans('sneaking')
        elseif TASK.IS_PED_GETTING_UP(ped) then
            return  JSlang.str_trans('getting up')
        elseif PED.IS_PED_GOING_INTO_COVER(ped) then
            return  JSlang.str_trans('going into cover')
        elseif PED.IS_PED_IN_COVER(ped) then
            return  JSlang.str_trans('moving in cover')
        else
            return  JSlang.str_trans('moving')
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
        JSlang.list(_LR['Settings'], 'Script settings', {'JSsettings'}, '')

        notifications = true
        JSlang.toggle(_LR['Script settings'], 'Disable JS notifications', {'JSnoNotify'}, 'Makes the script not notify when stuff happens. These can be pretty useful so I don\'t recommend turning them off.', function(toggle)
            notifications = not toggle
            if notifications then
                JSlang.toast('Notifications on')
            end
        end)

        local maxTimeBetweenPress = 300
        JSlang.slider(_LR['Script settings'], 'Double tap interval', {'JSdoubleTapInterval'}, 'Lets you set the maximum time between double taps in ms.', 1, 1000, 300, 1, function(value)
            maxTimeBetweenPress = value
        end)

        JSlang.action(_LR['Script settings'], 'Create translation template', {'JStranslationTemplate'}, 'Creates a template file for translation in store/JerryScript/Language.', function()
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

        JSlang.hyperlink(_LR['Script settings'], 'Command list', 'https://raw.githubusercontent.com/Jerrrry123/JerryScript/main/commandList.txt', 'A list of all the scripts features and commands.')

    ----------------------------------
    -- Player info settings
    ----------------------------------
        JSlang.list(_LR['Settings'], 'Player info settings', {'JSplayerInfoSettings'}, '')

        local piSettings = new.hudSettings(-151, 1, 3)
        generateHudSettings(_LR['Player info settings'], 'PI', piSettings)

        ----------------------------------
        -- Player info toggles
        ----------------------------------
            JSlang.list(_LR['Player info settings'], 'Display options', {'PIDisplay'}, '')

            local playerInfoTogglesOptions = {
                {
                    name = 'Disable name', command = 'PIdisableName', description = '', toggle = true,
                    displayText = function(pid)
                        return JSlang.str_trans('Player') ..': '.. players.get_name(pid)
                    end
                },
                {
                    name = 'Disable weapon', command = 'PIdisableWeapon', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local weaponName = getWeaponName(weaponHash)
                        return weaponName and JSlang.str_trans('Weapon') ..': '.. weaponName
                    end
                },
                {
                    name = 'Disable ammo info', command = 'PIdisableAmmo', description = '', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = WEAPON.GET_WEAPON_DAMAGE_TYPE(weaponHash)
                        if (damageType == 2 or damageType == 1 or damageType == 12) or WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) == util.joaat('GROUP_THROWN') or util.joaat('weapon_raypistol') == weaponHash then return end

                        local ammoCount
                        local ammo_ptr = memory.alloc_int()
                        if WEAPON.GET_AMMO_IN_CLIP(ped, weaponHash, ammo_ptr) and WEAPON.GET_WEAPONTYPE_GROUP(weaponHash) != util.joaat('GROUP_THROWN') then
                            ammoCount = memory.read_int(ammo_ptr)
                            local clipSize = WEAPON.GET_MAX_AMMO_IN_CLIP(ped, weaponHash, 1)
                            return ammoCount and JSlang.str_trans('Clip') ..': '.. ammoCount ..' / '.. clipSize
                        end
                    end
                },
                {
                    name = 'Disable damage type', command = 'PIdisableDamage', description = 'Displays the type of damage the players weapon does, like melee / fire / bullets / mk2 ammo.', toggle = true,
                    displayText = function(pid, ped, weaponHash)
                        local damageType = getDamageType(ped, weaponHash)
                        return damageType and JSlang.str_trans('Damage type') ..': '.. damageType
                    end
                },
                {
                    name = 'Disable vehicle', command = 'PIdisableVehicle', description = '', toggle = true,
                    displayText = function(pid, ped)
                        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then return end
                        local vehicleName = getPlayerVehicleName(ped)
                        return vehicleName and JSlang.str_trans('Vehicle') ..': '.. vehicleName
                    end
                },
                {
                    name = 'Disable score', command = 'PIdisableScore', description = 'Only shows when you or they have kills.', toggle = true,
                    displayText = function(pid)
                        local myScore = GET_INT_GLOBAL(2870058 + 386 + 1 + pid)
                        local theirScore = GET_INT_GLOBAL(2870058 + 353 + 1 + pid)
                        return (myScore > 0 or theirScore > 0) and (myScore ..' '.. JSlang.str_trans('Vs') ..' '.. theirScore) --only returns score if either part has kills
                    end
                },
                {
                    name = 'Disable moving indicator', command = 'PIdisableMovement', description = '', toggle = true,
                    displayText = function(pid, ped)
                        local movement = getMovementType(ped)
                        return movement and JSlang.str_trans('Player is') ..' '.. movement
                    end
                },
                {
                    name = 'Disable aiming indicator', command = 'PIdisableAiming', description = '', toggle = true,
                    displayText = function(pid)
                        return PLAYER.IS_PLAYER_TARGETTING_ENTITY(pid, players.user_ped()) and JSlang.str_trans('Player is aiming at you')
                    end
                },
                {
                    name = 'Disable reload indicator', command = 'PIdisableReload', description = '', toggle = true,
                    displayText = function(pid, ped)
                        return PED.IS_PED_RELOADING(ped) and JSlang.str_trans('Player is reloading')
                    end
                },
            }
            generateToggles(playerInfoTogglesOptions, _LR['Display options'], true)

    -----------------------------------
    -- Safe monitor settings
    -----------------------------------
        JSlang.list(_LR['Settings'], 'Safe monitor settings', {'SMsettings'}, 'Settings for the on screen text')

        smSettings = new.hudSettings(-3, 0, 2)
        generateHudSettings(_LR['Safe monitor settings'], 'SM', smSettings)

    -----------------------------------
    -- Explosion settings
    -----------------------------------
        JSlang.list(_LR['Settings'], 'Explosion settings', {'JSexpSettings'}, 'Settings for the different options that explode players in this script.')

        local expLoopDelay = new.delay(250, 0, 0)

        JSlang.list(_LR['Explosion settings'], 'Loop delay', {'JSexpDelay'}, 'Lets you set a custom delay between looped explosions.')
        generateDelaySettings(_LR['Loop delay'], 'Loop delay', expLoopDelay)

        -----------------------------------
        -- Fx explosion settings
        -----------------------------------
            local expSettings = {
                camShake = 0, invisible = false, audible = true, noDamage = false, owned = false, blamed = false, blamedPlayer = false,
                --stuff for fx explosions
                currentFx = JS_tbls.effects['Clown_Explosion'],
                colour = new.colour( 255, 0, 255 )
            }

            JSlang.list(_LR['Explosion settings'], 'FX explosions', {'JSfxExp'}, 'Lets you choose effects instead of explosion type.')

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

            JSlang.list_select(_LR['FX explosions'], 'FX type', {'JSfxExpType'}, 'Choose a fx explosion type.', getEffectLabelTableFromKeys(JS_tbls.effects), 5, function(index, name)
                if name == 'Explosion' then
                    expSettings.currentFx = nil
                else
                    expSettings.currentFx = JS_tbls.effects[name]
                end
            end)

            menu.rainbow(JSlang.colour(_LR['FX explosions'], 'FX colour', {'JSPfxColour'}, 'Only works on some pfx\'s.',  new.colour( 255, 0, 255 ), false, function(colour)
                expSettings.colour = colour
            end))
        -----------------------------------

        JSlang.slider(_LR['Explosion settings'], 'Camera shake', {'JSexpCamShake'}, 'How much explosions shake the camera.', 0, 1000, expSettings.camShake, 1, function(value)
            expSettings.camShake = toFloat(value)
        end)

        JSlang.toggle(_LR['Explosion settings'], 'Invisible explosions', {'JSexpInvis'}, '', function(toggle)
            expSettings.invisible = toggle
        end)

        JSlang.toggle(_LR['Explosion settings'], 'Silent explosions', {'JSexpSilent'}, '', function(toggle)
            expSettings.audible = not toggle
        end)

        JSlang.toggle(_LR['Explosion settings'], 'Disable explosion damage', {'JSnoExpDamage'}, '', function(toggle)
            expSettings.noDamage = toggle
        end)

        JSlang.list(_LR['Explosion settings'], 'Blame settings', {'JSblameSettings'}, 'Lets you blame yourself or other players for your explosions, go to the player list to chose a specific player to blame.')

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
        local exp_own_toggle = JSlang.toggle(_LR['Blame settings'], 'Owned explosions', {'JSownExp'}, 'Will overwrite "Disable explosion damage".', function(toggle)
            expSettings.owned = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_blame_toggle)
            end
        end)

        exp_blame_toggle = menu.toggle(_LR['Blame settings'], JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'), {'JSblameExp'}, JSlang.str_trans('Will overwrite "Disable explosion damage" and if you haven\'t chosen a player random players will be blamed for each explosion.'), function(toggle)
            expSettings.blamed = toggle
            if not runningToggling then
                mutuallyExclusiveToggles(exp_own_toggle)
            end
        end)

        JSlang.list(_LR['Blame settings'], 'Blame player list', {'JSblameList'}, 'Custom player list for selecting blames.')

        local blamesTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            blamesTogglesTable[pid] = menu.action(_LR['Blame player list'], playerName, {'JSblame'.. playerName}, JSlang.str_trans('Blames your explosions on them.'), function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. playerName)
                menu.focus(_LR['Blame player list'])
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
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'))
                if notifications then
                    JSlang.toast('Explosions stopped because the player you\'re blaming left.')
                end
            end
        end)

        JSlang.action(_LR['Blame settings'], 'Random blames', {'JSblameRandomExp'}, 'Switches blamed explosions back to random if you already chose a player to blame.', function()
            expSettings.blamedPlayer = false
            if not menu.get_value(exp_blame_toggle) then
                menu.trigger_command(exp_blame_toggle)
            end
            menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. JSlang.str_trans('Random'))
        end)

        local hornBoostMultiplier = 1.000
        JSlang.slider(_LR['Settings'], 'Horn boost multiplier', {'JShornBoostMultiplier'}, 'Set the force applied to the car when you or another player uses horn boost.', -100000, 100000, hornBoostMultiplier * 1000, 1, function(value)
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
    JSlang.toggle_loop(_LR['Self'], 'Ironman mode', {'JSironman'}, 'Grants you the abilities of ironman :)', function()
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
        SF.SET_DATA_SLOT(1, JSkey.get_control_instructional_button(0, 'INPUT_AIM'), JSlang.str_trans('Beam'))
        SF.SET_DATA_SLOT(0, JSkey.get_control_instructional_button(0, barrageInput), JSlang.str_trans('Barrage'))
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
        JSlang.list(_LR['Self'], 'Fire wings', {}, '')

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
        JSlang.toggle(_LR['Fire wings'], 'Fire wings', {'JSfireWings'}, 'Puts wings made of fire on your back.', function (toggle)
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

        JSlang.slider(_LR['Fire wings'], 'Fire wings scale', {'JSfireWingsScale'}, '', 1, 100, 3, 1, function(value)
            fireWingsSettings.scale = value / 10
        end)

        menu.rainbow(JSlang.colour(_LR['Fire wings'], 'Fire wings colour', {'JSfireWingsColour'}, '', fireWingsSettings.colour, false, function(colour)
            fireWingsSettings.colour = colour
        end))

    -----------------------------------
    -- Fire breath
    -----------------------------------
        JSlang.list(_LR['Self'], 'Fire breath', {}, '')

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

        JSlang.toggle(_LR['Fire breath'], 'Fire breath', {'JSfireBreath'}, '', function(toggle)
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

        JSlang.slider(_LR['Fire breath'], 'Fire breath scale', {'JSfireBreathScale'}, '', 1, 100, fireBreathSettings.scale * 10, 1, function(value)
            fireBreathSettings.scale = value / 10
        end)

        menu.rainbow(JSlang.colour(_LR['Fire breath'], 'Fire breath colour', {'JSfireBreathColour'}, '', fireBreathSettings.colour, false, function(colour)
            fireBreathSettings.colour = colour
        end))

    -----------------------------------
    -- Ped customization
    -----------------------------------
        local faceFeatures = {
            [0]  = 'Nose Width',
            [1]  = 'Nose Peak Hight',
            [2]  = 'Nose Peak Length',
            [3]  = 'Nose Bone Hight',
            [4]  = 'Nose Peak Lowering',
            [5]  = 'Nose Bone Twist',
            [6]  = 'Eyebrow Hight',
            [7]  = 'Eyebrow Forward',
            [8]  = 'Cheeks Bone Hight',
            [9]  = 'Cheeks Bone Width',
            [10] = 'Cheeks Width',
            [11] = 'Eyes Opening',
            [12] = 'Lips Thickness',
            [13] = 'Jaw Bone Width',
            [14] = 'Jaw Bone Back Length',
            [15] = 'Chin Bone Lowering',
            [16] = 'Chin Bone Length',
            [17] = 'Chin Bone Width',
            [18] = 'Chin Hole',
            [19] = 'Neck Width',
        }
        JSlang.list(_LR['Self'], 'Face features', {}, '')
        JSlang.list(_LR['Face features'], 'Customize face features', {}, 'Customizations reset after restarting the game.')

        local face_sliders = {}
        for i = 0, #faceFeatures do
            local faceValue = (util.is_session_started() and math.floor(STAT_GET_FLOAT('FEATURE_'.. i) * 100) or 0)
            face_sliders[faceFeatures[i]] = JSlang.slider(_LR['Customize face features'], faceFeatures[i], {'JSset'.. string.gsub(faceFeatures[i], ' ', '')}, '', -1000, 1000, faceValue, 1, function(value)
                PED._SET_PED_MICRO_MORPH_VALUE(players.user_ped(), i, value / 100)
            end)
        end

        menu.divider(_LR['Face features'], '', {}, '')

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

        JSlang.action(_LR['Face features'], 'Create face feature profile', {'JSsaveFaceFeatures'}, 'Saves your customized face in a file so you can load it.', function()
            menu.show_command_box('JSsaveFaceFeatures ')
        end, function(fileName)
            local f = assert(io.open(face_profiles_dir .. fileName ..'.txt', 'w'))
            for i = 0, #faceFeatures do
                f:write(faceFeatures[i] ..': '.. menu.get_value(face_sliders[faceFeatures[i]]) ..'\n')
            end
            f:close()
            reloadProfiles(_LR['Face features'])
        end)

        JSlang.action(_LR['Face features'], 'Reload profiles', {'JSreLoadFaceFeatureProfiles'}, 'Refreshes your profiles without having to restart the script.', function()
            reloadProfiles(_LR['Face features'])
        end)

        JSlang.divider(_LR['Face features'], 'Profiles')

        if filesystem.is_dir(face_profiles_dir) then
            loadProfiles(_LR['Face features'])
        end

        local faceOverlays = {
            [0]  = { name = 'Blemishes',          min = -1, max = 23 },
            [1]  = { name = 'Facial Hair',        min = -1, max = 28 },
            [2]  = { name = 'Eyebrows',           min = -1, max = 33 },
            [3]  = { name = 'Ageing',             min = -1, max = 14 },
            [4]  = { name = 'Makeup',             min = -1, max = 74 },
            [5]  = { name = 'Blush',              min = -1, max = 6  },
            [6]  = { name = 'Complexion',         min = -1, max = 11 },
            [7]  = { name = 'Sun Damage',         min = -1, max = 10 },
            [8]  = { name = 'Lipstick',           min = -1, max = 9  },
            [9]  = { name = 'Moles/Freckles',     min = -1, max = 17 },
            [10] = { name = 'Chest Hair',         min = -1, max = 16 },
            [11] = { name = 'Body Blemishes',     min = -1, max = 11 },
            [12] = { name = 'Add Body Blemishes', min = -1, max = 1  },
        }
        JSlang.list(_LR['Self'], 'Customize face overlays', {}, 'Customizations reset after restarting the game.')

        for i = 0, #faceOverlays do
            local overlayValue = PED._GET_PED_HEAD_OVERLAY_VALUE(players.user_ped(), i)
            JSlang.slider(_LR['Customize face overlays'], faceOverlays[i].name, {}, '', faceOverlays[i].min, faceOverlays[i].max, (overlayValue == 255 and -1 or overlayValue), 1, function(value)
                PED.SET_PED_HEAD_OVERLAY(players.user_ped(), i, (value == 255 and -1 or value), 1)
            end)
        end

    -----------------------------------
    -- Ragdoll options
    -----------------------------------
        JSlang.list(_LR['Self'], 'Ragdoll options', {'JSragdollOptions'}, 'Different options for making yourself ragdoll.')

        JSlang.toggle_loop(_LR['Ragdoll options'], 'Better clumsiness', {'JSclumsy'}, 'Like stands clumsiness, but you can get up after you fall.', function()
            if PED.IS_PED_RAGDOLL(players.user_ped()) then util.yield(3000) return end
            PED.SET_PED_RAGDOLL_ON_COLLISION(players.user_ped(), true)
        end)

        JSlang.action(_LR['Ragdoll options'], 'Stumble', {'JSstumble'}, 'Makes you stumble with a good chance of falling over.', function()
            local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(players.user_ped())
            PED.SET_PED_TO_RAGDOLL_WITH_FALL(players.user_ped(), 1500, 2000, 2, vector.x, -vector.y, vector.z, 1, 0, 0, 0, 0, 0, 0)
        end)

        -- credit to LAZScript for inspiring this
        local fallTimeout = false
        JSlang.toggle(_LR['Ragdoll options'], 'Fall over', {'JSfallOver'}, 'Makes you stumble, fall over and prevents you from getting back up.', function(toggle)
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
        JSlang.toggle_loop(_LR['Ragdoll options'], 'Ragdoll', {'JSragdoll'}, 'Just makes you ragdoll.', function()
            PED.SET_PED_TO_RAGDOLL(players.user_ped(), 2000, 2000, 0, true, true, true)
        end)
    -----------------------------------

    JSlang.list(_LR['Self'], 'Custom respawn', {}, '')

    local wasDead = false
    local respawnPos
    local respawnRot
    local custom_respawn_toggle = menu.toggle_loop(_LR['Custom respawn'], JSlang.str_trans('Custom respawn') ..': '.. JSlang.str_trans('none'), {}, JSlang.str_trans('Set a location that you respawn at when you die.'), function()
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

    local custom_respawn_location custom_respawn_location = JSlang.action(_LR['Custom respawn'], 'Save location', {}, 'No location set.', function()
        respawnPos = players.get_position(players.user())
        respawnRot = ENTITY.GET_ENTITY_ROTATION(players.user_ped(), 2)
        menu.set_menu_name(custom_respawn_toggle, JSlang.str_trans('Custom respawn') ..': '.. getZoneName(players.user()))
        local pos = 'X: '.. respawnPos.x ..'\nY: '.. respawnPos.y ..'\nZ: '.. respawnPos.z
        menu.set_help_text(custom_respawn_toggle,  pos)
        menu.set_help_text(custom_respawn_location,  JSlang.str_trans('Current location') ..':\n'.. pos)
    end)

    JSlang.slider(_LR['Self'], 'Ghost', {'JSghost'}, 'Makes your player different levels off see through.', 0, 100, 100, 25, function(value)
        ENTITY.SET_ENTITY_ALPHA(players.user_ped(), JS_tbls.alphaPoints[value / 25 + 1], false)
    end)

    JSlang.toggle_loop(_LR['Self'], 'Full regen', {'JSfullRegen'}, 'Makes your hp regenerate until you\'re at full health.', function()
        local health = ENTITY.GET_ENTITY_HEALTH(players.user_ped())
        if ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) == health then return end
        ENTITY.SET_ENTITY_HEALTH(players.user_ped(), health + 5, 0)
        util.yield(255)
    end)

    JSlang.toggle(_LR['Self'], 'Cold blooded', {'JScoldBlooded'}, 'Removes your thermal signature.\nOther players still see it tho.', function(toggle)
        PED.SET_PED_HEATSCALE_OVERRIDE(players.user_ped(), (toggle and 0 or 1.0))
    end)

    JSlang.toggle(_LR['Self'], 'Quiet footsteps', {'JSquietSteps'}, 'Disables the sound of your footsteps.', function(toggle)
        AUDIO._SET_PED_AUDIO_FOOTSTEP_LOUD(players.user_ped(), not toggle)
    end)
end

-----------------------------------
-- Weapons
-----------------------------------
do
    JSlang.list(menu_root, 'Weapons', {'JSweapons'}, '')

    local thermal_command = menu.ref_by_path('Game>Rendering>Thermal Vision', 37)
    JSlang.toggle_loop(_LR['Weapons'], 'Thermal guns', {'JSthermalGuns'}, 'Makes it so when you aim any gun you can toggle thermal vision on "E".', function()
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
        JSlang.list(_LR['Weapons'], 'Weapon settings', {}, '')

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
        JSlang.toggle_loop(_LR['Weapon settings'], 'Disable recoil', {'JSnoRecoil'}, 'Disables the camera shake when shooting guns.', function()
            local weaponHash = readWeaponAddress(modifiedRecoil, 0x2F4, true)
            if weaponHash == 0 then return end
            memory.write_float(modifiedRecoil[weaponHash].address, 0)
        end, function()
            resetWeapons(modifiedRecoil)
        end)

        local modifiedSpread = {}
        JSlang.toggle_loop(_LR['Weapon settings'], 'Disable spread', {'JSnoSpread'}, '', function()
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
        JSlang.toggle_loop(_LR['Weapon settings'], 'Remove spin-up time', {'JSnoSpinUp'}, 'Removes the spin-up from both the minigun and the widowmaker.', function()
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
        JSlang.toggle_loop(_LR['Weapon settings'], 'Bullet force multiplier', {'JSbulletForceMultiplier'}, 'Works best when shooting vehicles from the front.\nDisplayed value is in percent.', function()
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

        JSlang.divider(_LR['Weapon settings'], 'Aim fov')

        local extraZoom2 = 0
        local modifiedAimFov = {}
        JSlang.toggle_loop(_LR['Weapon settings'], 'Enable aim fov', {'JSenableAimFov'}, 'Lets you modify the fov you have while you\'re aiming.', function()
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

        JSlang.divider(_LR['Weapon settings'], 'Zoom aim fov')

        local extraZoom = 0
        local modifiedZoomFov = {}
        JSlang.toggle_loop(_LR['Weapon settings'], 'Enable zoom fov', {'JSenableZoomFov'}, 'Lets you modify the fov you have while you\'re aiming and has zoomed in.', function()
            local weaponHash = readWeaponAddress(modifiedZoomFov, 0x410, false)
            if weaponHash == 0 then return end
            memory.write_float(modifiedZoomFov[weaponHash].address,  modifiedZoomFov[weaponHash].original + extraZoom)
        end, function()
            resetWeapons(modifiedZoomFov)
        end)

        JSlang.slider_float(_LR['Weapon settings'], 'Zoom aim fov', {'JSzoomAimFov'}, '', 100, 9999999999, 100, 1, function(value)
            extraZoom = (value - 100) / 100
            modifiedZoomWeapon = nil
        end)

    -----------------------------------
    -- Proxy stickys
    -----------------------------------
        JSlang.list(_LR['Weapons'], 'Proxy stickys', {}, '')

        local proxyStickySettings = {players = true, npcs = false, radius = 2.0}
        local function autoExplodeStickys(ped)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, true)
            if MISC.IS_PROJECTILE_TYPE_WITHIN_DISTANCE(pos, util.joaat('weapon_stickybomb'), proxyStickySettings.radius, true) then
                WEAPON.EXPLODE_PROJECTILES(players.user_ped(), util.joaat('weapon_stickybomb'))
            end
        end

        JSlang.toggle_loop(_LR['Proxy stickys'], 'Proxy stickys', {'JSproxyStickys'}, 'Makes your sticky bombs automatically detonate around players or npc\'s, works with the player whitelist.', function()
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

        JSlang.toggle(_LR['Proxy stickys'], 'Detonate near players', {'JSProxyStickyPlayers'}, 'If your sticky bombs automatically detonate near players.', function(toggle)
            proxyStickySettings.players = toggle
        end, proxyStickySettings.players)

        JSlang.toggle(_LR['Proxy stickys'], 'Detonate near npc\'s', {'JSProxyStickyNpcs'}, 'If your sticky bombs automatically detonate near npc\'s.', function(toggle)
            proxyStickySettings.npcs = toggle
        end, proxyStickySettings.npcs)

        JSlang.slider(_LR['Proxy stickys'], 'Detonation radius', {'JSstickyRadius'}, 'How close the sticky bombs have to be to the target to detonate.', 1, 10, proxyStickySettings.radius, 1, function(value)
            proxyStickySettings.radius = toFloat(value)
        end)

        JSlang.action(_LR['Proxy stickys'], 'Remove all sticky bombs', {'JSremoveStickys'}, 'Removes every single sticky bomb that exists (not only yours).', function()
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
    JSlang.list(_LR['Weapons'], 'Nuke options', {}, '')

    local nuke_gun_option
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['Nuke options'], 'Nuke gun', {'JSnukeGun'}, 'Makes the rpg fire nukes', mutually_exclusive_weapons, function(toggle)
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

    JSlang.action(_LR['Nuke options'], 'Nuke waypoint', {'JSnukeWP'}, 'Drops a nuke on your selected Waypoint.', function ()
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

    JSlang.slider(_LR['Nuke options'], 'Nuke height', {'JSnukeHeight'}, 'The height of the nukes you drop.', 10, 100, nuke_height, 10, function(value)
        nuke_height = value
    end)

    --this is heavily skidded from wiriScript so credit to wiri
    local launcherThrowable = util.joaat('weapon_grenade')
    JSlang.list(_LR['Weapons'], 'Throwables launcher', {}, '')

    local throwables_launcher
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['Throwables launcher'], 'Throwables launcher', {'JSgrenade'}, 'Makes the grenade launcher able to shoot throwables, gives you the throwable if you don\'t have it so you can shoot it.', mutually_exclusive_weapons, function(toggle)
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
    JSlang.list_select(_LR['Throwables launcher'], 'Current throwable', {'JSthrowablesLauncher'}, 'Choose what throwable the grenade launcher has.', getLabelTableFromKeys(throwablesTable), 4, function(index, text)
        launcherThrowable = throwablesTable[text]
    end)

    local disable_firing = false
    local function disableFiringLoop()
        util.create_tick_handler(function()
            PLAYER.DISABLE_PLAYER_FIRING(players.user_ped(), true)
            return disable_firing
        end)
    end

    JSlang.list(_LR['Weapons'], 'Explosive animal gun', {}, '')

    local exp_animal = 'a_c_killerwhale'
    local explosive_animal_gun
    mutually_exclusive_weapons[#mutually_exclusive_weapons + 1] = menu.mutually_exclusive_toggle(_LR['Explosive animal gun'], 'Explosive animal gun', {'JSexpAnimalGun'}, 'Inspired by impulses explosive whale gun, but can fire other animals too.', mutually_exclusive_weapons, function(toggle)
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
    JSlang.list_select(_LR['Explosive animal gun'], 'Current animal', {'JSexplosiveAnimalGun'}, 'Choose what animal the explosive animal gun has.', getLabelTableFromKeys(animalsTable), 6, function(index, text)
        exp_animal = animalsTable[text]
    end)

    JSlang.list(_LR['Weapons'], 'Minecraft gun', {}, '')

    local impactCords = v3()
    local blocks = {}
    JSlang.toggle_loop(_LR['Minecraft gun'], 'Minecraft gun', {'JSminecraftGun'}, 'Spawns blocks where you shoot.', function()
        if WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), memory.addrof(impactCords)) then
            local hash = util.joaat('prop_mb_sandblock_01')
            loadModel(hash)
            blocks[#blocks + 1] = entities.create_object(hash, impactCords)
        end
    end)

    JSlang.action(_LR['Minecraft gun'], 'Delete last block', {'JSdeleteLastBlock'}, '', function()
        if blocks[#blocks] != nil then
            entities.delete_by_handle(blocks[#blocks])
            blocks[#blocks] = nil
        end
    end)

    JSlang.action(_LR['Minecraft gun'], 'Delete all blocks', {'JSdeleteBlocks'}, '', function()
        for i = 1, #blocks do
            entities.delete_by_handle(blocks[i])
            blocks[i] = nil
        end
    end)

    local flameThrower = {
        colour = mildOrangeFire
    }
    JSlang.toggle_loop(_LR['Weapons'], 'Flamethrower', {'JSflamethrower'}, 'Converts the minigun into a flamethrower.', function()
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

    JSlang.toggle(_LR['Weapons'], 'Friendly fire', {'JSfriendlyFire'}, 'Makes you able to shoot peds the game count as your friends.', function(toggle)
        PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), toggle, false)
    end)

    JSlang.toggle_loop(_LR['Weapons'], 'Reload when rolling', {'JSrollReload'}, 'Reloads your weapon when doing a roll.', function()
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
        JSlang.list(_LR['Vehicle'], 'Speed and handling', {'JSspeedHandling'}, '')

        JSlang.toggle(_LR['Speed and handling'], 'Low traction', {'JSlowTraction'}, 'Makes your vehicle have low traction, I recommend setting this to a hotkey.', function(toggle)
            carSettings.lowTraction.on = toggle
            carSettings.lowTraction.setOption(toggle)
        end)

        JSlang.toggle(_LR['Speed and handling'], 'Launch control', {'JSlaunchControl'}, 'Limits how much force your car applies when accelerating so it doesn\'t burnout, very noticeable in a Emerus.', function(toggle)
            carSettings.launchControl.on = toggle
            carSettings.launchControl.setOption(toggle)
        end)

        local my_torque = 100
        JSlang.slider_float(_LR['Speed and handling'], 'Set torque', {'JSsetSelfTorque'}, 'Modifies the speed of your vehicle.', -1000000, 1000000, my_torque, 1, function(value)
            my_torque = value
            util.create_tick_handler(function()
                VEHICLE.SET_VEHICLE_CHEAT_POWER_INCREASE(my_cur_car, my_torque/100)
                return (my_torque != 100)
            end)
        end)

        local quickBrakeLvL = 1.5
        JSlang.toggle_loop(_LR['Speed and handling'], 'Quick brake', {'JSquickBrake'}, 'Slows down your speed more when pressing "S".', function(toggle)
            if JSkey.is_control_just_pressed(2, 'INPUT_VEH_BRAKE') and ENTITY.GET_ENTITY_SPEED(my_cur_car) >= 0 and not ENTITY.IS_ENTITY_IN_AIR(my_cur_car) and VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_cur_car, -1, false) == players.user_ped() then
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) / quickBrakeLvL)
                util.yield(250)
            end
        end)

        JSlang.slider_float(_LR['Speed and handling'], 'Quick brake force', {'JSquickBrakeForce'}, '1.00 is ordinary brakes.', 100, 999, 150, 1,  function(value)
            quickBrakeLvL = value / 100
        end)

    -----------------------------------
    -- Boosts
    -----------------------------------
        JSlang.list(_LR['Vehicle'], 'Boosts', {'JSboosts'}, '')

        JSlang.toggle_loop(_LR['Boosts'], 'Horn boost', {'JShornBoost'}, 'Makes your car speed up when you honking your horn or activating your siren.', function()
            if not (AUDIO.IS_HORN_ACTIVE(my_cur_car) or VEHICLE.IS_VEHICLE_SIREN_ON(my_cur_car)) then return end
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(my_cur_car, ENTITY.GET_ENTITY_SPEED(my_cur_car) + hornBoostMultiplier)
        end)

        JSlang.toggle_loop(_LR['Boosts'], 'Vehicle jump', {'JSVehJump'}, 'Lets you jump with your car if you double tap "W".', function()
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
            JSlang.divider(_LR['Boosts'], 'Nitro')

            local nitroSettings = {level = new.delay(500, 2, 0), power = 1, rechargeTime = new.delay(200, 1, 0)}

            JSlang.toggle_loop(_LR['Boosts'], 'Enable nitro', {'JSnitro'}, 'Enable nitro boost on any vehicle, use it by pressing "X".', function(toggle)
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

            JSlang.list(_LR['Boosts'], 'Duration', {'JSnitroDuration'}, 'Lets you set a customize how long the nitro lasts.')
            generateDelaySettings(_LR['Duration'], 'Duration', nitroSettings.level)

            JSlang.list(_LR['Boosts'], 'Recharge time', {'JSnitroRecharge'}, 'Lets you set a custom delay of how long it takes for nitro to recharge.')
            generateDelaySettings(_LR['Recharge time'], 'Recharge time', nitroSettings.rechargeTime)

        -----------------------------------
        -- Shunt boost
        -----------------------------------
            JSlang.divider(_LR['Boosts'], 'Shunt boost')

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

            JSlang.toggle_loop(_LR['Boosts'], 'Shunt boost', {'JSshuntBoost'}, 'Lets you shunt boost in any vehicle by double tapping "A" or "D".', function()
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

            JSlang.toggle(_LR['Boosts'], 'Disable recharge', {'JSnoShutRecharge'}, 'Removes the force build-up of the shunt boost.', function(toggle)
                shuntSettings.disableRecharge = toggle
            end)
            JSlang.slider(_LR['Boosts'], 'Force', {'JSshuntForce'}, 'How much force is applied to your car.', 0, 1000, 30, 1, function(value)
                shuntSettings.maxForce = value
            end)

    -----------------------------------
    -- Shunt boost
    -----------------------------------
        JSlang.divider(_LR['Boosts'], 'Veh bounce')

        local wasInAir
        local bouncy = 50
        JSlang.toggle_loop(_LR['Boosts'], 'Veh bounce', {'JSvehBounce'}, 'Adds some bounciness to your vehicle when it falls to the ground.', function()
            local isInAir = ENTITY.IS_ENTITY_IN_AIR(entities.get_user_vehicle_as_handle())
            if wasInAir and not isInAir then
                local vec = ENTITY.GET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle())
                ENTITY.SET_ENTITY_VELOCITY(entities.get_user_vehicle_as_handle(), vec.x, vec.y, (vec.z * -1 * bouncy / 100))
            end
            wasInAir = isInAir
        end)

        JSlang.slider_float(_LR['Boosts'], 'Bounciness multiplier', {'JSbounceMult'}, '', 1, 1000, bouncy, 1, function(value)
            bouncy = value
        end)

    -----------------------------------
    -- Vehicle doors
    -----------------------------------
        JSlang.list(_LR['Vehicle'], 'Vehicle doors', {'JSvehDoors'}, '')

        JSlang.toggle(_LR['Vehicle doors'], 'Indestructible doors', {'JSinvincibleDoors'}, 'Makes it so your vehicle doors can\'t break off.', function(toggle)
            carSettings.indestructibleDoors.on = toggle
            local vehicleDoorCount =  VEHICLE._GET_NUMBER_OF_VEHICLE_DOORS(my_cur_car)
            for i = -1, vehicleDoorCount do
                VEHICLE._SET_VEHICLE_DOOR_CAN_BREAK(my_cur_car, i, not toggle)
            end
        end)

        JSlang.toggle_loop(_LR['Vehicle doors'], 'Shut doors when driving', {'JSautoClose'}, 'Closes all the vehicle doors when you start driving.', function()
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
        JSlang.action(_LR['Vehicle doors'], 'Open all doors', {'JScarDoorsOpen'}, 'Made this to test door stuff.', function()
            for i, door in ipairs(carDoors) do
                VEHICLE.SET_VEHICLE_DOOR_OPEN(my_cur_car, i - 1, false, false)
            end
        end)

        JSlang.action(_LR['Vehicle doors'], 'Close all doors', {'JScarDoorsClosed'}, 'Made this to test door stuff.', function()
            VEHICLE.SET_VEHICLE_DOORS_SHUT(my_cur_car, false)
        end)

    -----------------------------------
    -- Plane options
    -----------------------------------
        JSlang.list(_LR['Vehicle'], 'Plane options', {'JSplane'}, '')

        local afterBurnerState = false
        JSlang.toggle_loop(_LR['Plane options'], 'Toggle plane afterburner', {'JSafterburner'}, 'Makes you able to toggle afterburner on planes by pressing "left shift".', function()
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

        JSlang.toggle(_LR['Plane options'], 'Lock vtol', {'JSlockVtol'}, 'Locks the angle of planes vtol propellers.', function(toggle)
            VEHICLE._SET_DISABLE_VEHICLE_FLIGHT_NOZZLE_POSITION(my_cur_car, toggle)
        end)
    -----------------------------------

    local ghost_vehicle_option = JSlang.slider(_LR['Vehicle'], 'Ghost vehicle', {'JSghostVeh'}, 'Makes your vehicle different levels off see through.', 0 , 100, 100, 25, function(value)
        carSettings.ghostCar.on = value != 100
        carSettings.ghostCar.value = value / 25
        carSettings.ghostCar.setOption(value != 100)
    end)
    carSettings.ghostCar.on = menu.get_value(ghost_vehicle_option) != 100

    -----------------------------------
    -- Vehicle sounds
    -----------------------------------
        JSlang.list(_LR['Vehicle'], 'Vehicle sounds', {'JSvehSounds'}, '')

        JSlang.toggle(_LR['Vehicle sounds'], 'Disable exhaust pops', {'JSdisablePops'}, 'Disables those annoying exhaust pops that your car makes if it has a non-stock exhaust option.', function(toggle)
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
        JSlang.slider_text(_LR['Vehicle sounds'], 'Engine sound', {'JSengineSound'}, '', {'Default', 'Silent', 'Electric'}, function(index, value)
            AUDIO._FORCE_VEHICLE_ENGINE_AUDIO(entities.get_user_vehicle_as_handle(), if type(car_sounds[value]) == 'string' then car_sounds[value] else car_sounds[value]())
        end)

        JSlang.toggle_loop(_LR['Vehicle sounds'], 'Immersive radio', {'JSemersiveRadio'}, 'Lowers the radio volume when you\'re not in first person mode.', function()
            AUDIO.SET_FRONTEND_RADIO_ACTIVE(CAM.GET_CAM_VIEW_MODE_FOR_CONTEXT(1) == 4)
        end, function()
            AUDIO.SET_FRONTEND_RADIO_ACTIVE(true)
        end)

        JSlang.toggle(_LR['Vehicle sounds'], 'Npc horn', {'JSnpcHorn'}, 'Makes you horn like a npc. Also makes your car doors silent.', function(toggle)
            carSettings.npcHorn.on = toggle
            VEHICLE._SET_VEHICLE_SILENT(my_cur_car, toggle)
        end)
    -----------------------------------

    JSlang.toggle(_LR['Vehicle'], 'Stance', {'JSstance'}, 'Activates stance on vehicles that support it.', function(toggle)
        VEHICLE._SET_REDUCE_DRIFT_VEHICLE_SUSPENSION(my_cur_car, toggle)
    end)

    JSlang.toggle_loop(_LR['Vehicle'], 'To the moon', {'JStoMoon'}, 'Forces you into the sky if you\'re in a vehicle.', function(toggle)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(my_cur_car)
        ENTITY.APPLY_FORCE_TO_ENTITY(my_cur_car, 1, 0, 0, 100.0, 0, 0, 0.5, 0, false, false, true)
    end)

    JSlang.toggle_loop(_LR['Vehicle'], 'Anchor', {'JSanchor'}, 'Forces you into the ground if you\'re in a air born vehicle.', function(toggle)
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
        JSlang.list(_LR['Online'], 'Fake money', {'JSfakeMoney'}, 'Adds fake money, it is only a visual thing and you can\'t spend it.')

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

        JSlang.action(_LR['Fake money'], 'Add fake money', {'JSaddFakeMoney'}, 'Adds money once.', function()
            HUD.CHANGE_FAKE_MP_CASH(cashFakeMoney, bankFakeMoney)
            transactionPending()
        end)

        JSlang.toggle_loop(_LR['Fake money'], 'Loop fake money', {'JSloopFakeMoney'}, 'Adds loops money with your chosen delay.', function()
            HUD.CHANGE_FAKE_MP_CASH(cashFakeMoney, bankFakeMoney)
            transactionPending()
            util.yield(getTotalDelay(fakeMoneyLoopDelay))
        end)

        JSlang.toggle(_LR['Fake money'], 'Show transaction pending', {'JSfakeTransaction'}, 'Adds a loading transaction pending message when adding fake money.', function(toggle)
            fakeMoneyTransactionPending = toggle
        end, fakeMoneyTransactionPending)

        JSlang.list(_LR['Fake money'], 'Fake money loop delay', {'JSexpDelay'}, 'Lets you set a custom delay to the fake money loop.')
        generateDelaySettings(_LR['Fake money loop delay'], 'Fake money loop delay', fakeMoneyLoopDelay)

        JSlang.slider(_LR['Fake money'], 'Bank fake money', {'JSbankFakeMoney'}, 'How much fake money that gets added into your bank.', -2000000000, 2000000000, bankFakeMoney, 1, function(value)
            bankFakeMoney = value
        end)

        JSlang.slider(_LR['Fake money'], 'Cash fake money', {'JScashFakeMoney'}, 'How much fake money that gets added in cash.', -2000000000, 2000000000, cashFakeMoney, 1, function(value)
            cashFakeMoney = value
        end)

    -----------------------------------
    -- Safe monitor
    -----------------------------------
        JSlang.list(_LR['Online'], 'Safe monitor', {'JSsm'}, 'Safe monitor allows you to monitor your safes. It does NOT affect the money being generated.')

        safeMonitorToggle = false
        JSlang.toggle(_LR['Safe monitor'], 'Toggle all selected', {'SMtoggleAllSelected'}, 'Toggles every option.', function(toggle)
            safeMonitorToggle = toggle
        end)

        JS_tbls.safeManagerToggles = {
            {
                name = 'Nightclub Safe',
                command = 'SMclub',
                description = 'Monitors nightclub safe cash, this does NOT affect income.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Nightclub Cash') ..': '.. STAT_GET_INT('CLUB_SAFE_CASH_VALUE')  / 1000  ..'k / 210k'
                end
            },
            {
                name = 'Nightclub Popularity',
                command = 'SMclubPopularity',
                description = '',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Nightclub Popularity') ..': '.. math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)  ..'%'
                end
            },
            {
                name = 'Nightclub Daily Earnings',
                command = 'SMnightclubEarnings',
                description = 'Nightclub daily earnings.\nMaximum daily earnings is 10k.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Nightclub Daily Earnings') ..': '.. getNightclubDailyEarnings() / 1000  ..'k / day'
                end
            },
            {
                name = 'Arcade safe',
                command = 'SMarcade',
                description = 'Monitors arcade safe cash, this does NOT affect income.\nMaximum daily earnings is 5k if you have all the arcade games.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Arcade Cash') ..': '.. STAT_GET_INT('ARCADE_SAFE_CASH_VALUE') / 1000  ..'k / 100k'
                end
            },
            {
                name = 'Agency safe',
                command = 'SMagency',
                description = 'Monitors agency safe cash, this does NOT affect income.\nMaximum daily earnings is 20k.',
                toggle = true,
                displayText = function()
                    return JSlang.str_trans('Agency Cash') ..': '.. STAT_GET_INT('FIXER_SAFE_CASH_VALUE') / 1000  ..'k / 250k'
                end
            },
            {
                name = 'Security contracts',
                command = 'SMsecurity',
                description = 'Displays the number of agency security missions you have completed.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Security contracts') ..': '.. STAT_GET_INT('FIXER_COUNT')
                end
            },
            {
                name = 'Agency daily Earnings',
                command = 'SMagencyEarnings',
                description = 'Agency daily earnings.\nMaximum daily earnings is 20k if you have completed 200 contracts.',
                toggle = false,
                displayText = function()
                    return JSlang.str_trans('Agency Daily Earnings') ..': '.. getAgencyDailyEarnings(STAT_GET_INT('FIXER_COUNT')) / 1000 ..'k / day'
                end
            },
        }
        generateToggles(JS_tbls.safeManagerToggles, _LR['Safe monitor'], false)

        local first_open_SM_earnings = {true}
        JSlang.list(_LR['Safe monitor'], 'Increase safe earnings', {'SMearnings'}, 'Might be risky.', function()
            listWarning(_LR['Increase safe earnings'], first_open_SM_earnings)
        end)

        local nightclubpopularity_command = menu.ref_by_path('Online>Quick Progress>Set Nightclub Popularity', 37)
        JSlang.toggle_loop(_LR['Increase safe earnings'], 'Auto nightclub popularity', {'SMautoClubPop'}, 'Automatically sets the nightclubs popularity to 100 if it results in less than max daily income.', function(toggle)
            if getNightclubDailyEarnings() < 50000 then
                menu.trigger_command(nightclubpopularity_command, 100)
            end
        end)

        local fixer_count_cooldown = false
        local soloPublic_command = menu.ref_by_path('Online>New Session>Create Public Session', 37)
        JSlang.action(_LR['Increase safe earnings'], 'Increment security contracts completed', {'SMsecurityComplete'}, 'Will put you in a new lobby to make the increase stick.\nI added a cooldown to this button so you cant spam it.\nAlso doesn\'t work past 200', function()
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
            [1] = { name = JSlang.str_trans('Ceo office'),   sprite = 475 },
            [2] = { name = JSlang.str_trans('MC clubhouse'), sprite = 492,
                subProperties = {listName = JSlang.str_trans('MC businesses'), properties = {
                    [1] = { name = JSlang.str_trans('Weed farm'),           sprite = 496 },
                    [2] = { name = JSlang.str_trans('Cocaine lockup'),      sprite = 497 },
                    [3] = { name = JSlang.str_trans('Document forgery'),    sprite = 498 },
                    [4] = { name = JSlang.str_trans('Methamphetamine Lab'), sprite = 499 },
                    [5] = { name = JSlang.str_trans('Counterfeit cash'),    sprite = 500 },
                }}
            },
            [3] = { name = JSlang.str_trans('Bunker'),     sprite = 557 },
            [4] = { name = JSlang.str_trans('Hangar'),     sprite = 569 },
            [5] = { name = JSlang.str_trans('Facility'),   sprite = 590 },
            [6] = { name = JSlang.str_trans('Night club'), sprite = 614 },
            [7] = { name = JSlang.str_trans('Arcade'),     sprite = 740 },
            [8] = { name = JSlang.str_trans('Auto shop'),  sprite = 779 },
            [9] = { name = JSlang.str_trans('Agency'),     sprite = 826 },
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

        JSlang.list(_LR['Online'], 'Property tp\'s', {'JSpropertyTp'}, 'Lets you teleport to the properties you own.', function()
            regenerateTpLocations(_LR['Property tp\'s'])
        end)

        propertyTpRefs['tmp'] = menu.action(_LR['Property tp\'s'], '', {}, '', function()end)

    ----------------------------------
    -- Casino
    ----------------------------------
        JSlang.list(_LR['Online'], 'Casino', {'JScasino'}, 'No theres no recoveries here.')

        local last_LW_seconds = 0
        JSlang.toggle_loop(_LR['Casino'], 'Lucky wheel cooldown', {'JSlwCool'}, 'Tells you if the lucky wheel is available or how much time is left until it is.', function()
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

        JSlang.action(_LR['Casino'], 'Casino loss/profit', {'JScasinoLP'}, 'Tells you how much you made or lost in the casino.', function()
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
        JSlang.list(_LR['Online'], 'Time trials', {'JStt'}, '')

        local function ttTimeToString(time)
            local min = math.floor(time / 60000)
            local sec = (time % 60000) / 1000
            return (min == 0 and '' or min ..'min ') .. sec ..'s'
        end

        JSlang.divider(_LR['Time trials'], 'Time trial')

        JSlang.toggle_loop(_LR['Time trials'], 'Best time trial time', {'JSbestTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString((STAT_GET_INT_MPPLY('mpply_timetrialbesttime'))))
            util.yield(100)
        end)

        JSlang.action(_LR['Time trials'], 'Teleport to time trial', {'JStpToTT'}, '', function()
            local ttBlip = HUD._GET_CLOSEST_BLIP_OF_TYPE(430)
            if not HUD.DOES_BLIP_EXIST(ttBlip) then
                JSlang.toast('Couldn\'t find time trial.')
                return
            end
            tpToBlip(ttBlip)
        end)

        JSlang.divider(_LR['Time trials'], 'Rc time trial')

        JSlang.toggle_loop(_LR['Time trials'], 'Best rc time trial time', {'JSbestRcTT'}, '', function()
            util.toast(JSlang.str_trans('Best Time') ..': '.. ttTimeToString(STAT_GET_INT_MPPLY('mpply_rcttbesttime')))
            util.yield(100)
        end)

        JSlang.action(_LR['Time trials'], 'Teleport to rc time trial', {'JStpToRcTT'}, '', function()
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

        JSlang.list(_LR['Online'], 'Block areas', {'JSblock'}, 'Block areas in online with invisible walls, but if you over use it it will crash you lol.')

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

        JSlang.toggle_loop(_LR['Block areas'], 'Custom block', {}, 'Makes you able to block an area in front of you by pressing "B".', function()
            local dir = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0, 5.0, 0)
            GRAPHICS._DRAW_SPHERE(dir, 0.3, 52, 144, 233, 0.5)
            if JSkey.is_key_down('VK_B') then
                if blockInProgress then JSlang.toast('A block is already being run.') return end
                setBlockStatus(true)
                block({dir.x, dir.y, dir.z - 0.6})
                setBlockStatus(false, 'area')
            end
        end)

        JSlang.list(_LR['Block areas'], 'Block LSC', {'JSblockLSC'}, 'Block lsc from being accessed.')
        JSlang.list(_LR['Block areas'], 'Block casino', {'JSblockCasino'}, 'Block casino from being accessed.')
        JSlang.list(_LR['Block areas'], 'Block maze bank', {'JSblockCasino'}, 'Block maze bank from being accessed.')

        local blockAreasActions = {
            --Orbital block
            {root = _LR['Block areas'], name = 'orbital room', coordinates = {{335.95837, 4834.216, -60.99977}}, blocked = false},
            -- Lsc blocks
            {root = _LR['Block LSC'], name = 'burton', coordinates = {{-357.66544, -134.26419, 38.23775}}, blocked = false},
            {root = _LR['Block LSC'], name = 'LSIA', coordinates = {{-1144.0569, -1989.5784, 12.9626}}, blocked = false},
            {root = _LR['Block LSC'], name = 'la meza', coordinates = {{721.08496, -1088.8752, 22.046721}}, blocked = false},
            {root = _LR['Block LSC'], name = 'blaine county', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = _LR['Block LSC'], name = 'paleto bay', coordinates = {{115.59574, 6621.5693, 31.646144}, {110.460236, 6615.827, 31.660228}}, blocked = false},
            {root = _LR['Block LSC'], name = 'benny\'s', coordinates = {{-205.6571, -1309.4313, 31.093222}}, blocked = false},
            -- Casino blocks
            {root = _LR['Block casino'], name = 'casino entrance', coordinates = {{924.3438, 49.19933, 81.10636}, {922.5348, 45.917263, 81.10635}}, blocked = false},
            {root = _LR['Block casino'], name = 'casino garage', coordinates = {{935.29553, -0.5328601, 78.56404}}, blocked = false},
            {root = _LR['Block casino'], name = 'lucky wheel', coordinates = {{1110.1014, 228.71582, -49.935845}}, blocked = false},
            --Maze bank block
            {root = _LR['Block maze bank'], name = 'maze bank entrance', coordinates = {{-81.18775, -795.82874, 44.227295}}, blocked = false},
            {root = _LR['Block maze bank'], name = 'maze bank garage', coordinates = {{-77.96956, -780.9376, 38.473335}, {-82.82901, -781.81635, 38.50093}}, blocked = false},
            --Mc block
            {root = _LR['Block areas'], name = 'hawick clubhouse', coordinates = {{-17.48541, -195.7588, 52.370953}, {-23.452509, -193.01324, 52.36245}}, blocked = false},
            --Arena war garages
            {root = _LR['Block areas'], name = 'arena war garages', coordinates = {
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
        JSlang.list(_LR['Players'], 'Whitelist', {'JSwhitelist'}, 'Applies to most options in this section.')

        JSlang.toggle(_LR['Whitelist'], 'Exclude self', {'JSWhitelistSelf'}, 'Will make you not explode yourself. Pretty cool option if you ask me ;P', function(toggle)
            whitelistGroups.user = not toggle
        end)

        JSlang.toggle(_LR['Whitelist'], 'Exclude friends', {'JSWhitelistFriends'}, 'Will make you not explode your friends... if you have any. (;-;)', function(toggle)
            whitelistGroups.friends = not toggle
        end)

        JSlang.toggle(_LR['Whitelist'], 'Exclude strangers', {'JSWhitelistStrangers'}, 'If you only want to explode your friends I guess.', function(toggle)
            whitelistGroups.strangers = not toggle
        end)

        JSlang.text_input(_LR['Whitelist'], 'Whitelist player', {'JSWhitelistPlayer'}, 'Lets you whitelist a single player by name.', function(input)
            whitelistedName = input
        end, '')

        JSlang.list(_LR['Whitelist'], 'Whitelist player list', {'JSwhitelistList'}, 'Custom player list for selecting  players you wanna whitelist.')

        local whitelistTogglesTable = {}
        players.on_join(function(pid)
            local playerName = players.get_name(pid)
            whitelistTogglesTable[pid] = menu.toggle(_LR['Whitelist player list'], playerName, {'JSwhitelist'.. playerName}, JSlang.str_trans('Whitelist') ..' '.. playerName ..' '.. JSlang.str_trans('from options that affect all players.'), function(toggle)
                if toggle then
                    whitelistListTable[pid] = pid
                    if notifications then
                        util.toast(JSlang.str_trans('Whitelisted') ..' '.. playerName)
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
        JSlang.list(_LR['Players'], 'Anti chat spam', {}, '')

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

        JSlang.toggle(_LR['Anti chat spam'], 'Anti chat spam', {'JSantiChatSpam'}, 'Kicks people if they spam chat.', function(toggle)
            chatSpamSettings.enabled = toggle
        end)

        JSlang.toggle(_LR['Anti chat spam'], 'Ignore team chat', {'JSignoreTeamSpam'}, '', function(toggle)
            chatSpamSettings.enabled = toggle
        end, chatSpamSettings.ignoreTeam)

        JSlang.slider(_LR['Anti chat spam'], 'Identical messages', {'JSidenticalChatMessages'}, 'How many identical chat messages a player can send before getting kicked.', 2, 9999, chatSpamSettings.identicalMessages, 1, function(value)
            chatSpamSettings.identicalMessages = value
        end)

    -----------------------------------
    -- Explosions
    -----------------------------------
        JSlang.action(_LR['Players'], 'Explode all', {'JSexplodeAll'}, 'Makes everyone explode.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for _, pid in pairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                explodePlayer(playerPed, false, expSettings)
            end
        end)

        explodeLoopAll = JSlang.toggle_loop(_LR['Players'], 'Explode all loop', {'JSexplodeAllLoop'}, 'Constantly explodes everyone.', function()
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
    JSlang.toggle_loop(_LR['Players'], 'Orbital cannon detection', {'JSorbDetection'}, 'Tells you when anyone starts using the orbital cannon', function()
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
        JSlang.list(_LR['Players'], 'Coloured otr reveal', {}, '')

        local markedPlayers = {}
        local otrBlipColour = 58
        JSlang.toggle_loop(_LR['Coloured otr reveal'], 'Coloured otr reveal', {'JScolouredOtrReveal'}, 'Marks otr players with coloured blips.', function()
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

        local otr_colour_slider = JSlang.slider(_LR['Coloured otr reveal'], 'otr reveal colour', {'JSortRevealColour'}, '',1, 81, otrBlipColour, 1, function(value)
            otrBlipColour = value + (value > 71 and 1 or 0) + (value > 77 and 2 or 0)
        end)

        JSlang.toggle_loop(_LR['Coloured otr reveal'], 'Otr rgb reveal', {'JSortRgbReveal'}, '', function()
            menu.set_value(otr_colour_slider, (otrBlipColour == 84 and 1 or otrBlipColour + 1))
            util.yield(250)
        end)

    -----------------------------------
    -- Vehicle
    -----------------------------------
        JSlang.list(_LR['Players'], 'Vehicles', {'JSplayersVeh'}, 'Do stuff to all players vehicles.')

        JSlang.toggle(_LR['Vehicles'], 'Lock burnout', {'JSlockBurnout'}, 'Locks all player cars in burnout.', function(toggle)
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
        JSlang.slider(_LR['Vehicles'], 'Set torque', {'JSsetAllTorque'}, 'Modifies the speed of all player vehicles.', -1000000, 1000000, all_torque, 1, function(value)
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

        JSlang.toggle(_LR['Vehicles'], 'Force surface all subs', {'JSforceSurfaceAll'}, 'Forces all Kosatkas to the surface.\nNot compatible with the whitelist.', function(toggle)
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


    JSlang.toggle_loop(_LR['Players'], 'No fly zone', {'JSnoFly'}, 'Forces all players in air born vehicles into the ground.', function()
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

    JSlang.toggle_loop(_LR['Players'], 'Shoot gods', {'JSshootGods'}, 'Disables godmode for other players when aiming at them. Mostly works on trash menus.', function()
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
        JSlang.list(_LR['Players'], 'Aim karma', {'JSaimKarma'}, 'Do stuff to players that aim at you.')

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

        JSlang.toggle_loop(_LR['Aim karma'], 'Shoot', {'JSbulletAimKarma'}, 'Shoots players that aim at you.', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] then
                local pos = ENTITY.GET_ENTITY_COORDS(karma[userPed].ped)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos, pos.x, pos.y, pos.z + 0.1, 100, true, 100416529, userPed, true, false, 100.0)
                util.yield(getTotalDelay(expLoopDelay))
            end
        end)

        JSlang.toggle_loop(_LR['Aim karma'], 'Explode', {'JSexpAimKarma'}, 'Explodes the player with your custom explosion settings.', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] then
                explodePlayer(karma[userPed].ped, true, expSettings)
            end
        end)

        JSlang.toggle_loop(_LR['Aim karma'], 'Disable godmode', {'JSgodAimKarma'}, 'If a god mode player aims at you this disables their god mode by pushing their camera forwards.', function()
            local userPed = players.user_ped()
            if isAnyPlayerTargetingEntity(userPed) and karma[userPed] and players.is_godmode(karma[userPed].pid) then
                local karmaPid = karma[userPed].pid
                util.trigger_script_event(1 << karmaPid, {-1388926377, karmaPid, -1762807505, math.random(0, 9999)})
            end
        end)

        local stand_player_aim_punish =  menu.ref_by_path('World>Inhabitants>Player Aim Punishments>Anonymous Explosion', 37)
        JSlang.action(_LR['Aim karma'], 'Stands player aim punishments', {}, 'Link to stands player aim punishments.', function()
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
    JSlang.toggle(_LR['World'], 'irl time', {'JSirlTime'}, 'Makes the in game time match your irl time. Disables stands "Smooth Transition".', function(toggle)
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
    JSlang.toggle_loop(_LR['World'], 'Disable numpad', {'JSdisableNumpad'}, 'Disables numpad so you don\'t rotate your plane/submarine while navigating stand', function()
        if not menu.is_open() or JSkey.is_key_down('VK_LBUTTON') or JSkey.is_key_down('VK_RBUTTON') then return end
        for _, control in pairs(numpadControls) do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    local mapZoom = 83
    JSlang.slider(_LR['World'], 'Map zoom level', {'JSmapZoom'}, '', 1, 100, mapZoom, 1, function(value)
        mapZoom = 83
        mapZoom = value
        util.create_tick_handler(function()
            HUD.SET_RADAR_ZOOM_PRECISE(mapZoom)
            return mapZoom != 83
        end)
    end)

    JSlang.toggle(_LR['World'], 'Enable footsteps', {'JSfootSteps'}, 'Enables foot prints on all surfaces.', function(toggle)
        GRAPHICS._SET_FORCE_PED_FOOTSTEPS_TRACKS(toggle)
    end)

    JSlang.toggle(_LR['World'], 'Enable vehicle trails', {'JSvehicleTrails'}, 'Enables vehicle trails on all surfaces.', function(toggle)
        GRAPHICS._SET_FORCE_VEHICLE_TRAILS(toggle)
    end)

    JSlang.toggle_loop(_LR['World'], 'Disable all map notifications', {'JSnoMapNotifications'}, 'Removes that constant spam.', function()
        HUD.THEFEED_HIDE_THIS_FRAME()
    end)


    JSlang.list(_LR['World'], 'Colour overlay', {}, '')

    local colourOverlay = new.colour( 0, 0, 10, 0.1 )

    JSlang.toggle_loop(_LR['Colour overlay'], 'Colour overlay', {'JScolourOverlay'}, 'Applies a colour filter on the game.', function()
        directx.draw_rect(0, 0, 1, 1, colourOverlay)
    end)

    menu.rainbow(JSlang.colour(_LR['Colour overlay']   , 'Set overlay colour', {'JSoverlayColour'}, '', colourOverlay, true, function(colour)
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

        JSlang.toggle(_LR['Trains'], 'Derail trains', {'JSderail'}, 'Derails and stops all trains.', function(toggle)
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

        JSlang.action(_LR['Trains'], 'Delete trains', {'JSdeleteTrain'}, 'Just because every script has train options, I gotta have an anti train option.', function()
            VEHICLE.DELETE_ALL_TRAINS()
        end)

        local markedTrains = {}
        local markedTrainBlips = {}
        JSlang.toggle_loop(_LR['Trains'], 'Mark nearby trains', {'JSnoMapNotifications'}, 'Marks nearby trains with purple blips.', function()
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
        JSlang.list(_LR['World'], 'Peds', {'JSpeds'}, '')

        local pedToggleLoops = {
            {name = 'Ragdoll peds', command = 'JSragdollPeds', description = 'Makes all nearby peds fall over lol.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_TO_RAGDOLL(ped, 2000, 2000, 0, true, true, true)
            end},
            {name = 'Death\'s touch', command = 'JSdeathTouch', description = 'Kills peds that touches you.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) or PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not ENTITY.IS_ENTITY_TOUCHING_ENTITY(ped, players.user_ped()) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
            {name = 'Cold peds', command = 'JScoldPeds', description = 'Removes the thermal signature from all peds.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                PED.SET_PED_HEATSCALE_OVERRIDE(ped, 0)
            end},
            {name = 'Mute peds', command = 'JSmutePeds', description = 'Because I don\'t want to hear that dude talk about his gay dog any more.', action = function(ped)
                if PED.IS_PED_A_PLAYER(ped) then return end
                AUDIO.STOP_PED_SPEAKING(ped, true)
            end},
            {name = 'Npc horn boost', command = 'JSnpcHornBoost', description = 'Boosts npcs that horn.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not AUDIO.IS_HORN_ACTIVE(vehicle) then return end
                AUDIO.SET_AGGRESSIVE_HORNS(true) --Makes pedestrians sound their horn longer, faster and more agressive when they use their horn.
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end, onStop = function()
                AUDIO.SET_AGGRESSIVE_HORNS(false)
            end},
            {name = 'Npc siren boost', command = 'JSnpcSirenBoost', description = 'Boosts npcs cars with an active siren.', action = function(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if PED.IS_PED_A_PLAYER(ped) or not PED.IS_PED_IN_ANY_VEHICLE(ped, true) or not VEHICLE.IS_VEHICLE_SIREN_ON(vehicle) then return end
                VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, ENTITY.GET_ENTITY_SPEED(vehicle) + 1.2)
            end},
            {name = 'Auto kill enemies', command = 'JSautokill', description = 'Just instantly kills hostile peds.', action = function(ped) --basically copy pasted form wiri script
                local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(players.user_ped(), ped)
                if PED.IS_PED_A_PLAYER(ped) or ENTITY.IS_ENTITY_DEAD(ped) or not( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, players.user_ped()) ) then return end
                ENTITY.SET_ENTITY_HEALTH(ped, 0, 0)
            end},
        }
        for i = 1, #pedToggleLoops do
            JSlang.toggle_loop(_LR['Peds'], pedToggleLoops[i].name, {pedToggleLoops[i].command}, pedToggleLoops[i].description, function()
                local pedHandles = entities.get_all_peds_as_handles()
                for j = 1, #pedHandles do
                    pedToggleLoops[i].action(pedHandles[j])
                end
                util.yield(10)
            end, function()
                if pedToggleLoops[i].onStop then pedToggleLoops[i].onStop() end
            end)
        end

        JSlang.toggle_loop(_LR['Peds'], 'Kill jacked peds', {'JSkillJackedPeds'}, 'Automatically kills peds when stealing their car.', function(toggle)
            if not PED.IS_PED_JACKING(players.user_ped()) then return end
            local jackedPed = PED.GET_JACK_TARGET(players.user_ped())
            util.yield(100)
            ENTITY.SET_ENTITY_HEALTH(jackedPed, 0, 0)
        end)

        JSlang.toggle(_LR['Peds'], 'Riot mode', {'JSriot'}, 'Makes peds hostile.', function(toggle)
            MISC.SET_RIOT_MODE_ENABLED(toggle)
        end)
end


JSlang.hyperlink(menu_root, 'Join the discord server', 'https://discord.gg/QzqBdHQC9S', 'Join the JerryScript discord server to suggest features, report bugs and test upcoming features.')

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

play_credits_toggle = JSlang.toggle(menu_root, 'Play credits', {}, '', function(toggle)
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
        local player_root = JSlang.list(menu.player_root(pid), 'JS player options')
        local playerPed = || -> PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerName = players.get_name(pid)

        ----------------------------------
        -- Player info toggle
        ----------------------------------
            playerInfoToggles[pid] = menu.mutually_exclusive_toggle(player_root, 'Player info', {'JSplayerInfo'}, 'Display information about this player.', playerInfoToggles, function(toggle)
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

            JSlang.action(trolling_root, 'Explode player', {'JSexplode'}, 'Explodes this player with your selected options.', function()
                explodePlayer(playerPed(), false, expSettings)
            end)

            JSlang.toggle_loop(trolling_root, 'Explode loop player', {'JSexplodeLoop'}, 'Loops explosions on them with your selected options.', function()
                explodePlayer(playerPed(), true, expSettings)
                util.yield(getTotalDelay(expLoopDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.action(trolling_root, 'Blame explosions', {'JSexpBlame'}, 'Makes your explosions blamed on them.', function()
                expSettings.blamedPlayer = pid
                if not menu.get_value(exp_blame_toggle) then
                    menu.trigger_command(exp_blame_toggle)
                end
                menu.set_menu_name(exp_blame_toggle, JSlang.str_trans('Blame') ..': '.. playerName)
            end)

            local damage_root = JSlang.list(trolling_root, 'Damage', {}, '')

            JSlang.action(damage_root, 'Primed grenade', {'JSprimedGrenade'}, 'Spawns a grenade on top of them.', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1.4, pos.x, pos.y, pos.z + 1.3, 100, true, -1813897027, players.user_ped(), true, false, 100.0)
            end)

            JSlang.action(damage_root, 'Sticky', {'JSsticky'}, 'Spawns a sticky bomb on them that might stick to their vehicle and you can detonate by pressing "G".', function()
                local pos = players.get_position(pid)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1 , pos.x, pos.y, pos.z + 1.1, 10, true, 741814745, players.user_ped(), true, false, 100.0)
            end)

            JSlang.toggle_loop(trolling_root, 'Undetected money drop 2022', {'JSfakeMoneyDrop'}, 'Drops money bags that wont give any money.', function()
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

            JSlang.action(trolling_root, 'Entity YEET', {'JSentityYeet'}, 'Pushes all peds and vehicles near them.. into them ;)\nRequires you to be near them or spectating them.', function ()
                yeetEntities()
            end)

            JSlang.toggle_loop(trolling_root, 'Entity Storm', {'JSentityStorm'}, 'Constantly pushes all peds and vehicles near them.. into them :p\nRequires you to be near them or spectating them.', function ()
                yeetEntities()
                util.yield(getTotalDelay(stormDelay))
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.slider(trolling_root, 'Range for YEET/Storm', {'JSpushRange'}, 'How close nearby entities have to be to get pushed the targeted player.', 1, 1000, yeetRange, 10, function (value)
                yeetRange = value
            end)

            JSlang.slider(trolling_root, 'Multiplier for YEET/Storm', {'JSpushMultiplier'}, 'Multiplier for how much force is applied to entities when they get pushed towards them.', 1, 1000, yeetMultiplier, 5, function(value)
                yeetMultiplier = value
            end)

            local strom_delay_root = JSlang.list(trolling_root, 'Storm delay', {'JSentStormDelay'}, 'Lets you set the delay for how often entities are pushed in entity storm.')
            generateDelaySettings(strom_delay_root, 'Storm delay', stormDelay)
        -----------------------------------

        JSlang.toggle_loop(player_root, 'Give shoot gods', {'JSgiveShootGods'}, 'Grants this player the ability to disable players god mode when shooting them.', function()
            local playerList = getNonWhitelistedPlayers(whitelistListTable, whitelistGroups, whitelistedName)
            for k, playerPid in ipairs(playerList) do
                local playerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerPid)
                if (PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed) or PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(pid, playerPed)) and players.is_godmode(playerPid) then
                    util.trigger_script_event(1 << playerPid, {-1388926377, playerPid, -1762807505, math.random(0, 9999)})
                end
            end
            if not players.exists(pid) then util.stop_thread() end
        end)

        JSlang.toggle_loop(player_root, 'Give horn boost', {'JSgiveHornBoost'}, 'Gives them the ability to speed up their car by pressing honking their horn or activating the siren.', function()
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
            local give_karma_root = JSlang.list(player_root, 'Give aim karma', {'JSgiveAimKarma'}, 'Allows you to set punishments for targeting this player.')

            --dosnt work on yourself
            JSlang.toggle_loop(give_karma_root, 'Shoot', {'JSgiveBulletAimKarma'}, 'Shoots players that aim at them.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] then
                    local pos = ENTITY.GET_ENTITY_COORDS(karma[playerPed()].ped)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos, pos.x, pos.y, pos.z +0.1, 100, true, 100416529, players.user_ped(), true, false, 100.0)
                    util.yield(getTotalDelay(expLoopDelay))
                end
            end)

            JSlang.toggle_loop(give_karma_root, 'Explode', {'JSgiveExpAimKarma'}, 'Explosions with your custom explosion settings.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] then
                    explodePlayer(karma[playerPed()].ped, true, expSettings)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(give_karma_root, 'Disable godmode', {'JSgiveGodAimKarma'}, 'If a god mode player aims at them this disables the aimers god mode by pushing their camera forwards.', function()
                if isAnyPlayerTargetingEntity(playerPed()) and karma[playerPed()] and players.is_godmode(karma[playerPed()].pid) then
                    util.trigger_script_event(1 << karma[playerPed()].pid, {-1388926377, karma[playerPed()].pid, -1762807505, math.random(0, 9999)})
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

        ----------------------------------
        -- Vehicle
        ----------------------------------
            local player_veh_root = JSlang.list(player_root, 'Vehicle')

            JSlang.toggle(player_veh_root, 'Lock burnout', {'JSlockBurnout'}, 'Locks their car in a burnout.', function(toggle)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    VEHICLE.SET_VEHICLE_BURNOUT(playerVehicle, toggle)
                end
            end)

            local player_torque = 1000
            JSlang.slider(player_veh_root, 'Set torque', {'JSsetTorque'}, 'Modifies the speed of their vehicle.', -1000000, 1000000, player_torque, 1, function(value)
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

            JSlang.toggle(player_veh_root, 'Surface submarine', {'JSforceSurface'}, 'Forces their submarine to the surface if they\'re driving it.', function(toggle)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed, false)
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) and ENTITY.GET_ENTITY_MODEL(vehicle) == 1336872304 then
                    VEHICLE.FORCE_SUBMARINE_SURFACE_MODE(vehicle, toggle)
                    if toggle and notifications then
                        util.toast(JSlang.str_trans('Forcing') ..' '.. playerName .. JSlang.str_trans('\'s submarine to the surface.'))
                    end
                end
            end)

            JSlang.toggle_loop(player_veh_root, 'To the moon', {'JStoMoon'}, 'Forces their vehicle into the sky.', function()
                if PED.IS_PED_IN_ANY_VEHICLE(playerPed(), true) then
                    local playerVehicle = PED.GET_VEHICLE_PED_IS_IN(playerPed(), false)
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(playerVehicle)
                    ENTITY.APPLY_FORCE_TO_ENTITY(playerVehicle, 1, 0, 0, 100.0, 0, 0, 0.5, 0, false, false, true)
                    util.yield(10)
                end
                if not players.exists(pid) then util.stop_thread() end
            end)

            JSlang.toggle_loop(player_veh_root, 'Anchor', {'JSanchor'}, 'Forces their vehicle info the ground if its in the air.', function()
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
            local rain_root = JSlang.list(player_root, 'Entity rain', {'JSrain'}, '')

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
                { name = 'Meow rain',    description = 'UWU',                                          animals = {'a_c_cat_01'},                                 spawned = {} },
                { name = 'Sea rain',     description = '<º)))><',                                      animals = {'a_c_fish', 'a_c_dolphin', 'a_c_killerwhale'}, spawned = {} },
                { name = 'Dog rain',     description = 'Wooof',                                        animals = {'a_c_retriever', 'a_c_pug', 'a_c_rottweiler'}, spawned = {} },
                { name = 'Chicken rain', description = '*clucking*',                                   animals = {'a_c_hen'},                                    spawned = {} },
                { name = 'Monkey rain',  description = 'Idk what sound a monkey does',                 animals = {'a_c_chimp'},                                  spawned = {} },
                { name = 'Pig rain',     description = '(> (00) <)',                                   animals = {'a_c_pig'},                                    spawned = {} },
                { name = 'Rat rain',     description = 'Puts a Remote access trojan in your pc. (JK)', animals = {'a_c_rat'},                                    spawned = {} }
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

            JSlang.action(rain_root, 'Clear rain', {'JSclear'}, 'Deletes rained entities.', function()
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
