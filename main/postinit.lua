local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

local postinit = {
    "player"
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

for k, v in pairs(postinit) do
    modimport("postinit/" .. v)
end

for k, v in pairs(stategraphs_post) do
    modimport("postinit/stategraphs/SG".. v)
end

for k, v in pairs(skill_scripts) do
    modimport("postinit/skillscripts/".. v)
end
