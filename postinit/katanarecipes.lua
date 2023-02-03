--FindAndConvertIngredient，AddDictionaryPrefab from Gem Core

local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local AddRecipePostInit =AddRecipePostInit
local AddCharacterRecipe = AddCharacterRecipe
GLOBAL.setfenv(1, GLOBAL)

AddCharacterRecipe("shusui",
{Ingredient("katanablade", 1,"images/inventoryimages/katanablade.xml"),Ingredient("cane", 1),Ingredient("thulecite", 20),Ingredient("nightmarefuel", 20)},
TECH.OBSIDIAN_TWO,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/shusui.xml", image = "shusui.tex"},
{"CHARACTER", "WEAPONS"}
)

local function shusuipostinit(recipe)
    local ingredient = recipe:FindAndConvertIngredient("thulecite")
    if ingredient then
        ingredient:AddDictionaryPrefab("obsidian")
    end
end

AddRecipePostInit("shusui", shusuipostinit)

AddCharacterRecipe("mortalblade",
{Ingredient("shusui", 1,"images/inventoryimages/shusui.xml"),Ingredient("thulecite", 20),Ingredient("nightmarefuel", 40)},
TECH.OBSIDIAN_TWO,
{builder_tag="manutsaweecraft", atlas = "images/inventoryimages/mortalblade.xml", image = "mortalblade.tex"},
{"CHARACTER", "WEAPONS"}
)

local function mortalbladepostinit(recipe)
    local ingredient = recipe:FindAndConvertIngredient("thulecite")
    if ingredient then
        ingredient:AddDictionaryPrefab("obsidian")
    end
end

AddRecipePostInit("mortalblade", shusuipostinit)
