local shirasaya_assets = {
    Asset("ANIM", "anim/shirasaya.zip"),
    Asset("ANIM", "anim/shirasaya2.zip"),
    Asset("ANIM", "anim/swap_shirasaya.zip"),
    Asset("ANIM", "anim/swap_Sshirasaya.zip"),
    -- I made sc_shirasaya, but it looks bad.
    -- because I'm not very skilled at animation.
    Asset("ANIM", "anim/sc_shirasaya.zip"),
    Asset("ANIM", "anim/sc_shirasaya2.zip"),

    Asset("ATLAS", "images/inventoryimages/shirasaya2.xml"),
    Asset("IMAGE", "images/inventoryimages/shirasaya2.tex"),
}

local raikiri_assets = {
    Asset("ANIM", "anim/raikiri.zip"),
    Asset("ANIM", "anim/raikiri2.zip"),
    Asset("ANIM", "anim/swap_raikiri.zip"),
    Asset("ANIM", "anim/swap_Sraikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri2.zip"),

    Asset("ATLAS", "images/inventoryimages/raikiri2.xml"),
    Asset("IMAGE", "images/inventoryimages/raikiri2.tex"),
}

local koshirae_assets = {
    Asset("ANIM", "anim/koshirae.zip"),
    Asset("ANIM", "anim/koshirae2.zip"),
    Asset("ANIM", "anim/swap_koshirae.zip"),
    Asset("ANIM", "anim/swap_Skoshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae2.zip"),

    Asset("ATLAS", "images/inventoryimages/koshirae2.xml"),
    Asset("IMAGE", "images/inventoryimages/koshirae2.tex"),
}

local hitokiri_assets = {
    Asset("ANIM", "anim/hitokiri.zip"),
    Asset("ANIM", "anim/hitokiri2.zip"),
    Asset("ANIM", "anim/swap_hitokiri.zip"),
    Asset("ANIM", "anim/swap_Shitokiri.zip"),
    Asset("ANIM", "anim/sc_hitokiri.zip"),
    Asset("ANIM", "anim/sc_hitokiri2.zip"),

    Asset("ATLAS", "images/inventoryimages/hitokiri2.xml"),
    Asset("IMAGE", "images/inventoryimages/hitokiri2.tex"),
}

-- Sheath insertion mode
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

    if not owner:HasTag("notshowscabbard") then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    end

	inst.components.weapon:SetRange(1, 1.5)

	inst.components.equippable.walkspeedmult = 1.25

	if inst:HasTag("mkatana") then
        inst:RemoveTag("mkatana")
    end

    if not inst:HasTag("Iai") then
        inst:AddTag("Iai")
    end

    inst.wpstatus = 1
end

-- Exothecation mode
local function ExothecationMode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", inst.swap, inst.swap)

	inst.AnimState:SetBank(inst.bank2)
    inst.AnimState:SetBuild(inst.build2)

    if TUNING.MANUTSAWEE.COMPATIBLE then
        if inst.components.tool ~= nil then
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
		inst.components.weapon:SetDamage(TUNING.KATANA.MASTER_DMG + (owner.kenjutsulevel * 2))
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

	inst.components.weapon:SetDamage(TUNING.KATANA.MASTER_DMG)
end

local shockeffect
local function onisraining(inst, israining)
    if israining then
        shockeffect = true
    else
        shockeffect = false
    end
end


local function castFn(inst, target)
	if inst.wpstatus == 1 then
        ExothecationMode(inst)
    else
        SheathInsertionMode(inst)
	end
end

local function SpawnNewKatana(inst, item)

    local owner = inst.components.inventoryitem:GetGrandOwner()
	local katana = SpawnPrefab(item)

    if not owner:HasTag("notshowscabbard")  then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    end

	if owner ~= nil then
		owner.components.inventory:GiveItem(katana)
		inst:DoTaskInTime(0.1, function()
            owner.components.inventory:DropItem(katana)
            local electrichitsparks = SpawnPrefab("electrichitsparks")
            electrichitsparks:AlignToTarget(katana, katana, true)
        end)
	end

end

local function Onfinish(inst)
    SpawnNewKatana(inst, inst.item)
	inst:Remove()
end

local function swordregen(inst)
	local usedamount = inst.components.finiteuses:GetUses()
	if usedamount and inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then
		inst.components.finiteuses:SetUses(usedamount + 2)
	end

	inst:DoTaskInTime(60, swordregen)
end

local function onSave(inst, data)
    data.wpstatus = inst.wpstatus
end

local function onLoad(inst, data)
    if data ~= nil then
        inst.wpstatus = data.wpstatus or 1
    end
end

-- They run on client
local function commonfn(bank, build, shadow_item)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    if shadow_item then
        inst:AddTag("shadow_item")
        inst:AddTag("shadow")
    end

	inst:AddTag("nosteal")
	inst:AddTag("sharp")

	inst.spelltype = "SCIENCE"

    inst:AddTag("veryquickcast")
    inst:AddTag("katanaskill")

	inst:AddTag("waterproofer")

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("small")
    inst.components.floater:SetVerticalOffset(0.1)

    return inst
