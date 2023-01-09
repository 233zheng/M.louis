local assets=
{
    Asset("ANIM", "anim/koshirae.zip"),  
    Asset("ANIM", "anim/koshirae2.zip"),  
    Asset("ANIM", "anim/swap_koshirae.zip"),
    Asset("ANIM", "anim/swap_Skoshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae.zip"),
    Asset("ANIM", "anim/sc_koshirae2.zip"),
	
    Asset("ATLAS", "images/inventoryimages/koshirae.xml"),
    Asset("IMAGE", "images/inventoryimages/koshirae.tex"),
	Asset("ANIM", "anim/player_lunge_blue.zip"), --from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
}
local prefabs = {}
local function Firstmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_Skoshirae", "swap_Skoshirae")
	
	inst.AnimState:SetBank("koshirae")
    inst.AnimState:SetBuild("koshirae")
	if inst.components.workable then inst.components.workable:SetWorkable(false) end
	
	inst.components.weapon:SetRange(1, 1.5)
	if not owner:HasTag("notshowscabbard") then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end	
	
	inst.components.equippable.walkspeedmult = 1.25

	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if not inst:HasTag("Iai")then inst:AddTag("Iai") end
	inst.wpstatus = 1
end

local DMG = 68
local function Seccondmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_koshirae", "swap_koshirae")
	
	if not owner:HasTag("notshowscabbard") and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_koshirae", "tail")end
	
	inst.AnimState:SetBank("koshirae2")
    inst.AnimState:SetBuild("koshirae2")
	if inst.components.workable then inst.components.workable:SetWorkable(true) end
	
	inst.components.weapon:SetRange(.8, 1.2)
	
	inst.components.equippable.walkspeedmult = 1.15	

	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if inst:HasTag("Iai")then inst:RemoveTag("Iai") end
	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end
	inst.wpstatus = 2 
end

local function onpocket(inst)
	local owner = inst.components.inventoryitem.owner 	
   if not owner:HasTag("notshowscabbard") and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_koshirae2", "tail") end  
end

local function OnEquip(inst, owner)	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	if owner:HasTag("kenjutsu") then --Owner	
		inst.components.weapon:SetDamage(DMG+(owner.kenjutsulevel*2))		
	end	
	
	if inst.wpstatus == 1 then 
    Firstmode(inst)
	else  Seccondmode(inst) end		
end
  
local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	
	inst.components.weapon:SetDamage(DMG)	
end

local function onSave(inst, data)   
    data.wpstatus = inst.wpstatus     
end

local function onLoad(inst, data)
    if data then	
        inst.wpstatus = data.wpstatus or 1 		
    end
	if inst.wpstatus == 1 then 
	inst.AnimState:SetBank("koshirae")
    inst.AnimState:SetBuild("koshirae")
	inst.components.workable:SetWorkable(false)
	else 
	inst.AnimState:SetBank("koshirae2")
    inst.AnimState:SetBuild("koshirae2")
	inst.components.workable:SetWorkable(true)
	end	
end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end
	
	if inst.wpstatus == 1 and inst:HasTag("Iai") then Seccondmode(inst) 
		if target.components.combat ~= nil then target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.6) end 
	end
	
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

local function castFn(inst, target)	
    local owner = inst.components.inventoryitem.owner	
	if inst.wpstatus == 1 then	
	Seccondmode(inst)	
	else 		 
	Firstmode(inst)
	end
end 

local function Onfinish(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()	
	if owner and not owner:HasTag("notshowscabbard")  then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end
	inst:Remove()	
end

local function repair(inst, chopper)
	local collapse_fx = SpawnPrefab("crab_king_shine")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
	local item = SpawnPrefab("koshirae")
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
	
	--local minimap = inst.entity:AddMiniMapEntity()	
	--minimap:SetIcon( "koshirae.tex" )
    
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("koshirae")
    inst.AnimState:SetBuild("koshirae")
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
	
    if not TheWorld.ismastersim then
        return inst
    end 
    inst.entity:SetPristine()   
	--------------------------------------------------
	
    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(DMG)
	inst.components.weapon:SetOnAttack(onattack)	
	--------------------------------------------------
	
    inst:AddComponent("inspectable")
	--inst:AddComponent("timer")
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(800)
	inst.components.finiteuses:SetUses(800)
	inst.components.finiteuses:SetOnFinished(Onfinish)

	--------------------------------------------------
	
    inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem:SetSinks(true)
	--inst.components.inventoryitem.keepondeath = true
	--inst.components.inventoryitem.keepondrown = true
	inst.components.inventoryitem.canonlygoinpocket = true	
    inst.components.inventoryitem.imagename = "koshirae"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/koshirae.xml"
	--------------------------------------------------
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.canusefrominventory = true		
	inst.components.spellcaster.veryquickcast = true
	--------------------------------------------------
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )	
	inst.components.equippable:SetOnPocket(onpocket)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(repair)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkable(false)
		
	 -- status
    inst.wpstatus = 1
    inst.OnSave = onSave
    inst.OnLoad = onLoad
		
		
	MakeHauntableLaunch(inst)	
		
    return inst
end

return  Prefab("common/inventory/koshirae", fn, assets, prefabs) 