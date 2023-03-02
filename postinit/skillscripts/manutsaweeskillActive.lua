local SpawnPrefab = GLOBAL.SpawnPrefab
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local AddPlayerPostInit = AddPlayerPostInit
GLOBAL.setfenv(1, GLOBAL)

local blockcount = 0

----------------------------------------------------------------------------------------------
------------------------------------function-------------------------------------------------
----------------------------------------------------------------------------------------------

local function SkillRemove(inst)
	inst:RemoveTag("michimonji")
	inst:RemoveTag("mflipskill")
	inst:RemoveTag("mthrustskill")
	inst:RemoveTag("misshin")
	inst:RemoveTag("heavenlystrike")
	inst:RemoveTag("ryusen")
	inst:RemoveTag("susanoo")

	inst.mafterskillndm = nil
	inst.inspskill = nil
	inst.components.combat:SetRange(inst.oldrange)
	inst.components.combat:EnableAreaDamage(false)
	inst.AnimState:SetDeltaTimeMultiplier(1)
	inst:DoTaskInTime(.3, function()
        inst.components.talker:Say("I don't wanna do this.")
    end)
end

--skill effect
local function slashfx1(inst, target)
local effects = SpawnPrefab("shadowstrike_slash_fx")
    effects.Transform:SetScale(3, 3, 3)
    effects.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function slashfx2(inst, target)
local effects2 = SpawnPrefab("shadowstrike_slash2_fx")
    effects2.Transform:SetScale(3, 3, 3)
    effects2.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
end

local function slashfx3(inst, target)
local effects = SpawnPrefab("shadowstrike_slash_fx")
    effects.Transform:SetScale(1.6, 1.6, 1.6)
    effects.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function groundpoundfx1(inst)
local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("groundpoundring_fx")
    fx.Transform:SetScale(.6, .6, .6)
    fx.Transform:SetPosition(x, y, z)
end

local function groundpoundfx2(inst)
local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("groundpoundring_fx")
    fx.Transform:SetScale(.8, .8, .8)
    fx.Transform:SetPosition(x, y, z)
end

local function groundpoundfx3(inst, target)
local effects = SpawnPrefab("groundpoundring_fx")
    effects.Transform:SetScale(.7, .7, .7)
    effects.Transform:SetPosition(target:GetPosition():Get())
end

local function slashfx4(inst, target, fxscale)
local effects = SpawnPrefab("wanda_attack_shadowweapon_old_fx")
    effects.Transform:SetScale(fxscale, fxscale, fxscale)
    effects.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function slashfx5(inst, target, fxscale)
local effects = SpawnPrefab("wanda_attack_shadowweapon_normal_fx")
    effects.Transform:SetScale(fxscale, fxscale, fxscale)
    effects.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function slashfx6(inst, target, fxscale)
local effects = SpawnPrefab("fence_rotator_fx")
    effects.Transform:SetScale(fxscale, fxscale, fxscale)
    effects.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function maoeattack(inst, target, mtpdmg, atkrange)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, atkrange, nil)
	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

    for k,v in pairs(ents) do
        if (v and v:HasTag("bird")) then
            v.sg:GoToState("stunned")
        end

        if v and v:IsValid() and v.components.health ~= nil and v.components.combat ~= nil and not v.components.health:IsDead() then
            if not (v:HasTag("player") or v:HasTag("INLIMBO") or v:HasTag("structure") or v:HasTag("companion") or v:HasTag("abigial") or v:HasTag("wall")) then
                weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if weapon then
                    v.components.combat:GetAttacked(inst, weapon.components.weapon.damage*mtpdmg)
                end
                if v.components.freezable ~= nil then
                    v.components.freezable:SpawnShatterFX()
                end
            end
        elseif v and
            v:HasTag("tree") or
                v:HasTag("stump") and not v:HasTag("structure") then
            if v.components.workable ~= nil then
                v.components.workable:WorkedBy(inst, 10)
            end
        end
    end
end

