local assets=
{ 
    Asset("ANIM", "anim/m_foxmask.zip"),
    Asset("ANIM", "anim/m_foxmask_swap.zip"),
    Asset("ANIM", "anim/m_foxmask2_swap.zip"),
    Asset("ANIM", "anim/m_sfoxmask_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/m_foxmask.xml"),
    Asset("IMAGE", "images/inventoryimages/m_foxmask.tex"),
}
local prefabs = 
{
}

local function Maskmode(inst)
	local owner = inst.components.inventoryitem.owner
	if inst.maskstatus == 0 then 
	owner.AnimState:OverrideSymbol("swap_hat", "m_foxmask_swap", "swap_hat")
		
	elseif inst.maskstatus == 1 then owner.AnimState:OverrideSymbol("swap_hat", "m_sfoxmask_swap", "swap_hat")
	else owner.AnimState:OverrideSymbol("swap_hat", "m_foxmask2_swap", "swap_hat")
	
	end	
end

local function OnEquip(inst, owner)	
		Maskmode(inst)		
        owner.AnimState:Show("HAT")     
	
	 if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
     end
end

local function OnUnequip(inst, owner)
        owner.AnimState:Hide("HAT")		
		if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
end

local function castFn(inst, target)	
	if	inst.maskstatus >= 2 then inst.maskstatus = 0 else inst.maskstatus =  inst.maskstatus + 1 end
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
	inst:AddTag("quickcast")
	inst.spelltype = "SCIENCE"   
	
    MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("m_foxmask")  --MAKE SURE TO REFERENCE THE RIGHT BANK WHEN MAKING DROPPED ITEMS
    inst.AnimState:SetBuild("m_foxmask")
    inst.AnimState:PlayAnimation("idle")
	
	
	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.1)

	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "m_foxmask"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/m_foxmask.xml"	
	
	inst:AddComponent("tradable")
	 
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)	
    inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.quickcast = true	
	
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.GOGGLES_PERISHTIME)
    inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)  
    
    inst:AddComponent("equippable")
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst.maskstatus = 0
	inst.OnSave = onSave
    inst.OnLoad = onLoad
	
	MakeHauntableLaunch(inst)
    return inst
end

return  Prefab("common/inventory/m_foxmask", fn, assets, prefabs)