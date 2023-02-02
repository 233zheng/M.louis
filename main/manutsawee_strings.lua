-- MANUTSAWEE SKILL TEXT...
local STRINGS = GLOBAL.STRINGS
local require = GLOBAL.require
local AddModCharacter = AddModCharacter
GLOBAL.setfenv(1, GLOBAL)

-- The character select screen lines
STRINGS.CHARACTER_TITLES.manutsawee = "The Red-Eyes Girl"
STRINGS.CHARACTER_NAMES.manutsawee = "Manutsawee"
STRINGS.CHARACTER_DESCRIPTIONS.manutsawee = "󰀍 Kenjutsu"
STRINGS.CHARACTER_QUOTES.manutsawee = "\"Hmmm...\""
STRINGS.CHARACTER_SURVIVABILITY.manutsawee = "Grim"

-- Custom speech strings
STRINGS.CHARACTERS.MANUTSAWEE = require "speech_manutsawee"

-- The character's name as appears in-game
STRINGS.NAMES.MANUTSAWEE = "Manutsawee"
STRINGS.SKIN_NAMES.manutsawee_none = "Manutsawee"

local skin_modes = {{
    type = "ghost_skin",
    anim_bank = "ghost",
    idle_anim = "idle",
    scale = 0.75,
    offset = {0, -25}
}}

--Add Character！
AddModCharacter("manutsawee", "FEMALE", skin_modes)

-- item
-- Scarf
STRINGS.NAMES.M_SCARF = "Black Scarf"
STRINGS.RECIPE_DESC.M_SCARF = "Black Scarf."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.M_SCARF = "It'll be good for when winter comes."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.M_SCARF = "Makes you warm and fuzzy inside. Outside, too."

-- maid
STRINGS.NAMES.MAID_HB = "Louis's headwear"
STRINGS.RECIPE_DESC.MAID_HB = "Louis's headwear set."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAID_HB = "It's look good."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MAID_HB = "Hmmm..."

-- foxmask
STRINGS.NAMES.M_FOXMASK = "Kitsune Mask"
STRINGS.RECIPE_DESC.M_FOXMASK = "Fox Mask!"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.M_FOXMASK = "What a nice mask!."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.M_FOXMASK = "Now I'm a fox!."

-- samurai helmet general
STRINGS.NAMES.MKABUTO = "Kabuto"
STRINGS.RECIPE_DESC.MKABUTO = "Samarai's helmet."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MKABUTO = "That should keep me safe."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MKABUTO = "I'm a Samurai."

-- samurai helmet troop
STRINGS.NAMES.MKABUTO2 = "Kabuto"
STRINGS.RECIPE_DESC.MKABUTO2 = "Samarai's helmet."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MKABUTO2 = "That should keep me safe."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MKABUTO2 = "I'm a Samurai."

-- miko
STRINGS.NAMES.MMIKO_ARMOR = "Miko Robe"
STRINGS.RECIPE_DESC.MMIKO_ARMOR = "Miko robe for miko skin"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MMIKO_ARMOR = "Not for me."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MMIKO_ARMOR = "This robe for miko outfit."

-- memoryfruit
STRINGS.NAMES.MFRUIT = "Louis's memory fruit"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MFRUIT = "Fruit?"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MFRUIT = "Restore memory."

----------------------------------------------------------------------------------
-- ingot
-- normal
STRINGS.NAMES.MINGOT = "Mysterious Ingot"
STRINGS.RECIPE_DESC.MINGOT = "Bring it to fire"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MINGOT = "What is this?"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MINGOT = "Bring it to fire and hit with hammer."
-- hot
STRINGS.NAMES.HMINGOT = "Hot Mysterious Ingot"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HMINGOT = "it's very hot!"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.HMINGOT = "it's hammer time!!"
-- shape
STRINGS.NAMES.KATANABODY = "Katana shape"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KATANABODY = "so what?"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.KATANABODY = "Wrapped with rope and sharpened."

----------------------------------weapon
-- harakiri
STRINGS.NAMES.HARAKIRI = "Harakiri"
STRINGS.RECIPE_DESC.HARAKIRI = "Pay your mistake."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HARAKIRI = "This knife look so good."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.HARAKIRI = "For Honor!."

-- woodsword shinai
STRINGS.NAMES.SHINAI = "Shinai"
STRINGS.RECIPE_DESC.SHINAI = "Training Sword."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHINAI = "Is this useful?"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.SHINAI = "I can training my kenjutsu skill 󰀍 with this!. "

