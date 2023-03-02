local AddPrefabPostInit = AddPrefabPostInit
local resolvefilepath = GLOBAL.resolvefilepath
GLOBAL.setfenv(1, GLOBAL)

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

local function postinit(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.drawable ~= nil then
		local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
		inst.components.drawable.ondrawnfn = function(inst, image, src, atlas, bgimage, bgatlas)
            if oldondrawnfn ~= nil then
                oldondrawnfn(inst, image, src, atlas, bgimage, bgatlas)
            end
            if image ~= nil and table.contains(items, image) then
                inst.AnimState:OverrideSymbol("SWAP_SIGN", resolvefilepath(atlas), image..".tex")
            end
        end
	end
end

local t = {
    "minisign",
    "minisign_drawn"
}

for k, v in ipairs(t) do
    AddPrefabPostInit(v, postinit)
end
