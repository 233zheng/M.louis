local TUNING = GLOBAL.TUNING
local GetModConfigData = GetModConfigData
GLOBAL.setfenv(1, GLOBAL)

TUNING.MANUTSAWEE = {
    KEYLEVELCHECK = GetModConfigData("levelcheck"),
    SKILL = GetModConfigData("manutsaweeskill"), -- enable skill
    KEYSKILL1 = GetModConfigData("mkeyskill1"),
    KEYSKILL2 = GetModConfigData("mkeyskill2"),
    KEYSKILL3 = GetModConfigData("mkeyskill3"),
    KEYSKILLCOUNTERATK = GetModConfigData("mkeyskillcounteratk"),
    KEYSQUICKSHEATH = GetModConfigData("mkeyquicksheath"),
    KEYSKILLCANCEL = GetModConfigData("mkeyskillcancel"),

    MINDREGENCOUNT = GetModConfigData("manutsaweemindregen"), -- mind regen count
    MINDREGENRATE = GetModConfigData("manutsaweemindregenrate"), -- mind regen rate

    SKILLCDCT = GetModConfigData("mscdct"),
    SKILLCD1 = GetModConfigData("mscd1"),
    SKILLCD2 = GetModConfigData("mscd2"),
    SKILLCD3 = GetModConfigData("mscd3"),
    SKILLCDT2 = GetModConfigData("mscdt2"),
    SKILLCDT3 = GetModConfigData("mscdt3"),

    MASTER = GetModConfigData("manutsaweemaster"), -- enable set kenjutsu level
    MASTERVALUE = GetModConfigData("manutsaweemastervalue"), -- set kenjutsu level

    KEYGLASSES = GetModConfigData("glasses"),
    KEYHAIRS = GetModConfigData("Hairs"), -- change hairstyle key

    HUNGER = GetModConfigData("manutsaweehunger"),
    HEALTH = GetModConfigData("manutsaweehealth"),
    SANITY = GetModConfigData("manutsaweesanity"),
    MINDMAX = GetModConfigData("manutsaweemindmax"),

    HUNGERMAX = GetModConfigData("manutsaweehungermax"),
    HEALTHMAX = GetModConfigData("manutsaweehealthmax"),
    SANITYMAX = GetModConfigData("manutsaweesanitymax"),

    -- kenjutsu exp multiple
    KEXPMTP = GetModConfigData("manutsaweekexpmtp"),
    MSTARTITEM = GetModConfigData("manutsaweestartitem"),

    -- scout
    PTENT = GetModConfigData("manutsaweetent"),
    NSTICK = GetModConfigData("manutsaweenstick"),

    --option
    IDLEANIM = GetModConfigData("wandaidleanim"),
    COMPATIBLE = GetModConfigData("compatiblewithia"),
    COMPATIBLEWITHKATANA = GetModConfigData("compatiblewithkatana")
}

local t = {
    "raikiri",
    "shinai",
    "shirasaya",
    "koshirae",
    "hitokiri",
    "katanablade"
}

for k, v in ipairs(t) do
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE[v] = {
        atlas = "images/inventoryimages/".. v ..".xml",
        image = v .. ".tex"
    }
end

TUNING.KATANA = {
    HARAKIRIDMG = 34,
    COMMON_DMG = 68,
    YARIDMG = 42.5,
    MASTER_DMG = 81.6,

    -- finiteuses
    FINITEUSES = 800,
    MNAGINATA_USES = 300,
    HARAKIRI_USES = 200,

    --mmiko_armor
    MMIKO_ARMOR_AMOUNT = 1500,
    MMIKO_ARMOR_PRECENT = 0.8,
    MMIKO_ARMOR_COOLDOWN = 3,
    MMIKO_ARMOR_DURATION = 8,
}

TUNING.MINGOT_WORK_REQUIRED = 4
TUNING.MINGOT_LOOT = {
    WORK_MAX_SPAWNS = 10,
    LAUNCH_SPEED = -1.8,
    LAUNCH_HEIGHT = 0.5,
    LAUNCH_ANGLE = 65,
}

if GetModConfigData("compatiblewithia") then
    TUNING.MSURFBOARD_HEALTH = 300
    TUNING.MSURFBOARD_SPEED = 0
end
