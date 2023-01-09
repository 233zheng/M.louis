local assets=
{
    Asset("ANIM", "anim/raikiri.zip"),   
    Asset("ANIM", "anim/swap_raikiri.zip"),
    Asset("ANIM", "anim/swap_Sraikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri2.zip"),
	
    Asset("ATLAS", "images/inventoryimages/raikiri2.xml"),
    Asset("IMAGE", "images/inventoryimages/raikiri2.tex"),
	Asset("ANIM", "anim/player_lunge_blue.zip"), --from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
}

local function Firstmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_Sraikiri", "swap_Sraikiri")	
	inst.components.weapon:SetRange(1, 1.5)
	if not owner:HasTag("notshowscabbard") then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end
	
	inst.components.equippable.walkspeedmult = 1.25
	
	inst:RemoveTag("lightningrod")
	inst.lightningpriority = nil
	inst.components.equippable.insulated = false
		
	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if not inst:HasTag("Iai")then inst:AddTag("Iai") end
	inst.wpstatus = 1
end
local DMG = 81.6
local function Seccondmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_raikiri", "swap_raikiri")
	
	if not owner:HasTag("notshowscabbard")and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_raikiri", "tail")end
	
	inst.components.weapon:SetRange(.8, 1.2)
		
	inst.components.equippable.walkspeedmult = 1.15	
		
	inst:AddTag("lightningrod")
	inst.lightningpriority = 5
	inst.components.equippable.insulated = true	
	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if inst:HasTag("Iai")then inst:RemoveTag("Iai") end
	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end
	inst.wpstatus = 2 
end

local function onpocket(inst)
	local owner = inst.components.inventoryitem.owner 	
   if not owner:HasTag("notshowscabbard")and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_raikiri2", "tail") end
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
end

local shockeffect
local function onisraining(inst, israining)
   
        if israining then
            shockeffect = true
        else
            shockeffect = false
        end    
end

local function onattack(inst, owner, target)
	if owner.components.rider:IsRiding() then return end
	
	if inst.wpstatus == 1 and inst:HasTag("Iai") then Seccondmode(inst) 
		if target.components.combat ~= nil then target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8) end 
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
		
	SpawnPrefab("electrichitsparks"):AlignToTarget(target, owner, true)  
	if shockeffect and target ~= nil and target:IsValid() and owner ~= nil and owner:IsValid() then
		SpawnPrefab("electrichitsparks"):AlignToTarget(target, owner, true)
		if target.components.combat ~= nil then target.components.combat:GetAttacked(owner, inst.components.weapon.damage*.8) end
    end
	
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

local function OnPutInInventory(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if owner ~= nil and owner.components.inventory and owner:HasTag("kenjutsu") and owner:HasTag("manutsaweecraft")then	
		inst.components.spellcaster.canusefrominventory = true		
	else 
		inst.components.spellcaster.canusefrominventory = false		
		inst:DoTaskInTime(0.1, function()
        SpawnPrefab("electrichitsparks"):AlignToTarget(owner, inst, true)
			if owner.components.combat ~= nil then
				owner.components.combat:GetAttacked(inst, 10)
				end
		owner.components.inventory:DropItem(inst)	
		end)	
	end
end

local function Onfinish(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()	
	local item = SpawnPrefab("raikiri")
	if not owner:HasTag("notshowscabbard") then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end
	inst:Remove()
	if owner ~= nil then
		owner.components.inventory:GiveItem(item)
		inst:DoTaskInTime(0.1, function() owner.components.inventory:DropItem(item)	 SpawnPrefab("electrichitsparks"):AlignToTarget(item, item, true)	end)
	end
end

local function swordregen(inst)	
	local usedamount = inst.components.finiteuses:GetUses()
	if usedamount and inst.components.finiteuses and inst.components.finiteuses:GetPercent() < 1 then	
		inst.components.finiteuses:SetUses(usedamount+2)
	end
	
	inst:DoTaskInTime(60, swordregen)
end

local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()	
	minimap:SetIcon( "raikiri.tex" )
    
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("raikiri")
    inst.AnimState:SetBuild("raikiri")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("nosteal")    
	inst:AddTag("sharp")
	--inst:AddTag("trap")    
	
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
		
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)

	--------------------------------------------------
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(800)
    inst.components.finiteuses:SetUses(800)
    inst.components.finiteuses:SetOnFinished(Onfinish)
	
	--------------------------------------------------
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
	inst.components.inventoryitem.keepondrown = true
	inst.components.inventoryitem.canonlygoinpocket = true
	--inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)	
    inst.components.inventoryitem.imagename = "raikiri2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/raikiri2.xml"
	--------------------------------------------------
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.veryquickcast = true
	
	inst.components.spellcaster.canusefrominventory = true	
	--------------------------------------------------
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	--inst.components.equippable.restrictedtag = "manutsaweecraft"
	inst.components.equippable:SetOnPocket(onpocket)
	
	 -- status
    inst.wpstatus = 1
    inst.OnSave = onSave
    inst.OnLoad = onLoad
	
	inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)
	
	MakeHauntableLaunch(inst)	
	
	inst:DoTaskInTime(60, swordregen)
	
    return inst
end

return  Prefab("common/inventory/raikiri2", fn, assets) 