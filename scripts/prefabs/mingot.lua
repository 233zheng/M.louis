local assets =
{
    Asset("ANIM", "anim/mingot.zip"),
	Asset("ATLAS", "images/inventoryimages/mingot.xml"),
    Asset("IMAGE", "images/inventoryimages/mingot.tex"),
	
	Asset("ATLAS", "images/inventoryimages/hmingot.xml"),
    Asset("IMAGE", "images/inventoryimages/hmingot.tex"),
	
	Asset("ANIM", "anim/katanabody.zip"),
	Asset("ATLAS", "images/inventoryimages/katanabody.xml"),
    Asset("IMAGE", "images/inventoryimages/katanabody.tex"),
}

local function downgrade(inst, chopper)
	local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mingot")
    inst.AnimState:SetBuild("mingot")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("molebait")
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	
	inst:AddComponent("bait")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = "mingot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mingot.xml"
	
	inst:AddComponent("cookable")
    inst.components.cookable.product = "hmingot"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(downgrade)
    inst.components.workable:SetWorkLeft(3)
	 
	inst:AddComponent("lootdropper")
    
	MakeHauntableLaunchAndSmash(inst)
    return inst
end

local function upgrade(inst, chopper) 
	local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
	local item = SpawnPrefab("katanabody")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
	inst:Remove()	
end

local function onhit(inst)
	local fx = SpawnPrefab("sparks")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_mech_med_sharp")
end


local function OnDropped(inst)
    inst.Light:Enable(true)
end

local function OnPickup(inst)
    inst.Light:Enable(false)
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hmingot")
    inst.AnimState:SetBuild("mingot")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(255/255, 135/255, 0/255)
    inst.Light:Enable(true)
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

   -- inst:AddComponent("stackable")
   -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = "hmingot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hmingot.xml"
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup)
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "mingot"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(upgrade)
    inst.components.workable:SetWorkLeft(40)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	MakeHauntableLaunchAndSmash(inst)
    return inst
end

local function downgrade2(inst, chopper) 
	local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
	local item = SpawnPrefab("mingot")
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
	inst:Remove()	
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("katanabody")
    inst.AnimState:SetBuild("katanabody")
    inst.AnimState:PlayAnimation("idle")
			
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
		
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.imagename = "katanabody"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/katanabody.xml"
	
	inst:AddComponent("cookable")
    inst.components.cookable.product = "hmingot"
			
	MakeHauntableLaunch(inst)	
    return inst
end


return Prefab("mingot", fn, assets), Prefab("hmingot", fn2, assets), Prefab("katanabody", fn3, assets)