--倒卖狗不得好死，给你妈凑买棺材板的钱呢是吧？-- 
--jinx Scirpt中文区翻译：Lu_zi / BlackMist 臣服 -- 
util.require_natives("natives-1663599433-uno")
util.toast("欢迎来到JinxScript!\n" .. "官方Discord: https://discord.gg/hjs5S93kQv \n中文QQ交流群: 296512882") 
local response = false
local localVer = 2.70
async_http.init("raw.githubusercontent.com", "/Prisuhm/JinxScript/main/JinxScriptVersion", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("新版本已推送,更新脚本来获取最新版本.")
        menu.action(menu.my_root(), "更新此脚本", {}, "点击后会导致全英文，等Jinx中文区更新", function()
            async_http.init('raw.githubusercontent.com','/Prisuhm/JinxScript/main/JinxScript.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("脚本下载失败,请稍后重试,如果这种情况继续发生,请通过 Github 手动更新.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("更新成功,请重启脚本:)")
                util.restart_script()
            end)
            async_http.dispatch()
        end)
    end
end, function() response = true end)
async_http.dispatch()
repeat 
    util.yield()
until response

local function player_toggle_loop(root, pid, menu_name, command_names, help_text, callback)
    return menu.toggle_loop(root, menu_name, command_names, help_text, function()
        if not players.exists(pid) then util.stop_thread() end
        callback()
    end)
end

local spawned_objects = {}
local ladder_objects = {}
local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 243)) 
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(0x2908D3 + 1 + (pid * 0x1C5) + 243)) ~= 0)
end

local function get_entity_owner(addr)
    if util.is_session_started() and not util.is_session_transition_active() then
        local netObject = memory.read_long(addr + 0xD0)
        if netObject == 0 then
            return -1
        end
        local owner = memory.read_byte(netObject + 0x49)
        return owner
    end
    return players.user()
end

local function setBit(addr, bitIndex)
    memory.write_int(addr, memory.read_int(addr) | (1<<bitIndex))
end

local function clearBit(addr, bitIndex)
    memory.write_int(addr, memory.read_int(addr) & ~(1<<bitIndex))
end

function GetPlayerCurrentFmActivity(player)
    if player ~= -1 then
        return read_global.int(1892703 + (player * 599 + 1))
    end
    return -1
end

---@param player Player
---@return boolean
function IsPlayerTheBeast(player)
    return GetPlayerCurrentFmActivity(player) == 146 and read_global.int(2815059 + 5120) == player
end

local function get_blip_coords(blipId)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(blipId)
    if blip ~= 0 then return HUD.GET_BLIP_COORDS(blip) end
    return v3(0, 0, 0)
end

local function custom_alert(l1) -- totally not skidded from lancescript
    poptime = os.time()
    while true do
        if PAD.IS_CONTROL_JUST_RELEASED(18, 18) then
            if os.time() - poptime > 0.1 then
                break
            end
        end
        native_invoker.begin_call()
        native_invoker.push_arg_string("ALERT")
        native_invoker.push_arg_string("JL_INVITE_ND")
        native_invoker.push_arg_int(2)
        native_invoker.push_arg_string("")
        native_invoker.push_arg_bool(true)
        native_invoker.push_arg_int(-1)
        native_invoker.push_arg_int(-1)
        native_invoker.push_arg_string(l1)
        native_invoker.push_arg_int(0)
        native_invoker.push_arg_bool(true)
        native_invoker.push_arg_int(0)
        native_invoker.end_call("701919482C74B5AB")
        util.yield()
    end
end

local function request_model(hash, timeout)
    timeout = timeout or 3
    STREAMING.REQUEST_MODEL(hash)
    local end_time = os.time() + timeout
    repeat
        util.yield()
    until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end

