if not GLOBAL.IsInFrontEnd() then return end

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

modimport("main/config")
modimport("main/tuning")
modimport("main/characters")
modimport("main/manutsaweeskin")
