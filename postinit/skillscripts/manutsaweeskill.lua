local COLLISION = GLOBAL.COLLISION
local TimeEvent = GLOBAL.TimeEvent
local FRAMES = GLOBAL.FRAMES
local State = GLOBAL.State
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local SpawnPrefab = SpawnPrefab
local EventHandler = EventHandler
local AddStategraphState = AddStategraphState
local AddStategraphEvent = AddStategraphEvent
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------------
------------------------------------function-------------------------------------------------
----------------------------------------------------------------------------------------------

-- ia_SkillCollision
local function ia_SkillCollision(inst, enable)
	inst.Physics:ClearCollisionMask()
	if enable then
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.GROUND)
        -- Add WAVE Collides
        inst.Physics:CollidesWith(COLLISION.WAVES)
	else
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(COLLISION.GIANTS)
        -- Add WAVE Collides
        inst.Physics:CollidesWith(COLLISION.WAVES)
	end
end

local function SkillCollision(inst, enable)
	inst.Physics:ClearCollisionMask()
	if enable then
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.GROUND)
	else
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(COLLISION.GIANTS)
	end
end

local function habakirifx(inst, target, fxscale)
local wanda_attack_shadowweapon_normal_fx = SpawnPrefab("wanda_attack_shadowweapon_normal_fx")
    wanda_attack_shadowweapon_normal_fx.Transform:SetScale(fxscale, fxscale, fxscale)
    wanda_attack_shadowweapon_normal_fx.Transform:SetPosition(target:GetPosition():Get())
    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

----------------------------------------------------------------------------------------------

local equipskill

local events = {
    EventHandler("heavenlystrike", function(inst)
        inst.sg:GoToState("heavenlystrike")
    end),
    EventHandler("blockparry", function(inst)
        inst.sg:GoToState("blockparry")
    end),

    EventHandler("counterstart", function(inst)
        inst.sg:GoToState("counterstart")
    end)
}

local states = {
-------------------------------------------heavenlystrike---------------------------------------
    State{
        name = "heavenlystrike",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "skilling","notalking","mdashing" },

        onenter = function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local pufffx = SpawnPrefab("dirt_puff")
			pufffx.Transform:SetScale(.3, .3, .3)
			pufffx.Transform:SetPosition(x, y, z)

            if MCONFIG.COMPATIBLE then
                ia_SkillCollision(inst, true)
                else
                SkillCollision(inst, true)
            end

			inst.components.locomotor:Stop()
			if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			inst.components.combat:SetRange(inst.oldrange)
			inst.AnimState:PlayAnimation("atk_leap_pre")
			inst.Physics:SetMotorVelOverride(30,0,0)
        end,

        timeline = {
			TimeEvent(0 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
            end),
			TimeEvent(6 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")

                if MCONFIG.COMPATIBLE then
                    ia_SkillCollision(inst, false)
                    else
                    SkillCollision(inst, false)
                end

            end),
			TimeEvent(11 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
            end),
        },

		events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
			if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
			inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
        end,
    },
---------------------------------------------------------------------------------------------