local first_names = {"JAMES", "JOHN", "ROBERT", "MICHAEL", "WILLIAM", "DAVID", "RICHARD", "CHARLES", "JOSEPH", "THOMAS", "CHRISTOPHER", "DANIEL", "PAUL", "MARK", "DONALD", "GEORGE", "KENNETH", "STEVEN", "EDWARD", "BRIAN", "RONALD", "ANTHONY", "KEVIN", "JASON", "MATTHEW", "GARY", "TIMOTHY", "JOSE", "LARRY", "JEFFREY", "FRANK", "SCOTT", "ERIC", "STEPHEN", "ANDREW", "RAYMOND", "GREGORY", "JOSHUA", "JERRY", "DENNIS", "WALTER", "PATRICK", "PETER", "HAROLD", "DOUGLAS", "HENRY", "CARL", "ARTHUR", "RYAN", "ROGER", "JOE", "JUAN", "JACK", "ALBERT", "JONATHAN", "JUSTIN", "TERRY", "GERALD", "KEITH", "SAMUEL", "WILLIE", "RALPH", "LAWRENCE", "NICHOLAS", "ROY", "BENJAMIN", "BRUCE", "BRANDON", "ADAM", "HARRY", "FRED", "WAYNE", "BILLY", "STEVE", "LOUIS", "JEREMY", "AARON", "RANDY", "HOWARD", "EUGENE", "CARLOS", "RUSSELL", "BOBBY", "VICTOR", "MARTIN", "ERNEST", "PHILLIP", "TODD", "JESSE", "CRAIG", "ALAN", "SHAWN", "CLARENCE", "SEAN", "PHILIP", "CHRIS", "JOHNNY", "EARL", "JIMMY", "ANTONIO"}
local last_names = {"smith" , "johnson" , "williams" , "brown" , "jones" , "miller" , "davis" , "garcia" , "rodriguez" , "wilson" , "martinez" , "anderson" , "taylor" , "thomas" , "hernandez" , "moore" , "martin" , "jackson" , "thompson" , "white" , "lopez" , "lee" , "gonzalez" , "harris" , "clark" , "lewis" , "robinson" , "walker" , "perez" , "hall" , "young" , "allen" , "sanchez" , "wright" , "king" , "scott" , "green" , "baker" , "adams" , "nelson" , "hill" , "ramirez" , "campbell" , "mitchell" , "roberts" , "carter" , "phillips" , "evans" , "turner" , "torres" , "parker" , "collins" , "edwards" , "stewart" , "flores" , "morris" , "nguyen" , "murphy" , "rivera" , "cook" , "rogers" , "morgan" , "peterson" , "cooper" , "reed" , "bailey" , "bell" , "gomez" , "kelly" , "howard" , "ward" , "cox" , "diaz" , "richardson" , "wood" , "watson" , "brooks" , "bennett" , "gray" , "james" , "reyes" , "cruz" , "hughes" , "price" , "myers" , "long" , "foster" , "sanders" , "ross" , "morales" , "powell" , "sullivan" , "russell" , "ortiz" , "jenkins" , "gutierrez" , "perry" , "butler" , "barnes" , "fisher"}
local addresses = {"777 Brockton Avenue, Abington MA 2351" , "30 Memorial Drive, Avon MA 2322" , "250 Hartford Avenue, Bellingham MA 2019" , "700 Oak Street, Brockton MA 2301" , "66-4 Parkhurst Rd, Chelmsford MA 1824" , "591 Memorial Dr, Chicopee MA 1020" , "55 Brooksby Village Way, Danvers MA 1923" , "137 Teaticket Hwy, East Falmouth MA 2536" , "42 Fairhaven Commons Way, Fairhaven MA 2719" , "374 William S Canning Blvd, Fall River MA 2721" , "121 Worcester Rd, Framingham MA 1701" , "677 Timpany Blvd, Gardner MA 1440" , "337 Russell St, Hadley MA 1035" , "295 Plymouth Street, Halifax MA 2338" , "1775 Washington St, Hanover MA 2339" , "280 Washington Street, Hudson MA 1749" , "20 Soojian Dr, Leicester MA 1524" , "11 Jungle Road, Leominster MA 1453" , "301 Massachusetts Ave, Lunenburg MA 1462" , "780 Lynnway, Lynn MA 1905" , "70 Pleasant Valley Street, Methuen MA 1844" , "830 Curran Memorial Hwy, North Adams MA 1247" , "1470 S Washington St, North Attleboro MA 2760" , "506 State Road, North Dartmouth MA 2747" , "742 Main Street, North Oxford MA 1537" , "72 Main St, North Reading MA 1864" , "200 Otis Street, Northborough MA 1532" , "180 North King Street, Northhampton MA 1060" , "555 East Main St, Orange MA 1364" , "555 Hubbard Ave-Suite 12, Pittsfield MA 1201" , "300 Colony Place, Plymouth MA 2360" , "301 Falls Blvd, Quincy MA 2169" , "36 Paramount Drive, Raynham MA 2767" , "450 Highland Ave, Salem MA 1970" , "1180 Fall River Avenue, Seekonk MA 2771" , "1105 Boston Road, Springfield MA 1119" , "100 Charlton Road, Sturbridge MA 1566" , "262 Swansea Mall Dr, Swansea MA 2777" , "333 Main Street, Tewksbury MA 1876" , "550 Providence Hwy, Walpole MA 2081" , "352 Palmer Road, Ware MA 1082" , "3005 Cranberry Hwy Rt 6 28, Wareham MA 2538" , "250 Rt 59, Airmont NY 10901" , "141 Washington Ave Extension, Albany NY 12205" , "13858 Rt 31 W, Albion NY 14411" , "2055 Niagara Falls Blvd, Amherst NY 14228" , "101 Sanford Farm Shpg Center, Amsterdam NY 12010" , "297 Grant Avenue, Auburn NY 13021" , "4133 Veterans Memorial Drive, Batavia NY 14020" , "6265 Brockport Spencerport Rd, Brockport NY 14420" , "5399 W Genesse St, Camillus NY 13031" , "3191 County rd 10, Canandaigua NY 14424" , "30 Catskill, Catskill NY 12414" , "161 Centereach Mall, Centereach NY 11720" , "3018 East Ave, Central Square NY 13036" , "100 Thruway Plaza, Cheektowaga NY 14225" , "8064 Brewerton Rd, Cicero NY 13039" , "5033 Transit Road, Clarence NY 14031" , "3949 Route 31, Clay NY 13041" , "139 Merchant Place, Cobleskill NY 12043" , "85 Crooked Hill Road, Commack NY 11725" , "872 Route 13, Cortlandville NY 13045" , "279 Troy Road, East Greenbush NY 12061" , "2465 Hempstead Turnpike, East Meadow NY 11554" , "6438 Basile Rowe, East Syracuse NY 13057" , "25737 US Rt 11, Evans Mills NY 13637" , "901 Route 110, Farmingdale NY 11735" , "2400 Route 9, Fishkill NY 12524" , "10401 Bennett Road, Fredonia NY 14063" , "1818 State Route 3, Fulton NY 13069" , "4300 Lakeville Road, Geneseo NY 14454" , "990 Route 5 20, Geneva NY 14456" , "311 RT 9W, Glenmont NY 12077" , "200 Dutch Meadows Ln, Glenville NY 12302" , "100 Elm Ridge Center Dr, Greece NY 14626" , "1549 Rt 9, Halfmoon NY 12065" , "5360 Southwestern Blvd, Hamburg NY 14075" , "103 North Caroline St, Herkimer NY 13350" , "1000 State Route 36, Hornell NY 14843" , "1400 County Rd 64, Horseheads NY 14845" , "135 Fairgrounds Memorial Pkwy, Ithaca NY 14850" , "2 Gannett Dr, Johnson City NY 13790" , "233 5th Ave Ext, Johnstown NY 12095" , "601 Frank Stottile Blvd, Kingston NY 12401" , "350 E Fairmount Ave, Lakewood NY 14750" , "4975 Transit Rd, Lancaster NY 14086" , "579 Troy-Schenectady Road, Latham NY 12110" , "5783 So Transit Road, Lockport NY 14094" , "7155 State Rt 12 S, Lowville NY 13367" , "425 Route 31, Macedon NY 14502" , "3222 State Rt 11, Malone NY 12953" , "200 Sunrise Mall, Massapequa NY 11758" , "43 Stephenville St, Massena NY 13662" , "750 Middle Country Road, Middle Island NY 11953" , "470 Route 211 East, Middletown NY 10940" , "3133 E Main St, Mohegan Lake NY 10547" , "288 Larkin, Monroe NY 10950" , "41 Anawana Lake Road, Monticello NY 12701" , "4765 Commercial Drive, New Hartford NY 13413" , "1201 Rt 300, Newburgh NY 12550" , "255 W Main St, Avon CT 6001" , "120 Commercial Parkway, Branford CT 6405" , "1400 Farmington Ave, Bristol CT 6010" , "161 Berlin Road, Cromwell CT 6416" , "67 Newton Rd, Danbury CT 6810" , "656 New Haven Ave, Derby CT 6418" , "69 Prospect Hill Road, East Windsor CT 6088" , "150 Gold Star Hwy, Groton CT 6340" , "900 Boston Post Road, Guilford CT 6437" , "2300 Dixwell Ave, Hamden CT 6514" , "495 Flatbush Ave, Hartford CT 6106" , "180 River Rd, Lisbon CT 6351" , "420 Buckland Hills Dr, Manchester CT 6040" , "1365 Boston Post Road, Milford CT 6460" , "1100 New Haven Road, Naugatuck CT 6770" , "315 Foxon Blvd, New Haven CT 6513" , "164 Danbury Rd, New Milford CT 6776" , "3164 Berlin Turnpike, Newington CT 6111" , "474 Boston Post Road, North Windham CT 6256" , "650 Main Ave, Norwalk CT 6851" , "680 Connecticut Avenue, Norwalk CT 6854" , "220 Salem Turnpike, Norwich CT 6360" , "655 Boston Post Rd, Old Saybrook CT 6475" , "625 School Street, Putnam CT 6260" , "80 Town Line Rd, Rocky Hill CT 6067" , "465 Bridgeport Avenue, Shelton CT 6484" , "235 Queen St, Southington CT 6489" , "150 Barnum Avenue Cutoff, Stratford CT 6614" , "970 Torringford Street, Torrington CT 6790" , "844 No Colony Road, Wallingford CT 6492" , "910 Wolcott St, Waterbury CT 6705" , "155 Waterford Parkway No, Waterford CT 6385" , "515 Sawmill Road, West Haven CT 6516" , "2473 Hackworth Road, Adamsville AL 35005" , "630 Coonial Promenade Pkwy, Alabaster AL 35007" , "2643 Hwy 280 West, Alexander City AL 35010" , "540 West Bypass, Andalusia AL 36420" , "5560 Mcclellan Blvd, Anniston AL 36206" , "1450 No Brindlee Mtn Pkwy, Arab AL 35016" , "1011 US Hwy 72 East, Athens AL 35611" , "973 Gilbert Ferry Road Se, Attalla AL 35954" , "1717 South College Street, Auburn AL 36830" , "701 Mcmeans Ave, Bay Minette AL 36507" , "750 Academy Drive, Bessemer AL 35022" , "312 Palisades Blvd, Birmingham AL 35209" , "1600 Montclair Rd, Birmingham AL 35210" , "5919 Trussville Crossings Pkwy, Birmingham AL 35235" , "9248 Parkway East, Birmingham AL 35206" , "1972 Hwy 431, Boaz AL 35957" , "10675 Hwy 5, Brent AL 35034" , "2041 Douglas Avenue, Brewton AL 36426" , "5100 Hwy 31, Calera AL 35040" , "1916 Center Point Rd, Center Point AL 35215" , "1950 W Main St, Centre AL 35960" , "16077 Highway 280, Chelsea AL 35043" , "1415 7Th Street South, Clanton AL 35045" , "626 Olive Street Sw, Cullman AL 35055" , "27520 Hwy 98, Daphne AL 36526" , "2800 Spring Avn SW, Decatur AL 35603" , "969 Us Hwy 80 West, Demopolis AL 36732" , "3300 South Oates Street, Dothan AL 36301" , "4310 Montgomery Hwy, Dothan AL 36303" , "600 Boll Weevil Circle, Enterprise AL 36330" , "3176 South Eufaula Avenue, Eufaula AL 36027" , "7100 Aaron Aronov Drive, Fairfield AL 35064" , "10040 County Road 48, Fairhope AL 36533" , "3186 Hwy 171 North, Fayette AL 35555" , "3100 Hough Rd, Florence AL 35630" , "2200 South Mckenzie St, Foley AL 36535" , "2001 Glenn Bldv Sw, Fort Payne AL 35968" , "340 East Meighan Blvd, Gadsden AL 35903" , "890 Odum Road, Gardendale AL 35071" , "1608 W Magnolia Ave, Geneva AL 36340" , "501 Willow Lane, Greenville AL 36037" , "170 Fort Morgan Road, Gulf Shores AL 36542" , "11697 US Hwy 431, Guntersville AL 35976" , "42417 Hwy 195, Haleyville AL 35565" , "1706 Military Street South, Hamilton AL 35570" , "1201 Hwy 31 NW, Hartselle AL 35640" , "209 Lakeshore Parkway, Homewood AL 35209" , "2780 John Hawkins Pkwy, Hoover AL 35244" , "5335 Hwy 280 South, Hoover AL 35242" , "1007 Red Farmer Drive, Hueytown AL 35023" , "2900 S Mem PkwyDrake Ave, Huntsville AL 35801" , "11610 Memorial Pkwy South, Huntsville AL 35803" , "2200 Sparkman Drive, Huntsville AL 35810" , "330 Sutton Rd, Huntsville AL 35763" , "6140A Univ Drive, Huntsville AL 35806" , "4206 N College Ave, Jackson AL 36545" , "1625 Pelham South, Jacksonville AL 36265" , "1801 Hwy 78 East, Jasper AL 35501" , "8551 Whitfield Ave, Leeds AL 35094" , "8650 Madison Blvd, Madison AL 35758" , "145 Kelley Blvd, Millbrook AL 36054" , "1970 S University Blvd, Mobile AL 36609" , "6350 Cottage Hill Road, Mobile AL 36609" , "101 South Beltline Highway, Mobile AL 36606" , "2500 Dawes Road, Mobile AL 36695" , "5245 Rangeline Service Rd, Mobile AL 36619" , "685 Schillinger Rd, Mobile AL 36695" , "3371 S Alabama Ave, Monroeville AL 36460" , "10710 Chantilly Pkwy, Montgomery AL 36117" , "3801 Eastern Blvd, Montgomery AL 36116" , "6495 Atlanta Hwy, Montgomery AL 36117" , "851 Ann St, Montgomery AL 36107" , "15445 Highway 24, Moulton AL 35650" , "517 West Avalon Ave, Muscle Shoals AL 35661" , "5710 Mcfarland Blvd, Northport AL 35476" , "2453 2Nd Avenue East, Oneonta AL 35121  205-625-647" , "2900 Pepperrell Pkwy, Opelika AL 36801" , "92 Plaza Lane, Oxford AL 36203" , "1537 Hwy 231 South, Ozark AL 36360" , "2181 Pelham Pkwy, Pelham AL 35124" , "165 Vaughan Ln, Pell City AL 35125" , "3700 Hwy 280-431 N, Phenix City AL 36867" , "1903 Cobbs Ford Rd, Prattville AL 36066" , "4180 Us Hwy 431, Roanoke AL 36274" , "13675 Hwy 43, Russellville AL 35653" , "1095 Industrial Pkwy, Saraland AL 36571" , "24833 Johnt Reidprkw, Scottsboro AL 35768" , "1501 Hwy 14 East, Selma AL 36703" , "7855 Moffett Rd, Semmes AL 36575" , "150 Springville Station Blvd, Springville AL 35146" , "690 Hwy 78, Sumiton AL 35148" , "41301 US Hwy 280, Sylacauga AL 35150" , "214 Haynes Street, Talladega AL 35160" , "1300 Gilmer Ave, Tallassee AL 36078" , "34301 Hwy 43, Thomasville AL 36784" , "1420 Us 231 South, Troy AL 36081" , "1501 Skyland Blvd E, Tuscaloosa AL 35405" , "3501 20th Av, Valley AL 36854" , "1300 Montgomery Highway, Vestavia Hills AL 35216" , "4538 Us Hwy 231, Wetumpka AL 36092" , "2575 Us Hwy 43, Winfield AL 35594"}
local rand_words = {"car", "cartoon", "fun", "boy", "girl", "spaghetti", "pizza", "guitar", "music", "ratio", "dog", "cat", "password"}
local password = rand_words[math.random(#rand_words)] .. math.random(10, 99)
local name = (string.lower(first_names[math.random(#first_names)])) .. ' ' .. (string.lower(last_names[math.random(#last_names)]))
local ssn = math.random(100, 999) .. '-' .. math.random(10, 99) .. '-' .. math.random(1000, 9999)
local phone_num = '+1 (' .. math.random(100, 999) .. ')' .. '-' .. math.random(100, 999) .. '-' .. math.random(1000, 9999)
local ip = math.random(255) .. '.' .. math.random(255) .. '.' .. math.random(255) .. '.' .. math.random(255)
local blood_types = {'A+', 'B+', 'AB+', 'A-', 'B-', 'AB-', 'O+', 'O-'}

local All_business_properties = {
    -- Clubhouses
    "罗伊洛文斯坦大道 1334 号",
    "佩罗海滩 7 号",
    "艾尔金大街 75 号",
    "68 号公路 101 号",
    "佩立托大道 1 号",
    "阿尔冈琴大道 47 号",
    "资本大道 137 号",
    "克林顿大街 2214 号",
    "霍伊克大街 1778 号",
    "东约书亚路 2111 号",
    "佩立托大道 68 号",
    "戈马街 4 号",
    -- 设施
    "塞诺拉大沙漠设施",
    "68 号公路设施",
    "沙滩海岸设施",
    "戈多山设施",
    "佩立托湾设施",
    "桑库多湖设施",
    "桑库多河设施",
    "荣恩风力发电场设施",
    "兰艾水库设施",
    -- 游戏厅
    "像素彼得 - 佩立托湾",
    "奇迹神所 - 葡萄籽",
    "仓库 - 戴维斯",
    "八位元 - 好麦坞",
    "请投币 - 罗克福德山",
    "游戏末日 - 梅萨",
}
local small_warehouses = {
    [1] = "太平洋鱼饵仓储", 
    [2] = "白寡妇车库", 
    [3] = "赛尔托瓦单元", 
    [4] = "便利店车库", 
    [5] = "法拍车库", 
    [9] = "码头 400 号工作仓库", 
}

local medium_warehouses = {
    [7] = "翘臀内衣外景场地", 
    [10] = "GEE 仓库", 
    [11] = "洛圣都海事大厦 3 号楼", 
    [12] = "火车站仓库", 
    [13] = "透心凉辅楼仓库",
    [14] = "废弃的工厂直销店", 
    [15] = "折扣零售商店", 
    [21] = "旧发电站", 
}

local large_warehouses = {
    [6] = "希罗汽油工厂",  
    [8] = "贝尔吉科仓库", 
    [16] = "物流仓库", 
    [17] = "达内尔兄弟仓库", 
    [18] = "家具批发市场", 
    [19] = "柏树仓库", 
    [20] = "西好麦坞外景场地", 
    [22] = "沃克父子仓库"
}


local weapon_stuff = {
    {"烟花", "weapon_firework"}, 
    {"原子能枪", "weapon_raypistol"},
    {"邪恶冥王", "weapon_raycarbine"},
    {"电磁步枪", "weapon_railgun"},
    {"红色激光", "vehicle_weapon_enemy_laser"},
    {"绿色激光", "vehicle_weapon_player_laser"},
    {"天煞机炮", "vehicle_weapon_player_lazer"},
    {"火箭炮", "weapon_rpg"},
    {"制导火箭发射器", "weapon_hominglauncher"},
    {"紧凑型电磁脉冲发射器", "weapon_emplauncher"},
    {"信号弹", "weapon_flaregun"},
    {"霰弹枪", "weapon_bullpupshotgun"},
    {"电击枪", "weapon_stungun"},
    {"催泪瓦斯", "weapon_smokegrenade"},
}

local proofs = {
    bullet = {name="子弹",on=false},
    fire = {name="火烧",on=false},
    explosion = {name="爆炸",on=false},
    collision = {name="撞击",on=false},
    melee = {name="近战",on=false},
    steam = {name="蒸汽",on=false},
    drown = {name="溺水",on=false},
}

local effect_stuff = {
    {"吸毒驾车", "DrugsDrivingIn"}, 
    {"吸毒的崔佛", "DrugsTrevorClownsFight"},
    {"吸毒的麦克", "DrugsMichaelAliensFight"},
    {"小查视角(红绿色盲)", "ChopVision"},
    {"默片", "DeathFailOut"},
    {"黑白", "HeistCelebPassBW"},
    {"横冲直撞", "Rampage"},
    {"我的眼镜在哪里？", "MenuMGSelectionIn"},
    {"梦境", "DMT_flight_intro"},
}


local visual_stuff = {
    {"提升亮度", "AmbientPush"},
    {"提升饱和度", "rply_saturation"},
    {"提升曝光度", "LostTimeFlash"},
    {"雾之夜", "casino_main_floor_heist"},
    {"更好的夜晚", "dlc_island_vault"},
    {"正常雾天", "Forest"},
    {"大雾天", "nervousRON_fog"},
    {"黄昏天", "MP_Arena_theme_evening"},
    {"暖色调", "mp_bkr_int01_garage"},
    {"死气沉沉", "MP_deathfail_night"},
    {"石化", "stoned"},
    {"水下", "underwater"},
}

local drugged_effects = {
    "药品 1",
    "药品 2",
    "药品 3",
    "药品 4",
    "药品 5",
    "药品 6",
    "药品 7",
    "药品 8",
}

local unreleased_vehicles = {
    "Sentinel4",
}

local modded_vehicles = {
    "dune2",
    "tractor",
    "dilettante2",
    "asea2",
    "cutter",
    "mesa2",
    "jet",
    "policeold1",
    "policeold2",
    "armytrailer2",
    "towtruck",
    "towtruck2",
    "cargoplane",
}

local modded_weapons = {
    "weapon_railgun",
    "weapon_stungun",
    "weapon_digiscanner",
}

local interiors = {
    {"安全空间 [挂机室]", {x=-158.71494, y=-982.75885, z=149.13135}},
    {"酷刑室", {x=147.170, y=-2201.804, z=4.688}},
    {"矿道", {x=-595.48505, y=2086.4502, z=131.38136}},
    {"欧米茄车库", {x=2330.2573, y=2572.3005, z=46.679367}},
    {"末日任务服务器组", {x=2474.0847, y=-332.58887, z=92.9927}},
    {"角色捏脸房间", {x=402.91586, y=-998.5701, z=-99.004074}},
    {"Lifeinvader大楼", {x=-1082.8595, y=-254.774, z=37.763317}},
    {"竞速结束车库", {x=405.9228, y=-954.1149, z=-99.6627}},
    {"被摧毁的医院", {x=304.03894, y=-590.3037, z=43.291893}},
    {"体育场", {x=-256.92334, y=-2024.9717, z=30.145584}},
    {"Split Sides喜剧俱乐部", {x=-430.00974, y=261.3437, z=83.00648}},
    {"巴哈马酒吧", {x=-1394.8816, y=-599.7526, z=30.319544}},
    {"看门人之家", {x=-110.20285, y=-8.6156025, z=70.51957}},
    {"费蓝德医生之家", {x=-1913.8342, y=-574.5799, z=11.435149}},
    {"杜根房子", {x=1395.2512, y=1141.6833, z=114.63437}},
    {"弗洛伊德公寓", {x=-1156.5099, y=-1519.0894, z=10.632717}},
    {"麦克家", {x=-813.8814, y=179.07889, z=72.15914}},
    {"富兰克林家（旧）", {x=-14.239959, y=-1439.6913, z=31.101551}},
    {"富兰克林家（新）", {x=7.3125067, y=537.3615, z=176.02803}},
    {"崔佛家", {x=1974.1617, y=3819.032, z=33.436287}},
    {"莱斯斯家", {x=1273.898, y=-1719.304, z=54.771}},
    {"莱斯特的纺织厂", {x=713.5684, y=-963.64795, z=30.39534}},
    {"莱斯特的纺织厂办事处", {x=707.2138, y=-965.5549, z=30.412853}},
    {"甲基安非他明实验室", {x=1391.773, y=3608.716, z=38.942}},
    {"人道实验室", {x=3625.743, y=3743.653, z=28.69009}},
    {"汽车旅馆客房", {x=152.2605, y=-1004.471, z=-99.024}},
    {"警察局", {x=443.4068, y=-983.256, z=30.689589}},
    {"太平洋标准银行金库", {x=263.39627, y=214.39891, z=101.68336}},
    {"布莱恩郡银行", {x=-109.77874, y=6464.8945, z=31.626724}}, -- credit to fluidware for telling me about this one
    {"龙舌兰酒吧", {x=-564.4645, y=275.5777, z=83.074585}},
    {"废料厂车库", {x=485.46396, y=-1315.0614, z=29.2141}},
    {"失落摩托帮", {x=980.8098, y=-101.96038, z=74.84504}},
    {"范吉利科珠宝店", {x=-629.9367, y=-236.41296, z=38.057056}},
    {"机场休息室", {x=-913.8656, y=-2527.106, z=36.331566}},
    {"停尸房", {x=240.94368, y=-1379.0645, z=33.74177}},
    {"联盟保存处", {x=1.298771, y=-700.96967, z=16.131021}},
    {"军事基地瞭望塔", {x=-2357.9187, y=3249.689, z=101.45073}},
    {"事务所内部", {x=-1118.0181, y=-77.93254, z=-98.99977}},
    {"中介所车库", {x=-1071.0494, y=-71.898506, z=-94.59982}},
    {"复仇者内部", {x=518.6444, y=4750.4644, z=-69.3235}},
    {"恐霸内部", {x=-1421.015, y=-3012.587, z=-80.000}},
    {"地堡内部", {x=899.5518,y=-3246.038, z=-98.04907}},
    {"IAA 办公室", {x=128.20, y=-617.39, z=206.04}},
    {"FIB 顶层", {x=135.94359, y=-749.4102, z=258.152}},
    {"FIB 47层", {x=134.5835, y=-766.486, z=234.152}},
    {"FIB 49层", {x=134.635, y=-765.831, z=242.152}},
    {"大公鸡", {x=-31.007448, y=6317.047, z=40.04039}},
    {"大麻商店", {x=-1170.3048, y=-1570.8246, z=4.663622}},
    {"脱衣舞俱乐部DJ位置", {x=121.398254, y=-1281.0024, z=29.480522}},
}

local station_name = {
"RADIO_11_TALK_02", -- Blaine County Radio
"RADIO_12_REGGAE", -- The Blue Ark
"RADIO_13_JAZZ", -- Worldwide FM
"RADIO_14_DANCE_02", -- FlyLo FM
"RADIO_15_MOTOWN", -- The Lowdown 9.11
"RADIO_20_THELAB", -- The Lab
"RADIO_16_SILVERLAKE", -- Radio Mirror Park
"RADIO_17_FUNK", -- Space 103.2
"RADIO_18_90S_ROCK", -- Vinewood Boulevard Radio
"RADIO_21_DLC_XM17", -- Blonded Los Santos 97.8 FM
"RADIO_22_DLC_BATTLE_MIX1_RADIO", -- Los Santos Underground Radio
"RADIO_23_DLC_XM19_RADIO", -- iFruit Radio
"RADIO_19_USER", -- Self Radio
"RADIO_01_CLASS_ROCK", -- Los Santos Rock Radio
"RADIO_02_POP", -- Non-Stop-Pop FM
"RADIO_03_HIPHOP_NEW", -- Radio Los Santos
"RADIO_04_PUNK", -- Channel X
"RADIO_05_TALK_01", -- West Coast Talk Radio
"RADIO_06_COUNTRY", -- Rebel Radio
"RADIO_07_DANCE_01", -- Soulwax FM
"RADIO_08_MEXICAN", -- East Los FM
"RADIO_09_HIPHOP_OLD", -- West Coast Classics
"RADIO_36_AUDIOPLAYER", -- Media Player
"RADIO_35_DLC_HEI4_MLR", -- The Music Locker
"RADIO_34_DLC_HEI4_KULT", -- Kult FM
"RADIO_27_DLC_PRHEI4", -- Still Slipping Los Santos
}

local values = {
    [0] = 0,
    [1] = 50,
    [2] = 88,
    [3] = 160,
    [4] = 208,
}

local launch_vehicle = {"向上", "向前", "向后", "向下", "翻滚"}
local invites = {"游艇", "办公室", "会所", "办公室车库", "载具改装铺", "公寓"}
local style_names = {"正常", "半冲刺", "反向", "无视红绿灯", "避开交通", "极度避开交通", "有时超车"}
local drivingStyles = {786603, 1074528293, 8388614, 1076, 2883621, 786468, 262144, 786469, 512, 5, 6}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}
local stinkers = {0x919B57F, 0xC682AB5, 0x3280B78, 0xC2590C9, 0xBB6BAE6, 0xA1FA84B, 0x101D84E, 0xCA6E931, 0x691AC07, 0xAA87C21, 0x988DB36, 0x6AE10E2, 0x71D0AF9}

local self = menu.list(menu.my_root(), "自我选项", {}, "")
local players_list = menu.list(menu.my_root(), "玩家选项", {}, "")
local session = menu.list(menu.my_root(), "聊天选项", {}, "")
local visuals = menu.list(menu.my_root(), "视觉效果", {}, "")
local funfeatures = menu.list(menu.my_root(), "娱乐功能", {}, "")
local teleport = menu.list(menu.my_root(), "传送选项", {}, "")
local detections = menu.list(menu.my_root(), "作弊检测", {}, "")
local bailOnAdminJoin = false
local protections = menu.list(menu.my_root(), "保护选项", {}, "")
menu.toggle(protections, "R*开发人员加入反应", {}, "", function(on)
    bailOnAdminJoin = on
end)

local int_min = -2147483647
local int_max = 2147483647

local menus = {}
local function player_list(pid)
    menus[pid] = menu.action(players_list, players.get_name(pid), {}, "", function() -- thanks to dangerman and aaron for showing me how to delete players properly
        menu.trigger_commands("jinxscript " .. players.get_name(pid))
    end)
end

local function handle_player_list(pid)
    local ref = menus[pid]
    if not players.exists(pid) then
        if ref then
            menu.delete(ref)
            menus[pid] = nil
        end
    end
end

players.on_join(player_list)
players.on_leave(handle_player_list)

local function player(pid) 
    for _, rid in ipairs (stinkers) do
            if players.get_rockstar_id(pid) == rid and get_transition_state(pid) ~= 0 then 
            menu.trigger_commands("kick " .. players.get_name(pid))
        end
    end

    if pid ~= players.user() and players.get_rockstar_id(pid) == 0xCB2A48C then
        util.toast(lang.get_string(0xD251C4AA, lang.get_current()):gsub("{(.-)}", {player = players.get_name(pid), reason = "JinxScript Developer \n(They might be a sussy impostor, watch out!)"}), TOAST_DEFAULT)
    end

    if pid ~= players.user() and players.get_rockstar_id(pid) == 0xAE8F8C2 then
        util.toast(lang.get_string(0xD251C4AA, lang.get_current()):gsub("{(.-)}", {player = players.get_name(pid), reason = "Based Gigachad\n (They are very based! Proceed with caution!)"}), TOAST_DEFAULT)
    end

    menu.divider(menu.player_root(pid), "Jinx Script")
    local bozo = menu.list(menu.player_root(pid), "Jinx Script", {"JinxScript"}, "\n· 点击打开尊贵的Jinx脚本玩家选项\n· 免费的大爹级原创综合脚本\n· Jinx作者：Prisuhm\n")

    local friendly = menu.list(bozo, "友好", {}, "")
    menu.toggle_loop(friendly, "给予无敌隐形载具", {}, "不会被大多数菜单检测到载具无敌", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), true, true, true, true, true, false, false, true)
        end, function() 
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(ped), false, false, false, false, false, false, false, false)
    end)

    menu.action(friendly, "给他/她升升级", {}, "给予该玩家17万RP经验,可从1级提升至25级.\n一名玩家只能用一次嗷", function()
        util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x5, 0, 1, 1, 1})
        for i = 0, 9 do
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x0, i, 1, 1, 1})
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x1, i, 1, 1, 1})
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x3, i, 1, 1, 1})
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0xA, i, 1, 1, 1})
        end
        for i = 0, 1 do
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x2, i, 1, 1, 1})
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x6, i, 1, 1, 1})
        end
        for i = 0, 19 do
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x4, i, 1, 1, 1})
        end
        for i = 0, 99 do
            util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x9, i, 1, 1, 1})
            util.yield()
        end
    end)

    local halloween_loop = menu.list(friendly, "循环给予万圣节收藏品", {}, "")
    local halloween_delay = 500
    menu.slider(halloween_loop, "延迟", {}, "", 0, 2500, 500, 10, function(amount)
        halloween_delay = amount
    end)
    player_toggle_loop(halloween_loop, pid, "启用循环", {}, "应该给他们不少钱和其他一些东西", function()
        util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x8, -1, 1, 1, 1})
        util.yield(halloween_delay)
    end)

    local rpwarning
     rpwarning = menu.action(friendly, "循环给予经验收藏品", {}, "", function(click_type)
        menu.show_warning(rpwarning, click_type, "警告:这可能会导致封禁,后果自负.", function()
            local rp_loop = menu.list(friendly, "循环给予收藏品", {}, "")
            menu.delete(rpwarning)
            local rp_delay = 500
            menu.slider(rp_loop, "延迟", {"givedelay"}, "", 0, 2500, 500, 10, function(amount)
                rp_delay = amount
            end)

            menu.toggle_loop(rp_loop, "启用循环", {}, "每个收藏品会给玩家1000RP经验", function()
                util.trigger_script_event(1 << pid, {0xB9BA4D30, pid, 0x4, -1, 1, 1, 1})
                util.yield(rp_delay)
            end)
            menu.trigger_command(rp_loop)
        end)
    end)

    local player_jinx_army = {}
    local army_player = menu.list(friendly, "宠物猫Jinx军队", {}, "整点小猫哄着你玩玩?\n删不掉的时候觉得烦的话换战局\n能少生成就少生成吧")
    menu.click_slider(army_player, "生成宠物猫Jinx军队", {}, "", 1, 256, 30, 1, function(val)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        pos.y = pos.y - 5
        pos.z = pos.z + 1
        local jinx = util.joaat("a_c_cat_01")
        request_model(jinx)
        for i = 1, val do
            player_jinx_army[i] = entities.create_ped(28, jinx, pos, 0)
            ENTITY.SET_ENTITY_INVINCIBLE(player_jinx_army[i], true)
            PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(player_jinx_army[i], true)
            PED.SET_PED_COMPONENT_VARIATION(player_jinx_army[i], 0, 0, 1, 0)
            TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(player_jinx_army[i], ped, 0, -0.3, 0, 7.0, -1, 10, true)
            util.yield()
        end 
    end)

    menu.action(army_player, "清除Jinx宠物猫", {}, "有几只清不掉的时候你就傻了 嘿嘿\n追着你喵喵叫 嘿嘿", function()
        for i, ped in ipairs(entities.get_all_peds_as_handles()) do
            if PED.IS_PED_MODEL(ped, util.joaat("a_c_cat_01")) then
                entities.delete_by_handle(ped)
            end
        end
    end)

    local funfeatures_player = menu.list(bozo, "娱乐", {}, "")
    menu.action(funfeatures_player, "自定义短信通知", {"customnotify"}, "例如: ~q~ <FONT SIZE=\"35\"> Jinx中文QQ交流群：296512882", function(cl)
        menu.show_command_box_click_based(cl, "customnotify "..players.get_name(pid):lower().." ") end, function(input)
            local event_data = {0x8E38E2DF, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
            input = input:sub(1, 127)
            for i = 0, #input -1 do
                local slot = i // 8
                local byte = string.byte(input, i + 1)
                event_data[slot + 3] = event_data[slot + 3] | byte << ((i-slot * 8)* 8)
            end
            util.trigger_script_event(1 << pid, event_data)
        end)

        
    menu.action(funfeatures_player, "自定义短信标签", {"label"}, "", function() menu.show_command_box("label "..players.get_name(pid).." ") end, function(label)
        local event_data = {0xD0CCAC62, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
        local out = label:sub(1, 127)
        if HUD.DOES_TEXT_LABEL_EXIST(label) then
            for i = 0, #out -1 do
                local slot = i // 8
                local byte = string.byte(out, i + 1)
                event_data[slot + 3] = event_data[slot + 3] | byte << ( (i - slot * 8) * 8)
            end
            util.trigger_script_event(1 << pid, event_data)
        else
            util.toast("抱歉,这不是一个有效的标签. :/")
        end
    end)

    menu.hyperlink(funfeatures_player, "标签列表", "https://gist.githubusercontent.com/aaronlink127/afc889be7d52146a76bab72ede0512c7/raw")
    local trolling = menu.list(bozo, "恶搞选项", {}, "")
    local radio_station = menu.list(trolling, "更换广播电台")
    local station = "RADIO_08_MEXICAN"
    menu.list_select(radio_station, "当前电台名称", {}, "", station_name, 1, function(index, value)
        station = value
    end)

    menu.action(radio_station, "更换电台", {""}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(players.user())
        local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)

        if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then 
            util.toast("玩家不在车内. :/")
        return end

        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then 
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(player_veh)
            ENTITY.SET_ENTITY_VISIBLE(players.user_ped(), false)
            menu.trigger_commands("tpveh" .. players.get_name(pid))
            util.yield(250)
            AUDIO.SET_VEH_RADIO_STATION(player_veh, station)
            util.yield(750)
        end
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), pos, false, false, false)
    end)
    local glitch_player_list = menu.list(trolling, "鬼畜玩家", {"glitchdelay"}, "")
    local object_stuff = {
        names = {
            "摩天轮",
            "UFO",
            "水泥搅拌车",
            "脚手架",
            "车库门",
            "保龄球",
            "足球",
            "橘子",
            "特技坡道",

        },
        objects = {
            "prop_ld_ferris_wheel",
            "p_spinning_anus_s",
            "prop_staticmixer_01",
            "prop_towercrane_02a",
            "des_scaffolding_root",
            "prop_sm1_11_garaged",
            "stt_prop_stunt_bowling_ball",
            "stt_prop_stunt_soccer_ball",
            "prop_juicestand",
            "stt_prop_stunt_jump_l",
        }
    }

    local object_hash = util.joaat("prop_ld_ferris_wheel")
    menu.list_select(glitch_player_list, "物体", {"glitchplayer"}, "选择鬼畜玩家使用的物体.", object_stuff.names, 1, function(index)
        object_hash = util.joaat(object_stuff.objects[index])
    end)

    menu.slider(glitch_player_list, "物体生成延迟", {"spawndelay"}, "", 100, 3000, 100, 10, function(amount)
        delay = amount
    end)

    local glitchPlayer = false
    local glitchPlayer_toggle
    glitchPlayer_toggle = menu.toggle(glitch_player_list, "启用", {}, "", function(toggled)
        glitchPlayer = toggled

        while glitchPlayer do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("这傻逼超出你的范围了 没法整. :/")
                menu.set_value(glitchPlayer_toggle, false)
            break end

            if not players.exists(pid) then 
                util.toast("找不到这傻逼,看看他还在战局吗?")
                menu.set_value(glitchPlayer_toggle, false)
            util.stop_thread() end

            local glitch_hash = object_hash
            local poopy_butt = util.joaat("rallytruck")
            request_model(glitch_hash)
            request_model(poopy_butt)
            local stupid_object = entities.create_object(glitch_hash, pos)
            local glitch_vehicle = entities.create_vehicle(poopy_butt, pos, 0)
            ENTITY.SET_ENTITY_VISIBLE(stupid_object, false)
            ENTITY.SET_ENTITY_VISIBLE(glitch_vehicle, false)
            ENTITY.SET_ENTITY_INVINCIBLE(stupid_object, true)
            ENTITY.SET_ENTITY_COLLISION(stupid_object, true, true)
            ENTITY.APPLY_FORCE_TO_ENTITY(glitch_vehicle, 1, 0.0, 10, 10, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
            util.yield(delay)
            entities.delete_by_handle(stupid_object)
            entities.delete_by_handle(glitch_vehicle)
            util.yield(delay)    
        end
    end)

    local glitchVeh = false
    local glitchVehCmd
    glitchVehCmd = menu.toggle(trolling, "鬼畜载具", {"glitchvehicle"}, "", function(toggle) -- credits to soul reaper for base concept
        glitchVeh = toggle
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        local veh_model = players.get_vehicle_model(pid)
        local ped_hash = util.joaat("a_m_m_acult_01")
        local object_hash = util.joaat("prop_ld_ferris_wheel")
        request_model(ped_hash)
        request_model(object_hash)
        
        while glitchVeh do
            if not players.exists(pid) then 
                util.toast("玩家不存在. :/")
                menu.set_value(glitchVehCmd, false);
            util.stop_thread() end

            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("玩家太远了. :/")
                menu.set_value(glitchVehCmd, false);
            break end

            if not PED.IS_PED_IN_VEHICLE(ped, player_veh, false) then 
                util.toast("你瞎吗?他不在车里啊! ")
                menu.set_value(glitchVehCmd, false);
            break end

            if not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                util.toast("车上没空座位了\n建议你给他车砸了.")
                menu.set_value(glitchVehCmd, false);
            break end

            local seat_count = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(veh_model)
            local glitch_obj = entities.create_object(object_hash, pos)
            local glitched_ped = entities.create_ped(26, ped_hash, pos, 0)
            local things = {glitched_ped, glitch_obj}

            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(glitch_obj)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(glitched_ped)

            ENTITY.ATTACH_ENTITY_TO_ENTITY(glitch_obj, glitched_ped, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)

            for i, spawned_objects in ipairs(things) do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(spawned_objects)
                ENTITY.SET_ENTITY_VISIBLE(spawned_objects, false)
                ENTITY.SET_ENTITY_INVINCIBLE(spawned_objects, true)
            end

            for i = 0, seat_count -1 do
                if VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(player_veh) then
                    local emptyseat = i
                    for l = 1, 25 do
                        PED.SET_PED_INTO_VEHICLE(glitched_ped, player_veh, emptyseat)
                        ENTITY.SET_ENTITY_COLLISION(glitch_obj, true, true)
                        util.yield()
                    end
                end
            end
            if glitched_ped ~= nil then -- added a 2nd stage here because it didnt want to delete sometimes, this solved that lol.
                entities.delete_by_handle(glitched_ped) 
            end
            if glitch_obj ~= nil then 
                entities.delete_by_handle(glitch_obj)
            end
        end
    end)

    local glitchForcefield = false
    local glitchforcefield_toggle
    glitchforcefield_toggle = menu.toggle(trolling, "大范围立场", {"forcefield"}, "", function(toggled)
        glitchForcefield = toggled
        local glitch_hash = util.joaat("p_spinning_anus_s")
        request_model(glitch_hash)

        while glitchForcefield do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
            
            if not players.exists(pid) then 
                util.toast("找不到这傻逼,看看他还在战局吗?")
                menu.set_value(glitchPlayer_toggle, false)
            util.stop_thread() end

            if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                util.toast("需要他在车里.")
                menu.set_value(glitchforcefield_toggle, false)
            break end
            
            local stupid_object = entities.create_object(glitch_hash, playerpos)
            ENTITY.SET_ENTITY_VISIBLE(stupid_object, false)
            util.yield()
            entities.delete_by_handle(stupid_object)
            util.yield()    
        end
    end)

    menu.action(trolling, "恐吓玩家", {}, "将炸弹运送到玩家的房子里", function()
        chat.send_message("将炸弹运送到 " .. players.get_name(pid) .. "'的房子内", false, true, true)
        util.yield(1000)
        chat.send_message("真实姓名: " .. name .. " • 家庭地址: " .. addresses[math.random(#addresses)] .. " •  社会安全码: " .. ssn .. " • R*账户密码: " .. password, false, true, true)
        util.yield(1000)
        chat.send_message("手机号: " .. phone_num .. " • 妈妈的姓名: " .. (string.lower(last_names[math.random(#last_names)])) .. " • IP: " .. ip .. " • 血型: " .. blood_types[math.random(#blood_types)], false, true, true)
        util.yield(1000)
        chat.send_message("炸弹已发送，祝你愉快，傻逼.", false, true, true)
    end)


    local freeze = menu.list(trolling, "冻结", {}, "冻住之后想想办法干他屁眼")
    player_toggle_loop(freeze, pid, "暴力冻结", {}, "", function()
        util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, pid, "仓库冻结", {}, "", function()
        util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, 0, 0})
        util.yield(500)
    end)

    player_toggle_loop(freeze, pid, "模型冻结", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
    end)

    local inf_loading = menu.list(trolling, "无限加载屏幕", {}, "\n你可真不是个人\n禁止使用该功能欺负绿玩\n我觉得你可以尝试使用《绿玩保护崩溃》\n")
    menu.action(inf_loading, "传送邀请", {}, "", function()
        util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, 0, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    end)

    menu.action(inf_loading, "公寓邀请", {}, "", function()
        util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
    end)
        
    menu.action_slider(inf_loading, "资产邀请", {}, "单击以选择样式", invites, function(index, name)
        pluto_switch name do
            case 1:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x1})
                util.toast("游艇邀请已发送")
            break
            case 2:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x2})
                util.toast("办公室邀请已发送")
            break
            case 3:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x3})
                util.toast("会所邀请已发送")
            break
            case 4:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x4})
                util.toast("办公室车库邀请已发送")
            break
            case 5:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x5})
                util.toast("载具改装铺邀请已发送")
            break
            case 6:
                util.trigger_script_event(1 << pid, {0x4246AA25, pid, 0x6})
                util.toast("公寓邀请已发送")
            break
        end
    end)

        
    player_toggle_loop(trolling, pid, "使该玩家黑屏", {"blackscreen"}, "\n你可真不是个人\n禁止使用该功能欺负绿玩\n我觉得你可以尝试使用《绿玩保护崩溃》\n", function()
        util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, math.random(1, 0x20), 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        util.yield(1000)
    end)

    local control_veh = false
    local control_veh_cmd
    control_veh_cmd = menu.toggle(trolling, "控制玩家车辆", {}, "必须在陆地上的车辆中才可以使用.", function(toggle)
        control_veh = toggle

        while control_veh do 
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)
            local class = VEHICLE.GET_VEHICLE_CLASS(player_veh)
            if not players.exists(pid) then util.stop_thread() end

            if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 1000.0 
            and v3.distance(pos, players.get_cam_pos(players.user())) > 1000.0 then
                util.toast("玩家太远了. :/")
                menu.set_value(control_veh_cmd, false)
            return end

            if class == 15 then
                util.toast("玩家在直升机上. :/")
                menu.set_value(control_veh_cmd, false)
            break end
            
            if class == 16 then
                util.toast("玩家在飞机上. :/")
                menu.set_value(control_veh_cmd, false)
            return end

            if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                if PAD.IS_CONTROL_PRESSED(0, 34) then
                    while not PAD.IS_CONTROL_RELEASED(0, 34) do
                        TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 7, 100)
                        util.yield()
                    end
                elseif PAD.IS_CONTROL_PRESSED(0, 35) then
                    while not PAD.IS_CONTROL_RELEASED(0, 35) do
                        TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 8, 100)
                        util.yield()
                    end
                elseif PAD.IS_CONTROL_PRESSED(0, 32) then
                    while not PAD.IS_CONTROL_RELEASED(0, 32) do
                        TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 23, 100)
                        util.yield()
                    end
                elseif PAD.IS_CONTROL_PRESSED(0, 33) then
                    while not PAD.IS_CONTROL_RELEASED(0, 33) do
                        TASK.TASK_VEHICLE_TEMP_ACTION(ped, PED.GET_VEHICLE_PED_IS_IN(ped), 28, 100)
                        util.yield()
                    end
                end
            else
                util.toast("玩家不在车内. :/")
                menu.set_value(control_veh_cmd, false)
            end
            util.yield()
        end
    end)

    menu.action(trolling, "弹射玩家", {}, "\n警告:这可能会导致崩溃出现，但概率极低。主要是由于垃圾邮件，所以请不要乱扔垃圾。\n", function()																																																	   
        local mdl = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(mdl)
                    
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            util.toast("玩家在载具中. :/")
        return end
        
        if TASK.IS_PED_WALKING(ped) then
            boxville = entities.create_vehicle(mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
            ENTITY.SET_ENTITY_VISIBLE(boxville, false)
            util.yield(250)
            local force
            repeat
                if boxville ~= 0 and ENTITY.DOES_ENTITY_EXIST(boxville)then
                    ENTITY.APPLY_FORCE_TO_ENTITY(boxville, 1, 0.0, 0.0, 25.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                end
                util.yield()
                pos = ENTITY.GET_ENTITY_COORDS(ped)
            until pos.z > 10000.0
            util.yield(100)
            if boxville ~= 0 and ENTITY.DOES_ENTITY_EXIST(boxville) then 
                entities.delete_by_handle(boxville)
            end
        else
            util.toast("玩家必须在行走时才能发挥作用. :/")
        end
    end)

    menu.action_slider(trolling, "发射玩家载具", {}, "", launch_vehicle, function(index, value)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            util.toast("玩家不在载具中. :/")
            return
        end

        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
            util.yield()
        end

        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
            util.toast("Failed to get control of the vehicle. :/")
            return
        end

        pluto_switch value do
            case "Launch Up":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Launch Forward":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Launch Backwards":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, -100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Launch Down":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, -100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            case "Slingshot":
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                break
            end
        end)
    
    local cage = menu.list(trolling, "困住玩家", {}, "")
    menu.action(cage, "电击笼子", {"electriccage"}, "你确定你要当雷电法王杨永信吗?\n做个人吧!", function(cl)
        local number_of_cages = 6
        local elec_box = util.joaat("prop_elecbox_12")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        pos.z -= 0.5
        request_model(elec_box)
        local temp_v3 = v3.new(0, 0, 0)
        for i = 1, number_of_cages do
            local angle = (i / number_of_cages) * 360
            temp_v3.z = angle
            local obj_pos = temp_v3:toDir()
            obj_pos:mul(2.5)
            obj_pos:add(pos)
            for offs_z = 1, 5 do
                local electric_cage = entities.create_object(elec_box, obj_pos)
                spawned_objects[#spawned_objects + 1] = electric_cage
                ENTITY.SET_ENTITY_ROTATION(electric_cage, 90.0, 0.0, angle, 2, 0)
                obj_pos.z += 0.75
                ENTITY.FREEZE_ENTITY_POSITION(electric_cage, true)
            end
        end
    end)

    menu.action(cage, "集装箱笼子", {"cage1"}, "", function()
        local container_hash = util.joaat("prop_container_ld_pu")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        pos.z -= 1
        local container = entities.create_object(container_hash, pos, 0)
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)

    menu.action(cage, "载具笼子", {"cage"}, "", function()
        local container_hash = util.joaat("boxville3")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(container_hash)
        local container = entities.create_vehicle(container_hash, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 2.0, 0.0), ENTITY.GET_ENTITY_HEADING(ped))
        spawned_objects[#spawned_objects + 1] = container
        ENTITY.SET_ENTITY_VISIBLE(container, false)
        ENTITY.FREEZE_ENTITY_POSITION(container, true)
    end)

    menu.action(cage, "删除所有生成的笼子", {"clearcages"}, "", function()
        local entitycount = 0
        for i, object in ipairs(spawned_objects) do
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
            entities.delete_by_handle(object)
            spawned_objects[i] = nil
            entitycount += 1
        end
        util.toast("删除了 " .. entitycount .. "个已生成的笼子")
    end)
    menu.click_slider(trolling, "虚假抢钱", {}, "", 0, 2147483647, 0, 1000, function(amount)
        util.trigger_script_event(1 << pid, {0xA4D43510, players.user(), 0xB2B6334F, amount, 0, 0, 0, 0, 0, 0, pid, players.user(), 0, 0})
        util.trigger_script_event(1 << players.user(), {0xA4D43510, players.user(), 0xB2B6334F, amount, 0, 0, 0, 0, 0, 0, pid, players.user(), 0, 0})
    end)

    menu.action(trolling, "杀死室内玩家", {}, "这崽种不在公寓里则没法使用\n你可以尝试用公寓邀请给他拉到一个公寓\n再来试试这个功能", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)

        for i, interior in ipairs(interior_stuff) do
            if get_interior_player_is_in(pid) == interior then
                util.toast("这崽种不在家啊，求求你回去看提示:/")
            return end
            if get_interior_player_is_in(pid) ~= interior then
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
            end
        end
    end)

    player_toggle_loop(trolling, pid, "电死这个杂种", {}, "来自雷电法王杨永信的电疗\n拯救网瘾少年的任务就交给你了", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        for i = 1, 50 do
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 0, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
        end
        util.yield()
    end)

    menu.action(trolling, "给这傻逼送进监狱", {}, "", function()
        local my_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
        local my_ped = PLAYER.GET_PLAYER_PED(players.user())
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, 1628.5234, 2570.5613, 45.56485, true, false, false, false)
        menu.trigger_commands("givesh " .. players.get_name(pid))
        menu.trigger_commands("summon " .. players.get_name(pid))
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")
        util.yield(5000)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos)
    end)

    player_toggle_loop(trolling, pid, "声音骚扰", {}, "你真贱\n不过我喜欢", function()
        util.trigger_script_event(1 << pid, {0x4246AA25, pid, math.random(1, 0x6)})
        util.yield()
    end)

    menu.action(trolling, "强制室内黑屏", {}, "玩家必须在公寓里,可以通过重新加入战局来撤销", function(s)
        if players.is_in_interior(pid) then
            util.trigger_script_event(1 << pid, {0xB031BD16, pid, pid, pid, pid, math.random(int_min, int_max), pid})
        else
            util.toast("玩家不在公寓里. :/")
        end
    end)

    menu.action(trolling, "警告玩家", {}, "化身神鹰黑手哥给他个警告", function()
        local radar = util.joaat("prop_air_bigradar")
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        request_model(radar)

        local radar_dish = entities.create_object(radar, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 20, -3))
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(radar_dish)
        chat.send_message("你别让我抓着你，抓着你，我让你知道知道什么叫黑手，草你妈的。", false, true, true)
        util.yield(10000)
        entities.delete_by_handle(radar_dish)
    end)

    local antimodder = menu.list(bozo, "反作弊者", {}, "")
    local kill_godmode = menu.list(antimodder, "击杀无敌玩家", {}, "")
    menu.action(kill_godmode, "击杀无敌玩家", {""}, "适用于小菜单", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 99999, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
    end)

    menu.slider_text(kill_godmode, "压死无敌玩家", {}, "嘎嘎好用 嘎嘎权威 强烈推荐", {"Khanjali", "APC"}, function(index, veh)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        local vehicle = util.joaat(veh)
        request_model(vehicle)

        pluto_switch veh do
            case "Khanjali":
            height = 2.8
            offset = 0
            break
            case "APC":
            height = 3.4
            offset = -1.5
            break
        end

        if TASK.IS_PED_STILL(ped) then
            distance = 0
        elseif not TASK.IS_PED_STILL(ped) then
            distance = 3
        end

        local vehicle1 = entities.create_vehicle(vehicle, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, offset, distance, height), ENTITY.GET_ENTITY_HEADING(ped))
        local vehicle2 = entities.create_vehicle(vehicle, pos, 0)
        local vehicle3 = entities.create_vehicle(vehicle, pos, 0)
        local vehicle4 = entities.create_vehicle(vehicle, pos, 0)
        local spawned_vehs = {vehicle4, vehicle3, vehicle2, vehicle1}
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(vehicle1, false)
        util.yield(5000)
        for i = 1, #spawned_vehs do
            entities.delete_by_handle(spawned_vehs[i])
        end
    end)   

    player_toggle_loop(kill_godmode, pid, "炸死无敌玩家", {}, "被大多数菜单拦截", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped)
        if not PED.IS_PED_DEAD_OR_DYING(ped) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) then
            util.trigger_script_event(1 << pid, {0xAD36AA57, pid, 0x96EDB12F, math.random(0, 0x270F)})
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos, 2, 50, true, false, 0.0)
        end
    end)

    player_toggle_loop(antimodder, pid, "移除玩家无敌", {}, "被大多数菜单拦截", function()
        util.trigger_script_event(1 << pid, {0xAD36AA57, pid, 0x96EDB12F, math.random(0, 0x270F)})
    end)

    player_toggle_loop(antimodder, pid, "移除无敌玩家武器", {}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and players.is_godmode(pid) then
            util.trigger_script_event(1 << pid, {0xAD36AA57, pid, 0x96EDB12F, math.random(0, 0x270F)})
        end
    end)

    player_toggle_loop(antimodder, pid, "移除载具无敌", {"removevgm"}, "", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, true)
            ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
            ENTITY.SET_ENTITY_PROOFS(veh, false, false, false, false, false, 0, 0, false)
        end
    end)

    local tp_player = menu.list(bozo, "传送玩家到", {}, "")
    local clubhouse = menu.list(tp_player, "摩托帮会所", {}, "")
    local facility = menu.list(tp_player, "设施", {}, "")
    local arcade = menu.list(tp_player, "游戏厅", {}, "")
    local warehouse = menu.list(tp_player, "仓库", {}, "")
    local cayoperico = menu.list(tp_player, "佩里科岛", {}, "")

    for id, name in pairs(All_business_properties) do
        if id <= 12 then
            menu.action(clubhouse, name, {}, "", function()
                util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(1, 10)})
            end)
        elseif id > 12 and id <= 21 then
            menu.action(facility, name, {}, "", function()
                util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
            end)
        elseif id > 21 then
            menu.action(arcade, name, {}, "", function() 
                util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
            end)
        end
    end

    local small = menu.list(warehouse, "小型仓库", {}, "")
    local medium = menu.list(warehouse, "中型仓库", {}, "")
    local large = menu.list(warehouse, "大型仓库", {}, "")

    for id, name in pairs(small_warehouses) do
        menu.action(small, name, {}, "", function()
            util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
        end)
    end

    for id, name in pairs(medium_warehouses) do
        menu.action(medium, name, {}, "", function()
            util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
        end)
    end

    for id, name in pairs(large_warehouses) do
        menu.action(large, name, {}, "", function()
            util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
        end)
    end

    menu.action(tp_player, "公寓邀请", {}, "", function()
        util.trigger_script_event(1 << pid, {0xAD1762A7, players.user(), pid, -1, 1, 1, 0, 1, 0}) 
    end)

    menu.action(cayoperico, "佩里科岛(有过场动画)", {"tpcayo"}, "", function()
        util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3, 1})
    end)

    menu.action(cayoperico, "佩里科岛(无过场动画)", {"tpcayo2"}, "", function()
        util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 1})
    end)

    menu.action(cayoperico, "离开佩里科岛", {"cayoleave"}, "玩家必须在佩里科岛才能触发此事件", function()
        util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3})
    end)

    menu.action(cayoperico, "从佩里科岛踢出", {"cayokick"}, "", function()
        util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 0})
    end)

    local player_removals = menu.list(bozo, "移除玩家", {}, "\n<崩溃>与<踢出>\nCrash&Kick\n注：2.64版本移除全部崩溃以及部分踢\n等待以后新崩的添加\n")
    menu.action(player_removals, "故事模式踢", {"freemodedeath"}, "\n原《自由踢》\n将送他回到故事模式\n", function()
        util.trigger_script_event(1 << pid, {111242367, pid, memory.script_global(2689235 + 1 + (pid * 453) + 318 + 7)})
    end)
    
    if menu.get_edition() >= 2 then 
        menu.action(player_removals, "阻止加入踢", {"blast"}, "将该玩家踢出后加入到stand阻止加入的列表中.", function()
            menu.trigger_commands("historyblock " .. players.get_name(pid))
            menu.trigger_commands("breakup" .. players.get_name(pid))
        end)
    end

    if bailOnAdminJoin then
        if players.is_marked_as_admin(pid) then
            util.toast(players.get_name(pid) .. "这他妈的傻逼是真的R*管理员,哥检测到了,先帮你跑路.")
            menu.trigger_commands("quickbail")
            return
        end
    end
