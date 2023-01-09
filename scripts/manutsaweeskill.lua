local function SkillCollision(inst, enable)
	inst.Physics:ClearCollisionMask()
	if enable then
		--inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.GROUND)
		
	else
		--inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(COLLISION.GIANTS)
	end	
end

AddStategraphState("wilson",
    State{
        name = "putglasses", 
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking"},

        onenter = function(inst)			
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
            inst.AnimState:PushAnimation("give_pst",false)			
        end,

       timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },
		
		 events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        }, 
		
		 onexit = function(inst)			
			
        end,
    }
)

AddStategraphState("wilson",
    State{
        name = "changehair", 
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking"},

        onenter = function(inst)			
			inst.components.locomotor:Stop()
			
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)

            inst.sg:SetTimeout(1)			
        end,

       ontimeout = function(inst)
            inst:PerformBufferedAction()
            inst.AnimState:PlayAnimation("build_pst")
            inst.sg:GoToState("idle", false)
        end,		 

        onexit = function(inst)
			inst.SoundEmitter:KillSound("make")		
        end,
    }
)

AddStategraphState("wilson",
    State{
        name = "heavenlystrike", 
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "skilling","notalking","mdashing" },

        onenter = function(inst)			
			local x, y, z = inst.Transform:GetWorldPosition()	
			local pufffx = SpawnPrefab("dirt_puff")
			pufffx.Transform:SetScale(.3, .3, .3)
			pufffx.Transform:SetPosition(x, y, z)
			
			SkillCollision(inst, true)
			inst.components.locomotor:Stop()
			if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			inst.components.combat:SetRange(inst.oldrange)
			inst.AnimState:PlayAnimation("atk_leap_pre")			
			inst.Physics:SetMotorVelOverride(30,0,0)			
        end,

        timeline =
        {
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")			
            end),
			TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			SkillCollision(inst, false)
            end),	
			TimeEvent(11*FRAMES, function(inst) inst.Physics:ClearMotorVelOverride() 		
            end),
			
        },        
		
		 events =
        {
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
    }
)

AddStategraphState("wilson",
    State{
        name = "blockparry",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph"},

        onenter = function(inst)
			
			inst.components.locomotor:Stop()			    				
			inst.AnimState:PlayAnimation("atk")
			--inst.AnimState:PushAnimation("parry_pst", false)   
			inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")			
        end,

        timeline =
        {			
			TimeEvent(0.5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")				
			inst.Physics:SetMotorVelOverride(-0.1,0,0)
			inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
            end),
			TimeEvent(1*FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")	
			SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())			
            end),
        },        
		
		 events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
		inst.Physics:ClearMotorVelOverride()		
        end,
    }
)

AddStategraphState("wilson",
    State{
        name = "counterstart", 
        tags = {"busy", "nomorph", "notalking", "nopredict", "doing"},		
        onenter = function(inst)						
				
			inst.AnimState:PlayAnimation("parry_pre")
			inst.AnimState:PushAnimation("parry_pst", false)   		
			inst.components.locomotor:Stop()
			inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
        end,

        timeline = 
        {		
			TimeEvent(.5*FRAMES, function(inst) inst.sg:AddStateTag("counteractive")						
            end),
			TimeEvent(8*FRAMES, function(inst) inst.sg:RemoveStateTag("counteractive")	inst.sg:AddStateTag("startblockparry")			
            end),			
        },        
		
		 events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")					
                end
            end),
        },

        onexit = function(inst)			
			inst.sg:RemoveStateTag("startblockparry")
        end,
    }
)