end

-- They run on master
local function masterfn(inst, image, spawnnewitem, bank, build, sc_bank, swap, sswap)
    -- Add required components
    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.KATANA.MASTER_DMG)
	-- inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("inspectable")

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KATANA.FINITEUSES)
	inst.components.finiteuses:SetUses(TUNING.KATANA.FINITEUSES)
	inst.components.finiteuses:SetOnFinished(Onfinish)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
	inst.components.inventoryitem.keepondrown = true
	inst.components.inventoryitem.canonlygoinpocket = true
    inst.components.inventoryitem.imagename = image
    inst.components.inventoryitem.atlasname = "images/inventoryimages/".. image ..".xml"

	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.veryquickcast = true

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnPocket(OnPocket)

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

    -- Save the value of status
    inst.OnSave = onSave
    inst.OnLoad = onLoad

	MakeHauntableLaunch(inst)

	inst:DoTaskInTime(60, swordregen)

    return inst
end

local function hitokiri2OnAttack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end

	if inst.wpstatus == 1 and inst:HasTag("Iai") then
        ExothecationMode(inst)
		if target.components.combat ~= nil then
            target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8)
        end
	end

	if owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (target:HasTag("wall") or target:HasTag("engineering")) then
        owner.components.health:DoDelta(TUNING.BATBAT_DRAIN, false, "hitokiri2")
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

local function hitokiri2fn()
    local inst = commonfn("hitokiri", "hitokiri")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "hitokiri2", "hitokiri", "hitokiri", "hitokiri", "sc_hitokiri", "swap_hitokiri", "swap_Shitokiri")

    -- Because it is a shadow item
    inst.components.equippable.is_magic_dapperness = true

    inst.components.weapon:SetOnAttack(hitokiri2OnAttack)

    return inst
end

local function shirasaya2OnAttack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end

	if inst.wpstatus == 1 and inst:HasTag("Iai") then
        ExothecationMode(inst)
		if target.components.combat ~= nil then
            target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8)
        end
	end

	if (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion")) then
		if target.components.combat ~= nil then target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.5) end
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

local function shirasaya2fn()
    local inst = commonfn("shirasaya", "shirasaya")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "shirasaya2", "shirasaya", "shirasaya", "shirasaya", "sc_shirasaya", "swap_shirasaya", "swap_Sshirasaya")

    inst.components.weapon:SetOnAttack(shirasaya2OnAttack)

    return inst
end

local function raikiri2OnAttackk(inst, owner, target)
	if owner.components.rider:IsRiding() then return end

	if inst.wpstatus == 1 and inst:HasTag("Iai") then
        ExothecationMode(inst)
		if target.components.combat ~= nil then
            target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8)
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

    local electrichitsparks = SpawnPrefab("electrichitsparks")
	electrichitsparks:AlignToTarget(target, owner, true)
	if shockeffect and target ~= nil and target:IsValid() and owner ~= nil and owner:IsValid() then
		electrichitsparks:AlignToTarget(target, owner, true)
		if target.components.combat ~= nil then target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8) end
    end

	inst.components.weapon.attackwear = target ~= nil and target:IsValid()
		and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
		and TUNING.GLASSCUTTER.SHADOW_WEAR
		or 1
end

local function raikiri2fn()
    local inst = commonfn("raikiri", "raikiri")

    inst:AddTag("lightningcutter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "raikiri2", "raikiri", "raikiri", "raikiri", "sc_raikiri", "swap_raikiri", "swap_Sraikiri")

    inst.components.weapon:SetOnAttack(raikiri2OnAttackk)

    -- Because it's a lightning cutter
    inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)

    return inst
end

local function koshirae2OnAttack(inst, owner, target)
	if owner.components.rider:IsRiding() then
        return
    end

	if inst.wpstatus == 1 and inst:HasTag("Iai") then
        ExothecationMode(inst)
		if target.components.combat ~= nil then
            target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8)
        end
	end

	if target:HasTag("epic") and target.components.combat ~= nil then
        target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.5)
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

local function koshirae2fn()
    local inst = commonfn("koshirae", "koshirae")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    masterfn(inst, "koshirae2", "koshirae", "koshirae", "koshirae", "sc_koshirae", "swap_koshirae", "swap_Skoshirae")

    inst.components.weapon:SetOnAttack(koshirae2OnAttack)

    return inst
end

-- Make katana and return it to host
local function MakeKatana2(name, fn, asset)
    return Prefab(name, fn, asset)
end

return MakeKatana2("hitokiri2", hitokiri2fn, hitokiri_assets),
        MakeKatana2("shirasaya2", shirasaya2fn, shirasaya_assets),
        MakeKatana2("raikiri2", raikiri2fn, raikiri_assets),
        MakeKatana2("koshirae2", koshirae2fn, koshirae_assets)