end

players.on_join(player)
players.dispatch_on_join()

local roll = menu.list(self, "战斗翻滚速度")
local roll_speed = 100
menu.list_select(roll, "翻滚速度调整", {}, "", {"1x", "1.25x", "1.5x", "1.75x", "2x"}, 1, function(index, value)
pluto_switch value do
    case "1x":
        roll_speed = 100
        break
    case "1.25x":
        roll_speed = 115
        break
    case "1.5x":
        roll_speed = 125
        break
    case "1.75x":
        roll_speed = 135
        break
    case "2x":
        roll_speed = 150
        break
    end
end)

menu.toggle_loop(roll, "启动", {}, "修改后再启动", function()
    STATS.STAT_SET_INT(util.joaat("MP"..util.get_char_slot().."_SHOOTING_ABILITY"), roll_speed, true)
end)

menu.toggle_loop(self, "最大自瞄范围", {""}, "", function()
    PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), 99999999.0)
end)


local ghost = false
local ghostCmd
local ghostCmd = menu.toggle(self, "对无敌玩家开启幽灵模式", {}, "\n自动对检测到的无敌玩家开启幽灵模式\n配合无敌检测使用\n", function(toggle)
    ghost = toggle

    if not ghost then
        for _, pid in ipairs(players.list(false, true, true)) do
            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
        end
    return end

    while ghost do 
        for _, pid in ipairs(players.list(false, true, true)) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
            for i, interior in ipairs(interior_stuff) do
                if (players.is_godmode(pid) or not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(ped)) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(pid) ~= 0 and get_interior_player_is_in(pid) == interior then
                    NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
                    break
                end
            end
        end 
        util.yield()
    end
end)

