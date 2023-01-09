local Assets = {
	-- Animation files for the item (showing it on the ground and swap symbols for the players).
	Asset("ANIM", "anim/m_scarf.zip"),
	Asset("ANIM", "anim/mface_scarf.zip"),
	
	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/m_scarf.xml"),
    Asset("IMAGE", "images/inventoryimages/m_scarf.tex"),
}

local function OnEquip(inst, owner)
	
    owner.AnimState:OverrideSymbol("swap_body", "m_scarf", "swap_body")
	
	if owner.prefab == "manutsawee" then 
	owner.AnimState:OverrideSymbol("beard", "mface_scarf", "beard_short")	
	end
	
	 if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
     end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	
	if owner.prefab == "manutsawee" then 
    owner.AnimState:ClearOverrideSymbol("beard")
	end
	
	if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
    end
	
end

local function MainFunction()
	-- Functions which are performed both on Client and Server start here.
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
    MakeInventoryPhysics(inst)
    
	-- Add minimap icon. Remember about its XML in modmain.lua!
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("m_scarf.tex")
	
	--[[ ANIMSTATE ]]--
	-- This is the name visible on the top of hierarchy in Spriter.
    inst.AnimState:SetBank("m_scarf")
	-- This is the name of your compiled*.zip file.
    inst.AnimState:SetBuild("m_scarf")
	-- This is the animation name while item is on the ground.
    inst.AnimState:PlayAnimation("anim")	
	
	
	MakeInventoryFloatable(inst, "small", 0.2, 1.1)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		-- If we're not the host - stop performing further functions.
		-- Only server functions below.
        return inst
    end
	
	inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/m_scarf.xml"
	inst.components.inventoryitem.imagename = "m_scarf"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	
	inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
	
	inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.GOGGLES_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)  
	
	--inst:AddComponent("armor")
	-- Durability = 500, resistance to damage = 70%
    --inst.components.armor:InitCondition(500, 0.7)	
    
	MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab( "common/inventory/m_scarf", MainFunction, Assets) 
