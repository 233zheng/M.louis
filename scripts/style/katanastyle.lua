local FRAMES = GLOBAL.FRAMES
local ACTIONS = GLOBAL.ACTIONS
local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local ActionHandler = GLOBAL.ActionHandler
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local require = GLOBAL.require


local function DoMountSound(inst, mount, sound, ispredicted)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
    end
end

local function DoMountSoundClient(inst, mount, sound)
    if mount ~= nil and mount.sounds ~= nil then
        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, true)
    end
end

	local katanarnd = 1
	local katanastate 
	local mkatana = State({
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
			inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("mkatana") then				
				 inst.sg.statemem.iskatana = true		
				
				inst.AnimState:SetDeltaTimeMultiplier(1.2)
                if  katanarnd == 1 then					
					inst.AnimState:PlayAnimation("atk_prop_pre")                	
					inst.AnimState:PushAnimation("atk", false)
					katanarnd = math.random(2, 3)				
				elseif  katanarnd == 2 then
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

        timeline =
        {	
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

        events =
        {
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
				if inst.sg:HasStateTag("mkatanaatk") then inst.sg:RemoveStateTag("mkatanaatk") end		
            end			
        end,
    }
)

AddStategraphState("wilson", mkatana)

local katana_client = State({
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
                if  katanarnd == 1 then
					inst.AnimState:PlayAnimation("atk_prop_pre")                	
					inst.AnimState:PushAnimation("atk", false)
					katanarnd = math.random(2, 3)				
				elseif  katanarnd == 2 then	
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

        timeline =
		{	
			TimeEvent(5 * FRAMES, function(inst) 
				inst.AnimState:SetDeltaTimeMultiplier(1)		 
				if inst.sg.statemem.iskatana and inst.sg:HasStateTag("mkatanaatk") then
					 inst.AnimState:PlayAnimation("lunge_pst")
					 inst.sg:RemoveStateTag("mkatanaatk")
				end		
			end),
			
			TimeEvent(8 * FRAMES, function(inst)  if inst.sg.statemem.iskatana then					
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

        events =
        {
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
	}
)

AddStategraphState("wilson_client", katana_client)


local Iai = State({
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
			inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
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

        timeline =
        {   
			
            TimeEvent(2 * FRAMES, function(inst) if inst.sg.statemem.iskatana then
                    inst:PerformBufferedAction()					
					inst.sg:RemoveStateTag("abouttoattack")
					end
            end),
			TimeEvent(10 * FRAMES, function(inst)
                if not inst.sg.statemem.iskatana then
                    inst:PerformBufferedAction()
                    inst.sg:RemoveStateTag("abouttoattack")
                end
            end),
			
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
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
)

AddStategraphState("wilson", Iai)
local Iai_client = State({
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

        timeline =
		{
            TimeEvent(2 * FRAMES, function(inst) if inst.sg.statemem.iskatana then
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

        events =
        {
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
)
AddStategraphState("wilson_client", Iai_client)


local yari = State({
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
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
			inst.AnimState:OverrideSymbol("fx_lunge_streak", "player_lunge_blue", "fx_lunge_streak")
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES			
            if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
                inst.AnimState:PlayAnimation("atk_pre")
                inst.AnimState:PushAnimation("atk", false)
                DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
                cooldown = math.max(cooldown, 16 * FRAMES)
            elseif equip ~= nil and equip:HasTag("yari") then
			
			inst.sg.statemem.isyari = true
			if  math.random(1, 3) == 1 then                						
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

        timeline =
        {
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

        events =
        {
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
)

AddStategraphState("wilson", yari)

local yari_client = State({
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
                if  math.random(1, 3) == 1 then                						
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

            local buffaction = inst:GetBufferedAction()
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

        timeline =
		{
            TimeEvent(8 * FRAMES, function(inst)  if inst.sg.statemem.isyari then
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

        events =
        {
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
)
AddStategraphState("wilson_client", yari_client)