local function mcounterattack()
    local state =
    GLOBAL.State{
        name = "mcounterattack",
        tags = {"attack", "doing", "busy", "nointerrupt" ,"nopredict","nomorph"}, --
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

        timeline =
        {
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)  
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
				inst:PerformBufferedAction()
				inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
			
            GLOBAL.TimeEvent(4 * FRAMES, function(inst)
                inst.components.combat:SetRange(inst.oldrange)				
            end),
           
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {            
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
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
			inst.inspskill = nil
			inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
        end,
    }
    return state
end

AddStategraphEvent("wilson", EventHandler("heavenlystrike", function(inst) inst.sg:GoToState("heavenlystrike") end))
AddStategraphEvent("wilson", EventHandler("blockparry", function(inst) inst.sg:GoToState("blockparry") end))

AddStategraphEvent("wilson", EventHandler("putglasses", function(inst) inst.sg:GoToState("putglasses") end))
AddStategraphEvent("wilson", EventHandler("changehair", function(inst) inst.sg:GoToState("changehair") end))

AddStategraphEvent("wilson", EventHandler("counterstart", function(inst) inst.sg:GoToState("counterstart") end))
AddStategraphState("wilson",mcounterattack())
---------------------------------------------------------------------------------------

local function monemind()
    local equipskill
    local state =
    GLOBAL.State{
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
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
				equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end
				inst.Physics:SetMotorVelOverride(32,0,0)				
				inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())			
            end),
			GLOBAL.TimeEvent(4 * FRAMES, function(inst)
				inst.Physics:ClearMotorVelOverride()			
			end),
			GLOBAL.TimeEvent(9 * FRAMES, function(inst)			
			inst.sg:GoToState("idle")			
            end),			
        },

        ontimeout = function(inst)            
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {            
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then					
                    inst.sg:GoToState("idle")					
                end
            end),
        },

        onexit = function(inst)			
		
        end,
    }
    return state
end
AddStategraphState("wilson",monemind())

local function mquicksheath()
	local equipskill
    local state =
    GLOBAL.State{
        name = "mquicksheath",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking","skilling"},
        onenter = function(inst, target)
			equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.locomotor:Stop()			
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")	
           
        end,

        timeline =
        {				
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)
				equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end				
            end),
			GLOBAL.TimeEvent(8 * FRAMES, function(inst)
			inst.sg:GoToState("idle")
            end),			
        },

        ontimeout = function(inst)            
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {            
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then					
                    inst.sg:GoToState("idle")					
                end
            end),
        },

        onexit = function(inst)			
		
        end,
    }
    return state
end
AddStategraphState("wilson",mquicksheath())

