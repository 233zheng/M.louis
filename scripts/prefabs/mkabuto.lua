local assets=
{ 
    Asset("ANIM", "anim/mkabuto.zip"),
    Asset("ANIM", "anim/mkabuto_swap.zip"),
    Asset("ANIM", "anim/m2kabuto_swap.zip"),

    Asset("ATLAS", "images/inventoryimages/mkabuto.xml"),
    Asset("IMAGE", "images/inventoryimages/mkabuto.tex"),
}

local prefabs = 
{
}

local function Maskmode(inst)
	local owner = inst.components.inventoryitem.owner
	if inst.maskstatus == 0 then 
	owner.AnimState:OverrideSymbol("swap_hat", "mkabuto_swap", "swap_hat")
	
	else owner.AnimState:OverrideSymbol("swap_hat", "m2kabuto_swap", "swap_hat")
	
	end	
end

local function OnEquip(inst, owner)		
     Maskmode(inst)
	 
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
        end
end

local function OnUnequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end	
end

local function castFn(inst, target)	
	if	inst.maskstatus == 0 then inst.maskstatus = 1	else inst.maskstatus = 0 end
	Maskmode(inst)
end

local function onSave(inst, data)   
    data.maskstatus = inst.maskstatus    
end

local function onLoad(inst, data)
    if data then	
        inst.maskstatus = data.maskstatus or 0 		
    end 		
end

local function fn()
 local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	inst:AddTag("hat")
	
    MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("mkabuto")  --MAKE SURE TO REFERENCE THE RIGHT BANK WHEN MAKING DROPPED ITEMS
    inst.AnimState:SetBuild("mkabuto")
    inst.AnimState:PlayAnimation("idle")	
	inst.spelltype = "SCIENCE"   
	
	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)

	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mkabuto"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mkabuto.xml"	
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)	
    inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.quickcast = true	
	
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_FOOTBALLHAT*2, TUNING.ARMOR_FOOTBALLHAT_ABSORPTION)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)   
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

	inst.maskstatus = 0
	inst.OnSave = onSave
    inst.OnLoad = onLoad
	
	MakeHauntableLaunch(inst)
    return inst
end

return  Prefab("common/inventory/mkabuto", fn, assets, prefabs)