local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require
local AddModCharacter = AddModCharacter
GLOBAL.setfenv(1, GLOBAL)

-- The character's name as appears in-game
STRINGS.NAMES.MANUTSAWEE = "Manutsawee"

-- The character select screen lines
STRINGS.CHARACTER_TITLES.manutsawee = "The Red-Eyes Girl"
STRINGS.CHARACTER_NAMES.manutsawee = "Manutsawee"
STRINGS.CHARACTER_ABOUTME.manutsawee = "Manutsawee is too long so just louis."
STRINGS.CHARACTER_DESCRIPTIONS.manutsawee = "*Art of the Japanese sword\n*Brave\n*Benevolent"
STRINGS.CHARACTER_QUOTES.manutsawee = "\"Where There's a Will, There's a Way\""
STRINGS.CHARACTER_SURVIVABILITY.manutsawee= "󰀕Grim"

-- Custom speech strings
STRINGS.CHARACTERS.MANUTSAWEE = require "speech_manutsawee"

STRINGS.CHARACTER_BIOS.manutsawee = {
    { title = "Birthday", desc = "October 9" },
    { title = "Favorite Food", desc = "Unagi, Bacon and Eggs, Cooked Kelp Fronds, Durian, Roasted durian" },
    { title = "Favorite Food in IA", desc = "Californiaroll, Caviar" },
    -- So? Who wants to think about it?
    { title = "Her Past...", desc = "Is yet to be revealed."},
}

local skin_modes = {{
    type = "ghost_skin",
    anim_bank = "ghost",
    idle_anim = "idle",
    scale = 0.75,
    offset = {0, -25}
}}

AddModCharacter("manutsawee", "FEMALE", skin_modes)
