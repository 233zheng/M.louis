local assets=
{
    Asset("ANIM", "anim/raikiri.zip"),  
    Asset("ANIM", "anim/raikiri2.zip"),  
    Asset("ANIM", "anim/swap_raikiri.zip"),
    Asset("ANIM", "anim/swap_Sraikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri.zip"),
    Asset("ANIM", "anim/sc_raikiri2.zip"),
	
    Asset("ATLAS", "images/inventoryimages/raikiri.xml"),
    Asset("IMAGE", "images/inventoryimages/raikiri.tex"),
	Asset("ANIM", "anim/player_lunge_blue.zip"), --from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
}
local prefabs = {}
local function Firstmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_Sraikiri", "swap_Sraikiri")
	
	inst.AnimState:SetBank("raikiri")
    inst.AnimState:SetBuild("raikiri")
	if inst.components.workable then inst.components.workable:SetWorkable(false) end
	
	inst.components.weapon:SetRange(1, 1.5)
	if not owner:HasTag("notshowscabbard")  then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end
		
	inst.components.equippable.walkspeedmult = 1.25
	
	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if not inst:HasTag("Iai")then inst:AddTag("Iai") end
	inst.wpstatus = 1
end

local DMG = 68
local function Seccondmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_raikiri", "swap_raikiri")
	
	inst.AnimState:SetBank("raikiri2")
    inst.AnimState:SetBuild("raikiri2")
	if inst.components.workable then inst.components.workable:SetWorkable(true) end
	
	if not owner:HasTag("notshowscabbard") and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_raikiri", "tail")end
	
	inst.components.weapon:SetRange(.8, 1.2)
		
	inst.components.equippable.walkspeedmult = 1.15
	
	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if inst:HasTag("Iai")then inst:RemoveTag("Iai") end
	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end
	inst.wpstatus = 2 
end

local function onpocket(inst)
	local owner = inst.components.inventoryitem.owner 	
   if not owner:HasTag("notshowscabbard") and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_raikiri2", "tail") end
  
 -- if owner and owner:HasTag("kenjutsu") then inst.components.workable:SetWorkable(true)	else   inst.components.workable:SetWorkable(false) end
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
	inst.AnimState:SetBank("raikiri")
    inst.AnimState:SetBuild("raikiri")
	inst.components.workable:SetWorkable(false)
	else 
	inst.AnimState:SetBank("raikiri2")
    inst.AnimState:SetBuild("raikiri2")
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

--local function OnPutInInventory(inst)
--	local owner = inst.components.inventoryitem:GetGrandOwner()
--	if owner ~= nil and owner.components.inventory and (owner:HasTag("kenjutsu") or owner:HasTag("manutsaweecraft"))then		
--		inst.components.spellcaster.canusefrominventory = true		
--	else 
--		inst.components.spellcaster.canusefrominventory = false		
--		inst:DoTaskInTime(0.1, function()
--        SpawnPrefab("electrichitsparks"):AlignToTarget(owner, inst, true)
--		owner.components.combat:GetAttacked(inst, 10)
--		owner.components.inventory:DropItem(inst)	
--		end)	
--	end
--end

local function Onfinish(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()	
	if owner and not owner:HasTag("notshowscabbard")  then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end
	inst:Remove()	
end

local function repair(inst, chopper)
	local collapse_fx = SpawnPrefab("crab_king_shine")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
	local item = SpawnPrefab("raikiri")
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
	
	local minimap = inst.entity:AddMiniMapEntity()	
	minimap:SetIcon( "raikiri.tex" )
    
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("raikiri")
    inst.AnimState:SetBuild("raikiri")
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
	---inst:AddComponent("timer")
	
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
	--inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)	
    inst.components.inventoryitem.imagename = "raikiri"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/raikiri.xml"
	--------------------------------------------------
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(castFn)
	inst.components.spellcaster.canusefrominventory = true	
	inst.components.spellcaster.veryquickcast = true
	--------------------------------------------------
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	--inst.components.equippable.restrictedtag = "manutsaweecraft"
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

return  Prefab("common/inventory/raikiri", fn, assets, prefabs) 