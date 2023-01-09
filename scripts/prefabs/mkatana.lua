local assets=
{
    Asset("ANIM", "anim/mkatana.zip"),  
    Asset("ANIM", "anim/swap_mkatana.zip"),
    Asset("ANIM", "anim/swap_Smkatana.zip"),
    Asset("ANIM", "anim/sc_mkatana.zip"),
    Asset("ANIM", "anim/sc_mkatana2.zip"),
	
    Asset("ATLAS", "images/inventoryimages/mkatana.xml"),
    Asset("IMAGE", "images/inventoryimages/mkatana.tex"),
	Asset("ANIM", "anim/player_lunge_blue.zip"), --from The Combat Overhaul https://steamcommunity.com/sharedfiles/filedetails/?id=2317339651
}
local prefabs = {}
local function Firstmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_Smkatana", "swap_Smkatana")	
	inst.components.weapon:SetRange(1, 1.5)
	if not owner:HasTag("notshowscabbard")  then owner.AnimState:ClearOverrideSymbol("swap_body_tall")end	
	
	--inst.components.equippable.walkspeedmult = 1.25
	
	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if not inst:HasTag("Iai")then inst:AddTag("Iai") end
	inst.wpstatus = 1
end

local DMG = 42
local function Seccondmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_object", "swap_mkatana", "swap_mkatana")
	
	if not owner:HasTag("notshowscabbard")and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_mkatana", "tail")end
	
	inst.components.weapon:SetRange(.8, 1.2)
	
	--inst.components.equippable.walkspeedmult = 1.15	

	if inst:HasTag("mkatana")then inst:RemoveTag("mkatana") end
	if inst:HasTag("Iai")then inst:RemoveTag("Iai") end
	if owner:HasTag("kenjutsu") and not inst:HasTag("mkatana")then inst:AddTag("mkatana") end
	inst.wpstatus = 2 
end

local function onpocket(inst)
	local owner = inst.components.inventoryitem.owner 	
   if not owner:HasTag("notshowscabbard")and owner:HasTag("character") then owner.AnimState:OverrideSymbol("swap_body_tall", "sc_mkatana2", "tail") end
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

local function fn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
		
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("mkatana")
    inst.AnimState:SetBuild("mkatana")
    inst.AnimState:PlayAnimation("idle")
	
  
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
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(300)
	inst.components.finiteuses:SetUses(300)
	inst.components.finiteuses:SetOnFinished(Onfinish)

	--------------------------------------------------
	
    inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.canonlygoinpocket = true	
    inst.components.inventoryitem.imagename = "mkatana"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mkatana.xml"
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
	
	 -- status
    inst.wpstatus = 1
    inst.OnSave = onSave
    inst.OnLoad = onLoad
		
	MakeHauntableLaunch(inst)	
		
    return inst
end

return  Prefab("common/inventory/mkatana", fn, assets, prefabs) 