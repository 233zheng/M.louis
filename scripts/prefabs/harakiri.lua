local assets=
{
    Asset("ANIM", "anim/harakiri.zip"),   
    Asset("ANIM", "anim/swap_harakiri.zip"),
    
    Asset("ATLAS", "images/inventoryimages/harakiri.xml"),
    Asset("IMAGE", "images/inventoryimages/harakiri.tex"),	
}

local function OnEquip(inst, owner)	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.AnimState:OverrideSymbol("swap_object", "swap_harakiri", "swap_harakiri")	
end
  
local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")	
end

local function castFn(inst, target)

local owner = inst.components.inventoryitem.owner
local body = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)

if body then owner.components.inventory:DropItem(body) end

owner.components.combat:GetAttacked(inst, 99999)
local impactfx = SpawnPrefab("impact")    
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(owner.GUID, owner.components.combat.hiteffectsymbol, 0, 0, 0)        
        impactfx:FacePoint(owner.Transform:GetWorldPosition())       
	--inst.Remove(inst)	
end

local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()	
    
    MakeInventoryPhysics(inst)  
      
    inst.AnimState:SetBank("harakiri")
    inst.AnimState:SetBuild("harakiri")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")    
		
	inst.spelltype = "SCIENCE"   
    inst:AddTag("quickcast")
    
	MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("small")
    inst.components.floater:SetVerticalOffset(0.1)		    
	
    if not TheWorld.ismastersim then
        return inst
    end 
    inst.entity:SetPristine()   

    inst:AddComponent("weapon")	
	inst.components.weapon:SetDamage(34)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst:AddComponent("inspectable")    
    inst:AddComponent("inventoryitem")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.veryquickcast = true
    inst.components.spellcaster.canusefrominventory = true
	
    inst.components.inventoryitem.imagename = "harakiri"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/harakiri.xml"	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	
	--MakeHauntableLaunch(inst)		
    return inst
end

return  Prefab("common/inventory/harakiri", fn, assets) 