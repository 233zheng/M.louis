	--------------------------------------------WILSON SG ACTIONHANDLER FOR ATTACK OVERRIDE---------------------------------------------------------------------------
require = GLOBAL.require

RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
GIngredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

FRAMES = GLOBAL.FRAMES
ACTIONS = GLOBAL.ACTIONS
State = GLOBAL.State
EventHandler = GLOBAL.EventHandler
ActionHandler = GLOBAL.ActionHandler
TimeEvent = GLOBAL.TimeEvent

EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local originalAttack
local originalClientAttack

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


local function ClientManutsaweeAttack(inst, action)
  local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
 if weapon and weapon:HasTag("mkatana") and not inst.sg:HasStateTag("attack") and inst.replica.combat then
    return "mkatana"
  elseif weapon and weapon:HasTag("Iai")  and not inst.sg:HasStateTag("attack") and inst.replica.combat then
    return "Iai"	
	  elseif weapon and weapon:HasTag("yari")  and not inst.sg:HasStateTag("attack") and inst.replica.combat then
      return "yari"
	else
    return originalClientAttack(inst, action)
  end
end


AddStategraphPostInit('wilson', function(sg)
  actionhandlers = sg.actionhandlers
  for i,v in pairs(actionhandlers) do
    if v.action == ACTIONS.ATTACK then
      originalAttack = actionhandlers[i].deststate
      actionhandlers[i].deststate = ManutsaweeAttack
    end
  end
end)
AddStategraphPostInit('wilson_client', function(sg)
  actionhandlers = sg.actionhandlers
  for i,v in pairs(actionhandlers) do
    if v.action == ACTIONS.ATTACK then
      originalClientAttack = actionhandlers[i].deststate
      actionhandlers[i].deststate = ClientManutsaweeAttack
    end
  end
end)