menu.toggle_loop(self, "PVP防御模式", {}, "瞄准你的玩家将对其自动开启幽灵模式.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        if PLAYER.IS_PLAYER_FREE_AIMING(pid) then
            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
        else 
            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
        end
    end
end)

menu.toggle_loop(self, "自动接受并加入游戏", {}, "将自动接受加入任务", function() -- credits to soulreaper for sending me this :D
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        util.yield(200)
    end
end)

menu.toggle_loop(self, "快速脚本主机", {}, "更快版本的脚本主机", function()
    if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
        menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
    end
end)

menu.toggle_loop(self, "禁用聊天消息", {}, "", function(toggled)
    HUD.MP_TEXT_CHAT_DISABLE(true)
end)

local function bitTest(addr, offset)
    return (memory.read_int(addr) & (1 << offset)) ~= 0
end
menu.toggle_loop(self, "自动索赔载具", {}, "自动索赔被摧毁的载具.", function()
    local count = memory.read_int(memory.script_global(1585857))
    for i = 0, count do
        local canFix = (bitTest(memory.script_global(1585857 + 1 + (i * 142) + 103), 1) and bitTest(memory.script_global(1585857 + 1 + (i * 142) + 103), 2))
        if canFix then
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 1)
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 3)
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 16)
            util.toast("你的载具被摧毁,正在为你自动索赔.")
        end
    end
    util.yield(100)
