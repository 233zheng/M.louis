local AddPlayerPostInit = AddPlayerPostInit
GLOBAL.setfenv(1, GLOBAL)

local function MOnEquip(inst, data)
    if data.item and (data.item.prefab == "onemanband" or data.item.prefab == "armorsnurtleshell") then
        if not inst:HasTag("notshowscabbard") then
            inst:AddTag("notshowscabbard")
        end
    end
end

local function MOnUnEquip(inst, data)
    if data.item and (data.item.prefab == "onemanband" or data.item.prefab == "armorsnurtleshell") then
        if inst:HasTag("notshowscabbard") then
            inst:RemoveTag("notshowscabbard")
        end
    end
end

local function MOnDroped(inst, data)
    local item = data ~= nil and (data.prev_item or data.item)

    if item and item:HasTag("katanaskill") and not item:HasTag("woodensword") then
        if not inst:HasTag("notshowscabbard") then
            inst.AnimState:ClearOverrideSymbol("swap_body_tall")
        end
    end
end

local function KatanaShowOnBack(inst)
    inst:ListenForEvent("equip", MOnEquip)
    inst:ListenForEvent("unequip", MOnUnEquip)
    inst:ListenForEvent("dropitem", MOnDroped)
    inst:ListenForEvent("itemlose", MOnDroped)
end

AddPlayerPostInit(KatanaShowOnBack)
