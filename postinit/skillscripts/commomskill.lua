local State =  GLOBAL.State
local EventHandler = EventHandler
local TimeEvent = GLOBAL.TimeEvent
local FRAMES = GLOBAL.FRAMES
local AddStategraphState = AddStategraphState
local AddStategraphEvent = AddStategraphEvent
GLOBAL.setfenv(1, GLOBAL)

local events = {
    EventHandler("putglasses", function(inst)
        inst.sg:GoToState("putglasses")
    end),
    EventHandler("changehair", function(inst)
        inst.sg:GoToState("changehair")
    end),
}

local states = {
-------------------------------------------putglasses---------------------------------------
    State{
        name = "putglasses",
        tags = {"busy", "nopredict", "nointerrupt", "nomorph", "doing","notalking"},

        onenter = function(inst)
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("give")
            inst.AnimState:PushAnimation("give_pst",false)
        end,

       timeline = {
            TimeEvent(13 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

		 events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

-------------------------------------------changehair---------------------------------------

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

}

for _, state in ipairs(states) do
    AddStategraphState("wilson", state)
end

for _, event in ipairs(events) do
    AddStategraphEvent("wilson", event)
end
