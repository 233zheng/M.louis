--Skins system by Hornet
local _G = GLOBAL
local PREFAB_SKINS = _G.PREFAB_SKINS
local PREFAB_SKINS_IDS = _G.PREFAB_SKINS_IDS
local SKIN_AFFINITY_INFO = GLOBAL.require("skin_affinity_info")
local STRINGS = GLOBAL.STRINGS

modimport("ManutsaweeSkins_api")

SKIN_AFFINITY_INFO.manutsawee = {
	"manutsawee_yukata",
	"manutsawee_yukatalong", 
	"manutsawee_fuka", 
	"manutsawee_maid", 
	"manutsawee_shinsengumi",
	"manutsawee_jinbei",
	"manutsawee_miko",
	"manutsawee_qipao",
	"manutsawee_sailor",
}

PREFAB_SKINS["manutsawee"] = {
	"manutsawee_none", 	
	"manutsawee_yukata",
	"manutsawee_yukatalong",
	"manutsawee_fuka",
	"manutsawee_maid",
	"manutsawee_shinsengumi",
	"manutsawee_jinbei",
	"manutsawee_miko",
	"manutsawee_qipao",
	"manutsawee_sailor",
} 


PREFAB_SKINS_IDS = {} 
for prefab,skins in pairs(PREFAB_SKINS) do
    PREFAB_SKINS_IDS[prefab] = {}
    for k,v in pairs(skins) do
      	  PREFAB_SKINS_IDS[prefab][v] = k
    end
end

AddSkinnableCharacter("manutsawee") 

--Skin STRINGS
STRINGS.SKIN_NAMES.manutsawee_none = "Louis"
STRINGS.SKIN_QUOTES.manutsawee_none = "I hate this uniform."
STRINGS.SKIN_DESCRIPTIONS.manutsawee_none = "Thai's school uniform"
--SAILOR
STRINGS.SKIN_NAMES.manutsawee_sailor = "Louis Sailor Uniform"
STRINGS.SKIN_QUOTES.manutsawee_sailor = "\"So so so... nothing just say so..\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_sailor = "Japan's school uniform"
--JS
STRINGS.SKIN_NAMES.manutsawee_yukata = "Louis Kimono(M) "
STRINGS.SKIN_QUOTES.manutsawee_yukata = "\"Shine omae! haha.'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_yukata = "Japan's outfit mini version."
--Jlong
STRINGS.SKIN_NAMES.manutsawee_yukatalong = "Louis Kimono"
STRINGS.SKIN_QUOTES.manutsawee_yukatalong = "\"Kon ni chi wa ..?'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_yukatalong = "Japan's outfit."
--miko
STRINGS.SKIN_NAMES.manutsawee_miko = "Louis Miko"
STRINGS.SKIN_QUOTES.manutsawee_miko = "\"Can i fight with yokai?'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_miko = "Japan's shrine maiden outfit."
--qipao
STRINGS.SKIN_NAMES.manutsawee_qipao = "Louis Qipao"
STRINGS.SKIN_QUOTES.manutsawee_qipao = "\"Ni hao ..?'\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_qipao = "China's dress"
--Sur
STRINGS.SKIN_NAMES.manutsawee_fuka = "Louis Cosplay"
STRINGS.SKIN_QUOTES.manutsawee_fuka = "\"I'm a kung-fu master now.\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_fuka = "Fu hua hawk of the fog's outfit from honkai impact 3d"
--Maid
STRINGS.SKIN_NAMES.manutsawee_maid = "Louis Maid"
STRINGS.SKIN_QUOTES.manutsawee_maid = "\"I'm not a maid but i like this.\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_maid = "Maid's outfit"
--Shinsen
STRINGS.SKIN_NAMES.manutsawee_shinsengumi = "Louis Shinsengumi"
STRINGS.SKIN_QUOTES.manutsawee_shinsengumi = "\"One must not infringe the samurai code!\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_shinsengumi = "Laws of the Shinsengumi\nOne must not infringe the samurai code\nOne is not authorized to escape from office\nOne is not allowed to arbitrarily raise money\nOne must not arbitrarily handle litigations\nOne is not authorized to engage in personal conflicts\n"
--jinbei
STRINGS.SKIN_NAMES.manutsawee_jinbei = "Louis Jinbei"
STRINGS.SKIN_QUOTES.manutsawee_jinbei = "\"Relax Feeling good.\""
STRINGS.SKIN_DESCRIPTIONS.manutsawee_jinbei = "Japan's outfit."
