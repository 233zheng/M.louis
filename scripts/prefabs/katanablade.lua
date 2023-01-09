local assets=
{
    Asset("ANIM", "anim/katanablade.zip"),   
    Asset("ANIM", "anim/swap_katanablade.zip"),
    
    Asset("ATLAS", "images/inventoryimages/katanablade.xml"),
    Asset("IMAGE", "images/inventoryimages/katanablade.tex"),	
}

local DMG = 68
local function OnEquip(inst, owner)	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	owner.AnimState:OverrideSymbol("swap_object", "swap_katanablade", "swap_katanablade")
	
	if owner:HasTag("kenjutsu") then --Owner	
		inst.components.weapon:SetDamage(DMG+(owner.kenjutsulevel*2))		
	end	

	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end

end
  
local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	if owner.kenjutsulevel ~= nil then --Owner	
	inst:RemoveTag("mkatana")	
	end

end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end		
	if math.random(1,4) == 1 then
		local x = math.random(1, 1.2)
		local y = math.random(1, 1.2)
		local z = math.random(1, 1.2)
		local slash	= {"shadowstrike_slash_fx","shadowstrike_slash2_fx"}
		
		slash = SpawnPrefab(slash[math.random(1,2)])		
		slash.Transform:SetPosition(target:GetPosition():Get())
		slash.Transform:SetScale(x, y, z)
	end	
	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end
	
	inst.components.weapon.attackwear = target ~= nil and target:IsValid()
		and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
		and TUNING.GLASSCUTTER.SHADOW_WEAR
		or 1
end

local function Onfinish(inst)	
	inst:Remove()	
end

local function repair(inst, chopper)
	local collapse_fx = SpawnPrefab("crab_king_shine")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
	local item = SpawnPrefab("katanablade")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
	item.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    
	inst:Remove()	
end

local function onhit(inst, worker)
	local fx = SpawnPrefab("sparks")
	if not worker:HasTag("player") then inst.components.workable:SetWorkLeft(10) return end
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_mech_med_sharp")    
end

local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()	
    
    MakeInventoryPhysics(inst)  
      
    inst.AnimState:SetBank("katanablade")
    inst.AnimState:SetBuild("katanablade")
    inst.AnimState:PlayAnimation("idle")
	  
	--inst:AddTag("nosteal")    
	inst:AddTag("sharp")
	inst:AddTag("woodensword")	
    inst:AddTag("katanaskill")
		
    if not TheWorld.ismastersim then
        return inst
    end 
    inst.entity:SetPristine()   

    inst:AddComponent("weapon")	
	inst.components.weapon:SetDamage(DMG)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetRange(.8, 1.2)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
		
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(800)
	inst.components.finiteuses:SetUses(800)
	inst.components.finiteuses:SetOnFinished(Onfinish)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.imagename = "katanablade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/katanablade.xml"	
	--inst.components.inventoryitem.canonlygoinpocket = true
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.walkspeedmult = 1.15
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(repair)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkable(true)
	
	MakeHauntableLaunch(inst)		
    return inst
end

return  Prefab("common/inventory/katanablade", fn, assets) 