local function ryusen() --ryusen
	local equipskill
    local state =
    GLOBAL.State{
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

        timeline =
        {	
			
			GLOBAL.TimeEvent(2 * FRAMES, function(inst)
				equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
				SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())	
            end),
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			SpawnPrefab("wanda_attack_shadowweapon_old_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
			end),
			GLOBAL.TimeEvent(6 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			SpawnPrefab("wanda_attack_shadowweapon_normal_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
			
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			
			equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
			end),			
			GLOBAL.TimeEvent(9 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			SpawnPrefab("wanda_attack_shadowweapon_old_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
			
			inst.components.combat:DoAttack(inst.sg.statemem.target)			
            inst:PerformBufferedAction()
			
			equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
			end),
			GLOBAL.TimeEvent(12 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			SpawnPrefab("wanda_attack_shadowweapon_normal_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
			
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			
			equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
			end),
			GLOBAL.TimeEvent(13 * FRAMES, function(inst)
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            end),
			GLOBAL.TimeEvent(14 * FRAMES, function(inst)
			inst.Physics:SetMotorVelOverride(32,0,0)
			inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
            end),
			GLOBAL.TimeEvent(16 * FRAMES, function(inst)			
			inst.Physics:ClearMotorVelOverride()
			local x, y, z = inst.Transform:GetWorldPosition()	
			local fx = SpawnPrefab("groundpoundring_fx")
			fx.Transform:SetScale(.6, .6, .6)
			fx.Transform:SetPosition(x, y, z)
            end),
			GLOBAL.TimeEvent(17 * FRAMES, function(inst)		
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
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
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
			inst.mafterskillndm = inst:DoTaskInTime(2, function() inst.mafterskillndm = nil end)
        end,
    }
    return state
end
AddStategraphState("wilson",ryusen())

local function mflipskill() --flipskill
    local state =
    GLOBAL.State{
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

        timeline =
        {	
			GLOBAL.TimeEvent(1 * FRAMES, function(inst)		
			inst.Physics:SetMotorVelOverride(32,0,0)
			inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())			
            end),
			GLOBAL.TimeEvent(2 * FRAMES, function(inst)
			inst.Physics:ClearMotorVelOverride()
            end),
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)
			 inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump") 			
            end),
			GLOBAL.TimeEvent(4 * FRAMES, function(inst)
			 inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump") 			
            end),
			GLOBAL.TimeEvent(5 * FRAMES, function(inst)
			 inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump") 			
            end),
			GLOBAL.TimeEvent(6 * FRAMES, function(inst)
			 inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump") 			
            end),
			GLOBAL.TimeEvent(7 * FRAMES, function(inst)			
			 inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump") 			
            end),            
			GLOBAL.TimeEvent(8 * FRAMES, function(inst)
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
			GLOBAL.TimeEvent(12 * FRAMES, function(inst)
			
			--inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
            end),			
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {            
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
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
			inst.inspskill = nil
			inst.components.combat:EnableAreaDamage(false)
        end,
    }
    return state
end
AddStategraphState("wilson",mflipskill())

local function mthrustskill() --thrustskill
    local state =
    GLOBAL.State{
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

        timeline =
        {	
			GLOBAL.TimeEvent(1 * FRAMES, function(inst)			
			inst.Physics:SetMotorVelOverride(32,0,0)
			inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())			
            end),
			GLOBAL.TimeEvent(2 * FRAMES, function(inst)
			inst.Physics:ClearMotorVelOverride()
            end),
			GLOBAL.TimeEvent(8 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword") 			
            end),			
			GLOBAL.TimeEvent(9 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			
            end),
			GLOBAL.TimeEvent(10 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			
            end),
			GLOBAL.TimeEvent(12 * FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
			inst.components.combat:DoAttack(inst.sg.statemem.target)	
            inst:PerformBufferedAction()
			
            end),            
			GLOBAL.TimeEvent(14 * FRAMES, function(inst)				
				inst.components.combat:DoAttack(inst.sg.statemem.target)	
				inst.components.combat:DoAttack(inst.sg.statemem.target)	
               	inst:PerformBufferedAction()
				
				inst.components.combat:SetRange(inst.oldrange)
				inst.components.combat:SetAreaDamage(1, 1)	
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
				inst.AnimState:SetDeltaTimeMultiplier(1)
				
            end),
			GLOBAL.TimeEvent(18 * FRAMES, function(inst)			
			--inst.mafterskillndm = inst:DoTaskInTime(1.5, function() inst.mafterskillndm = nil end)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {    			
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then					
                    inst.sg:GoToState("idle")					
					
                end
            end),
        },

        onexit = function(inst)
			if inst.components.combat then	inst.components.combat:SetTarget(nil) inst.components.combat:SetRange(inst.oldrange) end			
			inst.inspskill = nil
			inst.components.combat:EnableAreaDamage(false)
        end,
    }
    return state
end
AddStategraphState("wilson",mthrustskill())

local function michimonji() 
    local state =
    GLOBAL.State{
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

        timeline =
        {	
			GLOBAL.TimeEvent(8 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
				SpawnPrefab("electrichitsparks").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)				
				local x, y, z = inst.Transform:GetWorldPosition()	
				local fx = SpawnPrefab("groundpoundring_fx")
				fx.Transform:SetScale(.5, .5, .5)
				fx.Transform:SetPosition(x, y, z)
				
            end),			
			GLOBAL.TimeEvent(9 * FRAMES, function(inst)
				inst.AnimState:SetDeltaTimeMultiplier(1)
				inst.Physics:SetMotorVelOverride(32,0,0)
				inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())				
            end),
			GLOBAL.TimeEvent(10 * FRAMES, function(inst)
				inst.Physics:ClearMotorVelOverride()
				local x, y, z = inst.Transform:GetWorldPosition()	
				local pufffx = SpawnPrefab("dirt_puff")
				pufffx.Transform:SetScale(.6, .6, .6)
				pufffx.Transform:SetPosition(x, y, z)				
            end),
			GLOBAL.TimeEvent(17 * FRAMES, function(inst)
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

        events =
        {    			
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
                and not inst.sg:HasStateTag("dead")
                then					
                    inst.sg:GoToState("idle")
					
                end
            end),
        },

        onexit = function(inst)
			if inst.components.combat then	inst.components.combat:SetTarget(nil) inst.components.combat:SetRange(inst.oldrange) end			
			inst.inspskill = nil
			inst.components.combat:EnableAreaDamage(false)	
			if inst.doubleichimonji ~= nil then 
				inst.doubleichimonji = nil
				inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL1ATTACK, 2, true)				
				inst.mafterskillndm = inst:DoTaskInTime(2, function() inst.mafterskillndm = nil end)
			end			
			if inst.doubleichimonjistart then inst.doubleichimonjistart = nil inst.doubleichimonji = true end
        end,
    }
    return state
end
AddStategraphState("wilson",michimonji())

local function habakirifx(inst, target, fxscale) 
local effects = SpawnPrefab("wanda_attack_shadowweapon_normal_fx")																
						effects.Transform:SetScale(fxscale, fxscale, fxscale)
						effects.Transform:SetPosition(target:GetPosition():Get())
						inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
						inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe")
end

local function mhabakiri()
    local equipskill
	local state =
    GLOBAL.State{
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

        timeline =
        {	
			GLOBAL.TimeEvent(1 * FRAMES, function(inst)				
				inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				inst.Physics:SetMotorVelOverride(-.25,0,10)
            end),
			
			GLOBAL.TimeEvent(3 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
            end),
			
			GLOBAL.TimeEvent(4 * FRAMES, function(inst)						
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				habakirifx(inst, inst.sg.statemem.target, 3) 
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
				inst:PerformBufferedAction()		
				inst.Physics:ClearMotorVelOverride()
            end),
			
			GLOBAL.TimeEvent(5 * FRAMES, function(inst)			
				inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
				inst.AnimState:PlayAnimation("lunge_pst")
				inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				inst.Physics:SetMotorVelOverride(-.5,0,-20)
            end),
			
			GLOBAL.TimeEvent(8* FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				habakirifx(inst, inst.sg.statemem.target, 2) 
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
				inst:PerformBufferedAction()			
				inst.Physics:ClearMotorVelOverride()
            end),
			
			GLOBAL.TimeEvent(9 * FRAMES, function(inst)				
				inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
				inst.AnimState:PlayAnimation("atk")
				inst:ForceFacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
				inst.Physics:SetMotorVelOverride(-.5,0,20)
            end),				
           
			GLOBAL.TimeEvent(12* FRAMES, function(inst)
				inst.components.combat:DoAttack(inst.sg.statemem.target)
				habakirifx(inst, inst.sg.statemem.target, 2) 
				inst:PerformBufferedAction()
				inst.components.combat:SetRange(inst.oldrange)
				inst.components.combat:SetAreaDamage(1, 1)	
				inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")			
				inst.Physics:ClearMotorVelOverride()
				inst.Physics:SetMotorVelOverride(-.5,0,-10)
            end),
			
			GLOBAL.TimeEvent(15* FRAMES, function(inst)
				equipskill = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equipskill and equipskill.components.spellcaster ~= nil then
					equipskill.components.spellcaster:CastSpell(inst)
				end	
				inst.Physics:ClearMotorVelOverride()
				SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())			
            end),
					
			GLOBAL.TimeEvent(20 * FRAMES, function(inst)
				inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL2ATTACK, 2, true)			
			end),			
						
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
			
        end,

        events =
        {            
            GLOBAL.EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() and inst.components.health ~= nil and not inst.components.health:IsDead()
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
			inst.inspskill = nil
			inst.components.combat:EnableAreaDamage(false)
			inst.mafterskillndm = inst:DoTaskInTime(1, function() inst.mafterskillndm = nil end)
        end,
    }
    return state
end
AddStategraphState("wilson",mhabakiri())

local function groundpoundfx1(inst)
	local x, y, z = inst.Transform:GetWorldPosition()	
			local fx = SpawnPrefab("groundpoundring_fx")
			fx.Transform:SetScale(.6, .6, .6)
			fx.Transform:SetPosition(x, y, z)
end

local function mshockfx1(inst)
	SpawnPrefab("sparks").Transform:SetPosition(inst:GetPosition():Get())	
	SpawnPrefab("shock_fx").Transform:SetPosition(inst:GetPosition():Get())
	SpawnPrefab("mossling_spin_fx").Transform:SetPosition(inst:GetPosition():Get())
	SpawnPrefab("dirt_puff").Transform:SetPosition(inst:GetPosition():Get())
end