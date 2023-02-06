local AddMinimapAtlas = AddMinimapAtlas
local GetModConfigData = GetModConfigData

PrefabFiles = {
    "manutsawee",
    "manutsawee_none",

    "yari",
    "mnaginata",
    "shinai",

    "mkabuto",
    "mkabuto2",

    "maid_hb",
    "m_foxmask",
    "m_scarf",
    "harakiri",

    "mkatana",
    "katanablade",

    -- "koshirae",
    -- "shirasaya",
    -- "hitokiri",
    -- "raikiri",
    "katana",

    -- "koshirae2",
    -- "shirasaya2",
    -- "hitokiri2",
    -- "raikiri2",
    "katana2",

    "mfruit",

    "mingot",
    "mmiko_armor",

    "msurfboard"
}

Assets = {
     --player_lunge_blue.zip from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
    Asset("ANIM", "anim/player_lunge_blue.zip"),

    Asset("IMAGE", "images/saveslot_portraits/manutsawee.tex"),
    Asset("ATLAS", "images/saveslot_portraits/manutsawee.xml"),

    Asset("IMAGE", "images/selectscreen_portraits/manutsawee.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/manutsawee.xml"),

    Asset("IMAGE", "images/selectscreen_portraits/manutsawee_silho.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/manutsawee_silho.xml"),

    Asset("IMAGE", "images/avatars/avatar_manutsawee.tex"),
    Asset("ATLAS", "images/avatars/avatar_manutsawee.xml"),
    Asset("IMAGE", "images/avatars/avatar_ghost_manutsawee.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_manutsawee.xml"),
    Asset("IMAGE", "images/avatars/self_inspect_manutsawee.tex"),
    Asset("ATLAS", "images/avatars/self_inspect_manutsawee.xml"),

    Asset("IMAGE", "images/names_manutsawee.tex"),
    Asset("ATLAS", "images/names_manutsawee.xml"),
    Asset("IMAGE", "images/names_gold_manutsawee.tex"),
    Asset("ATLAS", "images/names_gold_manutsawee.xml"),

    Asset("IMAGE", "bigportraits/manutsawee.tex"),
    Asset("ATLAS", "bigportraits/manutsawee.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_none.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_none.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_yukata.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_yukata.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_yukatalong.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_yukatalong.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_shinsengumi.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_shinsengumi.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_fuka.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_fuka.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_jinbei.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_jinbei.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_maid.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_maid.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_miko.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_miko.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_qipao.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_qipao.xml"),
    Asset("IMAGE", "bigportraits/manutsawee_sailor.tex"),
    Asset("ATLAS", "bigportraits/manutsawee_sailor.xml"),

    Asset("IMAGE", "images/map_icons/manutsawee.tex"),
    Asset("ATLAS", "images/map_icons/manutsawee.xml"),
    Asset("IMAGE", "images/map_icons/raikiri.tex"),
    Asset("ATLAS", "images/map_icons/raikiri.xml"),
    Asset("IMAGE", "images/map_icons/yari.tex"),
    Asset("ATLAS", "images/map_icons/yari.xml"),
    Asset("IMAGE", "images/map_icons/boat_msurfboard.tex"),
    Asset("ATLAS", "images/map_icons/boat_msurfboard.xml"),

    Asset("IMAGE", "images/inventoryimages/raikiri.tex"),
    Asset("ATLAS", "images/inventoryimages/raikiri.xml"),
    Asset("IMAGE", "images/inventoryimages/yari.tex"),
    Asset("ATLAS", "images/inventoryimages/yari.xml"),
    Asset("IMAGE", "images/inventoryimages/harakiri.tex"),
    Asset("ATLAS", "images/inventoryimages/harakiri.xml"),
    Asset("IMAGE", "images/inventoryimages/mkabuto.tex"),
    Asset("ATLAS", "images/inventoryimages/mkabuto.xml"),
    Asset("IMAGE", "images/inventoryimages/maid_hb.tex"),
    Asset("ATLAS", "images/inventoryimages/maid_hb.xml"),
}

AddMinimapAtlas("images/map_icons/manutsawee.xml")
AddMinimapAtlas("images/map_icons/raikiri.xml")
AddMinimapAtlas("images/map_icons/yari.xml")

if GetModConfigData("compatiblewithia") then
    table.insert(PrefabFiles, "msurfboard")
    table.insert(Assets, Asset("IMAGE", "images/inventoryimages/boat_msurfboard.tex"))
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages/boat_msurfboard.xml"))

    AddMinimapAtlas("images/map_icons/boat_msurfboard.xml")
end
