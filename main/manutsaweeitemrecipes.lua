local AddRecipe2 = AddRecipe2
local TECH = GLOBAL.TECH
local Ingredient = GLOBAL.Ingredient
local AddCharacterRecipe = AddCharacterRecipe
local GetModConfigData = GetModConfigData
GLOBAL.setfenv(1, GLOBAL)

--------------------------My item
--shinai
AddRecipe2("shinai",
{Ingredient("rope", 1),Ingredient("boards", 1)},
TECH.SCIENCE_ONE,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/shinai.xml", image = "shinai.tex"},
{"CHARACTER", "WEAPONS"})

--harakiri
AddRecipe2("harakiri",
{Ingredient("flint", 2),Ingredient("log", 2)},
TECH.SCIENCE_ONE,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/harakiri.xml", image = "harakiri.tex"},
{"CHARACTER", "WEAPONS"})

--maid_hb
AddRecipe2("maid_hb",
{Ingredient("silk", 4)},
TECH.SCIENCE_ONE,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/maid_hb.xml", image = "maid_hb.tex"},
{"CHARACTER", "CLOTHING"})

--m_foxmask
AddRecipe2("m_foxmask",
{Ingredient("silk", 4)},
TECH.SCIENCE_ONE,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/m_foxmask.xml", image = "m_foxmask.tex"},
{"CHARACTER", "CLOTHING"})

--m_scarf
AddRecipe2("m_scarf",
{Ingredient("silk", 4),Ingredient("beefalowool", 4)},
TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/m_scarf.xml", image = "m_scarf.tex"},
{"CHARACTER", "CLOTHING", "WINTER"})

--mmiko_armor
AddRecipe2("mmiko_armor",
{Ingredient("silk", 4),Ingredient("boards", 2),Ingredient("rope", 2)},
TECH.SCIENCE_TWO,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/mmiko_armor.xml", image = "mmiko_armor.tex"}
,{"CHARACTER", "CLOTHING", "WINTER", "ARMOUR"})

--yari
AddRecipe2("yari",
{Ingredient("spear", 1),Ingredient("goldnugget", 2)},
TECH.SCIENCE_TWO
,{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/yari.xml", image = "yari.tex"},
{"CHARACTER", "WEAPONS"})

--mnaginata
AddRecipe2("mnaginata",
{Ingredient("spear", 1),Ingredient("goldnugget", 2)},
TECH.SCIENCE_TWO,
{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/mnaginata.xml", image = "mnaginata.tex"},
{"CHARACTER", "WEAPONS"})

--mkabuto
AddRecipe2("mkabuto",
{Ingredient("boards", 2),Ingredient("rope", 2),Ingredient("goldnugget", 2)},
TECH.SCIENCE_TWO,
{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/mkabuto.xml", image = "mkabuto.tex"},
{"CHARACTER", "ARMOUR"})

--mkabuto2
AddRecipe2("mkabuto2",
{Ingredient("boards", 2),Ingredient("rope", 2)},
TECH.SCIENCE_TWO,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/mkabuto2.xml", image = "mkabuto2.tex"},
{"CHARACTER", "ARMOUR"})

--mingot
AddRecipe2("mingot",
{Ingredient("moonrocknugget", 8),Ingredient("moonglass", 8),Ingredient("thulecite", 4)},
TECH.SCIENCE_TWO,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/mingot.xml", image = "mingot.tex"},
{"CHARACTER", "REFINE"})

if GetModConfigData("compatiblewithia") then
    -- Surf board
    AddRecipe2("msurfboard_item",
    {Ingredient("boards", 1), Ingredient("seashell", 2)},
    TECH.NONE,
    {builder_tag = "manutsaweecraft", atlas = "images/inventoryimages/boat_msurfboard.xml", image = "boat_msurfboard.tex"},
    {"CHARACTER", "SEAFARING"})
end

AddRecipe2("mkatana",{Ingredient("flint", 6),Ingredient("rope", 2),Ingredient("log", 2)},TECH.SCIENCE_ONE,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/mkatana.xml", image = "mkatana.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("katanablade",{Ingredient("rope", 1),Ingredient("katanabody", 1,"images/inventoryimages/katanabody.xml"),Ingredient("cutstone", 1)},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/katanablade.xml", image = "katanablade.tex"},{"CHARACTER", "WEAPONS"})

AddRecipe2("shirasaya",{Ingredient("cane", 1),Ingredient("katanablade", 1,"images/inventoryimages/katanablade.xml")},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/shirasaya.xml", image = "shirasaya.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("koshirae",{Ingredient("cane", 1),Ingredient("katanablade", 1,"images/inventoryimages/katanablade.xml"),Ingredient("rope", 2),Ingredient("goldnugget", 2)},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/koshirae.xml", image = "koshirae.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("hitokiri",{Ingredient("cane", 1),Ingredient("katanablade", 1,"images/inventoryimages/katanablade.xml"),Ingredient("rope", 2),Ingredient("goldnugget", 2)},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/hitokiri.xml", image = "hitokiri.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("raikiri",{Ingredient("cane", 1),Ingredient("katanablade", 1,"images/inventoryimages/katanablade.xml"),Ingredient("rope", 2),Ingredient("goldnugget", 2)},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/raikiri.xml", image = "raikiri.tex"},{"CHARACTER", "WEAPONS"})

AddRecipe2("shirasaya2",{Ingredient("thulecite", 40),Ingredient("nightmarefuel", 80),Ingredient("shadowheart", 6),Ingredient("shirasaya", 1,"images/inventoryimages/shirasaya.xml")},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/shirasaya2.xml", image = "shirasaya2.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("koshirae2",{Ingredient("thulecite", 40),Ingredient("nightmarefuel", 80),Ingredient("opalpreciousgem", 6),Ingredient("koshirae", 1,"images/inventoryimages/koshirae.xml")},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/koshirae2.xml", image = "koshirae2.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("hitokiri2",{Ingredient("thulecite", 40),Ingredient("nightmarefuel", 80),Ingredient("minotaurhorn", 4),Ingredient("hitokiri", 1,"images/inventoryimages/hitokiri.xml")},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/hitokiri2.xml", image = "hitokiri2.tex"},{"CHARACTER", "WEAPONS"})
AddRecipe2("raikiri2",{Ingredient("thulecite", 40),Ingredient("nightmarefuel", 80),Ingredient("lightninggoathorn", 12),Ingredient("raikiri", 1,"images/inventoryimages/raikiri.xml")},TECH.SCIENCE_TWO,{builder_tag="manutsaweecraft2", atlas = "images/inventoryimages/raikiri2.xml", image = "raikiri2.tex"},{"CHARACTER", "WEAPONS"})
