local ThePlayer = GLOBAL.ThePlayer
local TheNet = GLOBAL.TheNet

local function ChatPostConstruct(inst)
    print("Load: core/screens/chatinputscreen.lua")
	function inst:OnBecomeActive()
		if not TheNet:IsDedicated() then
			if ThePlayer ~= nil then
		    		ThePlayer:PushEvent( "gamepaused", true )
			end
		end

		inst._base.OnBecomeActive(inst)

		inst.chat_edit:SetFocus()
		inst.chat_edit:SetEditing(true)
		TheFrontEnd:LockFocus(true)
	end

	function inst:OnBecomeInactive()
		if not TheNet:IsDedicated() then
			if ThePlayer ~= nil then
                ThePlayer:PushEvent( "gamepaused", false )
			end
		end

        inst._base.OnBecomeInactive(self)

		if inst.runtask ~= nil then
            inst.runtask:Cancel()
            inst.runtask = nil
        end
	end

	return inst
end

AddClassPostConstruct("screens/chatinputscreen", ChatPostConstruct)