local function mcanskill(inst, target)
	if (target:HasTag("prey") or target:HasTag("bird") or target:HasTag("buzzard") or target:HasTag("butterfly")) and not target:HasTag("hostile") then
		inst.mcanskill = true
    else
		inst.mcanskill = nil
	end
end

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--Good Way
local function OnCounter(inst) --counter
	if inst.prefab == "manutsawee" then

    if not TheWorld.ismastersim then
        return inst
    end

    local _GetAttacked = inst.components.combat.GetAttacked

    function inst.components.combat:GetAttacked(attacker, damage, weapon, stimuli)
		if attacker == nil or damage == nil or (inst.components.sleeper and inst.components.sleeper:IsAsleep()) or (inst.components.freezable and inst.components.freezable:IsFrozen()) then
            return _GetAttacked(self, attacker, damage, weapon, stimuli)
        end
            if attacker ~= nil then
                inst:ForceFacePoint(attacker.Transform:GetWorldPosition())
            end
		local pweapon = self:GetWeapon()
		if pweapon ~= nil and (inst.mafterskillndm ~= nil and not inst.sg:HasStateTag("mdashing")) then
			inst.mafterskillndm = inst:DoTaskInTime(1.5, function()
                inst.mafterskillndm = nil
            end)
			if blockcount > 0 then
				blockcount = 0
				if inst.blockactive ~= nil then
                    inst.blockactive:Cancel() inst.blockactive = nil
                end
				inst:PushEvent("heavenlystrike")
				if attacker.components.combat ~= nil then
					--inst.components.combat:DoAttack(attacker)
					maoeattack(inst, inst, 2,3)
					groundpoundfx1(inst)
					slashfx3(inst, attacker)
					if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel() inst.mafterskillndm = nil
                    end
				end
				return
			end
			inst:PushEvent("blockparry")
			blockcount = blockcount + 1
                if inst.blockactive ~= nil then
                    inst.blockactive:Cancel()
                    inst.blockactive = nil
                end
			inst.blockactive = inst:DoTaskInTime(3, function()
                blockcount = 0
            end)
			return
		end
            if inst.sg:HasStateTag("mdashing") or inst.inspskill ~= nil then
                local electricfx = SpawnPrefab("electricchargedfx")
                electricfx.Transform:SetScale(.7, .7, .7)
                electricfx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
            elseif inst.sg:HasStateTag("counteractive") then
                groundpoundfx1(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                local sparks = SpawnPrefab("sparks")
                sparks.Transform:SetPosition(inst:GetPosition():Get())
                inst.skill_target = attacker
                inst.sg:GoToState("mcounterattack",inst.skill_target)
                inst.components.timer:StartTimer("skillcountercd",MCONFIG.SKILLCDCT)
            else
                _GetAttacked(self, attacker, damage, weapon, stimuli)
            end
        end
	end
end

AddPlayerPostInit(OnCounter)

----------------------------------------------------------------------------------------------

local function mactiveskill(inst) --skill1
    if inst.prefab == "manutsawee" then
        if TheWorld.ismastersim then
            local old_start = inst.components.combat.StartAttack

            inst.components.combat.StartAttack = function(self)
                old_start(self)
                if self.target then
                local target = self.target
                local weapon = self:GetWeapon()
                local skilltime = .05
                if weapon ~= nil and weapon.components.weapon and inst:HasTag("michimonji") then --start
                    mcanskill(inst, target)

                    if inst.mcanskill then
                        inst.sg:GoToState("idle")
                        SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    inst.inspskill = true

                    if weapon.wpstatus == 1 then
                        skilltime = .3
                        if inst.mindpower >=5 then
                            inst.mindpower = (inst.mindpower-2)
                            inst.doubleichimonjistart = true
                        end
                    end

                    inst:DoTaskInTime(skilltime, function()
                        inst.skill_target = target
                        inst.sg:GoToState("michimonji",inst.skill_target)
                    end)

                    if inst.doubleichimonjistart then
                        inst:DoTaskInTime(1, function()

                        if inst.mafterskillndm ~= nil then
                            inst.mafterskillndm:Cancel()
                            inst.mafterskillndm = nil
                        end

                            if weapon ~= nil then
                                inst.skill_target = target
                                inst.sg:GoToState("michimonji",inst.skill_target)
                            end
                        end)
                    end

                    inst.mindpower = (inst.mindpower-3)
                    inst.components.timer:StartTimer("skill1cd",MCONFIG.SKILLCD1)

                    inst:RemoveTag("michimonji")
                end	--end

                if weapon ~= nil and weapon.components.weapon and inst:HasTag("mflipskill") then --start flip
                        mcanskill(inst, target)
                        skilltime = .1
                        if inst.mcanskill then
                            inst.sg:GoToState("idle")
                            SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    if weapon.wpstatus == 1 then
                        skilltime = .05
                        inst:DoTaskInTime(skilltime, function()

                        if inst.mafterskillndm ~= nil then
                            inst.mafterskillndm:Cancel()
                            inst.mafterskillndm = nil
                        end

                        if weapon ~= nil then
                            inst.skill_target = target
                            inst.sg:GoToState("mhabakiri",inst.skill_target)
                            groundpoundfx1(inst)
                        end

                    end)

                    else
                    inst:DoTaskInTime(skilltime, function()
                                inst.skill_target = target
                                inst.sg:GoToState("mflipskill",inst.skill_target)
                                groundpoundfx1(inst)
                        end)
                    end
                    inst.mindpower = (inst.mindpower-4)
                    inst.components.timer:StartTimer("skill2cd",MCONFIG.SKILLCD2)

                    inst:RemoveTag("mflipskill")
                end -- end skill

                if weapon ~= nil and weapon.components.weapon and inst:HasTag("mthrustskill")then --start thrust
                    mcanskill(inst, target)
                    skilltime = .1

                    if inst.mcanskill then
                        inst.sg:GoToState("idle")
                        SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    if weapon.wpstatus == 1 then
                        skilltime = .05
                        inst:DoTaskInTime(skilltime, function()

                            if inst.mafterskillndm ~= nil then
                                inst.mafterskillndm:Cancel()
                                inst.mafterskillndm = nil
                            end

                            if weapon ~= nil then
                                inst.skill_target = target
                                inst.sg:GoToState("mthrustskill",inst.skill_target)
                                groundpoundfx1(inst)

                                inst:DoTaskInTime(.7, function()
                                    inst:PushEvent("heavenlystrike")
                                    weapon = self:GetWeapon()
                                    if weapon and weapon.components.spellcaster ~= nil then
                                        weapon.components.spellcaster:CastSpell(inst)
                                        SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())
                                    end
                                end)

                                inst:DoTaskInTime(.9, function()
                                    slashfx1(inst, inst)
                                    maoeattack(inst, inst, 1,6.5)
                                    inst.components.combat:SetRange(inst.oldrange)
                                    inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL3ATTACK, 2, true)
                                    local fx = SpawnPrefab("groundpoundring_fx")
                                    fx.Transform:SetScale(.8, .8, .8)
                                    fx.Transform:SetPosition(inst:GetPosition():Get())
                                end)
                            end
                        end)

                    else

                    inst:DoTaskInTime(skilltime, function()
                        inst.skill_target = target
                        inst.sg:GoToState("mthrustskill",inst.skill_target)
                        groundpoundfx1(inst)
                        end)
                    end
                    inst.mindpower = (inst.mindpower-4)
                    inst.components.timer:StartTimer("skill3cd",MCONFIG.SKILLCD3)

                    inst:RemoveTag("mthrustskill")
                end--end skill

                if weapon ~= nil and weapon.components.weapon and inst:HasTag("misshin") then --start isshin
                        mcanskill(inst, target)

                        if inst.mcanskill then
                            inst.sg:GoToState("idle")
                            SkillRemove(inst)
                            return
                        end

                        if inst.mafterskillndm ~= nil then
                            inst.mafterskillndm:Cancel()
                            inst.mafterskillndm = nil
                        end

                        inst:DoTaskInTime(.1, function()
                        inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL4ATTACK, 2, true)
                        groundpoundfx1(inst)
                        slashfx1(inst, target)
                        inst.inspskill = true
                        inst.skill_target = target
                        inst.sg:GoToState("monemind",inst.skill_target)

                        inst:DoTaskInTime(.6, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,4)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(.7, function()
                            slashfx5(inst, inst,3)
                        end)

                        inst:DoTaskInTime(.8, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,3.5)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1, function()
                            groundpoundfx1(inst)
                            slashfx5(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.1, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,4)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.2, function()
                            slashfx5(inst, inst,3)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.4, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,3.5)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.5, function()
                            groundpoundfx1(inst)
                            slashfx5(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.6, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.8, function()
                            slashfx5(inst, inst,3)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.9, function()
                            groundpoundfx2(inst)
                            slashfx4(inst, inst,3.5)
                            maoeattack(inst, inst, 1,6)
                            inst.components.playercontroller:Enable(true)
                            inst.inspskill = nil
                            inst:PushEvent("heavenlystrike")
                            weapon = self:GetWeapon()
                            if weapon and weapon.components.spellcaster ~= nil then
                                weapon.components.spellcaster:CastSpell(inst)
                                SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())
                            end
                        end)

                        inst:DoTaskInTime(2.1, function()
                            slashfx1(inst, inst)
                            maoeattack(inst, inst, 1,4)
                            inst.components.combat:SetRange(inst.oldrange)
                        end)

                        inst.mindpower = (inst.mindpower-7)
                        inst.components.timer:StartTimer("skillT2cd",MCONFIG.SKILLCDT2)

                        inst:RemoveTag("misshin")
                    end)
                end --skill end

                if weapon ~= nil and weapon.components.weapon and inst:HasTag("heavenlystrike") then
                    mcanskill(inst, target)
                    if inst.mcanskill then
                        inst.sg:GoToState("idle")
                        SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    inst:DoTaskInTime(.1, function()
                        inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL5ATTACK, 2, true)
                    end)

                    inst.sg:AddStateTag("skilling")
                    inst:DoTaskInTime(.3, function()
                    inst:PushEvent("heavenlystrike")

                    inst.mindpower = (inst.mindpower-5)
                    inst.components.timer:StartTimer("skillT2cd", MCONFIG.SKILLCDT2-30)

                    SpawnPrefab("mossling_spin_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
                    SpawnPrefab("electricchargedfx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
                        --Do damage start

                    inst:RemoveTag("heavenlystrike")

                    local fx = SpawnPrefab("groundpoundring_fx")
                    fx.Transform:SetScale(.8, .8, .8)
                    fx.Transform:SetPosition(inst:GetPosition():Get())

                    ------------------------------------------------------------------------hitfx
                    slashfx1(inst, inst)
                    maoeattack(inst, inst, 1,6.5)
                    ----------------------------------------------------------------
                    inst:DoTaskInTime(.2, function() -------DoDMG
                        maoeattack(inst, inst, 2.5,6.5)
                        slashfx2(inst, inst)
                        local fx = SpawnPrefab("groundpoundring_fx")
                        fx.Transform:SetScale(.8, .8, .8)
                        fx.Transform:SetPosition(inst:GetPosition():Get())
                    end)

                    inst:DoTaskInTime(.3, function() -------DoDMG
                        maoeattack(inst, inst, 4,6.5)
                        slashfx1(inst, inst)
                        local fx = SpawnPrefab("groundpoundring_fx")
                        fx.Transform:SetScale(.8, .8, .8)
                        fx.Transform:SetPosition(inst:GetPosition():Get())
                        end)
                    end)
                end	-- end skill

                if weapon ~= nil and weapon.components.weapon and (inst:HasTag("ryusen")) then --start
                    mcanskill(inst, target)

                    if inst.mcanskill then
                        inst.sg:GoToState("idle")
                        SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    inst:DoTaskInTime(.1, function()
                    ------------------------------------
                        inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL6ATTACK, 2, true)
                        inst.skill_target = target
                        inst.sg:GoToState("ryusen",inst.skill_target)

                        inst.mindpower = (inst.mindpower-8)
                        inst.components.timer:StartTimer("skillT3cd",MCONFIG.SKILLCDT3-60)
                        inst:RemoveTag("ryusen")

                        inst:DoTaskInTime(.2, function()
                            slashfx4(inst, inst.skill_target,2)
                        end)

                        inst:DoTaskInTime(.4, function()
                            slashfx5(inst, inst.skill_target,2)
                        end)

                        inst:DoTaskInTime(.6, function()
                            slashfx4(inst, inst.skill_target, 2.5)
                        end)

                        inst:DoTaskInTime(.8, function()
                            slashfx5(inst, inst.skill_target,2.5)
                            groundpoundfx3(inst, inst.skill_target)
                        end)

                        inst:DoTaskInTime(1, function()
                            groundpoundfx1(inst)
                        end)

                        inst:DoTaskInTime(1.5, function()
                            slashfx1(inst, inst.skill_target)
                            groundpoundfx3(inst, inst.skill_target)
                        end)
                    end)
                end --endskill

                if weapon ~= nil and weapon.components.weapon and inst:HasTag("susanoo") then --start
                    mcanskill(inst, target)

                    if inst.mcanskill then
                        inst.sg:GoToState("idle")
                        SkillRemove(inst)
                        return
                    end

                    if inst.mafterskillndm ~= nil then
                        inst.mafterskillndm:Cancel()
                        inst.mafterskillndm = nil
                    end

                    inst:DoTaskInTime(.1, function()
                        inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL7ATTACK, 2, true)
                        groundpoundfx1(inst)
                        ------------------------------------
                        slashfx1(inst, target)
                        inst.inspskill = true
                        inst.skill_target = target
                        inst.sg:GoToState("monemind", inst.skill_target)

                        inst:DoTaskInTime(.6, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,4)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(.7, function()
                            slashfx6(inst, inst,3)
                        end)

                        inst:DoTaskInTime(.8, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,3.5)
                            maoeattack(inst, inst, 2,6.5)
                        end)

                        inst:DoTaskInTime(.9, function()
                            slashfx6(inst, inst,2.5)
                        end)

                        inst:DoTaskInTime(1, function()
                            groundpoundfx1(inst)
                            slashfx6(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.1, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,4)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.2, function()
                            slashfx6(inst, inst,3)
                            maoeattack(inst, inst, 2,6.5)
                        end)

                        inst:DoTaskInTime(1.3, function()
                            slashfx6(inst, inst,2.5)
                        end)

                        inst:DoTaskInTime(1.4, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,3.5)
                            maoeattack(inst, inst, 1,6.5)
                        end)

                        inst:DoTaskInTime(1.5, function()
                            groundpoundfx1(inst)
                            slashfx6(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.6, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,4)
                        end)

                        inst:DoTaskInTime(1.7, function()
                            slashfx6(inst, inst,2.5)
                        end)

                        inst:DoTaskInTime(1.8, function()
                            slashfx6(inst, inst,3)
                            maoeattack(inst, inst, 2,6.5)
                        end)

                        inst:DoTaskInTime(1.9, function()
                            groundpoundfx2(inst)
                            slashfx6(inst, inst,3.5)
                            maoeattack(inst, inst, 1,6)
                            inst.components.playercontroller:Enable(true)
                            inst.inspskill = nil
                            inst:PushEvent("heavenlystrike")
                            weapon = self:GetWeapon()
                            if weapon and weapon.components.spellcaster ~= nil then
                                weapon.components.spellcaster:CastSpell(inst)
                            end
                        end)

                        inst:DoTaskInTime(2.1, function()
                            slashfx1(inst, inst)
                            maoeattack(inst, inst, 2,4)
                            inst.components.combat:SetRange(inst.oldrange)
                        end)

                        inst.mindpower = (inst.mindpower-10)
                        inst.components.timer:StartTimer("skillT3cd",MCONFIG.SKILLCDT3)

                        inst:RemoveTag("susanoo")
                        end)
                    end
                end
            end
        end
    end
end

AddPlayerPostInit(mactiveskill)