-- katana
STRINGS.NAMES.MKATANA = "Katana"
STRINGS.RECIPE_DESC.MKATANA = "Japanese Sword"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MKATANA = "It's a sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MKATANA = "It's a katana."

-- Naginata
STRINGS.NAMES.MNAGINATA = "Naginata"
STRINGS.RECIPE_DESC.MNAGINATA = "It's Japanese Spear."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MNAGINATA = "This spear look different."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.MNAGINATA = "Nagigaga~."

-- yari
STRINGS.NAMES.YARI = "Yari"
STRINGS.RECIPE_DESC.YARI = "It's Japanese Spear."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YARI = "This spear look different."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.YARI = "It is excellent at both piercing and slicing across a wide area."

-- blade
STRINGS.NAMES.KATANABLADE = "Katana Blade"
STRINGS.RECIPE_DESC.KATANABLADE = "Sharp katana blade"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KATANABLADE = "Is it can use without sword-handle?"
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.KATANABLADE = "I can use it without sword-handle."

-- nihiru
STRINGS.NAMES.HITOKIRI = "Nihiru"
STRINGS.RECIPE_DESC.HITOKIRI = "The Bloodseeker"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HITOKIRI = "What a weird sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.HITOKIRI = "It's gonna make me mad."

STRINGS.NAMES.HITOKIRI2 = "Nihiru The Bloodseeker"
STRINGS.RECIPE_DESC.HITOKIRI2 = "True Nihiru"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HITOKIRI2 = "What a weird sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.HITOKIRI2 = "It's gonna make me mad."

-- ssakura
STRINGS.NAMES.KOSHIRAE = "Sakakura"
STRINGS.RECIPE_DESC.KOSHIRAE = "The Giant Slayers"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KOSHIRAE = "What a beautyful sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.KOSHIRAE = "Size doesn't matter."

STRINGS.NAMES.KOSHIRAE2 = "Sakakura The Giant Slayers"
STRINGS.RECIPE_DESC.KOSHIRAE2 = "True Sakakura"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KOSHIRAE2 = "What a beautyful sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.KOSHIRAE2 = "Size doesn't matter."

-- shirasaya
STRINGS.NAMES.SHIRASAYA = "Yasha"
STRINGS.RECIPE_DESC.SHIRASAYA = "The Demon Slayer"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHIRASAYA = "What a beautyful sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.SHIRASAYA = "C'mon,I'll kill all of you... Demon!"

STRINGS.NAMES.SHIRASAYA2 = "Yasha The Demon Slayer"
STRINGS.RECIPE_DESC.SHIRASAYA2 = "True Yasha"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHIRASAYA2 = "What a beautyful sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.SHIRASAYA2 = "C'mon,I'll kill all of you... Demon!"

-- raikiri
STRINGS.NAMES.RAIKIRI = "Raikiri"
STRINGS.RECIPE_DESC.RAIKIRI = "The Lightning Cutter"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIKIRI = "What a beautyful sword."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.RAIKIRI = "Once it used to split a bolt of lightning."

STRINGS.NAMES.RAIKIRI2 = "Raikiri The Lightning Cutter"
STRINGS.RECIPE_DESC.RAIKIRI2 = "True Raikiri"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAIKIRI2 = "This sword look dangerous,Don't touch it."
STRINGS.CHARACTERS.MANUTSAWEE.DESCRIBE.RAIKIRI2 = "Once it used to split a bolt of lightning."

------------------------------------------------------------------------------------------------

STRINGS.MANUTSAWEESKILLSPEECH = {

    -- Skill (1)
    SKILL1START = "ICHI NO KATA!\n󰀈: ",
    SKILL1ATTACK = "ICHIMONJI",

    -- Skill (2)
    SKILL2START = "NI NO KATA!\n󰀈: ",
    SKILL2ATTACK = "HABAKIRI!!",

    -- Skill (3)
    SKILL3START = "SAN NO KATA! \n󰀈: ",
    SKILL3ATTACK = "ONIKIRI!!",

    -- Skill (4)
    SKILL4START = "SHI NO KATA!\n󰀈: ",
    SKILL4ATTACK = "ISSHIN!!",

    -- Skill (5)
    SKILL5START = "GO NO KATA!\n󰀈: ",
    SKILL5ATTACK = "SHINDEN ISSEN!!",

    -- Skill (6)
    SKILL6START = "ROKU NO KATA!\n󰀈: ",
    SKILL6ATTACK = "RYUSEN!!",

    -- Skill (7)
    SKILL7START = "SHICHI NO KATA!\n󰀈: ",
    SKILL7ATTACK = "SUSANOO!!"

}
