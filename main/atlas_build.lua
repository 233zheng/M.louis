local AddMinimapAtlas = AddMinimapAtlas
local GetModConfigData = GetModConfigData

local items = {
    "boat_msurfboard",
    "harakiri",
    "hitokiri",
    "hitokiri2",
    "hmingot",
    "katanablade",
    "katanabody",
    "koshirae",
    "koshirae2",
    "maid_hb",
    "mfruit",
    "mingot",
    "mkabuto",
    "mkabuto2",
    "mkatana",
    "mmiko_armor",
    "mnaginata",
    "m_foxmask",
    "m_scarf",
    "raikiri",
    "raikiri2",
    "shinai",
    "shirasaya",
    "shirasaya2",
    "yari",
}

for k, v in ipairs(items) do
    table.insert(Assets, Asset("ATLAS_BUILD", "images/inventoryimages/"..v..".xml", 256))
end

local minimapatlas = {
    "manutsawee",
    "raikiri",
    "yari",
}

for k, v in ipairs(minimapatlas) do
    AddMinimapAtlas("images/map_icons/" ..v.. ".xml")
end

if GetModConfigData("compatiblewithia") then
    table.insert(PrefabFiles, "msurfboard")
    table.insert(Assets, Asset("IMAGE", "images/inventoryimages/boat_msurfboard.tex"))
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages/boat_msurfboard.xml"))

    table.insert(minimapatlas, "boat_msurfboard")
end