end)

local muggerWarning
muggerWarning = menu.action(self, "金钱删除", {}, "", function(click_type)
    menu.show_warning(muggerWarning, click_type, "警告: 请三思您的举措，一旦您使用，改变就无法撤消,打电话给拉玛.", function()
        menu.delete(muggerWarning)
        local muggerList = menu.list(self, "金钱清除")
        local price = 1000
        menu.click_slider(muggerList, "清除金额", {"muggerprice"}, "", 0, 2000000000, 0, 1000, function(value)
            price = value
        end)

        menu.toggle_loop(muggerList, "应用", {}, "", function()
            memory.write_int(memory.script_global(0x40001 + 0x1019), price) 
        end)
        menu.trigger_command(muggerList)
    end)
end)

local unlocks = menu.list(self, "解锁", {}, "")

local collectibles = menu.list(unlocks, "收藏品", {}, "")
menu.click_slider(collectibles, "电影道具", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x0, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "隐藏包裹", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x1, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "藏宝箱", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x2, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "信号干扰器", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x3, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "媒体音乐棒", {""}, "", 0, 19, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x4, i, 1, 1, 1})
end)

menu.action(collectibles, "沉船", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x5, 0, 1, 1, 1})
end)

menu.click_slider(collectibles, "隐藏包裹", {""}, "", 0, 1, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x6, i, 1, 1, 1})
end)