-------------------------------------------blockparry---------------------------------------
    State{
        name = "blockparry",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph"},

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk")
            --inst.AnimState:PushAnimation("parry_pst", false)
            inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
        end,

        timeline = {
            TimeEvent(0.5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                inst.Physics:SetMotorVelOverride(-0.1,0,0)
                inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
            end),

            TimeEvent(1*FRAMES, function(inst)
            local sparks = SpawnPrefab("sparks")
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                sparks.Transform:SetPosition(inst:GetPosition():Get())
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.Physics:ClearMotorVelOverride()
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------counterstart---------------------------------------
    State{
        name = "counterstart",
        tags = {"busy", "nomorph", "notalking", "nopredict", "doing"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("parry_pre")
            inst.AnimState:PushAnimation("parry_pst", false)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
        end,

        timeline = {
            TimeEvent(.5 * FRAMES, function(inst)
                inst.sg:AddStateTag("counteractive")
            end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("counteractive")
                inst.sg:AddStateTag("startblockparry")
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.sg:RemoveStateTag("startblockparry")
        end,
    },
----------------------------------------------------------------------------------------------

---------------------------------------mcounterattack---------------------------------------
    State{
        name = "mcounterattack",
        tags = {"attack", "doing", "busy", "nointerrupt" ,"nopredict","nomorph"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()

        if math.random(1, 3) > 1 then
            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.AnimState:PlayAnimation("lunge_pst")
        else
            inst.AnimState:PlayAnimation("atk")
        end

            inst.inspskill = true
            inst.components.combat:SetRange(4)
            target = inst.skill_target

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end

        end,

        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
                inst:PerformBufferedAction()
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),

            TimeEvent(4 * FRAMES, function(inst)
                inst.components.combat:SetRange(inst.oldrange)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead") then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.inspskill = nil
            inst.mafterskillndm = inst:DoTaskInTime(1.5, function()
                inst.mafterskillndm = nil
            end)
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------monemind---------------------------------------
    State{
        name = "monemind",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},

        onenter = function(inst, target)
            equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end

            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            target = inst.skill_target

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
            inst.components.combat:DoAttack(inst.sg.statemem.target)
                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
                inst.Physics:SetMotorVelOverride(32,0,0)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),
            TimeEvent(4 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
            end),
            TimeEvent(9 * FRAMES, function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        ontimeout = function(inst)
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead") then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
----------------------------------------------------------------------------------------------

-------------------------------------------mquicksheath------------------------------------
    State{
        name = "mquicksheath",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},

        onenter = function(inst, target)
            equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,

        timeline = {
            TimeEvent(3 * FRAMES, function(inst)
                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
            end),
            TimeEvent(8 * FRAMES, function(inst)
            inst.sg:GoToState("idle")
            end),
        },

        ontimeout = function(inst)
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
----------------------------------------------------------------------------------------------

-------------------------------------------ryusen---------------------------------------------
    State{
        name = "ryusen",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling","mdashing"},

        onenter = function(inst, target)
            equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()
            inst.components.combat:SetRange(10)
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            target = inst.skill_target
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline = {
            TimeEvent(2 * FRAMES, function(inst)
                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
                local sparks = SpawnPrefab("sparks")
                sparks .Transform:SetPosition(inst:GetPosition():Get())
            end),

            TimeEvent(3 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                local wanda_attack_shadowweapon_old_fx = SpawnPrefab("wanda_attack_shadowweapon_old_fx")
                wanda_attack_shadowweapon_old_fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
            end),

            TimeEvent(6 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                local wanda_attack_shadowweapon_normal_fx = SpawnPrefab("wanda_attack_shadowweapon_normal_fx")
                wanda_attack_shadowweapon_normal_fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)

                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()

                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                local wanda_attack_shadowweapon_old_fx = SpawnPrefab("wanda_attack_shadowweapon_old_fx")
                wanda_attack_shadowweapon_old_fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)

                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()

                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
            end),

            TimeEvent(12 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                local wanda_attack_shadowweapon_normal_fx = SpawnPrefab("wanda_attack_shadowweapon_normal_fx")
                wanda_attack_shadowweapon_normal_fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)

                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()

                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
            end),

            TimeEvent(13 * FRAMES, function(inst)
                inst.AnimState:PlayAnimation("atk")
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),

            TimeEvent(14 * FRAMES, function(inst)
                inst.Physics:SetMotorVelOverride(32,0,0)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),

            TimeEvent(16 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
                local x, y, z = inst.Transform:GetWorldPosition()
                local fx = SpawnPrefab("groundpoundring_fx")
                fx.Transform:SetScale(.6, .6, .6)
                fx.Transform:SetPosition(x, y, z)
            end),

            TimeEvent(17 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
                inst.components.combat:SetRange(inst.oldrange)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.mafterskillndm = inst:DoTaskInTime(2, function()
                inst.mafterskillndm = nil
            end)
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------mflipskill------------------------------------------
    State{
        name = "mflipskill",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetRange(6)
            inst.components.combat:EnableAreaDamage(true)
            inst.components.combat:SetAreaDamage(2, 1)
            inst.AnimState:SetDeltaTimeMultiplier(1.3)
            inst.inspskill = true
            inst.AnimState:PlayAnimation("lunge_pre")
            inst.AnimState:PushAnimation("lunge_pst", false)
            inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            target = inst.skill_target
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline = {
            TimeEvent(1 * FRAMES, function(inst)
                inst.Physics:SetMotorVelOverride(32,0,0)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),

            TimeEvent(2 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
            end),

            TimeEvent(3 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(4 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(5 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(6 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(7 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(8 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
                inst.components.combat:SetRange(inst.oldrange)
                inst.components.combat:SetAreaDamage(1, 1)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst.AnimState:SetDeltaTimeMultiplier(1)
            end),

            -- TimeEvent(12 * FRAMES, function(inst)
            --     inst.mafterskillndm = inst:DoTaskInTime(1.5, function()
            --         inst.mafterskillndm = nil
            --     end)
            -- end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead") then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.inspskill = nil
            inst.components.combat:EnableAreaDamage(false)
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------mthrustskill------------------------------------------
    State{
        name = "mthrustskill",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.combat:SetRange(6)
            inst.components.combat:EnableAreaDamage(true)
            inst.components.combat:SetAreaDamage(2, 1)
            inst.AnimState:SetDeltaTimeMultiplier(1.3)
            inst.inspskill = true
            inst.AnimState:PlayAnimation("multithrust")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            target = inst.skill_target
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline = {
            TimeEvent(1 * FRAMES, function(inst)
                inst.Physics:SetMotorVelOverride(32,0,0)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),

            TimeEvent(2 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
            end),

            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
            end),

            TimeEvent(10 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
            end),

            TimeEvent(12 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
            end),

            TimeEvent(14 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst:PerformBufferedAction()
                inst.components.combat:SetRange(inst.oldrange)
                inst.components.combat:SetAreaDamage(1, 1)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst.AnimState:SetDeltaTimeMultiplier(1)
            end),

            -- TimeEvent(18 * FRAMES, function(inst)
            --     inst.mafterskillndm = inst:DoTaskInTime(1.5, function()
            --         inst.mafterskillndm = nil
            --     end)
            -- end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead") then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.inspskill = nil
            inst.components.combat:EnableAreaDamage(false)
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------michimonji------------------------------------------
    State{
        name = "michimonji",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},

        onenter = function(inst, target)
            inst.inspskill = true
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk_prop_pre")
            inst.AnimState:PushAnimation("atk_prop_lag", false)
            inst.AnimState:PushAnimation("atk", false)
            inst.components.combat:EnableAreaDamage(true)
            inst.components.combat:SetAreaDamage(2, 1)
            inst.AnimState:SetDeltaTimeMultiplier(2.5)
            inst.components.combat:SetRange(6)
            target = inst.skill_target
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline = {
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                local electrichitsparks = SpawnPrefab("electrichitsparks")
                electrichitsparks.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
                local x, y, z = inst.Transform:GetWorldPosition()
                local fx = SpawnPrefab("groundpoundring_fx")
                fx.Transform:SetScale(.5, .5, .5)
                fx.Transform:SetPosition(x, y, z)
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.AnimState:SetDeltaTimeMultiplier(1)
                inst.Physics:SetMotorVelOverride(32,0,0)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),

            TimeEvent(10 * FRAMES, function(inst)
                inst.Physics:ClearMotorVelOverride()
                local x, y, z = inst.Transform:GetWorldPosition()
                local pufffx = SpawnPrefab("dirt_puff")
                pufffx.Transform:SetScale(.6, .6, .6)
                pufffx.Transform:SetPosition(x, y, z)
            end),

            TimeEvent(17 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                --if not inst.doubleichimonji then inst.components.combat:DoAttack(inst.sg.statemem.target) end
                inst:PerformBufferedAction()
                inst.components.combat:SetRange(inst.oldrange)
                inst.components.combat:SetAreaDamage(1, 1)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead") then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.inspskill = nil
            inst.components.combat:EnableAreaDamage(false)
            if inst.doubleichimonji ~= nil then
                inst.doubleichimonji = nil
                inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL1ATTACK, 2, true)
                inst.mafterskillndm = inst:DoTaskInTime(2, function() inst.mafterskillndm = nil end)
            end
            if inst.doubleichimonjistart then
                inst.doubleichimonjistart = nil
                inst.doubleichimonji = true
            end
        end,
    },
----------------------------------------------------------------------------------------------

-------------------------------------------mhabakiri------------------------------------------
    State{
        name = "mhabakiri",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling","mdashing"},

        onenter = function(inst, target)
            equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()
            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetRange(12)
            inst.components.combat:EnableAreaDamage(true)
            inst.components.combat:SetAreaDamage(2, 1)
            inst.inspskill = true
            inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            target = inst.skill_target
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline = {
            TimeEvent(1 * FRAMES, function(inst)
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                inst.Physics:SetMotorVelOverride(-.25,0,10)
            end),

            TimeEvent(3 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),

            TimeEvent(4 * FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                habakirifx(inst, inst.sg.statemem.target, 3)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst:PerformBufferedAction()
                inst.Physics:ClearMotorVelOverride()
            end),

            TimeEvent(5 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
                inst.AnimState:PlayAnimation("lunge_pst")
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                inst.Physics:SetMotorVelOverride(-.5,0,-20)
            end),

            TimeEvent(8* FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                habakirifx(inst, inst.sg.statemem.target, 2)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst:PerformBufferedAction()
                inst.Physics:ClearMotorVelOverride()
            end),

            TimeEvent(9 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
                inst.AnimState:PlayAnimation("atk")
                inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                inst.Physics:SetMotorVelOverride(-.5,0,20)
            end),

            TimeEvent(12* FRAMES, function(inst)
                inst.components.combat:DoAttack(inst.sg.statemem.target)
                habakirifx(inst, inst.sg.statemem.target, 2)
                inst:PerformBufferedAction()
                inst.components.combat:SetRange(inst.oldrange)
                inst.components.combat:SetAreaDamage(1, 1)
                inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
                inst.Physics:ClearMotorVelOverride()
                inst.Physics:SetMotorVelOverride(-.5,0,-10)
            end),

            TimeEvent(15* FRAMES, function(inst)
                equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                if equipskill and equipskill.components.spellcaster ~= nil then
                    equipskill.components.spellcaster:CastSpell(inst)
                end
                inst.Physics:ClearMotorVelOverride()
                local sparks = SpawnPrefab("sparks")
                sparks.Transform:SetPosition(inst:GetPosition():Get())
            end),

            TimeEvent(20 * FRAMES, function(inst)
                inst.components.talker:Say(STRINGS.MANUTSAWEESKILLSPEECH.SKILL2ATTACK, 2, true)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone()
                and inst.components.health ~= nil
                and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.combat ~= nil then
                inst.components.combat:SetTarget(nil)
                inst.components.combat:SetRange(inst.oldrange)
            end
            inst.inspskill = nil
            inst.components.combat:EnableAreaDamage(false)
            inst.mafterskillndm = inst:DoTaskInTime(1, function()
                inst.mafterskillndm = nil
            end)
        end,
    },

}

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end

for _, event in ipairs(events) do
    AddStategraphEvent("wilson", event)
end
