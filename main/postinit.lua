local modimport = modimport
local TUNING = GLOBAL.TUNING
GLOBAL.setfenv(1, GLOBAL)

local postinit = {
    "player"
}

local prefab_post = {
    "minisign"
}

local stategraphs_post = {
    "wilson",
    "wilson_client"
}

local skill_scripts = {
    "commomskill",
    "manutsaweeskill",
    "manutsaweeskillActive"
}

for k, v in ipairs(postinit) do
    modimport("postinit/" .. v)
end

for k, v in ipairs(prefab_post) do
    modimport("postinit/prefabs/" .. v)
end

for k, v in ipairs(stategraphs_post) do
    modimport("postinit/stategraphs/SG".. v)
end

for k, v in ipairs(skill_scripts) do
    modimport("postinit/skillscripts/".. v)
end

if MCONFIG.COMPATIBLEWITHKATANA then
    table.insert(postinit , "katanarecipes")
end
