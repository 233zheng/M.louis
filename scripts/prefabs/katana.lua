local shirasaya_assets = {
    Asset("ANIM", "anim/shirasaya.zip"),
    Asset("ANIM", "anim/shirasaya2.zip"),
    Asset("ANIM", "anim/swap_shirasaya.zip"),
    Asset("ANIM", "anim/swap_Sshirasaya.zip"),
    -- I made sc_shirasaya, but it looks bad.
    -- because I'm not very skilled at animation.
    Asset("ANIM", "anim/sc_shirasaya.zip"),
    Asset("ANIM", "anim/sc_shirasaya2.zip"),

    Asset("ATLAS", "images/inventoryimages/shirasaya.xml"),
    Asset("IMAGE", "images/inventoryimages/shirasaya.tex"),
}

local raikiri_assets = {
    Asset("ANIM", "anim/raikiri.zip"),
    Asset("ANIM", "anim/raikiri2.zip"),
    Asset("ANIM", "anim/swap_raikiri.zip"),
    Asset("ANIM", "anim/swap_Sraikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri2.zip"),

    Asset("ATLAS", "images/inventoryimages/raikiri.xml"),
    Asset("IMAGE", "images/inventoryimages/raikiri.tex"),
}

local koshirae_assets = {
    Asset("ANIM", "anim/koshirae.zip"),
    Asset("ANIM", "anim/koshirae2.zip"),
    Asset("ANIM", "anim/swap_koshirae.zip"),
    Asset("ANIM", "anim/swap_Skoshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae2.zip"),

    Asset("ATLAS", "images/inventoryimages/koshirae.xml"),
    Asset("IMAGE", "images/inventoryimages/koshirae.tex"),
}

local hitokiri_assets = {
    Asset("ANIM", "anim/hitokiri.zip"),
    Asset("ANIM", "anim/hitokiri2.zip"),
    Asset("ANIM", "anim/swap_hitokiri.zip"),
    Asset("ANIM", "anim/swap_Shitokiri.zip"),
    Asset("ANIM", "anim/sc_hitokiri.zip"),
    Asset("ANIM", "anim/sc_hitokiri2.zip"),

    Asset("ATLAS", "images/inventoryimages/hitokiri.xml"),
    Asset("IMAGE", "images/inventoryimages/hitokiri.tex"),
}

local function SheathInsertionMode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", inst.sswap, inst.sswap)

	inst.AnimState:SetBank(inst.bank)
    inst.AnimState:SetBuild(inst.build)

    if TUNING.MANUTSAWEE.COMPATIBLE then
        if inst.components.tool ~= nil then
            inst:RemoveComponent("tool")
        end
    end

	if inst.components.workable ~= nil then
        inst.components.workable:SetWorkable(false)
    end

	inst.components.weapon:SetRange(1, 1.5)

	if not owner:HasTag("notshowscabbard")  then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    end

	inst.components.equippable.walkspeedmult = 1.25

	if inst:HasTag("mkatana") then
        inst:RemoveTag("mkatana")
    end

    if not inst:HasTag("Iai") then
        inst:AddTag("Iai")
    end

    inst.wpstatus = 1
end

local function ExothecationMode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", inst.swap, inst.swap)

	inst.AnimState:SetBank(inst.bank2)
    inst.AnimState:SetBuild(inst.build2)

    if TUNING.MANUTSAWEE.COMPATIBLE then
        if inst.components.tool == nil then
            inst:AddComponent("tool")
            inst.components.tool:SetAction(ACTIONS.HACK, 3)
        end
    end

	if inst.components.workable then
        inst.components.workable:SetWorkable(true)
    end

	if not owner:HasTag("notshowscabbard") then
        owner.AnimState:OverrideSymbol("swap_body_tall", inst.sc_bank, "tail")
    end

	inst.components.weapon:SetRange(.8, 1.2)

	inst.components.equippable.walkspeedmult = 1.15

	if inst:HasTag("mkatana")then
        inst:RemoveTag("mkatana")
    end

    if inst:HasTag("Iai") then
        inst:RemoveTag("Iai")
    end

	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana") then
        inst:AddTag("mkatana")
    end

    inst.wpstatus = 2
end

local function OnPocket(inst)
	local owner = inst.components.inventoryitem.owner

    if not owner:HasTag("notshowscabbard") and owner:HasTag("player") then
        owner.AnimState:OverrideSymbol("swap_body_tall", inst.sc_bank2, "tail")
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

	if owner:HasTag("kenjutsu") then --Owner
		inst.components.weapon:SetDamage(TUNING.KATANA.COMMON_DMG+(owner.kenjutsulevel*2))
	end

	if inst.wpstatus == 1 then
        SheathInsertionMode(inst)
	else
        ExothecationMode(inst)
    end
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	inst.components.weapon:SetDamage(TUNING.KATANA.COMMON_DMG)
end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end

	if inst.wpstatus == 1 and inst:HasTag("Iai") then
        ExothecationMode(inst)
		if target.components.combat ~= nil then
            target.components.combat:GetAttacked(owner, inst.components.weapon.damage * .6)
        end
	end

	if math.random(1,4) == 1 then
        local num = math.random(1, 1.2)
		local x = num
		local y = num
		local z = num
		local slash	= {"shadowstrike_slash_fx","shadowstrike_slash2_fx"}

		slash = SpawnPrefab(slash[math.random(1,2)])
		slash.Transform:SetPosition(target:GetPosition():Get())
		slash.Transform:SetScale(x, y, z)
	end

	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana") then
        inst:AddTag("mkatana")
    end

    inst.components.weapon.attackwear = target ~= nil and target:IsValid()
		and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
		and TUNING.GLASSCUTTER.SHADOW_WEAR
		or 1