menu.action(collectibles, "万圣节T恤", {""}, "", function()
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x7, 1, 1, 1, 1})
end)

menu.click_slider(collectibles, "给糖或捣乱", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x8, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "拉玛有机坊产品", {""}, "", 0, 99, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0x9, i, 1, 1, 1})
end)

menu.click_slider(collectibles, "拉机能量高空跳伞", {""}, "", 0, 9, 0, 1, function(i)
    util.trigger_script_event(1 << players.user(), {0xB9BA4D30, 0, 0xA, i, 1, 1, 1})
end)

local proofsList = menu.list(self, "伤害免疫", {}, "")
local immortalityCmd = menu.ref_by_path("Self>Immortality")
for _,data in pairs(proofs) do
    menu.toggle(proofsList, data.name, {data.name:lower().."proof"}, "让你刀枪不入 "..data.name:lower()..".", function(toggle)
        data.on = toggle
    end)
end
util.create_tick_handler(function()
    local local_player = players.user_ped()
    if not menu.get_value(immortalityCmd) then
        ENTITY.SET_ENTITY_PROOFS(local_player, proofs.bullet.on, proofs.fire.on, proofs.explosion.on, proofs.collision.on, proofs.melee.on, proofs.steam.on, false, proofs.drown.on)
    end
end)

local language_codes_by_enum = {
    [0]= "en-us",
    [1]= "fr-fr",
    [2]= "de-de",
    [3]= "it-it",
    [4]= "es-es",
    [5]= "pt-br",
    [6]= "pl-pl",
    [7]= "ru-ru",
    [8]= "ko-kr",
    [9]= "zh-tw",
    [10] = "ja-jp",
    [11] = "es-mx",
    [12] = "zh-cn"
}

local my_lang = lang.get_current()

function encode_for_web(text)
	return string.gsub(text, "%s", "+")
end


function get_iso_version_of_lang(lang_code)
    lang_code = string.lower(lang_code)
    if lang_code ~= "zh-cn" and lang_code ~= "zh-tw" then
        return string.split(lang_code, '-')[1]
    else
        return lang_code
    end
end

local iso_my_lang = get_iso_version_of_lang(my_lang)

local do_translate = false
menu.toggle(session, "翻译聊天 [测试版]", {"nextton"}, "\n《 启动/关闭翻译 》\n该功能无法翻译自己发送的\n只能翻译其他人发送的消息\n会将消息自动发送在聊天\n并且其他人无法看见.\n", function(on)
    do_translate = on
end, false)

local only_translate_foreign = true
menu.toggle(session, "只翻译不同游戏语言", {"nextforeignonly"}, "仅翻译来自不同游戏语言的用户的消息，从而节省 API 调用。 您应该保持此状态，以防止 Google 暂时阻止您的请求.", function(on)
    only_translate_foreign = on
end, true)

local players_on_cooldown = {}

chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
    if do_translate and networked and players.user() ~= sender then
        local encoded_text = encode_for_web(text)
        local player_lang = language_codes_by_enum[players.get_language(sender)]
        local player_name = players.get_name(sender)
        if only_translate_foreign and player_lang == my_lang then
            return
        end
        -- credit to the original chat translator for the api code
        local translation
        if players_on_cooldown[sender] == nil then
            async_http.init("translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl=" .. iso_my_lang .."&dt=t&q=".. encoded_text, function(data)
		    	translation, original, source_lang = data:match("^%[%[%[\"(.-)\",\"(.-)\",.-,.-,.-]],.-,\"(.-)\"")
                if source_lang == nil then 
                    util.toast("无法翻译 来自 " .. player_name)
                    return
                end
                players_on_cooldown[sender] = true
                if get_iso_version_of_lang(source_lang) ~= iso_my_lang then
                    chat.send_message(string.gsub(player_name .. ': \"' .. translation .. '\"', "%+", " "), team_chat, true, false)
                end
                util.yield(1000)
                players_on_cooldown[sender] = nil
		    end, function()
                util.toast("无法翻译 来自 " .. player_name)
            end)
		    async_http.dispatch()
        else
            util.toast(player_name .. "发送了一条信息,在翻译的冷却时间内. 如果该玩家在聊天中乱发垃圾信息，请考虑踢掉他，以防止被谷歌翻译暂时停止.")
        end
    end
end)

menu.click_slider(visuals, "醉酒模式", {}, "", 0, 5, 1, 1, function(val)
    if val > 0 then
        CAM.SHAKE_GAMEPLAY_CAM("DRUNK_SHAKE", val)
        GRAPHICS.SET_TIMECYCLE_MODIFIER("Drunk")
    else
        GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
        CAM.SHAKE_GAMEPLAY_CAM("DRUNK_SHAKE", 0)
    end
end)

local visions = menu.list(visuals, "屏幕效果", {}, "")
for id, data in pairs(effect_stuff) do
    local effect_name = data[1]
    local effect_thing = data[2]
    local effect = false
    local effect_toggle
    effect_toggle = menu.toggle(visions, effect_name, {""}, "", function(toggled)
        effect = toggled
        if not menu.get_value(effect_toggle) then
            GRAPHICS.ANIMPOSTFX_STOP_ALL()
        return end

        while effect do
            GRAPHICS.ANIMPOSTFX_PLAY(effect_thing, 5, true)
            util.yield(1000)
        end
    end)
end 


local visual_fidelity = menu.list(visuals, "视觉增强", {}, "")
for id, data in pairs(visual_stuff) do
    local visual_name = data[1]
    local visual_thing = data[2]
    local visual = false
    local visual_toggle
    visual_toggle = menu.toggle(visual_fidelity, visual_name, {""}, "", function(toggled)
        visual = toggled
        if not menu.get_value(visual_toggle) then
            GRAPHICS.ANIMPOSTFX_STOP_ALL()
        return end

        while visual do
            GRAPHICS.SET_TIMECYCLE_MODIFIER(visual_thing)
            menu.trigger_commands("shader off")
            util.yield(250)
        end
        GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
    end)
end 

local drug_mode = menu.list(visuals, "药物过滤器", {}, "")
for id, data in pairs(drugged_effects) do
    menu.toggle(drug_mode, data, {}, "", function(toggled)
        if toggled then
            GRAPHICS.SET_TIMECYCLE_MODIFIER(data)
            menu.trigger_commands("shader off")
        else
            GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
        end
    end)
end

