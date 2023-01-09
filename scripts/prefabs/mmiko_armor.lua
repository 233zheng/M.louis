local Assets = {	
	Asset("ANIM", "anim/mmiko_armor.zip"),
		
    Asset("ATLAS", "images/inventoryimages/mmiko_armor.xml"),
    Asset("IMAGE", "images/inventoryimages/mmiko_armor.tex"),
}

local function Armormode(inst)
	local owner = inst.components.inventoryitem.owner
	if inst.armorstatus == 0 then 
	owner.AnimState:OverrideSymbol("swap_body", "mmiko_armor", "swap_body")
	
	else  owner.AnimState:ClearOverrideSymbol("swap_body")
	
	end	
end

local function OnEquip(inst, owner)
	Armormode(inst)   
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function castFn(inst, target)
	local owner = inst.components.inventoryitem.owner
	if owner.prefab ~= "manutsawee" then return end
	if	inst.armorstatus == 0 then inst.armorstatus = 1	else inst.armorstatus = 0 end
	Armormode(inst)
end

local function onSave(inst, data)   
    data.armorstatus = inst.armorstatus    
end

local function onLoad(inst, data)
    if data then	
        inst.armorstatus = data.armorstatus or 0 		
    end 		
end

local function MainFunction()
	
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mmiko_armor")
    inst.AnimState:SetBuild("mmiko_armor")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("mikoarmor")
	inst.spelltype = "SCIENCE"
	
	MakeInventoryFloatable(inst, "small", 0.2, 1.1)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then	
        return inst
    end
	
	inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/mmiko_armor.xml"
	inst.components.inventoryitem.imagename = "mmiko_armor"
		
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_MED)

    inst:AddComponent("equippable")
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)	
	inst.components.equippable.restrictedtag = "manutsaweecraft"
	
	inst:AddComponent("armor")	
    inst.components.armor:InitCondition(1500, 0.8)	
    
	MakeHauntableLaunch(inst)
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)	
    inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.quickcast = true	
	
	inst.armorstatus = 0
	inst.OnSave = onSave
    inst.OnLoad = onLoad
	
    return inst
end
	
return Prefab( "common/inventory/mmiko_armor", MainFunction, Assets) 
