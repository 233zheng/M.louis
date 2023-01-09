-- Import the engine.
modimport("engine.lua")

-- Imports to keep the keyhandler from working while typing in chat.
Load "chatinputscreen"
Load "consolescreen"
Load "textedit"

PrefabFiles = {"manutsawee","manutsawee_none","raikiri","raikiri2","yari","mnaginata","harakiri","mkabuto","mkabuto2","shinai","maid_hb","m_foxmask","m_scarf","shirasaya","shirasaya2","koshirae","koshirae2","mfruit","katanablade","mingot","hitokiri","hitokiri2","mkatana","mmiko_armor",}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/manutsawee.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/manutsawee.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/manutsawee.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/manutsawee.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/manutsawee_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/manutsawee_silho.xml" ),

    Asset( "IMAGE", "bigportraits/manutsawee.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee.xml" ),
	
	Asset( "IMAGE", "images/map_icons/manutsawee.tex" ),
	Asset( "ATLAS", "images/map_icons/manutsawee.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_manutsawee.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_manutsawee.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_manutsawee.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_manutsawee.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_manutsawee.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_manutsawee.xml" ),
	
	Asset( "IMAGE", "images/names_manutsawee.tex" ),
    Asset( "ATLAS", "images/names_manutsawee.xml" ),
	
	Asset( "IMAGE", "images/names_gold_manutsawee.tex" ),
    Asset( "ATLAS", "images/names_gold_manutsawee.xml" ),
	
    Asset( "IMAGE", "bigportraits/manutsawee_none.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_none.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_yukata.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_yukata.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_yukatalong.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_yukatalong.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_shinsengumi.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_shinsengumi.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_fuka.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_fuka.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_jinbei.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_jinbei.xml" ),

	Asset( "IMAGE", "bigportraits/manutsawee_maid.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_maid.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_miko.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_miko.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_qipao.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_qipao.xml" ),
	
	Asset( "IMAGE", "bigportraits/manutsawee_sailor.tex" ),
    Asset( "ATLAS", "bigportraits/manutsawee_sailor.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/raikiri.tex"),
	Asset( "ATLAS", "images/inventoryimages/raikiri.xml"), 
	
	Asset("IMAGE", "images/map_icons/raikiri.tex"),
	Asset("ATLAS", "images/map_icons/raikiri.xml"),	
	
	Asset( "IMAGE", "images/inventoryimages/yari.tex"),
	Asset( "ATLAS", "images/inventoryimages/yari.xml"),
	
	Asset("IMAGE", "images/map_icons/yari.tex"),
	Asset("ATLAS", "images/map_icons/yari.xml"),
		
	Asset( "IMAGE", "images/inventoryimages/harakiri.tex"),
	Asset( "ATLAS", "images/inventoryimages/harakiri.xml"),
	
	Asset( "IMAGE", "images/inventoryimages/mkabuto.tex"),
	Asset( "ATLAS", "images/inventoryimages/mkabuto.xml"),
	
	Asset( "IMAGE", "images/inventoryimages/maid_hb.tex"),
	Asset( "ATLAS", "images/inventoryimages/maid_hb.xml"),
		----------------------------------
}
AddMinimapAtlas("images/map_icons/manutsawee.xml")
AddMinimapAtlas("images/map_icons/raikiri.xml")
AddMinimapAtlas("images/map_icons/yari.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

GLOBAL.FOODTYPE.MFRUIT = "MFRUIT"
GLOBAL.TUNING.MANUTSAWEE = { 

	KEYLEVELCHECK = GetModConfigData("levelcheck"),
	SKILL = GetModConfigData("manutsaweeskill"), --enable skill							 					 
	KEYSKILL1 = GetModConfigData("mkeyskill1"),
	KEYSKILL2 = GetModConfigData("mkeyskill2"),
	KEYSKILL3 = GetModConfigData("mkeyskill3"),
	KEYSKILLCOUNTERATK = GetModConfigData("mkeyskillcounteratk"),
	KEYSQUICKSHEATH = GetModConfigData("mkeyquicksheath"),
	KEYSKILLCANCEL = GetModConfigData("mkeyskillcancel"),
	
	MINDREGENCOUNT = GetModConfigData("manutsaweemindregen"),--mind regen count							
	MINDREGENRATE = GetModConfigData("manutsaweemindregenrate"),--mind regen rate
	
	SKILLCDCT  = GetModConfigData("mscdct"),
	SKILLCD1  = GetModConfigData("mscd1"),
	SKILLCD2  = GetModConfigData("mscd2"),
	SKILLCD3  = GetModConfigData("mscd3"),
	SKILLCDT2 = GetModConfigData("mscdt2"),
	SKILLCDT3 = GetModConfigData("mscdt3"),
	
	MASTER = GetModConfigData("manutsaweemaster"),--enable set kenjutsu level
	MASTERVALUE = GetModConfigData("manutsaweemastervalue"),--set kenjutsu level
	
	KEYGLASSES = GetModConfigData("glasses"),
	KEYHAIRS = GetModConfigData("Hairs"),--change hairstyle key

	HUNGER = GetModConfigData("manutsaweehunger"),
	HEALTH = GetModConfigData("manutsaweehealth"),
	SANITY = GetModConfigData("manutsaweesanity"),
	MINDMAX = GetModConfigData("manutsaweemindmax"),
	
	HUNGERMAX = GetModConfigData("manutsaweehungermax"),
	HEALTHMAX = GetModConfigData("manutsaweehealthmax"),
	SANITYMAX = GetModConfigData("manutsaweesanitymax"),
	
	--kenjutsu exp multiple
	KEXPMTP = GetModConfigData("manutsaweekexpmtp"),							 
	MSTARTITEM = GetModConfigData("manutsaweestartitem"),
	
	--scout
	PTENT = GetModConfigData("manutsaweetent"),
	NSTICK = GetModConfigData("manutsaweenstick"),
}

--
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["raikiri"] = {atlas = "images/inventoryimages/raikiri.xml", image = "raikiri.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["shinai"] = {atlas = "images/inventoryimages/shinai.xml", image = "shinai.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["shirasaya"] = {atlas = "images/inventoryimages/shirasaya.xml", image = "shirasaya.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["koshirae"] = {atlas = "images/inventoryimages/koshirae.xml", image = "koshirae.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["hitokiri"] = {atlas = "images/inventoryimages/hitokiri.xml", image = "hitokiri.tex"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE["katanablade"] = {atlas = "images/inventoryimages/katanablade.xml", image = "katanablade.tex"}

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

local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

AddModCharacter("manutsawee", "FEMALE", skin_modes)

modimport("scripts/manutsaweeskin")
modimport("scripts/manutsaweeitemrecipe")
modimport("scripts/manutsaweeskill")
modimport("scripts/manutsaweeskillActive")
modimport("scripts/manutsaweetexts")
modimport("scripts/style/attackkatanastyle.lua")
modimport("scripts/style/katanastyle.lua")

local function MOnEquip(inst,data)

	if data.item and (data.item.prefab == "onemanband" or data.item.prefab == "armorsnurtleshell" ) then
		if not inst:HasTag("notshowscabbard") then 
		inst:AddTag("notshowscabbard") end
	end  	
end

local function MOnUnEquip(inst,data)

	if data.item and (data.item.prefab == "onemanband" or data.item.prefab == "armorsnurtleshell" ) then		
		if inst:HasTag("notshowscabbard") then 
		inst:RemoveTag("notshowscabbard") end
	end
end

local function MOnDroped(inst,data)
	local item = data ~= nil and (data.prev_item or data.item)
	
	if item and item:HasTag("katanaskill") and not item:HasTag("woodensword") then	
		if not inst:HasTag("notshowscabbard") then 
		inst.AnimState:ClearOverrideSymbol("swap_body_tall")
		end
	end
end

local function RaikiriShowOnBack(inst)	
	  inst:ListenForEvent("equip", MOnEquip)
	  inst:ListenForEvent("unequip", MOnUnEquip)	  
	  inst:ListenForEvent("dropitem", MOnDroped) 
	  inst:ListenForEvent("itemlose", MOnDroped)
end
AddPlayerPostInit(RaikiriShowOnBack)
----------------------------------