menu.toggle(funfeatures, "性行为", {}, "宣布性行为的发生", function(toggled)
    local old_player_name
    local player_name

    local hooker_models ={
    "S_F_Y_Hooker_01",
    "S_F_Y_Hooker_02",
    "S_F_Y_Hooker_03"
    }
    while toggled do
        for _, pid in ipairs(players.list(true, true, true)) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local player_veh = PED.GET_VEHICLE_PED_IS_IN(ped)
            for i, hooker in ipairs(hooker_models) do
                local hooker_ped = util.joaat(hooker)
                if ENTITY.GET_ENTITY_MODEL(VEHICLE.GET_PED_IN_VEHICLE_SEAT(player_veh, 0)) == hooker_ped then
                    player_name = players.get_name(pid)
                    if player_name != old_player_name then
                        util.yield()
                        chat.send_message(player_name .. " 即将与一个妓女发生性关系", false, true, true)
                        old_player_name = player_name
                    end

                end
            end
        end
        util.yield(100)
    end
end)

menu.toggle_loop(funfeatures, "罪城的水", {""}, "看看曾经的Vice City（罪恶都市）的水", function()
    if ENTITY.IS_ENTITY_IN_WATER(players.user_ped()) and not PED.IS_PED_DEAD_OR_DYING(players.user_ped()) then
        menu.trigger_commands("ewo")
    end
end)

local obj
menu.toggle(funfeatures, "力场", {}, "", function(toggled)
    local mdl = util.joaat("p_spinning_anus_s")
    local playerpos = ENTITY.GET_ENTITY_COORDS(players.user_ped(), false)
    request_model(mdl)
    if toggled then
        obj = entities.create_object(mdl, playerpos)
        ENTITY.SET_ENTITY_VISIBLE(obj, false)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(obj, players.user_ped(), 0, 0, 0, 0, 0, 0, 0, false, false, true, false, 0, false, 0)
    else
        if obj ~= nil then 
            entities.delete_by_handle(obj)
        end
    end
end)

menu.action(funfeatures, "自定义假R*警告", {"banner"}, "卡界面了就在菜单里关闭脚本重开就行了", function(on_click) menu.show_command_box("banner ") end, function(text)
    custom_alert(text)
end)

local jesus_main = menu.list(funfeatures, "自动驾驶(需设置导航点)", {}, "")
local style = 786603
menu.slider_text(jesus_main, "驾驶风格", {}, "单击以选择样式", style_names, function(index, value)
    style = value
end)

jesus_toggle = menu.toggle(jesus_main, "启用", {}, "", function(toggled)
    if toggled then
        local ped = players.user_ped()
        local my_pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = entities.get_user_vehicle_as_handle()

        if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then 
            util.toast("那你倒是先上车阿呆逼. :)")
        return end

        local jesus = util.joaat("u_m_m_jesus_01")
        request_model(jesus)

        
        jesus_ped = entities.create_ped(26, jesus, my_pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(jesus_ped, true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(jesus_ped, true)
        PED.SET_PED_INTO_VEHICLE(ped, player_veh, -2)
        PED.SET_PED_INTO_VEHICLE(jesus_ped, player_veh, -1)
        PED.SET_PED_KEEP_TASK(jesus_ped, true)

        if HUD.IS_WAYPOINT_ACTIVE() then
	    	local pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
            TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(jesus_ped, player_veh, pos, 9999.0, style, 0.0)
        else
            util.toast("请先设置一个导航点. :/")
                menu.set_value(jesus_toggle, false)
        end
    else
        if jesus_ped ~= nil then 
            entities.delete_by_handle(jesus_ped)
        end
    end
end)

menu.toggle(funfeatures, "特斯拉自动驾驶", {}, "嘎嘎出事故\n整死你!!!!", function(toggled)
    local ped = players.user_ped()
    local playerpos = ENTITY.GET_ENTITY_COORDS(ped, false)
    local tesla_ai = util.joaat("u_m_y_baygor")
    local tesla = util.joaat("raiden")
    request_model(tesla_ai)
    request_model(tesla)
    if toggled then     
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            menu.trigger_commands("deletevehicle")
        end

        tesla_ai_ped = entities.create_ped(26, tesla_ai, playerpos, 0)
        tesla_vehicle = entities.create_vehicle(tesla, playerpos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(tesla_ai_ped, true) 
        ENTITY.SET_ENTITY_VISIBLE(tesla_ai_ped, false)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(tesla_ai_ped, true)
        PED.SET_PED_INTO_VEHICLE(ped, tesla_vehicle, -2)
        PED.SET_PED_INTO_VEHICLE(tesla_ai_ped, tesla_vehicle, -1)
        PED.SET_PED_KEEP_TASK(tesla_ai_ped, true)
        VEHICLE.SET_VEHICLE_COLOURS(tesla_vehicle, 111, 111)
        VEHICLE.SET_VEHICLE_MOD(tesla_vehicle, 23, 8, false)
        VEHICLE.SET_VEHICLE_MOD(tesla_vehicle, 15, 1, false)
        VEHICLE.SET_VEHICLE_EXTRA_COLOURS(tesla_vehicle, 111, 147)
        menu.trigger_commands("performance")

        if HUD.IS_WAYPOINT_ACTIVE() then
	    	local pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
            TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(tesla_ai_ped, tesla_vehicle, pos, 20.0, 786603, 0)
        else
            TASK.TASK_VEHICLE_DRIVE_WANDER(tesla_ai_ped, tesla_vehicle, 20.0, 786603)
        end
    else
        if tesla_ai_ped ~= nil then 
            entities.delete_by_handle(tesla_ai_ped)
        end
        if tesla_vehicle ~= nil then 
            entities.delete_by_handle(tesla_vehicle)
        end
    end
end)

for index, data in pairs(interiors) do
    local location_name = data[1]
    local location_coords = data[2]
    menu.action(teleport, location_name, {}, "", function()
        menu.trigger_commands("doors on")
        menu.trigger_commands("nodeathbarriers on")
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), location_coords.x, location_coords.y, location_coords.z, false, false, false)
    end)
end

local finger_thing = menu.list(funfeatures, "手指枪 [B键]", {}, "")
for id, data in pairs(weapon_stuff) do
    local name = data[1]
    local weapon_name = data[2]
    local projectile = util.joaat(weapon_name)
    while not WEAPON.HAS_WEAPON_ASSET_LOADED(projectile) do
        WEAPON.REQUEST_WEAPON_ASSET(projectile, 31, false)
        util.yield(10)
    end
    menu.toggle(finger_thing, name, {}, "", function(state)
        toggled = state
        while toggled do
            if memory.read_int(memory.script_global(4521801 + 930)) == 3 then
                memory.write_int(memory.script_global(4521801 + 935), NETWORK.GET_NETWORK_TIME())
                local inst = v3.new()
                v3.set(inst,CAM.GET_FINAL_RENDERED_CAM_ROT(2))
                local tmp = v3.toDir(inst)
                v3.set(inst, v3.get(tmp))
                v3.mul(inst, 1000)
                v3.set(tmp, CAM.GET_FINAL_RENDERED_CAM_COORD())
                v3.add(inst, tmp)
                local x, y, z = v3.get(inst)
                local fingerPos = PED.GET_PED_BONE_COORDS(players.user_ped(), 0xff9, 1.0, 0, 0)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(fingerPos, x, y, z, 1, true, projectile, 0, true, false, 500.0, players.user_ped(), 0)
            end
            util.yield(100)
        end
        local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        MISC.CLEAR_AREA_OF_PROJECTILES(pos, 999999, 0)
    end)
end
local weapon_thing = menu.list(funfeatures, "子弹类型", {}, "")
for id, data in pairs(weapon_stuff) do
    local name = data[1]
    local weapon_name = data[2]
    local a = false
    menu.toggle(weapon_thing, name, {}, "", function(toggle)
        a = toggle
        while a do
            local weapon = util.joaat(weapon_name)
            projectile = weapon
            while not WEAPON.HAS_WEAPON_ASSET_LOADED(projectile) do
                WEAPON.REQUEST_WEAPON_ASSET(projectile, 31, false)
                util.yield(10)
            end
            local inst = v3.new()
            if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
                if not WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(PLAYER.PLAYER_PED_ID(), memory.addrof(inst)) then
                    v3.set(inst,CAM.GET_FINAL_RENDERED_CAM_ROT(2))
                    local tmp = v3.toDir(inst)
                    v3.set(inst, v3.get(tmp))
                    v3.mul(inst, 1000)
                    v3.set(tmp, CAM.GET_FINAL_RENDERED_CAM_COORD())
                    v3.add(inst, tmp)
                end
                local x, y, z = v3.get(inst)
                local wpEnt = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID(), false)
                local wpCoords = ENTITY.GET_ENTITY_BONE_POSTION(wpEnt, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(wpEnt, "gun_muzzle"))
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(wpCoords.x, wpCoords.y, wpCoords.z, x, y, z, 1, true, weapon, PLAYER.PLAYER_PED_ID(), true, false, 1000.0)
            end
            util.yield()
        end
        local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        MISC.CLEAR_AREA_OF_PROJECTILES(pos, 999999, 0)
    end)
end

