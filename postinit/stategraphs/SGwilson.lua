local require = GLOBAL.require
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local package = GLOBAL.package
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = ActionHandler
local AddStategraphState = AddStategraphState
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

local originalAttack

local SGWilson = require "stategraphs/SGwilson"

for k, v in pairs(SGWilson.actionhandlers) do
	if SGWilson.actionhandlers[k]["action"]["id"] == "ATTACK" then
        originalAttack = SGWilson.actionhandlers[k]["deststate"]
    end
end

local function ManutsaweeAttack(inst, action)
	inst.sg.mem.localchainattack = not action.forced or nil
	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
    if weapon and weapon:HasTag("mkatana") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
        return "mkatana"
    elseif weapon and weapon:HasTag("Iai") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
        return "Iai"
    elseif weapon and weapon:HasTag("yari") and not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and inst.components.combat ~= nil then
        return "yari"
    else
        return originalAttack(inst, action)
    end
end

----------------------------------------------------------------------------------------------
--------------------------------------function-----------------------------------------------
----------------------------------------------------------------------------------------------

local function DoMountSound(inst, mount, sound, ispredicted)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
    end
end

----------------------------------------------------------------------------------------------

local katanarnd = 1

local actionhandlers = {
    ActionHandler(ACTIONS.ATTACK, ManutsaweeAttack)
}

local states = {

--------------------------------------katana-----------------------------------------------
    State{
        name = "mkatana",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" }, --
        onenter = function(inst)

			if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end

            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES

            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()



            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then

                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)

            elseif equip ~= nil and equip:HasTag("mkatana") then

                inst.sg.statemem.iskatana = true
				inst.AnimState:SetDeltaTimeMultiplier(1.2)

                if katanarnd == 1 then

                    inst.AnimState:PlayAnimation("atk_prop_pre")
					inst.AnimState:PushAnimation("atk", false)
					katanarnd = math.random(2, 3)

                elseif katanarnd == 2 then
					inst.AnimState:SetDeltaTimeMultiplier(1.3)
					inst.sg:AddStateTag("mkatanaatk")
					inst.AnimState:PlayAnimation("chop_pre")

					katanarnd = 4
				elseif  katanarnd == 3 then
					inst.AnimState:SetDeltaTimeMultiplier(1.4)
					inst.sg:AddStateTag("mkatanaatk")
					inst.AnimState:PlayAnimation("pickaxe_pre")

					katanarnd = 1
				elseif katanarnd == 4 then
					inst.AnimState:SetDeltaTimeMultiplier(1.4)
					inst.AnimState:PlayAnimation("spearjab_pre")
					inst.AnimState:PushAnimation("spearjab", false)
					katanarnd = 5
				else
					inst.AnimState:PlayAnimation("atk_pre")
					inst.AnimState:PushAnimation("atk", false)
					katanarnd = 1
				end

                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                cooldown = math.max(cooldown, 13 * FRAMES)
            end

            inst.sg:SetTimeout(cooldown)
           if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
                end
            end
        end,

        timeline = {
			TimeEvent(5 * FRAMES, function(inst)
				inst.AnimState:SetDeltaTimeMultiplier(1)
                if inst.sg.statemem.iskatana and inst.sg:HasStateTag("mkatanaatk")  then
                    inst.AnimState:PlayAnimation("lunge_pst")
					inst.sg:RemoveStateTag("mkatanaatk")
                end
            end),

			TimeEvent(8 * FRAMES, function(inst)  if inst.sg.statemem.iskatana then
					inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
					end
            end),

			TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.iskatana then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end)
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.AnimState:SetDeltaTimeMultiplier(1)
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
				inst.AnimState:SetDeltaTimeMultiplier(1)
				if inst.sg:HasStateTag("mkatanaatk") then
                    inst.sg:RemoveStateTag("mkatanaatk")
                end
            end
        end,
    },

----------------------------------------------------------------------------------------------

--------------------------------------Iai------------------------------------------------------
    State{
        name = "Iai",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" }, --

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end

            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES

            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()

            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("Iai") then
                inst.sg.statemem.iskatana = true
                inst.AnimState:PlayAnimation("spearjab_pre")
                inst.AnimState:PushAnimation("lunge_pst", false)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
                cooldown = math.max(cooldown, 9 * FRAMES)
            end

            inst.sg:SetTimeout(cooldown)
            if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
                end
            end
        end,

        timeline = {
            TimeEvent(7.5 * FRAMES, function(inst) if inst.sg.statemem.iskatana then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                    end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.iskatana then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),},

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    },
--------------------------------------yari-----------------------------------------------

--------------------------------------yari-----------------------------------------------

    State{
        name = "yari",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" }, --

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end

            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES

            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.locomotor:Stop()

            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("yari") then

            inst.sg.statemem.isyari = true
            if math.random(1, 3) == 1 then
                inst.AnimState:PlayAnimation("spearjab_pre")
                inst.AnimState:PushAnimation("lunge_pst", false)
            elseif math.random(2, 3) == 2 then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
            else
                inst.AnimState:PlayAnimation("spearjab_pre")
                inst.AnimState:PushAnimation("spearjab", false)
                end
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
            cooldown = math.max(cooldown, 13 * FRAMES)
            end

            inst.sg:SetTimeout(cooldown)

            if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
                end
            end
        end,

        timeline = {
            TimeEvent(8 * FRAMES, function(inst) if inst.sg.statemem.isyari then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                    end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.isyari then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    }
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson", actionhandler)
    package.loaded["stategraphs/SGwilson"] = nil
end

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end
