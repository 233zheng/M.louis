local TUNING = GLOBAL.TUNING
GLOBAL.setfenv(1, GLOBAL)

local tuning = {
    KATANA = {
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
    },

    MINGOT_WORK_REQUIRED = 4,
    MINGOT_LOOT = {
        WORK_MAX_SPAWNS = 10,
        LAUNCH_SPEED = -1.8,
        LAUNCH_HEIGHT = 0.5,
        LAUNCH_ANGLE = 65,
    },
    -- Your character's stats
    MANUTSAWEE_HEALTH = MCONFIG.HEALTH,
    MANUTSAWEE_HUNGER = MCONFIG.HUNGER,
    MANUTSAWEE_SANITY = MCONFIG.SANITY,
}

for key, value in pairs(tuning) do
    if TUNING[key] then
        print("OVERRIDE: " .. key .. " in TUNING")
    end

    TUNING[key] = value
end

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

if MCONFIG.COMPATIBLE then
    TUNING.MSURFBOARD_HEALTH = 300
    TUNING.MSURFBOARD_SPEED = 0
end