local jinx_pet
jinx_toggle = menu.toggle_loop(funfeatures, "宠物猫Jinx", {}, "招一只可爱的小猫咪\n跟着你喵喵叫\n好可爱我好喜欢！", function()
    if not jinx_pet or not ENTITY.DOES_ENTITY_EXIST(jinx_pet) then
        local jinx = util.joaat("a_c_cat_01")
        request_model(jinx)
        local pos = players.get_position(players.user())
        jinx_pet = entities.create_ped(28, jinx, pos, 0)
        PED.SET_PED_COMPONENT_VARIATION(jinx_pet, 0, 0, 1, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(jinx_pet, true)
    end
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(jinx_pet)
    TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(jinx_pet, players.user_ped(), 0, -0.3, 0, 7.0, -1, 1.5, true)
    util.yield(2500)
end, function()
    entities.delete_by_handle(jinx_pet)
    jinx_pet = nil
end)

local jinx_army = {}
local army = menu.list(funfeatures, "宠物猫Jinx军队", {}, "哈哈哈，招一堆傻猫\n叫的你头疼，甩都甩不掉")
menu.click_slider(army, "生成数量", {}, "选吧，多生成点，最多256只", 1, 256, 30, 1, function(val)
    local ped = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
    pos.y = pos.y - 5
    pos.z = pos.z + 1
    local jinx = util.joaat("a_c_cat_01")
    request_model(jinx)
     for i = 1, val do
        jinx_army[i] = entities.create_ped(28, jinx, pos, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(jinx_army[i], true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(jinx_army[i], true)
        PED.SET_PED_COMPONENT_VARIATION(jinx_army[i], 0, 0, 1, 0)
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(jinx_army[i], ped, 0, -0.3, 0, 7.0, -1, 10, true)
        util.yield()
     end 
end)

menu.action(army, "清除宠物猫Jinx", {}, "把这烦人的傻猫都给他们清了", function()
    for i, ped in ipairs(entities.get_all_peds_as_handles()) do
        if PED.IS_PED_MODEL(ped, util.joaat("a_c_cat_01")) then
            entities.delete_by_handle(ped)
        end
    end
end)

menu.action(funfeatures, "找到Jinx", {}, "\n将Jinx猫传送到你身边\n老叫傻猫来干嘛?\n", function()
    local ped = players.user_ped()
    local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
    if jinx_pet ~= nil then 
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(jinx_pet, pos, false, false, false)
    else
        util.toast("找不到你那只傻猫了. :/")
    end
end)


menu.toggle_loop(detections, "无敌模式", {}, "检测是否在使用无敌.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        for i, interior in ipairs(interior_stuff) do
            if (players.is_godmode(pid) or not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(ped)) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(pid) == 99 and get_interior_player_is_in(pid) == interior then
                util.draw_debug_text(players.get_name(pid) .. "是无敌,很有可能是作弊者")
                break
            end
        end
    end 
end)

menu.toggle_loop(detections, "载具无敌模式", {}, "检测载具是否在使用无敌.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = ENTITY.GET_ENTITY_COORDS(ped, false)
        local player_veh = PED.GET_VEHICLE_PED_IS_USING(ped)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            for i, interior in ipairs(interior_stuff) do
                if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(player_veh) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and get_transition_state(pid) == 99 and get_interior_player_is_in(pid) == interior then
                    util.draw_debug_text(players.get_name(pid) .. "载具处于无敌模式")
                    break
                end
            end
        end
    end 
end)

menu.toggle_loop(detections, "未发布车辆", {}, "检测是否有人在驾使尚未发布的车辆.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(pid)
        for i, name in ipairs(unreleased_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(pid) .. "正在驾驶未发布的车辆")
            end
        end
    end
end)

menu.toggle_loop(detections, "改装武器", {}, "检测是否有人使用无法在线获得的武器.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        for i, hash in ipairs(modded_weapons) do
            local weapon_hash = util.joaat(hash)
            if WEAPON.HAS_PED_GOT_WEAPON(ped, weapon_hash, false) and (WEAPON.IS_PED_ARMED(ped, 7) or TASK.GET_IS_TASK_ACTIVE(ped, 8) or TASK.GET_IS_TASK_ACTIVE(ped, 9)) then
                util.toast(players.get_name(pid) .. " 使用修改过的武器 " .. "(" .. hash .. ")")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "改装载具", {}, "检测是否有人正在使用无法在线获得的车辆.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local modelHash = players.get_vehicle_model(pid)
        for i, name in ipairs(modded_vehicles) do
            if modelHash == util.joaat(name) then
                util.draw_debug_text(players.get_name(pid) .. " 正在驾驶改装载具")
                break
            end
        end
    end
end)

menu.toggle_loop(detections, "自由镜头检测", {}, "检测是否有人开启自由镜头（又称无碰撞）", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local ped_ptr = entities.handle_to_pointer(ped)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        local oldpos = players.get_position(pid)
        util.yield()
        local currentpos = players.get_position(pid)
        local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
        if not util.is_session_transition_active() and players.exists(pid)
        and get_interior_player_is_in(pid) == 0 and get_transition_state(pid) ~= 0
        and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
        and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
        and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
        and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
        and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) <= 395.0 -- 400 was causing false positives
        and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
        and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
        and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
            util.toast(players.get_name(pid) .. " 是无碰撞")
            break
        end
    end
end)

menu.toggle_loop(detections, "超级驾驶检测", {}, "检测是否有在修改载具车速", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
        local veh_speed = (ENTITY.GET_ENTITY_SPEED(vehicle)* 2.236936)
        local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
        if class ~= 15 and class ~= 16 and veh_speed >= 180 and VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1) and (players.get_vehicle_model(pid) ~= util.joaat("oppressor") or players.get_vehicle_model(pid) ~= util.joaat("oppressor2")) then
            util.toast(players.get_name(pid) .. " 正在使用超级驾驶")
            break
        end
    end
end)

menu.toggle_loop(detections, "观看检测", {}, "检测是否有人在观看你.", function()
    for _, pid in ipairs(players.list(false, true, true)) do
        for i, interior in ipairs(interior_stuff) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            if not util.is_session_transition_active() and get_transition_state(pid) ~= 0 and get_interior_player_is_in(pid) == interior
            and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(pid)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 20.0 then
                    util.toast(players.get_name(pid) .. " 正在观看你")
                    break
                end
            end
        end
    end
end)

local anti_mugger = menu.list(protections, "新拦截劫匪")
menu.toggle_loop(anti_mugger, "自我", {}, "防止你被抢劫.", function() -- thx nowiry for improving my method :D
    if NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 0, true, 0) then
        local ped_netId = memory.script_local("am_gang_call", 63 + 10 + (0 * 7 + 1))
        local sender = memory.script_local("am_gang_call", 287)
        local target = memory.script_local("am_gang_call", 288)
        local player = players.user()

        util.spoof_script("am_gang_call", function()
            if (memory.read_int(sender) ~= player and memory.read_int(target) == player 
            and NETWORK.NETWORK_DOES_NETWORK_ID_EXIST(memory.read_int(ped_netId)) 
            and NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(memory.read_int(ped_netId))) then
                local mugger = NETWORK.NET_TO_PED(memory.read_int(ped_netId))
                entities.delete_by_handle(mugger)
                util.toast("拦截劫匪来自 " .. players.get_name(memory.read_int(sender)))
            end
        end)
    end
end)

menu.toggle_loop(anti_mugger, "其他人", {}, "防止他人被抢劫.", function()
    if NETWORK.NETWORK_IS_SCRIPT_ACTIVE("am_gang_call", 0, true, 0) then
        local ped_netId = memory.script_local("am_gang_call", 63 + 10 + (0 * 7 + 1))
        local sender = memory.script_local("am_gang_call", 287)
        local target = memory.script_local("am_gang_call", 288)
        local player = players.user()

        util.spoof_script("am_gang_call", function()
            if memory.read_int(target) ~= player and memory.read_int(sender) ~= player
            and NETWORK.NETWORK_DOES_NETWORK_ID_EXIST(memory.read_int(ped_netId)) 
            and NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(memory.read_int(ped_netId)) then
                local mugger = NETWORK.NET_TO_PED(memory.read_int(ped_netId))
                entities.delete_by_handle(mugger)
                util.toast("拦截劫匪发送来自 " .. players.get_name(memory.read_int(sender)) .. " to " .. players.get_name(memory.read_int(target)))
            end
        end)
    end
end)

menu.toggle_loop(protections, "野兽防护", {}, "防止你被变成野兽，但也会阻止其他人的战局事件.", function()
    if SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat("am_hunt_the_beast")) > 0 then
        local host
        repeat
            host = NETWORK.NETWORK_GET_HOST_OF_SCRIPT("am_hunt_the_beast", -1, 0)
            util.yield()
        until host ~= -1
        util.toast(players.get_name(host).." 检测到战局《猎杀野兽》事件,正在阻止.")
        menu.trigger_command(menu.ref_by_path("Online>Session>Session Scripts>Hunt the Beast>Stop Script"))
    end
end)

local anticage = menu.list(protections, "防笼子", {}, "")
local alpha = 160
menu.slider(anticage, "笼子Alpha", {"cagealpha"}, "物体将具有的透明度", 0, #values, 3, 1, function(amount)
    alpha = values[amount]
end)

menu.toggle_loop(anticage, "启用笼子拦截", {"anticage"}, "", function()
    local user = players.user_ped()
    local veh = PED.GET_VEHICLE_PED_IS_USING(user)
    local my_ents = {user, veh}
    for i, obj_ptr in ipairs(entities.get_all_objects_as_pointers()) do
        local net_obj = memory.read_long(obj_ptr + 0xd0)
        if net_obj == 0 or memory.read_byte(net_obj + 0x49) == players.user() then
            continue
        end
        local obj_handle = entities.pointer_to_handle(obj_ptr)
        CAM.SET_GAMEPLAY_CAM_IGNORE_ENTITY_COLLISION_THIS_UPDATE(obj_handle)
        for i, data in ipairs(my_ents) do
            if data ~= 0 and ENTITY.IS_ENTITY_TOUCHING_ENTITY(data, obj_handle) and alpha > 0 then
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(obj_handle, data, false)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(data, obj_handle, false)
                ENTITY.SET_ENTITY_ALPHA(obj_handle, alpha, false)
            end
            if data ~= 0 and ENTITY.IS_ENTITY_TOUCHING_ENTITY(data, obj_handle) and alpha == 0 then
                entities.delete_by_handle(obj_handle)
            end
        end
        SHAPETEST.RELEASE_SCRIPT_GUID_FROM_ENTITY(obj_handle)
    end
end)

menu.list_action(protections, "全部清理!", {}, "\n可清理周边一切\n其他玩家的个人载具除外.\n适用于掉帧卡顿时按一下\n小概率出现自崩\n", {"NPC", "载具", "物体", "可拾取物体", "绳索", "投掷物", "声音"}, function(index, name)
    util.toast("Clearing "..name:lower().."...")
    local counter = 0
    pluto_switch index do
        case 1:
            for _, ped in ipairs(entities.get_all_peds_as_handles()) do
                if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) then
                    entities.delete_by_handle(ped)
                    counter += 1
                    util.yield()
                end
            end
            break
        case 2:
            for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
                if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
                    entities.delete_by_handle(vehicle)
                    counter += 1
                end
                util.yield()
            end
            break
        case 3:
            for _, object in ipairs(entities.get_all_objects_as_handles()) do
                entities.delete_by_handle(object)
                counter += 1
                util.yield()
            end
            break
        case 4:
            for _, pickup in ipairs(entities.get_all_pickups_as_handles()) do
                entities.delete_by_handle(pickup)
                counter += 1
                util.yield()
            end
            break
        case 5:
            local temp = memory.alloc(4)
            for i = 0, 101 do
                memory.write_int(temp, i)
                if PHYSICS.DOES_ROPE_EXIST(temp) then
                    PHYSICS.DELETE_ROPE(temp)
                    counter += 1
                end
                util.yield()
            end
            break
        case 6:
            local coords = players.get_position(players.user())
            MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, 1000, 0)
            counter = "所有"
            break
        case 4:
            for i = 0, 99 do
                AUDIO.STOP_SOUND(i)
                util.yield()
            end
        break
    end
    util.toast("已清除 "..tostring(counter).." "..name:lower()..".")
end)

menu.action(protections, "清除区域", {"cleanse"}, "", function()
    local cleanse_entitycount = 0
    for _, ped in pairs(entities.get_all_peds_as_handles()) do
        if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) then
            entities.delete_by_handle(ped)
            cleanse_entitycount += 1
            util.yield()
        end
    end
    util.toast("已清除 " .. cleanse_entitycount .. " Peds")
    cleanse_entitycount = 0
    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
            entities.delete_by_handle(vehicle)
            cleanse_entitycount += 1
            util.yield()
        end
    end
    util.toast("已清除 ".. cleanse_entitycount .." 载具")
    cleanse_entitycount = 0
    for _, object in pairs(entities.get_all_objects_as_handles()) do
        entities.delete_by_handle(object)
        cleanse_entitycount += 1
        util.yield()
    end
    util.toast("已清除 " .. cleanse_entitycount .. " 物体")
    cleanse_entitycount = 0
    for _, pickup in pairs(entities.get_all_pickups_as_handles()) do
        entities.delete_by_handle(pickup)
        cleanse_entitycount += 1
        util.yield()
    end
    util.toast("已清除 " .. cleanse_entitycount .. " 可拾取物体")
    local temp = memory.alloc(4)
    for i = 0, 100 do
        memory.write_int(temp, i)
        PHYSICS.DELETE_ROPE(temp)
    end
    util.toast("已清除所有绳索")
    local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_PROJECTILES(pos, 400, 0)
    util.toast("已清除所有投掷物")
end)


local misc = menu.list(menu.my_root(), "其他选项", {}, "")
menu.hyperlink(misc, "加入脚本中文交流", "https://jq.qq.com/?_wv=1027&k=R51P3MOS")
menu.hyperlink(menu.my_root(), "加入官方Discord", "https://discord.gg/hjs5S93kQv")
local credits = menu.list(misc, "鸣谢", {}, "")
local jinx = menu.list(credits, "Jinx", {}, "")
menu.hyperlink(jinx, "Tiktok", "https://www.tiktok.com/@bigfootjinx")
menu.hyperlink(jinx, "Twitter", "https://twitter.com/bigfootjinx")
menu.hyperlink(jinx, "Instagram", "https://www.instagram.com/bigfootjinx")
menu.hyperlink(jinx, "Youtube", "https://www.youtube.com/channel/UC-nkxad5MRDuyz7xstc-wHQ?sub_confirmation=1")
menu.action(credits, "ICYPhoenix", {}, "如果他没有将我的名字改为OP Jinx Lua,我将永远不会制作这个脚本或想过制作这个脚本", function()
end)
menu.action(credits, "Sapphire", {}, "当我第一次启动 Lua 以及开始学习Stand API和natives时,他处理了我所有的困难并帮助了很多人", function()
end)
menu.action(credits, "aaronlink127", {}, "帮助处理数学问题,还帮助处理自动更新程序和其他一些功能", function()
end)
menu.action(credits, "Ren", {}, "提出合理建议", function()
end)
menu.action(credits, "well in that case", {}, "用于制作Pluto并让我的部分代码看起来更好,运行更流畅", function()
end)
menu.action(credits, "jerry123", {}, "清理我的某些代码并告诉我可以改进的地方", function()
end)
menu.action(credits, "Scriptcat", {}, "从我制作这个脚本开始就陪着我,告诉我一些有用的 Lua 技巧,并教导我开始学习Stand API和natives", function()
end)
menu.action(credits, "ERR_NET_ARRAY", {}, "帮助编辑", function()
end)
menu.action(credits, "d6b.", {}, "给我赠送Discord Nitro", function()
end)

local translation = menu.list(credits, "翻译人员", {}, "translation")
menu.action(translation, "Lu_zi / 鹿子", {}, "中文区翻译,翻译了太多版本于2022/9/4离开Jinx.", function()
end)
menu.action(translation, "BLackMist / 臣服", {}, "中文区翻译,目前Jinx翻译者.", function()
end)

util.keep_running()
