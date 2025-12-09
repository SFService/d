-- Skal der tilføjes ting skal det bare følge nedestående, "item": er det som bliver spawnet i varevognen, så det skal være item navnet.
-- Man kan tilføje flere kategorier osv samt slette.
Config.gunCategories = {
    { name = 'handguns', label = "Pistoler", weapons = {
            { img = 'pistol.png', isUnlocked = 0, maxAmount = 0, item = 'pistol_case', label = 'Pistol 9mm', name = 'pistol', price = 600000, details = 'Standard håndvåben. En .45 kaliber kamp-pistol med et magasin på 12 skud, som kan udvides til 16.', data = { damage = 30, fr = 140, acc = 66.66, range = 200, reload = 2, clip = 12 } },
            { img = 'vintage.png', isUnlocked = 0, maxAmount = 0, item = 'vintagepistol_case', label = 'Vintage Pistol', name = 'vintage', price = 600000, details = 'Det, du virkelig har brug for, er et mere genkendeligt våben. Skil dig ud fra mængden under et væbnet røveri med denne indgraverede pistol.', data = { damage = 35, fr = 114, acc = 66.66, range = 120, reload = 2, clip = 6 } },
            { img = 'pistol_50.png', isUnlocked = 0, maxAmount = 0, item = 'pistol50_case', label = 'Pistol .50', name = 'pistol50', price = 950000, details = 'Højvirkningspistol, der leverer enorm kraft, men med ekstremt stærk rekyl. Holder 9 skud i magasinet.', data = { damage = 60, fr = 103, acc = 40, range = 300, reload = 2, clip = 9 } },
            { img = 'ceramic.png', isUnlocked = 0, maxAmount = 0, item = 'cermaicpistol_case', label = 'Ceramic Pistol', name = 'ceramic', price = 700000, details = 'Ikke din bedstemors keramik. Selvom denne lillebitte pistol er lille nok til at passe i hendes taske og ikke vil sætte en metaldetektor i gang.', data = { damage = 35, fr = 144, acc = 60, range = 200, reload = 2, clip = 12 } },
            { img = 'navy.png', isUnlocked = 0, maxAmount = 0, item = 'navyrevolver_case', label = 'Navy Revolver', name = 'navy', price = 900000, details = 'A true museum piece. You want to know how the West was won - slow reload speeds and a whole heap of bloodshed.', data = { damage = 75, fr = 35, acc = 85, range = 300, reload = 4, clip = 6 } },
            { img = 'heavy.png', isUnlocked = 0, maxAmount = 0, item = 'revolver_case', label = 'Heavy Revolver', name = 'heavy', price = 1100000, details = 'En håndpistol med nok stopkraft til at fælde et rasende næsehorn, og tung nok til at slå det ihjel, hvis du løber tør for ammunition.', data = { damage = 90, fr = 30, acc = 90, range = 300, reload = 3, clip = 6 } },
             { img = 'xm3.png', isUnlocked = 0, maxAmount = 0, item = 'xm3_case', label = 'WM 29 Pistol', name = 'xm3', price = 1100000, details = 'En håndpistol med nok stopkraft til at fælde et rasende næsehorn, og tung nok til at slå det ihjel, hvis du løber tør for ammunition.', data = { damage = 90, fr = 30, acc = 90, range = 300, reload = 3, clip = 6 } },
        }
    },
    { name = 'machine', label = "MGs & SMGs", weapons = {
            { img = 'mini.png', isUnlocked = 0, maxAmount = 0, item = 'minismg_case', label = 'Skorpion', name = 'skorp', price = 2500000, details = 'Bliver stadig mere populær, siden marketingholdet kiggede ud over specialoperationsenheder og begyndte at bekymre sig om de små fyre i lavindkomstområder.', data = { damage = 22, fr = 400, acc = 28, range = 180, reload = 1.5, clip = 20 } },
            { img = 'tec.png', isUnlocked = 0, maxAmount = 0, item = 'machinepistol_case', label = 'TEC-9', name = 'tec', price = 2800000, details = 'Denne fuldautomatiske er lilletrommen til din tvillingmotor V8 bas = ingen drive-by lyder helt rigtig uden den.', data = { damage = 25, fr = 277, acc = 40, range = 180, reload = 1.5, clip = 12 } },
            { img = 'micro.png', isUnlocked = 0, maxAmount = 0, item = 'microsmg_case', label = 'UZI', name = 'micro', price = 3700000, details = 'Kombinerer kompakt design med en høj skudrate på cirka 200-500 skud i minuttet.', data = { damage = 30, fr = 308, acc = 50, range = 200, reload = 2, clip = 16 } },
            { img = 'combatpdw.png', isUnlocked = 0, maxAmount = 0, item = 'combatpdw_case', label = 'Combat PDW', name = 'combatpdw', price = 4000000, details = 'Har du fået nok af de kedelige SMGer. Så det på tide du prøver kræfter af med den nye Combat PDW.', data = { damage = 30, fr = 308, acc = 50, range = 200, reload = 2, clip = 16 } },
        }
    },
    { name = 'assault', label = "Assault Rifles", weapons = {
            { img = 'ak74u.png', isUnlocked = 0, maxAmount = 0, item = 'compactrifle_case', label = 'AK-74u', name = 'ak74u', price = 4100000, details = "Halv størrelse, al magten, dobbelt rekyl: der er ingen mere risikabel måde at sige 'Jeg kompenserer for noget' på.", data = { damage = 50, fr = 280, acc = 28, range = 800, reload = 2, clip = 30 } },
            { img = 'ak47.png', isUnlocked = 0, maxAmount = 0, item = 'assaultrifle_case', label = 'AK-47', name = 'ak47', price = 4500000, details = 'Denne standard angrebsriffel har et stort kapacitetsmagasin og langdistance præcision.', data = { damage = 50, fr = 280, acc = 28, range = 800, reload = 2, clip = 30 } },
            { img = 'gusenberg.png', isUnlocked = 0, maxAmount = 0, item = 'gusenberg_case', label = 'Gusenberg', name = 'gusenberg', price = 4800000, details = 'Fuldfør dit look med et forbudstids våben. Ser godt ud, når det affyres fra en Albany Roosevelt eller matches med et nålestribet jakkesæt.', data = { damage = 30, fr = 303, acc = 25, range = 120, reload = 3, clip = 30 } },
            { img = 'WEAPON_ASSAULTSMG.png', isUnlocked = 0, maxAmount = 0, item = 'assaultsmg_case', label = 'Assault SMG', name = 'assaultsmg', price = 5800000, details = 'Fuldfør dit look med et forbudstids våben. Ser godt ud, når det affyres fra en Albany Roosevelt eller matches med et nålestribet jakkesæt.', data = { damage = 30, fr = 303, acc = 25, range = 120, reload = 3, clip = 30 } },
        }
    },
    { name = 'shotguns', label = "Shotguns", weapons = {
            { img = 'pump.png', isUnlocked = 0, maxAmount = 0, item = 'pumpshotgun_case', label = 'Pump Shotgun', name = 'pump', price = 1200000, details = 'Standard haglgevær ideelt til nærkamp. En høj projektilspredning kompenserer for dens lavere præcision på lang afstand.', data = { damage = 67, fr = 20, acc = 30, range = 20, reload = 2, clip = 8 } },
            { img = 'sawnoff.png', isUnlocked = 0, maxAmount = 0, item = 'sawnoffshotgun_case', label = 'Sawed-Off Shotgun', name = 'sawedoff', price = 1500000, details = 'Dette enkeltskuds, savet-af haglgevær kompenserer for sin lave rækkevidde og ammunitions kapacitet med ødelæggende effektivitet i nærkamp.', data = { damage = 96, fr = 20, acc = 20, range = 15, reload = 2, clip = 8 } },
            { img = 'db_shotgun.png', isUnlocked = 0, maxAmount = 0, item = 'dbshotgun_case', label = 'Dobbelt Barrel Shotgun', name = 'db', price = 800000, details = 'Standard haglgevær ideel til kortdistancekamp. En spredning med højt projektil opvejer dens lavere nøjagtighed på lang rækkevidde.', data = { damage = 15, fr = 60, acc = 40, range = 30, reload = 2, clip = 2 } },
        }
    },
    { name = 'misc', label = "Misc", weapons = {
            { img = 'vest.png', isUnlocked = 0, maxAmount = 0, item = 'armour', label = 'Skudsikker Vest', name = 'armour', price = 250000, details = 'Tung pansring, der giver beskyttelse til overkroppen og vitale organer. Foretrækkes af mammas drenge, der ikke har tid til at bløde.' },
            { img = 'clip.png', isUnlocked = 0, maxAmount = 0, item = 'clip', label = 'Extended Clip', name = 'clip', price = 120000, details = 'Udvidede klip foretrækkes af dem, der ikke kan ramme noget og har brug for et par skud mere.' },
        }
    },
}
-- Define your configuration table for usable items and their corresponding items
Config.weaponCases = {

    
    { label = 'pistol_case', give = 'weapon_pistol', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'vintagepistol_case', give = 'weapon_vintagepistol', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'pistol50_case', give = 'weapon_pistol50', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'cermaicpistol_case', give = 'weapon_ceramicpistol', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'navyrevolver_case', give = 'weapon_navyrevolver', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'revolver_case', give = 'weapon_revolver', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'xm3_case', give = 'WEAPON_PISTOLXM3', amount = 1, metadata = { type = 'Falcon Bandebuy' } },


    { label = 'minismg_case', give = 'weapon_minismg', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'machinepistol_case', give = 'weapon_machinepistol', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'microsmg_case', give = 'weapon_microsmg', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'combatpdw_case', give = 'weapon_combatpdw', amount = 1, metadata = { type = 'Falcon Bandebuy' } },

   
    { label = 'compactrifle_case', give = 'weapon_compactrifle', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'assaultrifle_case', give = 'weapon_assaultrifle', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'gusenberg_case', give = 'weapon_gusenberg', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'assaultsmg_case', give = 'weapon_assaultsmg', amount = 1, metadata = { type = 'Falcon Bandebuy' } },


    { label = 'pumpshotgun_case', give = 'weapon_pumpshotgun', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'sawnoffshotgun_case', give = 'weapon_sawedoff', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
    { label = 'dbshotgun_case', give = 'weapon_dbshotgun', amount = 1, metadata = { type = 'Falcon Bandebuy' } },
   
}

Config.levelsSetup = {
    { number = 1, min = 0, max = 1000 },
    { number = 2, min = 1001, max = 2500 },
    { number = 3, min = 2501, max = 5500 },
    { number = 4, min = 5501, max = 8000 },
    { number = 5, min = 8001, max = 12000 },
    { number = 6, min = 12001, max = 16000 },
    { number = 7, min = 16001, max = 20000 },
    { number = 8, min = 20001, max = 24000 },
}

-- levelUnlocks er hvor meget man kan købe af hver ting.
Config.reputationRequirements = {
    ["pistol"] = { levelNeeded = 1, levelUnlocks = { ["level_1"] = 5, ["level_2"] = 10, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["xm3"] = { levelNeeded = 1, levelUnlocks = { ["level_1"] = 5, ["level_2"] = 10, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["vintage"] = { levelNeeded = 1, levelUnlocks = { ["level_1"] = 5, ["level_2"] = 10, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["pistol50"] = { levelNeeded = 2, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 5, ["level_3"] = 10, ["level_4"] = 15, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["ceramic"] = { levelNeeded = 1, levelUnlocks = { ["level_1"] = 5, ["level_2"] = 10, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["navy"] = { levelNeeded = 2, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 5, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["heavy"] = { levelNeeded = 2, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 5, ["level_3"] = 10, ["level_4"] = 20, ["level_5"] = 20, ["level_6"] = 20, ["level_7"] = 20, ["level_8"] = 20 } },
    ["skorp"] = { levelNeeded = 3, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 10, ["level_6"] = 13, ["level_7"] = 16, ["level_8"] = 19 } },
    ["tec"] = { levelNeeded = 4, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 10, ["level_6"] = 13, ["level_7"] = 16, ["level_8"] = 19 } },
    ["micro"] = { levelNeeded = 5, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 10, ["level_6"] = 13, ["level_7"] = 16, ["level_8"] = 19 } },
    ["combatpdw"] = { levelNeeded = 5, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 10, ["level_6"] = 13, ["level_7"] = 16, ["level_8"] = 19 } },
    ["ak74u"] = { levelNeeded = 5, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 5, ["level_6"] = 5, ["level_7"] = 5, ["level_8"] = 5 } },
    ["ak47"] = { levelNeeded = 6, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 5, ["level_6"] = 5, ["level_7"] = 5, ["level_8"] = 5 } },
    ["gusenberg"] = { levelNeeded = 7, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 5, ["level_6"] = 5, ["level_7"] = 5, ["level_8"] = 5 } },
    ["assaultsmg"] = { levelNeeded = 7, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 0, ["level_5"] = 5, ["level_6"] = 5, ["level_7"] = 5, ["level_8"] = 5 } },
    ["pump"] = { levelNeeded = 3, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 5, ["level_4"] = 10, ["level_5"] = 15, ["level_6"] = 15, ["level_7"] = 15, ["level_8"] = 15 } },
    ["sawedoff"] = { levelNeeded = 3, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 5, ["level_3"] = 10, ["level_4"] = 10, ["level_5"] = 15, ["level_6"] = 15, ["level_7"] = 15, ["level_8"] = 15 } },
    ["db"] = { levelNeeded = 2, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 5, ["level_3"] = 10, ["level_4"] = 10, ["level_5"] = 15, ["level_6"] = 15, ["level_7"] = 15, ["level_8"] = 15 } },
    ["armour"] = { levelNeeded = 1, levelUnlocks = { ["level_1"] = 10, ["level_2"] = 20, ["level_3"] = 30, ["level_4"] = 50, ["level_5"] = 80, ["level_6"] = 90, ["level_7"] = 100, ["level_8"] = 120 } },
    ["clip"] = { levelNeeded = 4, levelUnlocks = { ["level_1"] = 0, ["level_2"] = 0, ["level_3"] = 0, ["level_4"] = 10, ["level_5"] = 30, ["level_6"] = 30, ["level_7"] = 30, ["level_8"] = 30 } },
}


