if not GLOBAL.IsInFrontEnd() then return end

-- I need to continue to modify here
--变量
local modimport = modimport
local AddModCharacter = AddModCharacter
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

--导入人物和皮肤模型
PrefabFiles = {
	"manutsawee_none"
}

--导入人物背景
Assets = {

	Asset( "IMAGE", "bigportraits/manutsawee.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee.xml" ),

    Asset( "IMAGE", "bigportraits/manutsawee_none.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_none.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_yukata.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_yukata.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_fuka.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_fuka.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_maid.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_maid.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_shinsengumi.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_shinsengumi.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_jinbei.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_jinbei.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_taohuu.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_taohuu.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_maid.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_maid.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_miko.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_miko.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_qipao.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_qipao.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_sailor.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_sailor.xml" ),

    Asset( "IMAGE", "bigportraits/manutsawee_taohuu.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_taohuu.xml" ),

    Asset( "IMAGE", "images/saveslot_portraits/manutsawee.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/manutsawee.xml" ),

    Asset( "IMAGE", "images/names_gold_manutsawee.tex" ),
    Asset( "ATLAS", "images/names_gold_manutsawee.xml" ),

}

STRINGS.NAMES.MANUTSAWEE = "Manutsawee"
STRINGS.SKIN_NAMES.manutsawee_none = "Manutsawee"
STRINGS.SKIN_DESCRIPTIONS.manutsawee_none = "A Little Girl with a Big Dream."

STRINGS.CHARACTER_TITLES.manutsawee = "The Sword Master"
STRINGS.CHARACTER_ABOUTME.manutsawee = "Manutsawee is too long so just louis."
STRINGS.CHARACTER_NAMES.manutsawee = "Manutsawee"
STRINGS.CHARACTER_DESCRIPTIONS.manutsawee = "*Art of the Japanese sword\n*Brave\n*Benevolent"
STRINGS.CHARACTER_QUOTES.manutsawee = "\"Where There's a Will, There's a Way\""

STRINGS.CHARACTER_BIOS.manutsawee = {
    { title = "Birthday", desc = "October 9" },
    { title = "Favorite Food", desc = "Unagi, Bacon and Eggs, Cooked Kelp Fronds, Durian, Roasted durian" },
    { title = "Favorite Food in IA", desc = "Californiaroll, Caviar" },
    -- So? Who wants to think about it?
    { title = "Her Past...", desc = "Is yet to be revealed."},
}

TUNING.MANUTSAWEE_HEALTH = 250
TUNING.MANUTSAWEE_HUNGER = 250
TUNING.MANUTSAWEE_SANITY = 250

STRINGS.CHARACTER_SURVIVABILITY.manutsawee= "󰀕Grim"

local skin_modes = {{
    type = "ghost_skin",
    anim_bank = "ghost",
    idle_anim = "idle",
    scale = 0.75,
    offset = {0, -25}
}}

modimport("main/manutsaweeskin")

AddModCharacter("manutsawee", "FEMALE", skin_modes)
