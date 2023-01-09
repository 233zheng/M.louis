local assets =
{
    Asset("ANIM", "anim/mfruit.zip"),
	Asset("ATLAS", "images/inventoryimages/mfruit.xml"),
    Asset("IMAGE", "images/inventoryimages/mfruit.tex"),
}

--local function OnPutInInventory(inst)
--	local owner = inst.components.inventoryitem:GetGrandOwner()
--	if owner ~= nil and owner.components.inventory then
--		if not (owner:HasTag("kenjutsu") or owner:HasTag("manutsaweecraft")) then
--			inst:DoTaskInTime(0.1, function()
--				SpawnPrefab("electrichitsparks"):AlignToTarget(owner, inst, true)
--				owner.components.combat:GetAttacked(inst, 10)
--				owner.components.inventory:DropItem(inst)	
--			end)	
--		end
--	end
--end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("mfruit")
    inst.AnimState:SetBuild("mfruit")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("nosteal")
	
    MakeInventoryFloatable(inst)
	inst.components.floater:SetSize("small")
    inst.components.floater:SetVerticalOffset(0.1)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
	inst.components.inventoryitem.keepondrown = true	
	--inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.imagename = "mfruit"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mfruit.xml"	

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MFRUIT
    inst.components.edible.hungervalue = 1

    return inst
end


return Prefab("mfruit", fn, assets)