-- Missioner, der kan tilføjes flere som lyster og ændres i hvad der ønskes.
Config.MissionsPools = {
    { img = "drugs.png", requiredPool = { { amount = 3000, reward = 750 }, { amount = 2500, reward = 625 }, { amount = 2000, reward = 500 } }, name = "Aflever Almindelige Stoffer", acceptedItems = { "coke_pooch", "meth_pooch", "opium_pooch" } },
    { img = "drugs.png", requiredPool = { { amount = 1500, reward = 750 }, { amount = 1000, reward = 625 }, { amount = 1500, reward = 500 } }, name = "Aflever Pakket Stoffer", acceptedItems = { "coke_packaged", "meth_packaged", "opium_packaged" } },
    { img = "police2.png", requiredPool = { { amount = 100, reward = 255 }, { amount = 10, reward = 170 } }, name = "Maleri #3", acceptedItems = { "painting_3" } },
    { img = "police2.png",  requiredPool = { { amount = 10, reward = 375 }, { amount = 25, reward = 250 } }, name = "Maleri #4", acceptedItems = { "painting_4" } },
    { img = "police2.png", requiredPool = { { amount = 2, reward = 350 }, { amount = 1, reward = 175 } }, name = "Våben Document", acceptedItems = { "document_1" } },
    { img = "bank.png", requiredPool = { { amount = 100, reward = 450 }, { amount = 10, reward = 225 } }, name = "Guldbarre", acceptedItems = { "gold_bar" } },
    { img = "bank.png", requiredPool = { { amount = 100, reward = 350 }, { amount = 10, reward = 175 } }, name = "Diamant Bokse", acceptedItems = { "dia_box" } },
}

-- Antallet af missioner der skal vises ad gangen
Config.MissionCount = 4
