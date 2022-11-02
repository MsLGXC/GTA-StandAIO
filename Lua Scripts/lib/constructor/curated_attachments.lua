-- Curated Attachments
-- v1.3

return {
    {
        name = "Objects",
        is_folder = true,
        items = {
            {
                name = "Lights",
                is_folder = true,
                items = {
                    {
                        name = "Red Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10a",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },
                    {
                        name = "Blue Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },
                    {
                        name = "Yellow Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10c",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                    },

                    {
                        name = "Combo Red+Blue Spinning Light",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                            {
                                model = "prop_wall_light_10a",
                                offset = { x = 0, y = 0.01, z = 0 },
                                rotation = { x = 0, y = 0, z = 180 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                        },
                        --reflection = {
                        --    model = "hei_prop_wall_light_10a_cr",
                        --    reflection_axis = { x = true, y = false, z = false },
                        --    options = { is_light_disabled = true },
                        --    children = {
                        --        {
                        --            model = "prop_wall_light_10a",
                        --            offset = { x = 0, y = 0.01, z = 0 },
                        --            rotation = { x = 0, y = 0, z = 180 },
                        --            options = { is_light_disabled = false },
                        --            bone_index = 1,
                        --        },
                        --    },
                        --}
                    },

                    {
                        name = "Pair of Spinning Lights",
                        model = "hei_prop_wall_light_10a_cr",
                        offset = { x = 0.3, y = 0, z = 1 },
                        rotation = { x = 180, y = 0, z = 0 },
                        options = {
                            is_light_disabled = true,
                            has_collision = false,
                        },
                        children = {
                            {
                                model = "prop_wall_light_10b",
                                offset = { x = 0, y = 0.01, z = 0 },
                                options = {
                                    is_light_disabled = false,
                                    bone_index = 1,
                                    has_collision = false,
                                },
                            },
                            {
                                model = "hei_prop_wall_light_10a_cr",
                                reflection_axis = { x = true, y = false, z = false },
                                options = {
                                    is_light_disabled = true,
                                    has_collision = false,
                                },
                                children = {
                                    {
                                        model = "prop_wall_light_10a",
                                        offset = { x = 0, y = 0.01, z = 0 },
                                        rotation = { x = 0, y = 0, z = 180 },
                                        options = {
                                            is_light_disabled = false,
                                            bone_index = 1,
                                            has_collision = false,
                                        },
                                    },
                                },
                            }
                        },
                    },

                    {
                        name = "Short Spinning Red Light",
                        model = "hei_prop_wall_alarm_on",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = -90, y = 0, z = 0 },
                    },
                    {
                        name = "Small Red Warning Light",
                        model = "prop_warninglight_01",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Blue Recessed Light",
                        model = "h4_prop_battle_lights_floorblue",
                        offset = { x = 0, y = 0, z = 0.75 },
                    },
                    {
                        name = "Red Recessed Light",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0, y = 0, z = 0.75 },
                    },
                    {
                        name = "Red/Blue Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                reflection_axis = { x = true, y = false, z = false },
                            }
                        }
                    },
                    {
                        name = "Blue/Red Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorblue",
                        offset = { x = 0.3, y = 0, z = 1 },
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorred",
                                reflection_axis = { x = true, y = false, z = false },
                            }
                        }
                    },

                    -- Flashing is still kinda wonky for networking
                    {
                        name = "Flashing Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        flash_start_on = false,
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                reflection_axis = { x = true, y = false, z = false },
                                flash_start_on = true,
                            }
                        }
                    },
                    {
                        name = "Alternating Pair of Recessed Lights",
                        model = "h4_prop_battle_lights_floorred",
                        offset = { x = 0.3, y = 0, z = 1 },
                        flash_start_on = true,
                        children = {
                            {
                                model = "h4_prop_battle_lights_floorred",
                                reflection_axis = { x = true, y = false, z = false },
                                flash_start_on = false,
                                children = {
                                    {
                                        model = "h4_prop_battle_lights_floorblue",
                                        flash_start_on = true,
                                    }
                                }
                            },
                            {
                                model = "h4_prop_battle_lights_floorblue",
                                flash_start_on = true,
                            }
                        }
                    },

                    {
                        name = "Red Disc Light",
                        model = "prop_runlight_r",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Blue Disc Light",
                        model = "prop_runlight_b",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Blue Pole Light",
                        model = "prop_air_lights_02a",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Red Pole Light",
                        model = "prop_air_lights_02b",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Red Angled Light",
                        model = "prop_air_lights_04a",
                        offset = { x = 0, y = 0, z = 1 },
                    },
                    {
                        name = "Blue Angled Light",
                        model = "prop_air_lights_05a",
                        offset = { x = 0, y = 0, z = 1 },
                    },

                    {
                        name = "Cone Light",
                        model = "prop_air_conelight",
                        offset = { x = 0, y = 0, z = 1 },
                        rotation = { x = 0, y = 0, z = 0 },
                    },

                    -- This is actually 2 lights, spaced 20 feet apart.
                    --{
                    --    name="Blinking Red Light",
                    --    model="hei_prop_carrier_docklight_01",
                    --}
                },
            },
            {
                name = "Police",
                is_folder = true,
                items = {
                    {
                        name = "Riot Shield",
                        model = "prop_riot_shield",
                        rotation = { x = 180, y = 180, z = 0 },
                    },
                    {
                        name = "Ballistic Shield",
                        model = "prop_ballistic_shield",
                        rotation = { x = 180, y = 180, z = 0 },
                    },
                    {
                        name = "Minigun",
                        model = "prop_minigun_01",
                        rotation = { x = 0, y = 0, z = 90 },
                    },
                    {
                        name = "Monitor Screen",
                        model = "hei_prop_hei_monitor_police_01",
                    },
                    {
                        name = "Bomb",
                        model = "prop_ld_bomb_anim",
                    },
                    {
                        name = "Bomb (open)",
                        model = "prop_ld_bomb_01_open",
                    },
                },
            },
            {
                name = "Vehicle Objects",
                is_folder = true,
                items = {
                    {
                        name = "Aircraft Carrier",
                        model = "prop_temp_carrier"
                    },
                    {
                        name = "Commercial Jet",
                        model = "p_med_jet_01_s"
                    },
                    {
                        name = "Military Jet",
                        model = "hei_prop_carrier_jet"
                    },
                    {
                        name = "Tugboat",
                        model = "hei_prop_heist_tug"
                    },
                    {
                        name = "UFO",
                        model = "imp_prop_ship_01a"
                    },
                    {
                        name = "Yacht",
                        model = "apa_mp_apa_yacht"
                    },
                }
            },
            {
                name = "Animated Objects",
                is_folder = true,
                items = {
                    {
                        name = "Radar Dish",
                        model = "hei_prop_carrier_radar_1_l1"
                    },
                    {
                        name = "UFO",
                        model = "p_spinning_anus_s"
                    },
                    {
                        name = "Wacky Arm Waving Inflatable Tube Man",
                        model = "prop_airdancer_2_cloth"
                    },
                }
            },
            items = {
                name = "Fun",
                is_folder = true,
                items = {
                    {
                        name = "ATM",
                        model = "prop_atm_01"
                    },
                    {
                        name = "Bomb",
                        model = "imp_prop_bomb_ball"
                    },
                    {
                        name = "Car wheel",
                        model = "imp_prop_impexp_tyre_01c"
                    },
                    {
                        name = "Ferris wheel",
                        model = "p_ferris_wheel_amo_l"
                    },
                    {
                        name = "Guitar",
                        model = "prop_acc_guitar_01"
                    },
                    {
                        name = "Pile o' cash",
                        model = "bkr_prop_bkr_cashpile_01"
                    },
                    {
                        name = "Shipping container",
                        model = "port_xr_cont_01"
                    },
                    {
                        name = "Weed plant",
                        model = "bkr_prop_weed_lrg_01b"
                    },
                    {
                        name = "Wood crate",
                        model = "ng_proc_crate_04a"
                    },
                },
            },
        },
    },
    {
        name = "Vehicles",
        is_folder = true,
        items = {
            {
                name = "Police",
                is_folder = true,
                items = {
                    {
                        name = "Police Cruiser",
                        model = "police",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Buffalo",
                        model = "police2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Sports",
                        model = "police3",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Van",
                        model = "policet",
                        type = "VEHICLE",
                    },
                    {
                        name = "Police Bike",
                        model = "policeb",
                        type = "VEHICLE",
                    },
                    {
                        name = "FIB Cruiser",
                        model = "fbi",
                        type = "VEHICLE",
                    },
                    {
                        name = "FIB SUV",
                        model = "fbi2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Sheriff Cruiser",
                        model = "sheriff",
                        type = "VEHICLE",
                    },
                    {
                        name = "Sheriff SUV",
                        model = "sheriff2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Unmarked Cruiser",
                        model = "police3",
                        type = "VEHICLE",
                    },
                    {
                        name = "Snowy Rancher",
                        model = "policeold1",
                        type = "VEHICLE",
                    },
                    {
                        name = "Snowy Cruiser",
                        model = "policeold2",
                        type = "VEHICLE",
                    },
                    {
                        name = "Park Ranger",
                        model = "pranger",
                        type = "VEHICLE",
                    },
                    {
                        name = "Riot Van",
                        model = "riot",
                        type = "VEHICLE",
                    },
                    {
                        name = "Riot Control Vehicle (RCV)",
                        model = "riot2",
                        type = "VEHICLE",
                    },
                },
            }
        },
    },
     {
        name = "Peds",
        is_folder = true,
        items = {
            {
                name="Ambient Females",
                is_folder = true,
                items = {
                    {
                        name="Beach Bikini",
                        model="a_f_m_beach_01",
                        type="PED",
                    },
                    {
                        name="Beverly Hills 1",
                        model="a_f_m_bevhills_01",
                        type="PED",
                    },
                    {
                        name="Beverly Hills 2",
                        model="a_f_m_bevhills_02",
                        type="PED",
                    },
                    {
                        name="Bodybuilder",
                        model="a_f_m_bodybuild_01",
                        type="PED",
                    },
                    {
                        name="Business",
                        model="a_f_m_business_02",
                        type="PED",
                    },
                    {
                        name="Downtown 1",
                        model="a_f_m_downtown_01",
                        type="PED",
                    },
                    {
                        name="East SA",
                        model="a_f_m_eastsa_01",
                        type="PED",
                    },
                    {
                        name="East SA 2",
                        model="a_f_m_eastsa_02",
                        type="PED",
                    },
                    {
                        name="Fat Black 1",
                        model="a_f_m_fatbla_01",
                        type="PED",
                    },
                    {
                        name="Fat Cult",
                        model="a_f_m_fatcult_01",
                        type="PED",
                    },
                    {
                        name="Fat White",
                        model="a_f_m_fatwhite_01",
                        type="PED",
                    },
                    {
                        name="K town 1",
                        model="a_f_m_ktown_01",
                        type="PED",
                    },
                    {
                        name="K town 2",
                        model="a_f_m_ktown_02",
                        type="PED",
                    },
                    {
                        name="Prologue Hostage",
                        model="a_f_m_prolhost_01",
                        type="PED",
                    },
                    {
                        name="Salton",
                        model="a_f_m_salton_01",
                        type="PED",
                    },
                    {
                        name="Skidrow",
                        model="a_f_m_skidrow_01",
                        type="PED",
                    },
                    {
                        name="South Central",
                        model="a_f_m_soucent_01",
                        type="PED",
                    },
                    {
                        name="South Central 2",
                        model="a_f_m_soucent_02",
                        type="PED",
                    },
                    {
                        name="South Central MC",
                        model="a_f_m_soucentmc_01",
                        type="PED",
                    },
                    {
                        name="Tourist",
                        model="a_f_m_tourist_01",
                        type="PED",
                    },
                    {
                        name="Tramp",
                        model="a_f_m_tramp_01",
                        type="PED",
                    },
                    {
                        name="Tramp Beach",
                        model="a_f_m_trampbeac_01",
                        type="PED",
                    },
                    {
                        name="Older General Street Female",
                        model="a_f_o_genstreet_01",
                        type="PED",
                    },
                    {
                        name="Older Indian",
                        model="a_f_o_indian_01",
                        type="PED",
                    },
                    {
                        name="Older Ktown",
                        model="a_f_o_ktown_01",
                        type="PED",
                    },
                    {
                        name="Older Salton",
                        model="a_f_o_salton_01",
                        type="PED",
                    },
                    {
                        name="Older South Central 1",
                        model="a_f_o_soucent_01",
                        type="PED",
                    },
                    {
                        name="Older South Central 2",
                        model="a_f_o_soucent_02",
                        type="PED",
                    },
                    {
                        name="Young Beach",
                        model="a_f_y_beach_01",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 1",
                        model="a_f_y_bevhills_01",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 2",
                        model="a_f_y_bevhills_02",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 3",
                        model="a_f_y_bevhills_03",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 4",
                        model="a_f_y_bevhills_04",
                        type="PED",
                    },
                    {
                        name="Young Business 1",
                        model="a_f_y_business_01",
                        type="PED",
                    },
                    {
                        name="Young Business 2",
                        model="a_f_y_business_02",
                        type="PED",
                    },
                    {
                        name="Young Business 3",
                        model="a_f_y_business_03",
                        type="PED",
                    },
                    {
                        name="Young Business 4",
                        model="a_f_y_business_04",
                        type="PED",
                    },
                    {
                        name="Young East SA 1",
                        model="a_f_y_eastsa_01",
                        type="PED",
                    },
                    {
                        name="Young East SA 2",
                        model="a_f_y_eastsa_02",
                        type="PED",
                    },
                    {
                        name="Young East SA 3",
                        model="a_f_y_eastsa_03",
                        type="PED",
                    },
                    {
                        name="Young Epsilon",
                        model="a_f_y_epsilon_01",
                        type="PED",
                    },
                    {
                        name="Young Agent",
                        model="a_f_y_femaleagent",
                        type="PED",
                    },
                    {
                        name="Young Fitness 1",
                        model="a_f_y_fitness_01",
                        type="PED",
                    },
                    {
                        name="Young Fitness 2",
                        model="a_f_y_fitness_02",
                        type="PED",
                    },
                    {
                        name="General Female",
                        model="a_f_y_genhot_01",
                        type="PED",
                    },
                    {
                        name="Golfer",
                        model="a_f_y_golfer_01",
                        type="PED",
                    },
                    {
                        name="Hiker",
                        model="a_f_y_hiker_01",
                        type="PED",
                    },
                    {
                        name="Young Hippe",
                        model="a_f_y_hippie_01",
                        type="PED",
                    },
                    {
                        name="Young Hipster 1",
                        model="a_f_y_hipster_01",
                        type="PED",
                    },
                    {
                        name="Young Hipster 2",
                        model="a_f_y_hipster_02",
                        type="PED",
                    },
                    {
                        name="Young Hipster 3",
                        model="a_f_y_hipster_03",
                        type="PED",
                    },
                    {
                        name="Young Hipster 4",
                        model="a_f_y_hipster_04",
                        type="PED",
                    },
                    {
                        name="Young Indian",
                        model="a_f_y_indian_01",
                        type="PED",
                    },
                    {
                        name="Young Juggalo",
                        model="a_f_y_juggalo_01",
                        type="PED",
                    },
                    {
                        name="Runner",
                        model="a_f_y_runner_01",
                        type="PED",
                    },
                    {
                        name="Rural Meth",
                        model="a_f_y_rurmeth_01",
                        type="PED",
                    },
                    {
                        name="Dressy",
                        model="a_f_y_scdressy_01",
                        type="PED",
                    },
                    {
                        name="Skater",
                        model="a_f_y_skater_01",
                        type="PED",
                    },
                    {
                        name="Young South Central 1",
                        model="a_f_y_soucent_01",
                        type="PED",
                    },
                    {
                        name="Young South Central 2",
                        model="a_f_y_soucent_02",
                        type="PED",
                    },
                    {
                        name="Young South Central 3",
                        model="a_f_y_soucent_03",
                        type="PED",
                    },
                    {
                        name="Tennis Player",
                        model="a_f_y_tennis_01",
                        type="PED",
                    },
                    {
                        name="Topless",
                        model="a_f_y_topless_01",
                        type="PED",
                    },
                    {
                        name="Young  Tourist 1",
                        model="a_f_y_tourist_01",
                        type="PED",
                    },
                    {
                        name="Young  Tourist 2",
                        model="a_f_y_tourist_02",
                        type="PED",
                    },
                    {
                        name="Vinewood 1",
                        model="a_f_y_vinewood_01",
                        type="PED",
                    },
                    {
                        name="Vinewood 2",
                        model="a_f_y_vinewood_02",
                        type="PED",
                    },
                    {
                        name="Vinewood 3",
                        model="a_f_y_vinewood_03",
                        type="PED",
                    },
                    {
                        name="Vinewood 4",
                        model="a_f_y_vinewood_04",
                        type="PED",
                    },
                    {
                        name="Yoga",
                        model="a_f_y_yoga_01",
                        type="PED",
                    },
                },
            },
            {
                name="Ambient Males",
                is_folder = true,
                items = {
                    {
                        name="Naked Altruist Cult",
                        model="a_m_m_acult_01",
                        type="PED",
                    },
                    {
                        name="African American",
                        model="a_m_m_afriamer_01",
                        type="PED",
                    },
                    {
                        name="Beach 1",
                        model="a_m_m_beach_01",
                        type="PED",
                    },
                    {
                        name="Beach 2",
                        model="a_m_m_beach_02",
                        type="PED",
                    },
                    {
                        name="Beverly hills 1",
                        model="a_m_m_bevhills_01",
                        type="PED",
                    },
                    {
                        name="Beverly hills 2",
                        model="a_m_m_bevhills_02",
                        type="PED",
                    },
                    {
                        name="Business 1",
                        model="a_m_m_business_01",
                        type="PED",
                    },
                    {
                        name="East SA 1",
                        model="a_m_m_eastsa_01",
                        type="PED",
                    },
                    {
                        name="East SA 2",
                        model="a_m_m_eastsa_02",
                        type="PED",
                    },
                    {
                        name="Farmer",
                        model="a_m_m_farmer_01",
                        type="PED",
                    },
                    {
                        name="Fat Latino",
                        model="a_m_m_fatlatin_01",
                        type="PED",
                    },
                    {
                        name="Generic Fat 1",
                        model="a_m_m_genfat_01",
                        type="PED",
                    },
                    {
                        name="Generic Fat 2",
                        model="a_m_m_genfat_02",
                        type="PED",
                    },
                    {
                        name="Golfer",
                        model="a_m_m_golfer_01",
                        type="PED",
                    },
                    {
                        name="Rabbi",
                        model="a_m_m_hasjew_01",
                        type="PED",
                    },
                    {
                        name="Hillbilly 1",
                        model="a_m_m_hillbilly_01",
                        type="PED",
                    },
                    {
                        name="Hillbilly 2",
                        model="a_m_m_hillbilly_02",
                        type="PED",
                    },
                    {
                        name="Indian",
                        model="a_m_m_indian_01",
                        type="PED",
                    },
                    {
                        name="Ktown 1",
                        model="a_m_m_ktown_01",
                        type="PED",
                    },
                    {
                        name="Malibu 1",
                        model="a_m_m_malibu_01",
                        type="PED",
                    },
                    {
                        name="Mexican Country",
                        model="a_m_m_mexcntry_01",
                        type="PED",
                    },
                    {
                        name="Mexican Laborer",
                        model="a_m_m_mexlabor_01",
                        type="PED",
                    },
                    {
                        name="a_m_m_og_boss_01",
                        model="a_m_m_og_boss_01",
                        type="PED",
                    },
                    {
                        name="Paparazzi",
                        model="a_m_m_paparazzi_01",
                        type="PED",
                    },
                    {
                        name="Polynesian",
                        model="a_m_m_polynesian_01",
                        type="PED",
                    },
                    {
                        name="Prologue Hostage",
                        model="a_m_m_prolhost_01",
                        type="PED",
                    },
                    {
                        name="Rural Meth Head",
                        model="a_m_m_rurmeth_01",
                        type="PED",
                    },
                    {
                        name="Salton 1",
                        model="a_m_m_salton_01",
                        type="PED",
                    },
                    {
                        name="Salton 2",
                        model="a_m_m_salton_02",
                        type="PED",
                    },
                    {
                        name="Salton 3",
                        model="a_m_m_salton_03",
                        type="PED",
                    },
                    {
                        name="Salton 4",
                        model="a_m_m_salton_04",
                        type="PED",
                    },
                    {
                        name="Skater",
                        model="a_m_m_skater_01",
                        type="PED",
                    },
                    {
                        name="Skidrow",
                        model="a_f_m_skidrow_01",
                        type="PED",
                    },
                    {
                        name="South Central Latino",
                        model="a_m_m_socenlat_01",
                        type="PED",
                    },
                    {
                        name="South Central 1",
                        model="a_m_m_soucent_01",
                        type="PED",
                    },
                    {
                        name="South Central 2",
                        model="a_m_m_soucent_02",
                        type="PED",
                    },
                    {
                        name="South Central 3",
                        model="a_m_m_soucent_03",
                        type="PED",
                    },
                    {
                        name="South Central 4",
                        model="a_m_m_soucent_04",
                        type="PED",
                    },
                    {
                        name="Latino 2",
                        model="a_m_m_stlat_02",
                        type="PED",
                    },
                    {
                        name="Tennis",
                        model="a_m_m_tennis_01",
                        type="PED",
                    },
                    {
                        name="Tourist",
                        model="a_m_m_tourist_01",
                        type="PED",
                    },
                    {
                        name="Tramp",
                        model="a_m_m_tramp_01",
                        type="PED",
                    },
                    {
                        name="Tramp Beach",
                        model="a_m_m_trampbeac_01",
                        type="PED",
                    },
                    {
                        name="Tranvest",
                        model="a_m_m_tranvest_01",
                        type="PED",
                    },
                    {
                        name="Tranvest 2",
                        model="a_m_m_tranvest_02",
                        type="PED",
                    },
                    {
                        name="Old Altruist Cult 1",
                        model="a_m_o_acult_01",
                        type="PED",
                    },
                    {
                        name="Old Altruist Cult 2",
                        model="a_m_o_acult_02",
                        type="PED",
                    },
                    {
                        name="Old Beach",
                        model="a_m_o_beach_01",
                        type="PED",
                    },
                    {
                        name="Old Generic Street",
                        model="a_m_o_genstreet_01",
                        type="PED",
                    },
                    {
                        name="Old Ktown",
                        model="a_m_o_ktown_01",
                        type="PED",
                    },
                    {
                        name="Old Salton",
                        model="a_m_o_salton_01",
                        type="PED",
                    },
                    {
                        name="Old South Central 1",
                        model="a_m_o_soucent_01",
                        type="PED",
                    },
                    {
                        name="Old South Central 2",
                        model="a_m_o_soucent_02",
                        type="PED",
                    },
                    {
                        name="Old South Central 3",
                        model="a_m_o_soucent_03",
                        type="PED",
                    },
                    {
                        name="Old Tramp 1",
                        model="a_m_o_tramp_01",
                        type="PED",
                    },
                    {
                        name="Young Altruist Cult 1",
                        model="a_m_y_acult_01",
                        type="PED",
                    },
                    {
                        name="Young Altruist Cult 2",
                        model="a_m_y_acult_02",
                        type="PED",
                    },
                    {
                        name="Young Beach 1",
                        model="a_m_y_beach_01",
                        type="PED",
                    },
                    {
                        name="Young Beach 2",
                        model="a_m_y_beach_02",
                        type="PED",
                    },
                    {
                        name="Young Beach 3",
                        model="a_m_y_beach_03",
                        type="PED",
                    },
                    {
                        name="Young Beach Vesp 1",
                        model="a_m_y_beachvesp_01",
                        type="PED",
                    },
                    {
                        name="Young Beach Vesp 2",
                        model="a_m_y_beachvesp_02",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 1",
                        model="a_m_y_bevhills_01",
                        type="PED",
                    },
                    {
                        name="Young Beverly Hills 2",
                        model="a_m_y_bevhills_02",
                        type="PED",
                    },
                    {
                        name="Breakdance",
                        model="a_m_y_breakdance_01",
                        type="PED",
                    },
                    {
                        name="Young Business",
                        model="a_m_y_busicas_01",
                        type="PED",
                    },
                    {
                        name="Young Business 1",
                        model="a_m_y_business_01",
                        type="PED",
                    },
                    {
                        name="Young Business 2",
                        model="a_m_y_business_02",
                        type="PED",
                    },
                    {
                        name="Young Business 3",
                        model="a_m_y_business_03",
                        type="PED",
                    },
                    {
                        name="Cyclist",
                        model="a_m_y_cyclist_01",
                        type="PED",
                    },
                    {
                        name="Cyclist 2",
                        model="a_m_y_dhill_01",
                        type="PED",
                    },
                    {
                        name="Young Downtown",
                        model="a_m_y_downtown_01",
                        type="PED",
                    },
                    {
                        name="Young East SA 1",
                        model="a_m_y_eastsa_01",
                        type="PED",
                    },
                    {
                        name="Young East SA 2",
                        model="a_m_y_eastsa_02",
                        type="PED",
                    },
                    {
                        name="Young Epsilon 1",
                        model="a_m_y_epsilon_01",
                        type="PED",
                    },
                    {
                        name="Young Epsilon 2",
                        model="a_m_y_epsilon_02",
                        type="PED",
                    },
                    {
                        name="Gay 1",
                        model="a_m_y_gay_01",
                        type="PED",
                    },
                    {
                        name="Gay 2",
                        model="a_m_y_gay_02",
                        type="PED",
                    },
                    {
                        name="Young Generic Street 1",
                        model="a_m_y_genstreet_01",
                        type="PED",
                    },
                    {
                        name="Young Generic Street 2",
                        model="a_m_y_genstreet_02",
                        type="PED",
                    },
                    {
                        name="Young golfer 1",
                        model="a_m_y_golfer_01",
                        type="PED",
                    },
                    {
                        name="Young Rabbi",
                        model="a_m_y_hasjew_01",
                        type="PED",
                    },
                    {
                        name="Young Hiker",
                        model="a_m_y_hiker_01",
                        type="PED",
                    },
                    {
                        name="Young Hippy",
                        model="a_m_y_hippy_01",
                        type="PED",
                    },
                    {
                        name="Young Hipster 1",
                        model="a_m_y_hipster_01",
                        type="PED",
                    },
                    {
                        name="Young Hipster 2",
                        model="a_m_y_hipster_02",
                        type="PED",
                    },
                    {
                        name="Young Hipster 3",
                        model="a_m_y_hipster_03",
                        type="PED",
                    },
                    {
                        name="Young Indian",
                        model="a_m_y_indian_01",
                        type="PED",
                    },
                    {
                        name="Jetski",
                        model="a_m_y_jetski_01",
                        type="PED",
                    },
                    {
                        name="Young juggalo",
                        model="a_m_y_juggalo_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_ktown_01",
                        model="a_m_y_ktown_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_ktown_02",
                        model="a_m_y_ktown_02",
                        type="PED",
                    },
                    {
                        name="a_m_y_latino_01",
                        model="a_m_y_latino_01",
                        type="PED",
                    },
                    {
                        name="Young Meth Head",
                        model="a_m_y_methhead_01",
                        type="PED",
                    },
                    {
                        name="Young Mexican",
                        model="a_m_y_mexthug_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_motox_01",
                        model="a_m_y_motox_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_motox_02",
                        model="a_m_y_motox_02",
                        type="PED",
                    },
                    {
                        name="a_m_y_musclbeac_01",
                        model="a_m_y_musclbeac_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_musclbeac_02",
                        model="a_m_y_musclbeac_02",
                        type="PED",
                    },
                    {
                        name="a_m_y_polynesian_01",
                        model="a_m_y_polynesian_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_roadcyc_01",
                        model="a_m_y_roadcyc_01",
                        type="PED",
                    },
                    {
                        name="Young Runner 1",
                        model="a_m_y_runner_01",
                        type="PED",
                    },
                    {
                        name="Young Runner 2",
                        model="a_m_y_runner_02",
                        type="PED",
                    },
                    {
                        name="Young Salton",
                        model="a_m_y_salton_01",
                        type="PED",
                    },
                    {
                        name="Young Skater 1",
                        model="a_m_y_skater_01",
                        type="PED",
                    },
                    {
                        name="Young Skater 2",
                        model="a_m_y_skater_02",
                        type="PED",
                    },
                    {
                        name="Young South Central 1",
                        model="a_m_y_soucent_01",
                        type="PED",
                    },
                    {
                        name="Young South Central 2",
                        model="a_m_y_soucent_02",
                        type="PED",
                    },
                    {
                        name="Young South Central 3",
                        model="a_m_y_soucent_03",
                        type="PED",
                    },
                    {
                        name="Young South Central 4",
                        model="a_m_y_soucent_04",
                        type="PED",
                    },
                    {
                        name="a_m_y_stbla_01",
                        model="a_m_y_stbla_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_stlat_01",
                        model="a_m_y_stlat_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_stwhi_01",
                        model="a_m_y_stwhi_01",
                        type="PED",
                    },
                    {
                        name="a_m_y_stwhi_02",
                        model="a_m_y_stwhi_02",
                        type="PED",
                    },
                    {
                        name="Sunbather",
                        model="a_m_y_sunbathe_01",
                        type="PED",
                    },
                    {
                        name="Surfer",
                        model="a_m_y_surfer_01",
                        type="PED",
                    },
                    {
                        name="Vinewood Douche",
                        model="a_m_y_vindouche_01",
                        type="PED",
                    },
                    {
                        name="Vinewood 1",
                        model="a_m_y_vinewood_01",
                        type="PED",
                    },
                    {
                        name="Vinewood 2",
                        model="a_m_y_vinewood_02",
                        type="PED",
                    },
                    {
                        name="Vinewood 3",
                        model="a_m_y_vinewood_03",
                        type="PED",
                    },
                    {
                        name="Vinewood 4",
                        model="a_m_y_vinewood_04",
                        type="PED",
                    },
                    {
                        name="Yoga",
                        model="a_m_y_yoga_01",
                        type="PED",
                    },

                }
            },
            {
                name="Cutscene",
                is_folder = true,
                items = {
                    {
                        name="Amanda Townley",
                        model="cs_amandatownley",
                        type="PED",
                    },
                    {
                        name="Andreas",
                        model="cs_andreas",
                        type="PED",
                    },
                    {
                        name="Ashley",
                        model="cs_ashley",
                        type="PED",
                    },
                    {
                        name="Bank Manager",
                        model="cs_bankman",
                        type="PED",
                    },
                    {
                        name="Barry",
                        model="cs_barry",
                        type="PED",
                    },
                    {
                        name="Beverly",
                        model="cs_beverly",
                        type="PED",
                    },
                    {
                        name="Brad",
                        model="cs_brad",
                        type="PED",
                    },
                    {
                        name="Brad Cadaver",
                        model="cs_bradcadaver",
                        type="PED",
                    },
                    {
                        name="Car Buyer",
                        model="cs_carbuyer",
                        type="PED",
                    },
                    {
                        name="Casey",
                        model="cs_casey",
                        type="PED",
                    },
                    {
                        name="Cheng SR",
                        model="cs_chengsr",
                        type="PED",
                    },
                    {
                        name="Chris Formage",
                        model="cs_chrisformage",
                        type="PED",
                    },
                    {
                        name="Clay",
                        model="cs_clay",
                        type="PED",
                    },
                    {
                        name="Dale",
                        model="cs_dale",
                        type="PED",
                    },
                    {
                        name="Dave Norton",
                        model="cs_davenorton",
                        type="PED",
                    },
                    {
                        name="Debra",
                        model="cs_debra",
                        type="PED",
                    },
                    {
                        name="Denise",
                        model="cs_denise",
                        type="PED",
                    },
                    {
                        name="Devin",
                        model="cs_devin",
                        type="PED",
                    },
                    {
                        name="Dom",
                        model="cs_dom",
                        type="PED",
                    },
                    {
                        name="Peter Dreyfuss",
                        model="cs_dreyfuss",
                        type="PED",
                    },
                    {
                        name="Dr Friedlander",
                        model="cs_drfriedlander",
                        type="PED",
                    },
                    {
                        name="Fabien",
                        model="cs_fabien",
                        type="PED",
                    },
                    {
                        name="FBI Suit",
                        model="cs_fbisuit_01",
                        type="PED",
                    },
                    {
                        name="Floyd",
                        model="cs_floyd",
                        type="PED",
                    },
                    {
                        name="Guadalope",
                        model="cs_guadalope",
                        type="PED",
                    },
                    {
                        name="Gurk",
                        model="cs_gurk",
                        type="PED",
                    },
                    {
                        name="Hunter",
                        model="cs_hunter",
                        type="PED",
                    },
                    {
                        name="Janet",
                        model="cs_janet",
                        type="PED",
                    },
                    {
                        name="Jewelery Assistant",
                        model="cs_jewelass",
                        type="PED",
                    },
                    {
                        name="Jimmy Boston",
                        model="cs_jimmyboston",
                        type="PED",
                    },
                    {
                        name="Jimmy Disanto",
                        model="cs_jimmydisanto",
                        type="PED",
                    },
                    {
                        name="Joe Minuteman",
                        model="cs_joeminuteman",
                        type="PED",
                    },
                    {
                        name="Johnny Klebitz",
                        model="cs_johnnyklebitz",
                        type="PED",
                    },
                    {
                        name="Josef",
                        model="cs_josef",
                        type="PED",
                    },
                    {
                        name="Josh",
                        model="cs_josh",
                        type="PED",
                    },
                    {
                        name="Karen Daniels",
                        model="cs_karen_daniels",
                        type="PED",
                    },
                    {
                        name="Lamar Davis",
                        model="cs_lamardavis",
                        type="PED",
                    },
                    {
                        name="Lazlow",
                        model="cs_lazlow",
                        type="PED",
                    },
                    {
                        name="Lester Crest",
                        model="cs_lestercrest",
                        type="PED",
                    },
                    {
                        name="Lester Crest 2",
                        model="cs_lestercrest_2",
                        type="PED",
                    },
                    {
                        name="Rickie Lukens",
                        model="cs_lifeinvad_01",
                        type="PED",
                    },
                    {
                        name="Magenta",
                        model="cs_magenta",
                        type="PED",
                    },
                    {
                        name="Manuel",
                        model="cs_manuel",
                        type="PED",
                    },
                    {
                        name="Marnie",
                        model="cs_marnie",
                        type="PED",
                    },
                    {
                        name="Martin Madrazo",
                        model="cs_martinmadrazo",
                        type="PED",
                    },
                    {
                        name="Mary Ann",
                        model="cs_maryann",
                        type="PED",
                    },
                    {
                        name="Michelle",
                        model="cs_michelle",
                        type="PED",
                    },
                    {
                        name="Milton",
                        model="cs_milton",
                        type="PED",
                    },
                    {
                        name="Molly",
                        model="cs_molly",
                        type="PED",
                    },
                    {
                        name="Movie Premier Female",
                        model="cs_movpremf_01",
                        type="PED",
                    },
                    {
                        name="Movie Premier Male",
                        model="cs_movpremmale",
                        type="PED",
                    },
                    {
                        name="Mark",
                        model="cs_mrk",
                        type="PED",
                    },
                    {
                        name="Mrs Thornhill",
                        model="cs_mrs_thornhill",
                        type="PED",
                    },
                    {
                        name="Mrs Phillips",
                        model="cs_mrsphillips",
                        type="PED",
                    },
                    {
                        name="Natalia",
                        model="cs_natalia",
                        type="PED",
                    },
                    {
                        name="Nervous Ron",
                        model="cs_nervousron",
                        type="PED",
                    },
                    {
                        name="Nigel",
                        model="cs_nigel",
                        type="PED",
                    },
                    {
                        name="Old Man 1",
                        model="cs_old_man1a",
                        type="PED",
                    },
                    {
                        name="Old Man 2",
                        model="cs_old_man2",
                        type="PED",
                    },
                    {
                        name="Omega",
                        model="cs_omega",
                        type="PED",
                    },
                    {
                        name="Bigfoot",
                        model="cs_orleans",
                        type="PED",
                    },
                    {
                        name="Agent ULP",
                        model="cs_paper",
                        type="PED",
                    },
                    {
                        name="Patricia",
                        model="cs_patricia",
                        type="PED",
                    },
                    {
                        name="Priest",
                        model="cs_priest",
                        type="PED",
                    },
                    {
                        name="Prologue Security 2",
                        model="cs_prolsec_02",
                        type="PED",
                    },
                    {
                        name="Russian Drunk",
                        model="cs_russiandrunk",
                        type="PED",
                    },
                    {
                        name="Simeon Yetarian",
                        model="cs_siemonyetarian",
                        type="PED",
                    },
                    {
                        name="Solomon",
                        model="cs_solomon",
                        type="PED",
                    },
                    {
                        name="Steve Hains",
                        model="cs_stevehains",
                        type="PED",
                    },
                    {
                        name="Stretch",
                        model="cs_stretch",
                        type="PED",
                    },
                    {
                        name="Tanisha",
                        model="cs_tanisha",
                        type="PED",
                    },
                    {
                        name="Tao Cheng",
                        model="cs_taocheng",
                        type="PED",
                    },
                    {
                        name="Taos Translator",
                        model="cs_taostranslator",
                        type="PED",
                    },
                    {
                        name="Tennis Coach",
                        model="cs_tenniscoach",
                        type="PED",
                    },
                    {
                        name="Terry",
                        model="cs_terry",
                        type="PED",
                    },
                    {
                        name="Tom",
                        model="cs_tom",
                        type="PED",
                    },
                    {
                        name="Tom Epsilon",
                        model="cs_tomepsilon",
                        type="PED",
                    },
                    {
                        name="Tracy Disanto",
                        model="cs_tracydisanto",
                        type="PED",
                    },
                    {
                        name="Wade",
                        model="cs_wade",
                        type="PED",
                    },
                    {
                        name="Zimbor",
                        model="cs_zimbor",
                        type="PED",
                    },
                    {
                        name="Abigail",
                        model="csb_abigail",
                        type="PED",
                    },
                    {
                        name="Agent",
                        model="csb_agent",
                        type="PED",
                    },
                    {
                        name="Alan",
                        model="csb_alan",
                        type="PED",
                    },
                    {
                        name="Anita",
                        model="csb_anita",
                        type="PED",
                    },
                    {
                        name="Anton",
                        model="csb_anton",
                        type="PED",
                    },
                    {
                        name="Avon",
                        model="csb_avon",
                        type="PED",
                    },
                    {
                        name="Ballas OG",
                        model="csb_ballasog",
                        type="PED",
                    },
                    {
                        name="Bogdan",
                        model="csb_bogdan",
                        type="PED",
                    },
                    {
                        name="Bride",
                        model="csb_bride",
                        type="PED",
                    },
                    {
                        name="BurgerShot Drug Dealer",
                        model="csb_burgerdrug",
                        type="PED",
                    },
                    {
                        name="Bryony",
                        model="csb_bryony",
                        type="PED",
                    },
                    {
                        name="Car guy 1",
                        model="csb_car3guy1",
                        type="PED",
                    },
                    {
                        name="Car guy 2",
                        model="csb_car3guy2",
                        type="PED",
                    },
                    {
                        name="Chef",
                        model="csb_chef",
                        type="PED",
                    },
                    {
                        name="Chef 2",
                        model="csb_chef2",
                        type="PED",
                    },
                    {
                        name="Chinese Goon",
                        model="csb_chin_goon",
                        type="PED",
                    },
                    {
                        name="Cletus",
                        model="csb_cletus",
                        type="PED",
                    },
                    {
                        name="Cop",
                        model="csb_cop",
                        type="PED",
                    },
                    {
                        name="Customer",
                        model="csb_customer",
                        type="PED",
                    },
                    {
                        name="Denise Friend",
                        model="csb_denise_friend",
                        type="PED",
                    },
                    {
                        name="FOS Rep",
                        model="csb_fos_rep",
                        type="PED",
                    },
                    {
                        name="csb_g",
                        model="csb_g",
                        type="PED",
                    },
                    {
                        name="Groom",
                        model="csb_groom",
                        type="PED",
                    },
                    {
                        name="Grove Street Dealer",
                        model="csb_grove_str_dlr",
                        type="PED",
                    },
                    {
                        name="Hao",
                        model="csb_hao",
                        type="PED",
                    },
                    {
                        name="Hugh",
                        model="csb_hugh",
                        type="PED",
                    },
                    {
                        name="csb_imran",
                        model="csb_imran",
                        type="PED",
                    },
                    {
                        name="Jack Howitzer",
                        model="csb_jackhowitzer",
                        type="PED",
                    },
                    {
                        name="Janitor",
                        model="csb_janitor",
                        type="PED",
                    },
                    {
                        name="Maude",
                        model="csb_maude",
                        type="PED",
                    },
                    {
                        name="Money",
                        model="csb_money",
                        type="PED",
                    },
                    {
                        name="Agent 14",
                        model="csb_mp_agent14",
                        type="PED",
                    },
                    {
                        name="Phoenicia Rackman",
                        model="csb_mrs_r",
                        type="PED",
                    },
                    {
                        name="Merryweather",
                        model="csb_mweather",
                        type="PED",
                    },
                    {
                        name="Ortega",
                        model="csb_ortega",
                        type="PED",
                    },
                    {
                        name="Oscar",
                        model="csb_oscar",
                        type="PED",
                    },
                    {
                        name="Paige",
                        model="csb_paige",
                        type="PED",
                    },
                    {
                        name="Dimitri Popov",
                        model="csb_popov",
                        type="PED",
                    },
                    {
                        name="Porn Dudes",
                        model="csb_porndudes",
                        type="PED",
                    },
                    {
                        name="Prologue Driver",
                        model="csb_prologuedriver",
                        type="PED",
                    },
                    {
                        name="prologue Security",
                        model="csb_prolsec",
                        type="PED",
                    },
                    {
                        name="Rampage Gang",
                        model="csb_ramp_gang",
                        type="PED",
                    },
                    {
                        name="Rampage Hics",
                        model="csb_ramp_hic",
                        type="PED",
                    },
                    {
                        name="Rampage Hipster",
                        model="csb_ramp_hipster",
                        type="PED",
                    },
                    {
                        name="Rampage Marine",
                        model="csb_ramp_marine",
                        type="PED",
                    },
                    {
                        name="Ramage Mexicans",
                        model="csb_ramp_mex",
                        type="PED",
                    },
                    {
                        name="Rashcosvki",
                        model="csb_rashcosvki",
                        type="PED",
                    },
                    {
                        name="Reporter",
                        model="csb_reporter",
                        type="PED",
                    },
                    {
                        name="Roccope Pelosi",
                        model="csb_roccopelosi",
                        type="PED",
                    },
                    {
                        name="Screen Writer",
                        model="csb_screen_writer",
                        type="PED",
                    },
                    {
                        name="Stripper 1",
                        model="csb_stripper_01",
                        type="PED",
                    },
                    {
                        name="Stripper 2",
                        model="csb_stripper_02",
                        type="PED",
                    },
                    {
                        name="Tonya",
                        model="csb_tonya",
                        type="PED",
                    },
                    {
                        name="Traffic Warden",
                        model="csb_trafficwarden",
                        type="PED",
                    },
                    {
                        name="Undercover",
                        model="csb_undercover",
                        type="PED",
                    },
                    {
                        name="Vagos Funeral Speaker",
                        model="csb_vagspeak",
                        type="PED",
                    },

                }
            },
            {
                    name="Gang Members",
                    is_folder = true,
                    items = {
                    {
                        name="Female Import Export",
                        model="g_f_importexport_01",
                        type="PED",
                    },
                    {
                        name="Ballas Female",
                        model="g_f_y_ballas_01",
                        type="PED",
                    },
                    {
                        name="Grove Street Female",
                        model="g_f_y_families_01",
                        type="PED",
                    },
                    {
                        name="Lost MC Female",
                        model="g_f_y_lost_01",
                        type="PED",
                    },
                    {
                        name="Vagos Female",
                        model="g_f_y_vagos_01",
                        type="PED",
                    },
                    {
                        name="Male Import Export",
                        model="g_m_importexport_01",
                        type="PED",
                    },
                    {
                        name="Armenian Boss",
                        model="g_m_m_armboss_01",
                        type="PED",
                    },
                    {
                        name="Armenian Goon 1",
                        model="g_m_m_armgoon_01",
                        type="PED",
                    },
                    {
                        name="Armenian Lieutenant",
                        model="g_m_m_armlieut_01",
                        type="PED",
                    },
                    {
                        name="Chem Plant Worker",
                        model="g_m_m_chemwork_01",
                        type="PED",
                    },
                    {
                        name="Chinese Boss",
                        model="g_m_m_chiboss_01",
                        type="PED",
                    },
                    {
                        name="Older Chinese Goon",
                        model="g_m_m_chicold_01",
                        type="PED",
                    },
                    {
                        name="Chinese Goon 1",
                        model="g_m_m_chigoon_01",
                        type="PED",
                    },
                    {
                        name="Chinese Goon 2",
                        model="g_m_m_chigoon_02",
                        type="PED",
                    },
                    {
                        name="Korean Boss 1",
                        model="g_m_m_korboss_01",
                        type="PED",
                    },
                    {
                        name="Mexican Boss 1",
                        model="g_m_m_mexboss_01",
                        type="PED",
                    },
                    {
                        name="Mexican Boss 2",
                        model="g_m_m_mexboss_02",
                        type="PED",
                    },
                    {
                        name="Armenian Goon 2",
                        model="g_m_y_armgoon_02",
                        type="PED",
                    },
                    {
                        name="Azteca",
                        model="g_m_y_azteca_01",
                        type="PED",
                    },
                    {
                        name="Ballas Easy",
                        model="g_m_y_ballaeast_01",
                        type="PED",
                    },
                    {
                        name="Ballas Original",
                        model="g_m_y_ballaorig_01",
                        type="PED",
                    },
                    {
                        name="Ballas South",
                        model="g_m_y_ballasout_01",
                        type="PED",
                    },
                    {
                        name="Grove Street 1",
                        model="g_m_y_famca_01",
                        type="PED",
                    },
                    {
                        name="Grove Street 2",
                        model="g_m_y_famdnf_01",
                        type="PED",
                    },
                    {
                        name="Grove Street 3",
                        model="g_m_y_famfor_01",
                        type="PED",
                    },
                    {
                        name="Korean Goon 1",
                        model="g_m_y_korean_01",
                        type="PED",
                    },
                    {
                        name="Korean Goon 2",
                        model="g_m_y_korean_02",
                        type="PED",
                    },
                    {
                        name="Korean Lieutenant",
                        model="g_m_y_korlieut_01",
                        type="PED",
                    },
                    {
                        name="Lost 1",
                        model="g_m_y_lost_01",
                        type="PED",
                    },
                    {
                        name="Lost 2",
                        model="g_m_y_lost_02",
                        type="PED",
                    },
                    {
                        name="Lost 3",
                        model="g_m_y_lost_03",
                        type="PED",
                    },
                    {
                        name="Mexican Gang",
                        model="g_m_y_mexgang_01",
                        type="PED",
                    },
                    {
                        name="Mexican Goon 1",
                        model="g_m_y_mexgoon_01",
                        type="PED",
                    },
                    {
                        name="Mexican Goon 2",
                        model="g_m_y_mexgoon_02",
                        type="PED",
                    },
                    {
                        name="Mexican Goon 3",
                        model="g_m_y_mexgoon_03",
                        type="PED",
                    },
                    {
                        name="Polynesian Goon 1",
                        model="g_m_y_pologoon_01",
                        type="PED",
                    },
                    {
                        name="Polynesian Goon 2",
                        model="g_m_y_pologoon_02",
                        type="PED",
                    },
                    {
                        name="Salvadoran Boss",
                        model="g_m_y_salvaboss_01",
                        type="PED",
                    },
                    {
                        name="Salvadoran Goon 1",
                        model="g_m_y_salvagoon_01",
                        type="PED",
                    },
                    {
                        name="Salvadoran Goon 2",
                        model="g_m_y_salvagoon_02",
                        type="PED",
                    },
                    {
                        name="Salvadoran Goon 3",
                        model="g_m_y_salvagoon_03",
                        type="PED",
                    },
                    {
                        name="Street Punk 1",
                        model="g_m_y_strpunk_01",
                        type="PED",
                    },
                    {
                        name="Street Punk 2",
                        model="g_m_y_strpunk_02",
                        type="PED",
                    },
                }
            },
            {
                    name="Multiplayer",
                    is_folder = true,
                    items = {
                    {
                        name="Benny Mechanic",
                        model="mp_f_bennymech_01",
                        type="PED",
                    },
                    {
                        name="Female Boat Staff",
                        model="mp_f_boatstaff_01",
                        type="PED",
                    },
                    {
                        name="Female Car Designer",
                        model="mp_f_cardesign_01",
                        type="PED",
                    },
                    {
                        name="Female Bartender",
                        model="mp_f_chbar_01",
                        type="PED",
                    },
                    {
                        name="Female Cocaine Worker",
                        model="mp_f_cocaine_01",
                        type="PED",
                    },
                    {
                        name="Female Counterfeit Worker",
                        model="mp_f_counterfeit_01",
                        type="PED",
                    },
                    {
                        name="Dead Hooker",
                        model="mp_f_deadhooker",
                        type="PED",
                    },
                    {
                        name="Female Executive Assistant ",
                        model="mp_f_execpa_01",
                        type="PED",
                    },
                    {
                        name="Female Executive Assistant 2",
                        model="mp_f_execpa_02",
                        type="PED",
                    },
                    {
                        name="Female Forgery Worker",
                        model="mp_f_forgery_01",
                        type="PED",
                    },
                    {
                        name="Female Freemode",
                        model="mp_f_freemode_01",
                        type="PED",
                    },
                    {
                        name="Female Helistaff",
                        model="mp_f_helistaff_01",
                        type="PED",
                    },
                    {
                        name="Female Meth Worker",
                        model="mp_f_meth_01",
                        type="PED",
                    },
                    {
                        name="Misty",
                        model="mp_f_misty_01",
                        type="PED",
                    },
                    {
                        name="Stripper",
                        model="mp_f_stripperlite",
                        type="PED",
                    },
                    {
                        name="Female Weed Worker",
                        model="mp_f_weed_01",
                        type="PED",
                    },
                    {
                        name="Heist Goons",
                        model="mp_g_m_pros_01",
                        type="PED",
                    },
                    {
                        name="Avon Goon",
                        model="mp_m_avongoon",
                        type="PED",
                    },
                    {
                        name="Male Boat Staff",
                        model="mp_m_boatstaff_01",
                        type="PED",
                    },
                    {
                        name="Bogdan Goon",
                        model="mp_m_bogdangoon",
                        type="PED",
                    },
                    {
                        name="Claude",
                        model="mp_m_claude_01",
                        type="PED",
                    },
                    {
                        name="Male Cocaine Worker",
                        model="mp_m_cocaine_01",
                        type="PED",
                    },
                    {
                        name="Male Counterfeit Worker",
                        model="mp_m_counterfeit_01",
                        type="PED",
                    },
                    {
                        name="Ex Army Vet",
                        model="mp_m_exarmy_01",
                        type="PED",
                    },
                    {
                        name="Male exec PA",
                        model="mp_m_execpa_01",
                        type="PED",
                    },
                    {
                        name="Grove Street",
                        model="mp_m_famdd_01",
                        type="PED",
                    },
                    {
                        name="Male FIB Secretary",
                        model="mp_m_fibsec_01",
                        type="PED",
                    },
                    {
                        name="Male Forgery Worker",
                        model="mp_m_forgery_01",
                        type="PED",
                    },
                    {
                        name="Male Freemode",
                        model="mp_m_freemode_01",
                        type="PED",
                    },
                    {
                        name="John Marston",
                        model="mp_m_marston_01",
                        type="PED",
                    },
                    {
                        name="Male Meth Worker",
                        model="mp_m_meth_01",
                        type="PED",
                    },
                    {
                        name="Niko Belic",
                        model="mp_m_niko_01",
                        type="PED",
                    },
                    {
                        name="Securo Guard",
                        model="mp_m_securoguard_01",
                        type="PED",
                    },
                    {
                        name="Male Shopkeep",
                        model="mp_m_shopkeep_01",
                        type="PED",
                    },
                    {
                        name="Warehouse Mechanic",
                        model="mp_m_waremech_01",
                        type="PED",
                    },
                    {
                        name="Male Weed Worker",
                        model="mp_m_weed_01",
                        type="PED",
                    },
                    {
                        name="Vagos Funeral",
                        model="mp_m_g_vagfun_01",
                        type="PED",
                    },
                    {
                        name="Male Armoured",
                        model="mp_s_m_armoured_01",
                        type="PED",
                    },
                    {
                        name="Weapons Expert",
                        model="mp_m_weapexp_01",
                        type="PED",
                    },
                    {
                        name="Weapons Worker",
                        model="mp_m_weapwork_01",
                        type="PED",
                    },
                }
            },
            {
                    name="MP Scenario Females",
                    is_folder = true,
                    items = {
                    {
                        name="Barber",
                        model="s_f_m_fembarber",
                        type="PED",
                    },
                    {
                        name="Maid",
                        model="s_f_m_maid_01",
                        type="PED",
                    },
                    {
                        name="Highend Shop Keeper",
                        model="s_f_m_shop_high",
                        type="PED",
                    },
                    {
                        name="Sweatshop Worker",
                        model="s_f_m_sweatshop_01",
                        type="PED",
                    },
                    {
                        name="Air Hostess",
                        model="s_f_y_airhostess_01",
                        type="PED",
                    },
                    {
                        name="Bartender",
                        model="s_f_y_bartender_01",
                        type="PED",
                    },
                    {
                        name="Lifguard",
                        model="s_f_y_baywatch_01",
                        type="PED",
                    },
                    {
                        name="Cop",
                        model="s_f_y_cop_01",
                        type="PED",
                    },
                    {
                        name="Factory Worker",
                        model="s_f_y_factory_01",
                        type="PED",
                    },
                    {
                        name="Hooker 1",
                        model="s_f_y_hooker_01",
                        type="PED",
                    },
                    {
                        name="Hooker 2",
                        model="s_f_y_hooker_02",
                        type="PED",
                    },
                    {
                        name="Hooker 3",
                        model="s_f_y_hooker_03",
                        type="PED",
                    },
                    {
                        name="Migrant",
                        model="s_f_y_migrant_01",
                        type="PED",
                    },
                    {
                        name="Movie Premier",
                        model="s_f_y_movprem_01",
                        type="PED",
                    },
                    {
                        name="Ranger",
                        model="s_f_y_ranger_01",
                        type="PED",
                    },
                    {
                        name="Nurse Scrubs",
                        model="s_f_y_scrubs_01",
                        type="PED",
                    },
                    {
                        name="Sheriff",
                        model="s_f_y_sheriff_01",
                        type="PED",
                    },
                    {
                        name="Low End Shop Keeper",
                        model="s_f_y_shop_low",
                        type="PED",
                    },
                    {
                        name="Mid Level Shop Keeper",
                        model="s_f_y_shop_mid",
                        type="PED",
                    },
                    {
                        name="Stripper 1",
                        model="s_f_y_stripper_01",
                        type="PED",
                    },
                    {
                        name="Stripper 2",
                        model="s_f_y_stripper_02",
                        type="PED",
                    },
                    {
                        name="Stripper 3",
                        model="s_f_y_stripperlite",
                        type="PED",
                    },
                    {
                        name="Sweat Shop 2",
                        model="s_f_y_sweatshop_01",
                        type="PED",
                    },
                }
            },
            {
                name="MP Scenario Males",
                is_folder = true,
                items = {
                    {
                        name="Male Ammunation Clerk 1",
                        model="s_m_m_ammucountry",
                        type="PED",
                    },
                    {
                        name="Armoured Male 1",
                        model="s_m_m_armoured_01",
                        type="PED",
                    },
                    {
                        name="Armoured Male 2",
                        model="s_m_m_armoured_02",
                        type="PED",
                    },
                    {
                        name="Autoshop 1",
                        model="s_m_m_autoshop_01",
                        type="PED",
                    },
                    {
                        name="Autoshop 2",
                        model="s_m_m_autoshop_02",
                        type="PED",
                    },
                    {
                        name="Bouncer",
                        model="s_m_m_bouncer_01",
                        type="PED",
                    },
                    {
                        name="Aircraft Carrier Crew",
                        model="s_m_m_ccrew_01",
                        type="PED",
                    },
                    {
                        name="Chem Plant Security",
                        model="s_m_m_chemsec_01",
                        type="PED",
                    },
                    {
                        name="CIA Security",
                        model="s_m_m_ciasec_01",
                        type="PED",
                    },
                    {
                        name="Country Bartender",
                        model="s_m_m_cntrybar_01",
                        type="PED",
                    },
                    {
                        name="Dock Worker",
                        model="s_m_m_dockwork_01",
                        type="PED",
                    },
                    {
                        name="Doctor",
                        model="s_m_m_doctor_01",
                        type="PED",
                    },
                    {
                        name="FIB Office Worker 1",
                        model="s_m_m_fiboffice_01",
                        type="PED",
                    },
                    {
                        name="FIB Office Worker 2",
                        model="s_m_m_fiboffice_02",
                        type="PED",
                    },
                    {
                        name="FIB Security",
                        model="s_m_m_fibsec_01",
                        type="PED",
                    },
                    {
                        name="Gaffer",
                        model="s_m_m_gaffer_01",
                        type="PED",
                    },
                    {
                        name="Gardener",
                        model="s_m_m_gardener_01",
                        type="PED",
                    },
                    {
                        name="General Transport Worker",
                        model="s_m_m_gentransport",
                        type="PED",
                    },
                    {
                        name="Hair Dresser",
                        model="s_m_m_hairdress_01",
                        type="PED",
                    },
                    {
                        name="Highend Security 1",
                        model="s_m_m_highsec_01",
                        type="PED",
                    },
                    {
                        name="Highend Security 2",
                        model="s_m_m_highsec_02",
                        type="PED",
                    },
                    {
                        name="Janitor",
                        model="s_m_m_janitor",
                        type="PED",
                    },
                    {
                        name="Latino Handyman",
                        model="s_m_m_lathandy_01",
                        type="PED",
                    },
                    {
                        name="Life Invader",
                        model="s_m_m_lifeinvad_01",
                        type="PED",
                    },
                    {
                        name="Line Cook",
                        model="s_m_m_linecook",
                        type="PED",
                    },
                    {
                        name="LS metro",
                        model="s_m_m_lsmetro_01",
                        type="PED",
                    },
                    {
                        name="Mariachi Band",
                        model="s_m_m_mariachi_01",
                        type="PED",
                    },
                    {
                        name="Marine 1",
                        model="s_m_m_marine_01",
                        type="PED",
                    },
                    {
                        name="Marine2",
                        model="s_m_m_marine_02",
                        type="PED",
                    },
                    {
                        name="Migrant",
                        model="s_m_m_migrant_01",
                        type="PED",
                    },
                    {
                        name="Alien Costume",
                        model="s_m_m_movalien_01",
                        type="PED",
                    },
                    {
                        name="Movie Premier",
                        model="s_m_m_movprem_01",
                        type="PED",
                    },
                    {
                        name="Movie Astronaut",
                        model="s_m_m_movspace_01",
                        type="PED",
                    },
                    {
                        name="Paramedic",
                        model="s_m_m_paramedic_01",
                        type="PED",
                    },
                    {
                        name="Pilot 1",
                        model="s_m_m_pilot_01",
                        type="PED",
                    },
                    {
                        name="Pilot 2",
                        model="s_m_m_pilot_02",
                        type="PED",
                    },
                    {
                        name="Postal 1",
                        model="s_m_m_postal_01",
                        type="PED",
                    },
                    {
                        name="Postal 2",
                        model="s_m_m_postal_02",
                        type="PED",
                    },
                    {
                        name="Prison Guard",
                        model="s_m_m_prisguard_01",
                        type="PED",
                    },
                    {
                        name="Scientist",
                        model="s_m_m_scientist_01",
                        type="PED",
                    },
                    {
                        name="Security Guard",
                        model="s_m_m_security_01",
                        type="PED",
                    },
                    {
                        name="Snow Cop",
                        model="s_m_m_snowcop_01",
                        type="PED",
                    },
                    {
                        name="Street Performer",
                        model="s_m_m_strperf_01",
                        type="PED",
                    },
                    {
                        name="Street Preacher",
                        model="s_m_m_strpreach_01",
                        type="PED",
                    },
                    {
                        name="Street Vendor",
                        model="s_m_m_strvend_01",
                        type="PED",
                    },
                    {
                        name="Trucker",
                        model="s_m_m_trucker_01",
                        type="PED",
                    },
                    {
                        name="Ups 1",
                        model="s_m_m_ups_01",
                        type="PED",
                    },
                    {
                        name="Ups 2",
                        model="s_m_m_ups_02",
                        type="PED",
                    },
                    {
                        name="Busker",
                        model="s_m_o_busker_01",
                        type="PED",
                    },
                    {
                        name="Airline Worker",
                        model="s_m_y_airworker",
                        type="PED",
                    },
                    {
                        name="Ammunation City",
                        model="s_m_y_ammucity_01",
                        type="PED",
                    },
                    {
                        name="Army Mechanic",
                        model="s_m_y_armymech_01",
                        type="PED",
                    },
                    {
                        name="Autopsy Doc",
                        model="s_m_y_autopsy_01",
                        type="PED",
                    },
                    {
                        name="Bartender",
                        model="s_m_y_barman_01",
                        type="PED",
                    },
                    {
                        name="Lifguard",
                        model="s_m_y_baywatch_01",
                        type="PED",
                    },
                    {
                        name="Blackops 1",
                        model="s_m_y_blackops_01",
                        type="PED",
                    },
                    {
                        name="Blackops 2",
                        model="s_m_y_blackops_02",
                        type="PED",
                    },
                    {
                        name="Blackops 3",
                        model="s_m_y_blackops_03",
                        type="PED",
                    },
                    {
                        name="Busboy",
                        model="s_m_y_busboy_01",
                        type="PED",
                    },
                    {
                        name="Chef",
                        model="s_m_y_chef_01",
                        type="PED",
                    },
                    {
                        name="Clown",
                        model="s_m_y_clown_01",
                        type="PED",
                    },
                    {
                        name="Construction 1",
                        model="s_m_y_construct_01",
                        type="PED",
                    },
                    {
                        name="Construction 2",
                        model="s_m_y_construct_02",
                        type="PED",
                    },
                    {
                        name="Cop",
                        model="s_m_y_cop_01",
                        type="PED",
                    },
                    {
                        name="Dealer",
                        model="s_m_y_dealer_01",
                        type="PED",
                    },
                    {
                        name="Devin Security",
                        model="s_m_y_devinsec_01",
                        type="PED",
                    },
                    {
                        name="Dock Worker",
                        model="s_m_y_dockwork_01",
                        type="PED",
                    },
                    {
                        name="Doorman",
                        model="s_m_y_doorman_01",
                        type="PED",
                    },
                    {
                        name="Airport Service 1",
                        model="s_m_y_dwservice_01",
                        type="PED",
                    },
                    {
                        name="Airport Service ",
                        model="s_m_y_dwservice_02",
                        type="PED",
                    },
                    {
                        name="Factory Worker",
                        model="s_m_y_factory_01",
                        type="PED",
                    },
                    {
                        name="Fireman",
                        model="s_m_y_fireman_01",
                        type="PED",
                    },
                    {
                        name="Garbage Collector",
                        model="s_m_y_garbage",
                        type="PED",
                    },
                    {
                        name="Vinewood Grip",
                        model="s_m_y_grip_01",
                        type="PED",
                    },
                    {
                        name="Highway Cop",
                        model="s_m_y_hwaycop_01",
                        type="PED",
                    },
                    {
                        name="Young Marine 1",
                        model="s_m_y_marine_01",
                        type="PED",
                    },
                    {
                        name="Young Marine 2",
                        model="s_m_y_marine_02",
                        type="PED",
                    },
                    {
                        name="Young Marine 3",
                        model="s_m_y_marine_03",
                        type="PED",
                    },
                    {
                        name="Mime",
                        model="s_m_y_mime",
                        type="PED",
                    },
                    {
                        name="Pest Control",
                        model="s_m_y_pestcont_01",
                        type="PED",
                    },
                    {
                        name="Pilot",
                        model="s_m_y_pilot_01",
                        type="PED",
                    },
                    {
                        name="Prisoner Muscular",
                        model="s_m_y_prismuscl_01",
                        type="PED",
                    },
                    {
                        name="Prisoner",
                        model="s_m_y_prisoner_01",
                        type="PED",
                    },
                    {
                        name="Ranger",
                        model="s_m_y_ranger_01",
                        type="PED",
                    },
                    {
                        name="Robber",
                        model="s_m_y_robber_01",
                        type="PED",
                    },
                    {
                        name="Sheriff",
                        model="s_m_y_sheriff_01",
                        type="PED",
                    },
                    {
                        name="Shop Mask Vendor",
                        model="s_m_y_shop_mask",
                        type="PED",
                    },
                    {
                        name="Young street Vendor",
                        model="s_m_y_strvend_01",
                        type="PED",
                    },
                    {
                        name="SWAT",
                        model="s_m_y_swat_01",
                        type="PED",
                    },
                    {
                        name="US Coast Guard",
                        model="s_m_y_uscg_01",
                        type="PED",
                    },
                    {
                        name="Valet",
                        model="s_m_y_valet_01",
                        type="PED",
                    },
                    {
                        name="Waiter",
                        model="s_m_y_waiter_01",
                        type="PED",
                    },
                    {
                        name="Window Cleaner",
                        model="s_m_y_winclean_01",
                        type="PED",
                    },
                    {
                        name="Mechanic",
                        model="s_m_y_xmech_01",
                        type="PED",
                    },
                    {
                        name="Mechanic MP",
                        model="s_m_y_xmech_02_mp",
                        type="PED",
                    },

                }
            },
            {
                name="Story Mode",
                is_folder = true,
                items = {
                    {
                        name="Heist Crew Driver",
                        model="hc_driver",
                        type="PED",
                    },
                    {
                        name="Heist Crew Gunman",
                        model="hc_gunman",
                        type="PED",
                    },
                    {
                        name="Heist Crew Hacker",
                        model="hc_hacker",
                        type="PED",
                    },
                    {
                        name="Abigail",
                        model="ig_abigail",
                        type="PED",
                    },
                    {
                        name="Agent",
                        model="ig_agent",
                        type="PED",
                    },
                    {
                        name="Amanda Townley",
                        model="ig_amandatownley",
                        type="PED",
                    },
                    {
                        name="Andreas",
                        model="ig_andreas",
                        type="PED",
                    },
                    {
                        name="Ashley",
                        model="ig_ashley",
                        type="PED",
                    },
                    {
                        name="Avon",
                        model="ig_avon",
                        type="PED",
                    },
                    {
                        name="Ballas OG",
                        model="ig_ballasog",
                        type="PED",
                    },
                    {
                        name="Bankman",
                        model="ig_bankman",
                        type="PED",
                    },
                    {
                        name="Barry",
                        model="ig_barry",
                        type="PED",
                    },
                    {
                        name="Benny",
                        model="ig_benny",
                        type="PED",
                    },
                    {
                        name="Bestmen Wedding",
                        model="ig_bestmen",
                        type="PED",
                    },
                    {
                        name="Beverly",
                        model="ig_beverly",
                        type="PED",
                    },
                    {
                        name="Brad",
                        model="ig_brad",
                        type="PED",
                    },
                    {
                        name="Bride",
                        model="ig_bride",
                        type="PED",
                    },
                    {
                        name="Car Guy 1",
                        model="ig_car3guy1",
                        type="PED",
                    },
                    {
                        name="Car Guy 2",
                        model="ig_car3guy2",
                        type="PED",
                    },
                    {
                        name="Casey",
                        model="ig_casey",
                        type="PED",
                    },
                    {
                        name="Chef",
                        model="ig_chef",
                        type="PED",
                    },
                    {
                        name="Chef 2",
                        model="ig_chef2",
                        type="PED",
                    },
                    {
                        name="Cheng SR",
                        model="ig_chengsr",
                        type="PED",
                    },
                    {
                        name="Chris Formage",
                        model="ig_chrisformage",
                        type="PED",
                    },
                    {
                        name="Clay",
                        model="ig_clay",
                        type="PED",
                    },
                    {
                        name="Clay Pain",
                        model="ig_claypain",
                        type="PED",
                    },
                    {
                        name="Cletus",
                        model="ig_cletus",
                        type="PED",
                    },
                    {
                        name="Dale",
                        model="ig_dale",
                        type="PED",
                    },
                    {
                        name="Dave Norton",
                        model="ig_davenorton",
                        type="PED",
                    },
                    {
                        name="Denise",
                        model="ig_denise",
                        type="PED",
                    },
                    {
                        name="Devin",
                        model="ig_devin",
                        type="PED",
                    },
                    {
                        name="Dom",
                        model="ig_dom",
                        type="PED",
                    },
                    {
                        name="Peter Dreyfuss",
                        model="ig_dreyfuss",
                        type="PED",
                    },
                    {
                        name="Dr Friedlander",
                        model="ig_drfriedlander",
                        type="PED",
                    },
                    {
                        name="Fabien",
                        model="ig_fabien",
                        type="PED",
                    },
                    {
                        name="Fbi Suit",
                        model="ig_fbisuit_01",
                        type="PED",
                    },
                    {
                        name="Floyd",
                        model="ig_floyd",
                        type="PED",
                    },
                    {
                        name="Franklin",
                        model="player_one",
                        type="PED",
                    },
                    {
                        name="Gerald",
                        model="ig_g",
                        type="PED",
                    },
                    {
                        name="Groom",
                        model="ig_groom",
                        type="PED",
                    },
                    {
                        name="Hao",
                        model="ig_hao",
                        type="PED",
                    },
                    {
                        name="Hunter",
                        model="ig_hunter",
                        type="PED",
                    },
                    {
                        name="Janet",
                        model="ig_janet",
                        type="PED",
                    },
                    {
                        name="Jay Norris",
                        model="ig_jay_norris",
                        type="PED",
                    },
                    {
                        name="Jewel Assitant",
                        model="ig_jewelass",
                        type="PED",
                    },
                    {
                        name="Jimmy Boston",
                        model="ig_jimmyboston",
                        type="PED",
                    },
                    {
                        name="Jimmy Disanto",
                        model="ig_jimmydisanto",
                        type="PED",
                    },
                    {
                        name="Joe Minuteman",
                        model="ig_joeminuteman",
                        type="PED",
                    },
                    {
                        name="Johnny Klebitz",
                        model="ig_johnnyklebitz",
                        type="PED",
                    },
                    {
                        name="Jose",
                        model="ig_josef",
                        type="PED",
                    },
                    {
                        name="Josh",
                        model="ig_josh",
                        type="PED",
                    },
                    {
                        name="Karen Daniels",
                        model="ig_karen_daniels",
                        type="PED",
                    },
                    {
                        name="Kerry Mcintosh",
                        model="ig_kerrymcintosh",
                        type="PED",
                    },
                    {
                        name="Lamar Davis",
                        model="ig_lamardavis",
                        type="PED",
                    },
                    {
                        name="Lazlow",
                        model="ig_lazlow",
                        type="PED",
                    },
                    {
                        name="Lester Crest",
                        model="ig_lestercrest",
                        type="PED",
                    },
                    {
                        name="Lester Crest 2",
                        model="ig_lestercrest_2",
                        type="PED",
                    },
                    {
                        name="Rickie Lukens",
                        model="ig_lifeinvad_01",
                        type="PED",
                    },
                    {
                        name="Lifeinvader Employee",
                        model="ig_lifeinvad_02",
                        type="PED",
                    },
                    {
                        name="Magenta",
                        model="ig_magenta",
                        type="PED",
                    },
                    {
                        name="Malc",
                        model="ig_malc",
                        type="PED",
                    },
                    {
                        name="Manuel",
                        model="ig_manuel",
                        type="PED",
                    },
                    {
                        name="Marnie",
                        model="ig_marnie",
                        type="PED",
                    },
                    {
                        name="Mary Ann",
                        model="ig_maryann",
                        type="PED",
                    },
                    {
                        name="Maude",
                        model="ig_maude",
                        type="PED",
                    },
                    {
                        name="Michael",
                        model="player_zero",
                        type="PED",
                    },
                    {
                        name="Michelle",
                        model="ig_michelle",
                        type="PED",
                    },
                    {
                        name="Milton",
                        model="ig_milton",
                        type="PED",
                    },
                    {
                        name="Molly",
                        model="ig_molly",
                        type="PED",
                    },
                    {
                        name="Money",
                        model="ig_money",
                        type="PED",
                    },
                    {
                        name="MP Agent 14",
                        model="ig_mp_agent14",
                        type="PED",
                    },
                    {
                        name="Torture Victim",
                        model="ig_mrk",
                        type="PED",
                    },
                    {
                        name="Mrs Thornhill",
                        model="ig_mrs_thornhill",
                        type="PED",
                    },
                    {
                        name="Mrs Phillips",
                        model="ig_mrsphillips",
                        type="PED",
                    },
                    {
                        name="Natalia",
                        model="ig_natalia",
                        type="PED",
                    },
                    {
                        name="Nervous Ron",
                        model="ig_nervousron",
                        type="PED",
                    },
                    {
                        name="Nigel",
                        model="ig_nigel",
                        type="PED",
                    },
                    {
                        name="Old Man 1",
                        model="ig_old_man1",
                        type="PED",
                    },
                    {
                        name="Old Man 2",
                        model="ig_old_man2",
                        type="PED",
                    },
                    {
                        name="Omega",
                        model="ig_omega",
                        type="PED",
                    },
                    {
                        name="Oneil Brothers",
                        model="ig_oneil",
                        type="PED",
                    },
                    {
                        name="Bigfoot",
                        model="ig_orleans",
                        type="PED",
                    },
                    {
                        name="Ortega",
                        model="ig_ortega",
                        type="PED",
                    },
                    {
                        name="Paige",
                        model="ig_paige",
                        type="PED",
                    },
                    {
                        name="Agent ULP",
                        model="ig_paper",
                        type="PED",
                    },
                    {
                        name="Patricia",
                        model="ig_patricia",
                        type="PED",
                    },
                    {
                        name="Dima Popov",
                        model="ig_popov",
                        type="PED",
                    },
                    {
                        name="Priest",
                        model="ig_priest",
                        type="PED",
                    },
                    {
                        name="Prologue Security",
                        model="ig_prolsec_02",
                        type="PED",
                    },
                    {
                        name="Rampage Gang",
                        model="ig_ramp_gang",
                        type="PED",
                    },
                    {
                        name="Rampage Hics",
                        model="ig_ramp_hic",
                        type="PED",
                    },
                    {
                        name="Rampage Hipsters",
                        model="ig_ramp_hipster",
                        type="PED",
                    },
                    {
                        name="Rampage Vagos",
                        model="ig_ramp_mex",
                        type="PED",
                    },
                    {
                        name="Rashcosvki",
                        model="ig_rashcosvki",
                        type="PED",
                    },
                    {
                        name="Rocco Pelosi",
                        model="ig_roccopelosi",
                        type="PED",
                    },
                    {
                        name="Russian Drunk",
                        model="ig_russiandrunk",
                        type="PED",
                    },
                    {
                        name="Sacha",
                        model="ig_sacha",
                        type="PED",
                    },
                    {
                        name="Screen Writer",
                        model="ig_screen_writer",
                        type="PED",
                    },
                    {
                        name="Simeon Yetarian",
                        model="ig_siemonyetarian",
                        type="PED",
                    },
                    {
                        name="Solomon",
                        model="ig_solomon",
                        type="PED",
                    },
                    {
                        name="Steve Hains",
                        model="ig_stevehains",
                        type="PED",
                    },
                    {
                        name="Stretch",
                        model="ig_stretch",
                        type="PED",
                    },
                    {
                        name="Talina",
                        model="ig_talina",
                        type="PED",
                    },
                    {
                        name="Tanisha",
                        model="ig_tanisha",
                        type="PED",
                    },
                    {
                        name="Tao Cheng",
                        model="ig_taocheng",
                        type="PED",
                    },
                    {
                        name="Taos Translator",
                        model="ig_taostranslator",
                        type="PED",
                    },
                    {
                        name="Tennis Coach",
                        model="ig_tenniscoach",
                        type="PED",
                    },
                    {
                        name="Terry",
                        model="ig_terry",
                        type="PED",
                    },
                    {
                        name="Tom Epsilon",
                        model="ig_tomepsilon",
                        type="PED",
                    },
                    {
                        name="Tonya",
                        model="ig_tonya",
                        type="PED",
                    },
                    {
                        name="Tracy Disanto",
                        model="ig_tracydisanto",
                        type="PED",
                    },
                    {
                        name="Traffic Warden",
                        model="ig_trafficwarden",
                        type="PED",
                    },
                    {
                        name="Trevor",
                        model="player_two",
                        type="PED",
                    },
                    {
                        name="Tyler Dix",
                        model="ig_tylerdix",
                        type="PED",
                    },
                    {
                        name="Vagos Funeral",
                        model="ig_vagspeak",
                        type="PED",
                    },
                    {
                        name="Wade",
                        model="ig_wade",
                        type="PED",
                    },
                    {
                        name="Zimbor",
                        model="ig_zimbor",
                        type="PED",
                    },


                }
            },
            {
                name="Story Scenario Females",
                is_folder = true,
                items = {
                    {
                        name="Corpse 1",
                        model="u_f_m_corpse_01",
                        type="PED",
                    },
                    {
                        name="Drowned Body",
                        model="u_f_m_drowned_01",
                        type="PED",
                    },
                    {
                        name="Miranda",
                        model="u_f_m_miranda",
                        type="PED",
                    },
                    {
                        name="Mourner",
                        model="u_f_m_promourn_01",
                        type="PED",
                    },
                    {
                        name="Movie Star",
                        model="u_f_o_moviestar",
                        type="PED",
                    },
                    {
                        name="Prologue Hostage",
                        model="u_f_o_prolhost_01",
                        type="PED",
                    },
                    {
                        name="Biker Chic",
                        model="u_f_y_bikerchic",
                        type="PED",
                    },
                    {
                        name="Jane",
                        model="u_f_y_comjane",
                        type="PED",
                    },
                    {
                        name="Corpse 2",
                        model="u_f_y_corpse_01",
                        type="PED",
                    },
                    {
                        name="Corpse 3",
                        model="u_f_y_corpse_02",
                        type="PED",
                    },
                    {
                        name="Posh Female",
                        model="u_f_y_hotposh_01",
                        type="PED",
                    },
                    {
                        name="Jewel Store Assistant",
                        model="u_f_y_jewelass_01",
                        type="PED",
                    },
                    {
                        name="Mistress",
                        model="u_f_y_mistress",
                        type="PED",
                    },
                    {
                        name="Poppy Mitchell",
                        model="u_f_y_poppymich",
                        type="PED",
                    },
                    {
                        name="Princess",
                        model="u_f_y_princess",
                        type="PED",
                    },
                    {
                        name="Spy Actress",
                        model="u_f_y_spyactress",
                        type="PED",
                    },
                }
            },
            {
                name="Story Scenario Males",
                is_folder = true,
                items = {
                    {
                        name="Al Di Napoli",
                        model="u_m_m_aldinapoli",
                        type="PED",
                    },
                    {
                        name="Bank Manager",
                        model="u_m_m_bankman",
                        type="PED",
                    },
                    {
                        name="Bike Hire",
                        model="u_m_m_bikehire_01",
                        type="PED",
                    },
                    {
                        name="DOA Agent",
                        model="u_m_m_doa_01",
                        type="PED",
                    },
                    {
                        name="Eddie Toh",
                        model="u_m_m_edtoh",
                        type="PED",
                    },
                    {
                        name="FIB Architect",
                        model="u_m_m_fibarchitect",
                        type="PED",
                    },
                    {
                        name="Film Director",
                        model="u_m_m_filmdirector",
                        type="PED",
                    },
                    {
                        name="Glen Stank",
                        model="u_m_m_glenstank_01",
                        type="PED",
                    },
                    {
                        name="Griff",
                        model="u_m_m_griff_01",
                        type="PED",
                    },
                    {
                        name="Jesus",
                        model="u_m_m_jesus_01",
                        type="PED",
                    },
                    {
                        name="Jewelery Security",
                        model="u_m_m_jewelsec_01",
                        type="PED",
                    },
                    {
                        name="Jewel Thief",
                        model="u_m_m_jewelthief",
                        type="PED",
                    },
                    {
                        name="Mark Fostenburg",
                        model="u_m_m_markfost",
                        type="PED",
                    },
                    {
                        name="Party Target",
                        model="u_m_m_partytarget",
                        type="PED",
                    },
                    {
                        name="Prologue Security",
                        model="u_m_m_prolsec_01",
                        type="PED",
                    },
                    {
                        name="Prologue Mourn Male",
                        model="u_m_m_promourn_01",
                        type="PED",
                    },
                    {
                        name="Rival Paparazzo",
                        model="u_m_m_rivalpap",
                        type="PED",
                    },
                    {
                        name="Spy Actor",
                        model="u_m_m_spyactor",
                        type="PED",
                    },
                    {
                        name="Street Artist",
                        model="u_m_m_streetart_01",
                        type="PED",
                    },
                    {
                        name="Love Fist Willy",
                        model="u_m_m_willyfist",
                        type="PED",
                    },
                    {
                        name="Film Noir",
                        model="u_m_o_filmnoir",
                        type="PED",
                    },
                    {
                        name="Financial Guru",
                        model="u_m_o_finguru_01",
                        type="PED",
                    },
                    {
                        name="Tap Dancing Hillbilly",
                        model="u_m_o_taphillbilly",
                        type="PED",
                    },
                    {
                        name="Old Male Tramp",
                        model="u_m_o_tramp_01",
                        type="PED",
                    },
                    {
                        name="Abner",
                        model="u_m_y_abner",
                        type="PED",
                    },
                    {
                        name="Anton Beaudelaire",
                        model="u_m_y_antonb",
                        type="PED",
                    },
                    {
                        name="Baby D",
                        model="u_m_y_babyd",
                        type="PED",
                    },
                    {
                        name="Baygor(kifflom)",
                        model="u_m_y_baygor",
                        type="PED",
                    },
                    {
                        name="Burgershot Drug Dealer",
                        model="u_m_y_burgerdrug_01",
                        type="PED",
                    },
                    {
                        name="Chip",
                        model="u_m_y_chip",
                        type="PED",
                    },
                    {
                        name="Male Corpse 1",
                        model="u_m_y_corpse_01",
                        type="PED",
                    },
                    {
                        name="Male Cyclist",
                        model="u_m_y_cyclist_01",
                        type="PED",
                    },
                    {
                        name="FIB Mugger",
                        model="u_m_y_fibmugger_01",
                        type="PED",
                    },
                    {
                        name="Guido",
                        model="u_m_y_guido_01",
                        type="PED",
                    },
                    {
                        name="Gun Vendor",
                        model="u_m_y_gunvend_01",
                        type="PED",
                    },
                    {
                        name="Hippie",
                        model="u_m_y_hippie_01",
                        type="PED",
                    },
                    {
                        name="Impotent Rage",
                        model="u_m_y_imporage",
                        type="PED",
                    },
                    {
                        name="Juggernaut",
                        model="u_m_y_juggernaut_01",
                        type="PED",
                    },
                    {
                        name="Justin",
                        model="u_m_y_justin",
                        type="PED",
                    },
                    {
                        name="Mani",
                        model="u_m_y_mani",
                        type="PED",
                    },
                    {
                        name="Military Bum",
                        model="u_m_y_militarybum",
                        type="PED",
                    },
                    {
                        name="Paparazzi",
                        model="u_m_y_paparazzi",
                        type="PED",
                    },
                    {
                        name="Party",
                        model="u_m_y_party_01",
                        type="PED",
                    },
                    {
                        name="Pogo",
                        model="u_m_y_pogo_01",
                        type="PED",
                    },
                    {
                        name="Prisoner",
                        model="u_m_y_prisoner_01",
                        type="PED",
                    },
                    {
                        name="Prologue Driver",
                        model="u_m_y_proldriver_01",
                        type="PED",
                    },
                    {
                        name="Republican Space Ranger",
                        model="u_m_y_rsranger_01",
                        type="PED",
                    },
                    {
                        name="Sports Bike Rider",
                        model="u_m_y_sbike",
                        type="PED",
                    },
                    {
                        name="Hanger Mechanic",
                        model="u_m_y_smugmech_01",
                        type="PED",
                    },
                    {
                        name="Groom Stag Party",
                        model="u_m_y_staggrm_01",
                        type="PED",
                    },
                    {
                        name="Tattoo Artist",
                        model="u_m_y_tattoo_01",
                        type="PED",
                    },
                    {
                        name="Zombie",
                        model="u_m_y_zombie_01",
                        type="PED",
                    },
                }
            },
            {
                name="DLC",
                is_folder = true,
                items = {
                    {
                        name="Female Club Customer 1",
                        model="a_f_y_clubcust_01",
                        type="PED",
                    },
                    {
                        name="Female Club Customer 2",
                        model="a_f_y_clubcust_02",
                        type="PED",
                    },
                    {
                        name="Female Club Customer 3",
                        model="a_f_y_clubcust_03",
                        type="PED",
                    },
                    {
                        name="Male Club Customer 1",
                        model="a_m_y_clubcust_01",
                        type="PED",
                    },
                    {
                        name="Male Club Customer 2",
                        model="a_m_y_clubcust_02",
                        type="PED",
                    },
                    {
                        name="Male Club Customer 3",
                        model="a_m_y_clubcust_03",
                        type="PED",
                    },
                    {
                        name="Dixon",
                        model="ig_dix",
                        type="PED",
                    },
                    {
                        name="DJ the Black Madonna",
                        model="ig_djblamadon",
                        type="PED",
                    },
                    {
                        name="ig_djblamrupert",
                        model="ig_djblamrupert",
                        type="PED",
                    },
                    {
                        name="ig_djblamryanh",
                        model="ig_djblamryanh",
                        type="PED",
                    },
                    {
                        name="ig_djblamryans",
                        model="ig_djblamryans",
                        type="PED",
                    },
                    {
                        name="Dixon Manager",
                        model="ig_djdixmanager",
                        type="PED",
                    },
                    {
                        name="ig_djgeneric_01",
                        model="ig_djgeneric_01",
                        type="PED",
                    },
                    {
                        name="ig_djsolfotios",
                        model="ig_djsolfotios",
                        type="PED",
                    },
                    {
                        name="ig_djsoljakob",
                        model="ig_djsoljakob",
                        type="PED",
                    },
                    {
                        name="DJ Solomun Manager",
                        model="ig_djsolmanager",
                        type="PED",
                    },
                    {
                        name="ig_djsolmike",
                        model="ig_djsolmike",
                        type="PED",
                    },
                    {
                        name="ig_djsolrobt",
                        model="ig_djsolrobt",
                        type="PED",
                    },
                    {
                        name="ig_djtalaurelia",
                        model="ig_djtalaurelia",
                        type="PED",
                    },
                    {
                        name="ig_djtalignazio",
                        model="ig_djtalignazio",
                        type="PED",
                    },
                    {
                        name="English Dave",
                        model="ig_englishdave",
                        type="PED",
                    },
                    {
                        name="Jimmy Boston 2",
                        model="ig_jimmyboston_02",
                        type="PED",
                    },
                    {
                        name="Kerry Mcintosh 2",
                        model="ig_kerrymcintosh_02",
                        type="PED",
                    },
                    {
                        name="Lacey Jones 2",
                        model="ig_lacey_jones_02",
                        type="PED",
                    },
                    {
                        name="Lazlow 2",
                        model="ig_lazlow_2",
                        type="PED",
                    },
                    {
                        name="Solomun",
                        model="ig_sol",
                        type="PED",
                    },
                    {
                        name="ig_talcc",
                        model="ig_talcc",
                        type="PED",
                    },
                    {
                        name="ig_talmm",
                        model="ig_talmm",
                        type="PED",
                    },
                    {
                        name="Tony Prince",
                        model="ig_tonyprince",
                        type="PED",
                    },
                    {
                        name="Tyler Dix",
                        model="ig_tylerdix_02",
                        type="PED",
                    },
                    {
                        name="Female Club Bar",
                        model="s_f_y_clubbar_01",
                        type="PED",
                    },
                    {
                        name="Male Club Bar",
                        model="s_m_y_clubbar_01",
                        type="PED",
                    },
                    {
                        name="Warehouse Tech",
                        model="s_m_y_waretech_01",
                        type="PED",
                    },
                    {
                        name="Miranda 2",
                        model="u_f_m_miranda_02",
                        type="PED",
                    },
                    {
                        name="u_f_y_danceburl_01",
                        model="u_f_y_danceburl_01",
                        type="PED",
                    },
                    {
                        name="u_f_y_dancelthr_01",
                        model="u_f_y_dancelthr_01",
                        type="PED",
                    },
                    {
                        name="u_f_y_dancerave_01",
                        model="u_f_y_dancerave_01",
                        type="PED",
                    },
                    {
                        name="Poppy Mitchell",
                        model="u_f_y_poppymich_02",
                        type="PED",
                    },
                    {
                        name="u_m_y_danceburl_01",
                        model="u_m_y_danceburl_01",
                        type="PED",
                    },
                    {
                        name="u_m_y_dancelthr_01",
                        model="u_m_y_dancelthr_01",
                        type="PED",
                    },
                    {
                        name="u_m_y_dancerave_01",
                        model="u_m_y_dancerave_01",
                        type="PED",
                    },
                    {
                        name="Agatha",
                        model="IG_Agatha",
                        type="PED",
                    },
                    {
                        name="Avery",
                        model="IG_Avery",
                        type="PED",
                    },
                    {
                        name="Brucie 2",
                        model="IG_Brucie2",
                        type="PED",
                    },
                    {
                        name="Tao Cheng 2",
                        model="IG_TaoCheng2",
                        type="PED",
                    },
                    {
                        name="Taos Translator 2",
                        model="IG_TaosTranslator2",
                        type="PED",
                    },
                    {
                        name="Thornton",
                        model="IG_Thornton",
                        type="PED",
                    },
                    {
                        name="Tom Connors",
                        model="IG_TomCasino",
                        type="PED",
                    },
                    {
                        name="Vincent",
                        model="IG_Vincent",
                        type="PED",
                    },
                    {
                        name="Female General Casino",
                        model="A_F_Y_GenCasPat_01",
                        type="PED",
                    },
                    {
                        name="Female Smart Casino",
                        model="A_F_Y_SmartCasPat_01",
                        type="PED",
                    },
                    {
                        name="A_M_M_MLCrisis_01",
                        model="A_M_M_MLCrisis_01",
                        type="PED",
                    },
                    {
                        name="Male General Casino",
                        model="A_M_Y_GenCasPat_01",
                        type="PED",
                    },
                    {
                        name="Male Smart Casino",
                        model="A_M_Y_SmartCasPat_01",
                        type="PED",
                    },
                    {
                        name="G_M_M_CasRN_01",
                        model="G_M_M_CasRN_01",
                        type="PED",
                    },
                    {
                        name="S_M_Y_WestSec_01",
                        model="S_M_Y_WestSec_01",
                        type="PED",
                    },
                    {
                        name="Female Casino",
                        model="S_F_Y_Casino_01",
                        type="PED",
                    },
                    {
                        name="Male Casino",
                        model="S_M_Y_Casino_01",
                        type="PED",
                    },
                    {
                        name="Carol",
                        model="U_F_O_Carol",
                        type="PED",
                    },
                    {
                        name="Eileen",
                        model="U_F_O_Eileen",
                        type="PED",
                    },
                    {
                        name="Casino Cashier",
                        model="U_F_M_CasinoCash_01",
                        type="PED",
                    },
                    {
                        name="Casino Shop Clerk",
                        model="U_F_M_CasinoShop_01",
                        type="PED",
                    },
                    {
                        name="Debbie",
                        model="U_F_M_Debbie_01",
                        type="PED",
                    },
                    {
                        name="Beth",
                        model="U_F_Y_Beth",
                        type="PED",
                    },
                    {
                        name="Lauren",
                        model="U_F_Y_Lauren",
                        type="PED",
                    },
                    {
                        name="Taylor",
                        model="U_F_Y_Taylor",
                        type="PED",
                    },
                    {
                        name="Blane",
                        model="U_M_M_Blane",
                        type="PED",
                    },
                    {
                        name="Curtis",
                        model="U_M_M_Curtis",
                        type="PED",
                    },
                    {
                        name="Vince",
                        model="U_M_M_Vince",
                        type="PED",
                    },
                    {
                        name="Dean",
                        model="U_M_O_Dean",
                        type="PED",
                    },
                    {
                        name="Caleb",
                        model="U_M_Y_Caleb",
                        type="PED",
                    },
                    {
                        name="CroupThief_01",
                        model="CroupThief_01",
                        type="PED",
                    },
                    {
                        name="Gabriel",
                        model="U_M_Y_Gabriel",
                        type="PED",
                    },
                    {
                        name="Ushi",
                        model="U_M_Y_Ushi",
                        type="PED",
                    },
                    {
                        name="a_f_y_bevhills_05",
                        model="a_f_y_bevhills_05",
                        type="PED",
                    },
                    {
                        name="ig_celeb_01",
                        model="ig_celeb_01",
                        type="PED",
                    },
                    {
                        name="Georgina Cheng",
                        model="ig_georginacheng",
                        type="PED",
                    },
                    {
                        name="Huang",
                        model="ig_huang",
                        type="PED",
                    },
                    {
                        name="Jimmy Disanto 2",
                        model="ig_jimmydisanto2",
                        type="PED",
                    },
                    {
                        name="Lester Crest 3",
                        model="ig_lestercrest_3",
                        type="PED",
                    },
                    {
                        name="Vincent",
                        model="ig_vincent_2",
                        type="PED",
                    },
                    {
                        name="Wendy",
                        model="ig_wendy",
                        type="PED",
                    },
                    {
                        name="Highend Security 3",
                        model="s_m_m_highsec_03",
                        type="PED",
                    },
                    {
                        name="West Security 2",
                        model="s_m_y_westsec_02",
                        type="PED",
                    },
                    {
                        name="Female Beach 2",
                        model="a_f_y_beach_02",
                        type="PED",
                    },
                    {
                        name="Club customer 3",
                        model="a_f_y_clubcust_04",
                        type="PED",
                    },
                    {
                        name="Male Beach 1",
                        model="a_m_o_beach_02",
                        type="PED",
                    },
                    {
                        name="Male Beach 2",
                        model="a_m_y_beach_04",
                        type="PED",
                    },
                    {
                        name="Club Customer 4",
                        model="a_m_y_clubcust_04",
                        type="PED",
                    },
                    {
                        name="Cartel Guards 1",
                        model="g_m_m_cartelguards_01",
                        type="PED",
                    },
                    {
                        name="Cartel Guards 2",
                        model="g_m_m_cartelguards_02",
                        type="PED",
                    },
                    {
                        name="Dre (better)",
                        model="ig_ary",
                        type="PED",
                    },
                    {
                        name="English Dave 2",
                        model="ig_englishdave_02",
                        type="PED",
                    },
                    {
                        name="Gustavo",
                        model="ig_gustavo",
                        type="PED",
                    },
                    {
                        name="Helmsman Pavel",
                        model="ig_helmsmanpavel",
                        type="PED",
                    },
                    {
                        name="ig_isldj_00",
                        model="ig_isldj_00",
                        type="PED",
                    },
                    {
                        name="ig_isldj_01",
                        model="ig_isldj_01",
                        type="PED",
                    },
                    {
                        name="ig_isldj_02",
                        model="ig_isldj_02",
                        type="PED",
                    },
                    {
                        name="ig_isldj_03",
                        model="ig_isldj_03",
                        type="PED",
                    },
                    {
                        name="ig_isldj_04",
                        model="ig_isldj_04",
                        type="PED",
                    },
                    {
                        name="ig_isldj_04_d_01",
                        model="ig_isldj_04_d_01",
                        type="PED",
                    },
                    {
                        name="ig_isldj_04_d_02",
                        model="ig_isldj_04_d_02",
                        type="PED",
                    },
                    {
                        name="ig_isldj_04_e_01",
                        model="ig_isldj_04_e_01",
                        type="PED",
                    },
                    {
                        name="Jackie",
                        model="ig_jackie",
                        type="PED",
                    },
                    {
                        name="Jimmy Iovine (better)",
                        model="ig_jio",
                        type="PED",
                    },
                    {
                        name="Juan Strickler(El Rubio)",
                        model="ig_juanstrickler",
                        type="PED",
                    },
                    {
                        name="Kaylee",
                        model="ig_kaylee",
                        type="PED",
                    },
                    {
                        name="Miguel Madrazo",
                        model="ig_miguelmadrazo",
                        type="PED",
                    },
                    {
                        name="DJ Pooh (better)",
                        model="ig_mjo",
                        type="PED",
                    },
                    {
                        name="Old Rich Guy",
                        model="ig_oldrichguy",
                        type="PED",
                    },
                    {
                        name="Patricia 2",
                        model="ig_patricia_02",
                        type="PED",
                    },
                    {
                        name="Pilot",
                        model="ig_pilot",
                        type="PED",
                    },
                    {
                        name="ig_sss",
                        model="ig_sss",
                        type="PED",
                    },
                    {
                        name="Beach Bar Staff",
                        model="s_f_y_beachbarstaff_01",
                        type="PED",
                    },
                    {
                        name="Female Club Bar 2",
                        model="s_f_y_clubbar_02",
                        type="PED",
                    },
                    {
                        name="Bouncer 2",
                        model="s_m_m_bouncer_02",
                        type="PED",
                    },
                    {
                        name="Drug Processor",
                        model="s_m_m_drugprocess_01",
                        type="PED",
                    },
                    {
                        name="Fieldworker",
                        model="s_m_m_fieldworker_01",
                        type="PED",
                    },
                    {
                        name="Highend Security 4",
                        model="s_m_m_highsec_04",
                        type="PED",
                    },
                    {
                        name="Female Car Club 1",
                        model="A_F_Y_CarClub_01",
                        type="PED",
                    },
                    {
                        name="Male Car Club 1",
                        model="A_M_Y_CarClub_01",
                        type="PED",
                    },
                    {
                        name="Tattoo Customer",
                        model="A_M_Y_TattooCust_01",
                        type="PED",
                    },
                    {
                        name="Prisoners 1",
                        model="G_M_M_Prisoners_01",
                        type="PED",
                    },
                    {
                        name="Slasher 1",
                        model="G_M_M_Slasher_01",
                        type="PED",
                    },
                    {
                        name="Avi Schwartzman 2",
                        model="IG_AviSchwartzman_02",
                        type="PED",
                    },
                    {
                        name="Benny 2",
                        model="IG_Benny_02",
                        type="PED",
                    },
                    {
                        name="Drug Dealer",
                        model="IG_DrugDealer",
                        type="PED",
                    },
                    {
                        name="Hao 2",
                        model="IG_Hao_02",
                        type="PED",
                    },
                    {
                        name="Lil Dee",
                        model="IG_LilDee",
                        type="PED",
                    },
                    {
                        name="Mimi",
                        model="IG_Mimi",
                        type="PED",
                    },
                    {
                        name="Moodyman 2",
                        model="IG_Moodyman_02",
                        type="PED",
                    },
                    {
                        name="Sessanta",
                        model="IG_Sessanta",
                        type="PED",
                    },
                    {
                        name="Female Autoshop 1",
                        model="S_F_M_Autoshop_01",
                        type="PED",
                    },
                    {
                        name="Retail Staff",
                        model="S_F_M_RetailStaff_01",
                        type="PED",
                    },
                    {
                        name="Male Autoshop 3",
                        model="S_M_M_Autoshop_03",
                        type="PED",
                    },
                    {
                        name="Race Organizer 1",
                        model="S_M_M_RaceOrg_01",
                        type="PED",
                    },
                    {
                        name="Tattoo Artist",
                        model="S_M_M_Tattoo_01",
                        type="PED",
                    },
                    {
                        name="Female Studio Party 1",
                        model="A_F_Y_StudioParty_01",
                        type="PED",
                    },
                    {
                        name="Female Studio Party 2",
                        model="A_F_Y_StudioParty_02",
                        type="PED",
                    },
                    {
                        name="Male Studio Party 1",
                        model="A_M_M_StudioParty_01",
                        type="PED",
                    },
                    {
                        name="Male Studio Party 2",
                        model="A_M_Y_StudioParty_01",
                        type="PED",
                    },
                    {
                        name="Goons 1",
                        model="G_M_M_Goons_01",
                        type="PED",
                    },
                    {
                        name="Dre",
                        model="IG_ARY_02",
                        type="PED",
                    },
                    {
                        name="Ballas Leader",
                        model="IG_Ballas_Leader",
                        type="PED",
                    },
                    {
                        name="Billionaire",
                        model="IG_Billionaire",
                        type="PED",
                    },
                    {
                        name="Entourage A",
                        model="IG_Entourage_A",
                        type="PED",
                    },
                    {
                        name="Entourage B",
                        model="IG_Entourage_B",
                        type="PED",
                    },
                    {
                        name="Golfer A",
                        model="IG_Golfer_A",
                        type="PED",
                    },
                    {
                        name="Golfer B",
                        model="IG_Golfer_B",
                        type="PED",
                    },
                    {
                        name="Imani",
                        model="IG_Imani",
                        type="PED",
                    },
                    {
                        name="Jimmy Iovine",
                        model="IG_JIO_02",
                        type="PED",
                    },
                    {
                        name="'Johnny Guns",
                        model="IG_Johnny_Guns",
                        type="PED",
                    },
                    {
                        name="Lamar Davis 2",
                        model="IG_LamarDavis_02",
                        type="PED",
                    },
                    {
                        name="DJ Pooh",
                        model="IG_MJO_02",
                        type="PED",
                    },
                    {
                        name="Musician",
                        model="IG_Musician_00",
                        type="PED",
                    },
                    {
                        name="Party Promoter",
                        model="IG_Party_Promo",
                        type="PED",
                    },
                    {
                        name="Requisition Officer",
                        model="IG_Req_Officer",
                        type="PED",
                    },
                    {
                        name="Security A",
                        model="IG_Security_A",
                        type="PED",
                    },
                    {
                        name="Sound Engineer",
                        model="IG_SoundEng_00",
                        type="PED",
                    },
                    {
                        name="Vagos Leader",
                        model="IG_Vagos_Leader",
                        type="PED",
                    },
                    {
                        name="Vernon",
                        model="IG_Vernon",
                        type="PED",
                    },
                    {
                        name="Vincent 3",
                        model="IG_Vincent_3",
                        type="PED",
                    },
                    {
                        name="Franklin 2",
                        model="P_Franklin_02",
                        type="PED",
                    },
                    {
                        name="Female Studio Assist",
                        model="S_F_M_StudioAssist_01",
                        type="PED",
                    },
                    {
                        name="Highend Security",
                        model="S_M_M_HighSec_05",
                        type="PED",
                    },
                    {
                        name="Male Studio Assist",
                        model="S_M_M_StudioAssist_02",
                        type="PED",
                    },
                    {
                        name="Studio Producer",
                        model="S_M_M_StudioProd_01",
                        type="PED",
                    },
                    {
                        name="Studio Sound Engineer",
                        model="S_M_M_StudioSouEng_02",
                        type="PED",
                    },
                }
            },
        },
    },
}
