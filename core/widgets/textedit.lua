local ThePlayer = GLOBAL.ThePlayer
local TheNet = GLOBAL.TheNet

local function TextEditConstruct(inst)
    print("Load: core/widgets/texredit.lua")
    local _SetEditing = inst.SetEditing
	function inst:SetEditing(editing)
		if not TheNet:IsDedicated() then
			if ThePlayer then
                ThePlayer:PushEvent( "gamepaused", editing )
			end
		end

		_SetEditing(self, editing)
	end

	local _OnDestroy = inst.OnDestroy
	function inst:OnDestroy(editing)
		if not TheNet:IsDedicated() then
			if ThePlayer then
                ThePlayer:PushEvent( "gamepaused", editing )
			end
		end

        _OnDestroy(self)
	end

	return inst
end

AddClassPostConstruct("widgets/textedit", TextEditConstruct)