end

local function castFn(inst, target)
	if inst.wpstatus == 1 then
        ExothecationMode(inst)
	else
        SheathInsertionMode(inst)
	end
end

local function Onfinish(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner and not owner:HasTag("notshowscabbard") then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    end
	inst:Remove()
end

local function SpawnNewKatana(inst, item)
	local katana = SpawnPrefab(item)
	katana.Transform:SetPosition(inst.Transform:GetWorldPosition())
	katana.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

local function repair(inst, chopper)
	local collapse_fx = SpawnPrefab("crab_king_shine")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    SpawnNewKatana(inst, inst.item)
	inst:Remove()
end

local function onhit(inst, worker)
	local fx = SpawnPrefab("sparks")

    if not worker:HasTag("player") then
        inst.components.workable:SetWorkLeft(10)
        return
    end

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_mech_med_sharp")
end

local function OnPutInInventory(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner ~= nil and owner.components.inventory and not owner:HasTag("manutsaweecraft") then
		if owner:HasTag("player") then
            owner.components.talker:Say("It's against me......")
        end
        inst:DoTaskInTime(0.1, function()
			owner.components.inventory:DropItem(inst)
		end)
    end
end

local function onSave(inst, data)
    data.wpstatus = inst.wpstatus
end

local function onLoad(inst, data)
    if data ~= nil then
        inst.wpstatus = data.wpstatus or 1
    end
end

local function commonfn(bank, build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

	--inst:AddTag("nosteal")
	inst:AddTag("sharp")

	inst.spelltype = "SCIENCE"
    inst:AddTag("veryquickcast")
    inst:AddTag("katanaskill")

	inst:AddTag("waterproofer")

	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("small")
    inst.components.floater:SetVerticalOffset(0.1)

    return inst
end

--Actually, I can use the same parameter
local function masterfn(inst, image, spawnnewitem, bank, build, sc_bank, swap, sswap)
    -- Add required components
    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.KATANA.COMMON_DMG)
	inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KATANA.FINITEUSES)
	inst.components.finiteuses:SetUses(TUNING.KATANA.FINITEUSES)
	inst.components.finiteuses:SetOnFinished(Onfinish)

    inst:AddComponent("inventoryitem")
	-- inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem.imagename = image
    inst.components.inventoryitem.atlasname = "images/inventoryimages/".. image ..".xml"
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.veryquickcast = true

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnPocket(OnPocket)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(repair)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkable(false)

    -- status
    inst.wpstatus = 1

    -- A very bad way
    inst.bank = bank
    inst.build = build
    inst.sc_bank = sc_bank
    inst.sc_bank2 = sc_bank .. "2"
    inst.swap = swap
    inst.sswap = sswap
    inst.item = spawnnewitem
    inst.bank2 = bank .. "2"
    inst.build2 = build .. "2"

    inst.OnSave = onSave
    inst.OnLoad = onLoad

	MakeHauntableLaunch(inst)

    return inst
end

local function hitokirifn()
    local inst = commonfn("hitokiri", "hitokiri")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "hitokiri", "hitokiri", "hitokiri", "hitokiri", "sc_hitokiri", "swap_hitokiri", "swap_Shitokiri")

    return inst
end

local function shirasayafn()
    local inst = commonfn("shirasaya", "shirasaya")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "shirasaya", "shirasaya", "shirasaya", "shirasaya", "sc_shirasaya", "swap_shirasaya", "swap_Sshirasaya")

    return inst
end

local function raikirifn()
    local inst = commonfn("raikiri", "raikiri")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "raikiri", "raikiri", "raikiri", "raikiri", "sc_raikiri", "swap_raikiri", "swap_Sraikiri")

    return inst
end

local function koshiraefn()
    local inst = commonfn("koshirae", "koshirae")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "koshirae", "koshirae", "koshirae", "koshirae", "sc_koshirae", "swap_koshirae", "swap_Skoshirae")

    return inst
end

--MakeKatanafn
local function MakeKatana(name, fn, asset)
    return Prefab(name, fn, asset)
end

return MakeKatana("hitokiri", hitokirifn, hitokiri_assets),
        MakeKatana("shirasaya", shirasayafn, shirasaya_assets),
        MakeKatana("raikiri", raikirifn, raikiri_assets),
        MakeKatana("koshirae", koshiraefn, koshirae_assets)
