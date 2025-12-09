Config = {}

Config.Minutes = function(minutes) return minutes * 60 end
Config.Hours = function(hours) return hours * (60 * 60) end
Config.Days = function(days) return days * (24 * (60 * 60)) end

Config.Debug = false
Config.Command = 'addbande'

Config.DropTime = 2 -- tid i dage

Config.UseOX = true -- Hvis true, så bruger den OX Context menu, ellers burger den ESX Default Menu
Config.SpawnOffset = vector3(0.0, 0.0, -100.0)
Config.CarSpawnDistance = 150.0

Config.ReturnRate = 75 -- Hvor meget du får tilbage, hvis du annullere en bestilling
Config.MaxActiveDeliverances = 1 -- Antallet af bestillinger ad gangen.
Config.RefreshWeaponTime = 60000 -- (hvor tit delivery tiden skal opdatere - Vi anbefaler at denne ikke ændres)

Config.GangJobs = {
    'saints',
    'frontline',
    'saint',
    '1down',
    'sa26',
    'ot',
    '52',
    'v',
    'gang9',
    'gang10',
    'gang11',
    'gang12',
}

-- Steder køretøjet med våben-bestilligen spawner
Config.GunDelivery = {
    vector4(-1578.96, 5168.97, 19.38, 85.5),
    vector4(-2309.14, 264.61, 169.41, 94.5),
    vector4(3615.95, 3727.8, 28.5, 324.5),
    vector4(1263.66, 1905.15, 78.63, 53.5),
    vector4(1020.95, 2449.96, 44.23, 141.5),
    vector4(706.17, 4173.05, 40.67, 105.5),
    vector4(1908.66, 573.82, 175.63, 65.5),
    vector4(2136.28, 4776.64, 40.78, 204.5),
}

-- Steder hvor Våben Manden har mulighed for at spawne
Config.NPCSpawns = {
    vector4(-3420.6379, 979.5725, 8.3467, 177.3073)
}

Config.UseCase = true -- Brug de våben kasser fra "readme" filen
Config.weaponCases = {
    ['ammo'] = { -- Dit ammunitions navn, HUSK du skal ændre begge to, hvis dit ammunition hedder noget andet
        label = 'ammo',
        give = 0, -- antallet af ammunition du får med
    },
    ['assaultrifle_case'] = {
        label = 'assaultrifle_case',
        give = 'weapon_assaultrifle',
    },
    ['cermaicpistol_case'] = {
        label = 'cermaicpistol_case',
        give = 'weapon_ceramicpistol',
    },
    ['compactrifle_case'] = {
        label = 'compactrifle_case',
        give = 'weapon_compactrifle',
    },
    ['dbshotgun_case'] = {
        label = 'dbshotgun_case',
        give = 'weapon_dbshotgun',
    },
    ['assaultsmg_case'] = {
        label = 'assaultsmg_case',
        give = 'weapon_assaultsmg',
    },
    ['gusenberg_case'] = {
        label = 'gusenberg_case',
        give = 'weapon_gusenberg',
    },
    ['machinepistol_case'] = {
        label = 'machinepistol_case',
        give = 'weapon_machinepistol',
    },
    ['microsmg_case'] = {
        label = 'microsmg_case',
        give = 'weapon_microsmg',
    },
    ['xm3_case'] = {
        label = 'xm3_case',
        give = 'WEAPON_PISTOLXM3',
    },
    ['minismg_case'] = {
        label = 'minismg_case',
        give = 'weapon_minismg',
    },
    ['navyrevolver_case'] = {
        label = 'navyrevolver_case',
        give = 'weapon_navyrevolver',
    },
    ['pistol50_case'] = {
        label = 'pistol50_case',
        give = 'weapon_pistol50',
    },
    ['pistol_case'] = {
        label = 'pistol_case',
        give = 'weapon_pistol',
    },
    ['pumpshotgun_case'] = {
        label = 'pumpshotgun_case',
        give = 'weapon_pumpshotgun',
    },
    ['revolver_case'] = {
        label = 'revolver_case',
        give = 'weapon_revolver',
    },
    ['vintagepistol_case'] = {
        label = 'vintagepistol_case',
        give = 'weapon_vintagepistol',
    }
}