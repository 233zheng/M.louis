local require = GLOBAL.require
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local package = GLOBAL.package
local ACTIONS = GLOBAL.ACTIONS
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local State = GLOBAL.State
local EventHandler = EventHandler
local ActionHandler = ActionHandler
local AddStategraphState = AddStategraphState
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

--attackkatanastyle

local originalClientAttack

local SGWilsonClient = require "stategraphs/SGwilson_client"

for k, v in pairs(SGWilsonClient.actionhandlers) do
	if SGWilsonClient.actionhandlers[k]["action"]["id"] == "ATTACK" then
        originalClientAttack = SGWilsonClient.actionhandlers[k]["deststate"]
    end
end

local function ClientManutsaweeAttack(inst, action)
	local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
    if weapon and weapon:HasTag("mkatana") and not inst.sg:HasStateTag("attack") and inst.replica.combat then
        return "mkatana"
    elseif weapon and weapon:HasTag("Iai") and not inst.sg:HasStateTag("attack") and inst.replica.combat then
        return "Iai"
    elseif weapon and weapon:HasTag("yari") and not inst.sg:HasStateTag("attack") and inst.replica.combat then
        return "yari"
    else
        return originalClientAttack(inst, action)
    end
end

--katanastyle

----------------------------------------------------------------------------------------------
--------------------------------------function-----------------------------------------------
----------------------------------------------------------------------------------------------

local function DoMountSoundClient(inst, mount, sound)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, true)
    end
end

----------------------------------------------------------------------------------------------

local katanarnd = 1

local actionhandlers = {
    ActionHandler(ACTIONS.ATTACK, ClientManutsaweeAttack)
}

local states = {

--------------------------------------katana-----------------------------------------------
    State{
        name = "mkatana",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)

            local buffaction = inst:GetBufferedAction()
            local cooldown = 0
            if inst.replica.combat ~= nil then
                if inst.replica.combat:InCooldown() then
                    inst.sg:RemoveStateTag("abouttoattack")
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle", true)
                    return
                end
                inst.replica.combat:StartAttack()
                cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
            end

            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local rider = inst.replica.rider

            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.locomotor:Stop()

            if rider ~= nil and rider:IsRiding() then

                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSoundClient(inst, rider:GetMount(), "angry")

                if cooldown > 0 then
                    cooldown = math.max(cooldown, 16 * FRAMES)
                end

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

                elseif katanarnd == 3 then

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

                if cooldown > 0 then
                    cooldown = math.max(cooldown, 13 * FRAMES)
                end
            end

            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end

            if cooldown > 0 then
                inst.sg:SetTimeout(cooldown)
            end
        end,

        timeline = {
            TimeEvent(5 * FRAMES, function(inst)
                inst.AnimState:SetDeltaTimeMultiplier(1)
                if inst.sg.statemem.iskatana and inst.sg:HasStateTag("mkatanaatk") then
                    inst.AnimState:PlayAnimation("lunge_pst")
                    inst.sg:RemoveStateTag("mkatanaatk")
                end
            end),

            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.iskatana then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),

            TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.iskatana then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end)
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                    inst.AnimState:SetDeltaTimeMultiplier(1)
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
                inst.AnimState:SetDeltaTimeMultiplier(1)
                if inst.sg:HasStateTag("mkatanaatk") then  inst.sg:RemoveStateTag("mkatanaatk") end
            end
        end,
    },
----------------------------------------------------------------------------------------------

--------------------------------------Iai-----------------------------------------------
    State{
        name = "Iai",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local cooldown = 0

            if inst.replica.combat ~= nil then
                if inst.replica.combat:InCooldown() then
                    inst.sg:RemoveStateTag("abouttoattack")
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle", true)
                    return
                end
                inst.replica.combat:StartAttack()
                cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
            end

            inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.locomotor:Stop()

            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local rider = inst.replica.rider

            if rider ~= nil and rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSoundClient(inst, rider:GetMount(), "angry")
                if cooldown > 0 then
                    cooldown = math.max(cooldown, 16 * FRAMES)
                end

            elseif equip ~= nil and equip:HasTag("Iai") then

                inst.AnimState:PlayAnimation("spearjab_pre")
                inst.AnimState:PushAnimation("lunge_pst", false)
                inst.sg.statemem.iskatana = true
                if cooldown > 0 then
                    cooldown = math.max(cooldown, 9 * FRAMES)
                end
            end

            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end

            end

            if cooldown > 0 then
                inst.sg:SetTimeout(cooldown)
            end
        end,

        timeline = {
            TimeEvent(7.5 * FRAMES, function(inst)
                if inst.sg.statemem.iskatana then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.iskatana then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
    },
----------------------------------------------------------------------------------------------

--------------------------------------yari-----------------------------------------------
    State {
        name = "yari",
        tags = { "attack", "notalking", "abouttoattack" },

        onenter = function(inst)
            local buffaction = inst:GetBufferedAction()
            local cooldown = 0

            if inst.replica.combat ~= nil then
                if inst.replica.combat:InCooldown() then
                    inst.sg:RemoveStateTag("abouttoattack")
                    inst:ClearBufferedAction()
                    inst.sg:GoToState("idle", true)
                    return
                end
                inst.replica.combat:StartAttack()
                cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
            end

			inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.locomotor:Stop()

            local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            local rider = inst.replica.rider

            if rider ~= nil and rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSoundClient(inst, rider:GetMount(), "angry")
                if cooldown > 0 then
                    cooldown = math.max(cooldown, 16 * FRAMES)
                end

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

                if cooldown > 0 then
                    cooldown = math.max(cooldown, 13 * FRAMES)
                end
            end

            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end

            if cooldown > 0 then
                inst.sg:SetTimeout(cooldown)
            end
        end,

        timeline = {
            TimeEvent(8 * FRAMES, function(inst)
                if inst.sg.statemem.isyari then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
				end
			end),

			TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.isyari then
                    inst:ClearBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events = {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
        end,
	}
----------------------------------------------------------------------------------------------
}

for _, actionhandler in ipairs(actionhandlers) do
    AddStategraphActionHandler("wilson_client", actionhandler)
    package.loaded["stategraphs/SGwilson_client"] = nil
end

for _, state in ipairs(states) do
    AddStategraphState("wilson_client", state)
end
