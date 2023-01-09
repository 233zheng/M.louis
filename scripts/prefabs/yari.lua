local assets=
{   Asset("ANIM", "anim/yari.zip"),   
    Asset("ANIM", "anim/swap_yari.zip"),	
    Asset("ATLAS", "images/inventoryimages/yari.xml"),
    Asset("IMAGE", "images/inventoryimages/yari.tex"),
	Asset("ANIM", "anim/player_lunge_blue.zip"), --from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
}
local DMG = 42.5
local function OnEquip(inst, owner)	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.AnimState:OverrideSymbol("swap_object", "swap_yari", "swap_yari")
	
	if owner:HasTag("kenjutsu") then 
		inst:AddTag("yari") 
		inst.components.weapon:SetDamage(DMG+(owner.kenjutsulevel*2)) 
	end
	
end
  
local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	if owner:HasTag("kenjutsu") then inst:RemoveTag("yari")	end
	inst.components.weapon:SetDamage(DMG)
end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end
	
	--if math.random(1,3) == 1 then			
	local effect = SpawnPrefab("impact")		
	effect.Transform:SetPosition(target:GetPosition():Get())
	--end
	
end


local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()	
	minimap:SetIcon( "yari.tex" )
    
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("yari")
    inst.AnimState:SetBuild("yari")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")	
	inst:AddTag("yarispear")	
    
	local swap_data = {sym_build = "swap_yari", bank = "yari"}
    MakeInventoryFloatable(inst, "med", nil, {1.0, 0.5, 1.0}, true, -13, swap_data)    
	
    if not TheWorld.ismastersim then
        return inst
    end 
    inst.entity:SetPristine()   

    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(DMG)
	inst.components.weapon:SetRange(1.6, 1.8)
	inst.components.weapon:SetOnAttack(onattack)	
	
	inst:AddComponent("timer")
    inst:AddComponent("inspectable")    
    inst:AddComponent("inventoryitem")
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
    inst.components.inventoryitem.imagename = "yari"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/yari.xml"	
	--inst.components.inventoryitem.canonlygoinpocket = true
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	
	--MakeHauntableLaunch(inst)		
    return inst
end

return  Prefab("common/inventory/yari", fn, assets) 