local MakePlayerCharacter = require "prefabs/player_common"
local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	
	Asset("ANIM", "anim/hair_cut.zip"),
	Asset("ANIM", "anim/hair_short.zip"),
	Asset("ANIM", "anim/hair_medium.zip"),
	Asset("ANIM", "anim/hair_long.zip"),
	
	Asset("ANIM", "anim/hair_short_pony.zip"),
	Asset("ANIM", "anim/hair_medium_pony.zip"),	
	Asset("ANIM", "anim/hair_long_pony.zip"),
	
	Asset("ANIM", "anim/hair_short_twin.zip"),
	Asset("ANIM", "anim/hair_medium_twin.zip"),
	Asset("ANIM", "anim/hair_long_twin.zip"),
	
	Asset("ANIM", "anim/hair_short_htwin.zip"),
	Asset("ANIM", "anim/hair_medium_htwin.zip"),
	Asset("ANIM", "anim/hair_long_htwin.zip"),
	
	Asset("ANIM", "anim/hair_short_yoto.zip"),
	Asset("ANIM", "anim/hair_medium_yoto.zip"),
	Asset("ANIM", "anim/hair_long_yoto.zip"),
	
	Asset("ANIM", "anim/hair_short_ronin.zip"),
	Asset("ANIM", "anim/hair_medium_ronin.zip"),
	Asset("ANIM", "anim/hair_long_ronin.zip"),
	
	Asset("ANIM", "anim/hair_short_ball.zip"),
	Asset("ANIM", "anim/hair_medium_ball.zip"),
	Asset("ANIM", "anim/hair_long_ball.zip"),
	
	Asset("ANIM", "anim/eyeglasses.zip"),	
}

local MANUTSAWEE_DMG = 1
local MANUTSAWEE_CRIDMG = 0.1

-- Your character's stats
TUNING.MANUTSAWEE_HEALTH = TUNING.MANUTSAWEE.HEALTH
TUNING.MANUTSAWEE_HUNGER = TUNING.MANUTSAWEE.HUNGER 
TUNING.MANUTSAWEE_SANITY = TUNING.MANUTSAWEE.SANITY 

local hitcount = 0 --attackcount regen mind
local criticalrate = 5 --critical hit rate

local mstartitem = {"shinai","raikiri","shirasaya","koshirae","hitokiri","katanablade"}
local start_inv = {}
	if TUNING.MANUTSAWEE.MSTARTITEM > 0 then
		TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MANUTSAWEE = {mstartitem[TUNING.MANUTSAWEE.MSTARTITEM]}	
	else TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MANUTSAWEE = {}
end

for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.MANUTSAWEE
end
local prefabs = FlattenTree(start_inv, true)

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
end 

local function mindregenfn(inst)
	inst.mindpower = inst.mindpower+1	
	local mindregenfx = SpawnPrefab("battlesong_instant_electric_fx")
		mindregenfx.Transform:SetScale(.7, .7, .7)
		mindregenfx.Transform:SetPosition(inst:GetPosition():Get())
		mindregenfx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)	
	if inst.mindpower >= 3 then inst.components.talker:Say("󰀈: "..inst.mindpower.."\n", 2, true) end
end

local function mindregen(inst)
	if inst.mindpower < inst.max_mindpower/2 then
		 mindregenfn(inst)
	end
	inst:DoTaskInTime(TUNING.MANUTSAWEE.MINDREGENRATE, mindregen)
end

local HAIR_BITS = { "_cut", "_short", "_medium",  "_long" }
local HAIR_TYPES = { "", "_yoto", "_ronin", "_pony", "_twin", "_htwin","_ball"}
local function OnChangehair(inst, skinname)
 if inst.hairlong == 1 and inst.hairtype > 1 then inst.hairtype = 1 end
 if skinname == nil then    
	inst.AnimState:OverrideSymbol("hairpigtails", "hair"..HAIR_BITS[inst.hairlong]..HAIR_TYPES[inst.hairtype], "hairpigtails")
	inst.AnimState:OverrideSymbol("hair", "hair"..HAIR_BITS[inst.hairlong]..HAIR_TYPES[inst.hairtype], "hair")
	inst.AnimState:OverrideSymbol("hair_hat", "hair"..HAIR_BITS[inst.hairlong]..HAIR_TYPES[inst.hairtype], "hair_hat")
	inst.AnimState:OverrideSymbol("headbase", "hair"..HAIR_BITS[inst.hairlong]..HAIR_TYPES[inst.hairtype], "headbase")
	inst.AnimState:OverrideSymbol("headbase_hat", "hair"..HAIR_BITS[inst.hairlong]..HAIR_TYPES[inst.hairtype], "headbase_hat")
else
	 inst.AnimState:OverrideSkinSymbol("hairpigtails", skinname, "hairpigtails" )
	 inst.AnimState:OverrideSkinSymbol("hair", skinname, "hair" )
	 inst.AnimState:OverrideSkinSymbol("hair_hat", skinname, "hair_hat" )
	 inst.AnimState:OverrideSkinSymbol("headbase", skinname, "headbase" )
	 inst.AnimState:OverrideSkinSymbol("headbase_hat", skinname, "headbase_hat" )
end
 if inst.hairtype <= 2 then  inst.components.beard.insulation_factor = 1 else inst.components.beard.insulation_factor = .1 end
end

local function PutGlasses(inst, skinname)	
		if skinname == nil then
			inst.AnimState:OverrideSymbol("face", "eyeglasses", "face")
		else
			inst.AnimState:OverrideSkinSymbol("face", skinname, "face" )
		end 	
end

local function kenjutsuupgrades(inst)		
	-------------------
	if inst.kenjutsulevel >= 2 and not inst:HasTag("kenjutsu")  then inst:AddTag("kenjutsu") end
	if inst.kenjutsulevel >= 4 and inst.startregen == nil then inst.startregen = inst:DoTaskInTime(TUNING.MANUTSAWEE.MINDREGENRATE, mindregen)	end
	if inst.kenjutsulevel >= 5 and not inst:HasTag("manutsaweecraft2")  then inst:AddTag("manutsaweecraft2") end
	-------------------
		
	if inst.kenjutsulevel >= 1 then 
		inst.components.sanity.neg_aura_mult = 1 - ((inst.kenjutsulevel/2)/10)
		inst.kenjutsumaxexp = 500 * inst.kenjutsulevel

		local hunger_percent = inst.components.hunger:GetPercent()
		local health_percent = inst.components.health:GetPercent()
		local sanity_percent = inst.components.sanity:GetPercent()
		
		if TUNING.MANUTSAWEE.HEALTHMAX > 0 then 
		inst.components.health.maxhealth = math.ceil(TUNING.MANUTSAWEE_HEALTH + inst.kenjutsulevel * TUNING.MANUTSAWEE.HEALTHMAX)
		inst.components.health:SetPercent(health_percent)
		end
		if TUNING.MANUTSAWEE.HUNGERMAX > 0 then 
		inst.components.hunger.max = math.ceil(TUNING.MANUTSAWEE_HUNGER + inst.kenjutsulevel * TUNING.MANUTSAWEE.HUNGERMAX)		
		inst.components.hunger:SetPercent(hunger_percent)
		end
		if TUNING.MANUTSAWEE.SANITYMAX > 0 then 
		inst.components.sanity.max = math.ceil(TUNING.MANUTSAWEE_SANITY + inst.kenjutsulevel * TUNING.MANUTSAWEE.SANITYMAX)
		inst.components.sanity:SetPercent(sanity_percent)
		end
	end	
	
	if inst.kenjutsulevel >= 5 then
		inst.components.sanity:AddSanityAuraImmunity("ghost")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   1, inst)
		inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,  1, inst)
		inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1, inst)
		end	
	if inst.kenjutsulevel >= 6 then
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_TINY /2
		inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_TINY /2
		inst.components.sanity:SetPlayerGhostImmunity(true)	
		end
	if inst.kenjutsulevel >= 10 then inst.kenjutsuexp = 0 end
	
	MANUTSAWEE_CRIDMG = 0.1 + ((inst.kenjutsulevel/2)/10)
	
	----check point
	inst.max_mindpower = TUNING.MANUTSAWEE.MINDMAX + inst.kenjutsulevel 
		
	local fx = SpawnPrefab("fx_book_light_upgraded")			
			fx.Transform:SetScale(.9, 2.5, 1)
			fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
end

local function kenjutsulevelup(inst)
	inst.kenjutsulevel = inst.kenjutsulevel + 1	
	kenjutsuupgrades(inst)
end

local function LevelCheckFn(inst)	-------- check level
	if not inst.components.timer:TimerExists("checkCD")then inst.components.timer:StartTimer("checkCD",.8)
		if inst.kenjutsulevel < 10 then
			inst.components.talker:Say("󰀍: "..inst.kenjutsulevel.." :"..inst.kenjutsuexp.."/"..inst.kenjutsumaxexp.."\n󰀈: "..inst.mindpower.."/"..inst.max_mindpower.."\n", 2, true)
			print("当前能量点:" .. inst.mindpower, "当前最大能量点:"..inst.max_mindpower)
		else 
			inst.components.talker:Say("\n󰀈: "..inst.mindpower.."/"..inst.max_mindpower.."\n", 2, true)
			print("当前能量点:" .. inst.mindpower, "当前最大能量点:"..inst.max_mindpower)
		end
	end
end

local smallScale = 1
local medScale = 2
local largeScale = 4
local function onkilled(inst, data)
	local target = data.victim
	local scale = (target:HasTag("smallcreature") and smallScale)
                       or (target:HasTag("largecreature") and largeScale)
                       or medScale
	if target and scale then				   
		if not ((target:HasTag("prey")or target:HasTag("bird")or target:HasTag("insect")) and not target:HasTag("hostile")) and inst.components.sanity:GetPercent() <= .8  then inst.components.sanity:DoDelta(scale) end
	end
end

local function Onattack(inst, data)	--Attack
if not inst.components.rider:IsRiding() then
	local target = data.target
	local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)	
	local tx, ty, tz = target.Transform:GetWorldPosition()
	
	if equip ~= nil and not equip:HasTag("projectile") and not equip:HasTag("rangedweapon") then 	

	--kenjutsulevel------------------------------------------------------------------------------------------------------------------------------------------
		if equip:HasTag("katanaskill") and not inst.components.timer:TimerExists("HitCD") and not inst.sg:HasStateTag("skilling")  then 	--GainKenExp		
			if inst.kenjutsulevel < 10 then inst.kenjutsuexp = inst.kenjutsuexp + (1 * TUNING.MANUTSAWEE.KEXPMTP) end
			inst.components.timer:StartTimer("HitCD",.5)
		end
		
	if inst.kenjutsuexp >= inst.kenjutsumaxexp then inst.kenjutsuexp = inst.kenjutsuexp - inst.kenjutsumaxexp kenjutsulevelup(inst) end --OnKenLevelUp
	--kenjutsulevelend------------------------------------------------------------------------------------------------------------------------------------------
	
	--critical rate
	if not ((target:HasTag("prey")or target:HasTag("bird")or target:HasTag("insect")or target:HasTag("wall"))and not target:HasTag("hostile")) then
	if math.random(1,100) <= criticalrate + inst.kenjutsulevel and not inst.components.timer:TimerExists("CriCD") and not inst.sg:HasStateTag("skilling") then inst.components.timer:StartTimer("CriCD",15 - (inst.kenjutsulevel/2))	--critical		
		 local hitfx = SpawnPrefab("slingshotammo_hitfx_rock")
			if hitfx then
				hitfx.Transform:SetScale(.8, .8, .8)
				hitfx.Transform:SetPosition(tx, ty, tz)
			end
		inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
		inst.components.combat.damagemultiplier = (MANUTSAWEE_DMG+MANUTSAWEE_CRIDMG)
		inst:DoTaskInTime(.1, function(inst) inst.components.combat.damagemultiplier = MANUTSAWEE_DMG end)		
	end	
	end
	--mind count

	if not ((target:HasTag("prey")or target:HasTag("bird")or target:HasTag("insect")or target:HasTag("wall"))and not target:HasTag("hostile")) then
		if not inst.components.timer:TimerExists("HeartCD") and not inst.sg:HasStateTag("skilling") and not inst.inspskill then inst.components.timer:StartTimer("HeartCD",.3)  --mind gain
			hitcount = hitcount + 1
	
			if hitcount >= TUNING.MANUTSAWEE.MINDREGENCOUNT and inst.kenjutsulevel >= 1 then
		
					if inst.mindpower < inst.max_mindpower then 
						mindregenfn(inst)
					else inst.components.sanity:DoDelta(1)
					end			
			hitcount = 0 end
		end	
	end

	end
end
end

local function ondeath(inst)	
	SkillRemove(inst)	
end

local function onload(inst, data)
	--if data ~= nil then
		if data.kenjutsulevel ~= nil then inst.kenjutsulevel = data.kenjutsulevel	end
		if data.kenjutsuexp  ~= nil then inst.kenjutsuexp = data.kenjutsuexp end
			
		-----------------------------------------
		if data.mindpower  ~= nil then inst.mindpower = data.mindpower end
		-----------------------------------------
		kenjutsuupgrades(inst)
		
		if inst.kenjutsulevel > 0 and data._mlouis_health ~= nil and data._mlouis_sanity ~= nil and data._mlouis_hunger ~= nil then
			inst.components.health:SetCurrentHealth(data._mlouis_health)
			inst.components.sanity.current = data._mlouis_sanity
			inst.components.hunger.current = data._mlouis_hunger
		end
	
		if data.hairlong ~= nil then inst.hairlong = data.hairlong end
		if data.hairtype ~= nil then inst.hairtype = data.hairtype end	
		OnChangehair(inst)
	--end
end

local function onsave(inst, data) 
		
	data.kenjutsulevel = inst.kenjutsulevel
	data.kenjutsuexp = inst.kenjutsuexp
		
	-----------------------------------------
	data.mindpower = inst.mindpower
	-----------------------------------------
	data._mlouis_health = inst.components.health.currenthealth
    data._mlouis_sanity = inst.components.sanity.current
    data._mlouis_hunger = inst.components.hunger.current
	
	data.hairlong = inst.hairlong
	data.hairtype = inst.hairtype
	
end

local nskill1 = 1
local nskill2 = 3
local nskill3 = 4
local nskill4 = 6
local nskill5 = 5
local nskill6 = 7
local nskill7 = 8
local ncountskill = 2

local function CanUseSkill(inst, weapon)
inst.canuseskill = false
if inst.mafterskillndm ~= nil then inst.mafterskillndm:Cancel() inst.mafterskillndm = nil end

if inst.components.health ~= nil and inst.components.health:IsDead() and (inst.sg:HasStateTag("dead") or inst:HasTag("playerghost")) 
or (inst.components.sleeper and inst.components.sleeper:IsAsleep()) 
or (inst.components.freezable and inst.components.freezable:IsFrozen()) then return end
if (inst.components.rider:IsRiding() or inst.components.inventory:IsHeavyLifting()) then return end
if weapon ~= nil then
	if ( weapon:HasTag("projectile") or weapon:HasTag("whip") or weapon:HasTag("rangedweapon") 
		or not (weapon:HasTag("tool") or  weapon:HasTag("sharp") or  weapon:HasTag("weapon") or  weapon:HasTag("katanaskill")) ) then return end
else return
end
inst.canuseskill = true
end 

local function cooldownskillfx(inst, fxnum)
			local fxlist = {"ghostlyelixir_retaliation_dripfx","ghostlyelixir_shield_dripfx","ghostlyelixir_speed_dripfx","battlesong_instant_panic_fx","monkey_deform_pre_fx","fx_book_birds"}
			local fx = SpawnPrefab(fxlist[fxnum])	
			fx.Transform:SetScale(.9, .9, .9)			
			fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)					
end

local function OnTimerDone(inst, data)
	if data.name then local name = data.name local fxnum
		if name == "skill1cd" then fxnum = 1 cooldownskillfx(inst,fxnum) return end
		if name == "skill2cd" then fxnum = 2 cooldownskillfx(inst,fxnum) return end
		if name == "skill3cd" then fxnum = 3 cooldownskillfx(inst,fxnum) return end	
		if name == "skillcountercd" then fxnum = 4 cooldownskillfx(inst,fxnum) return end	
		if name == "skillT2cd" then fxnum = 5 cooldownskillfx(inst,fxnum) return end	
		if name == "skillT3cd" then fxnum = 6 cooldownskillfx(inst,fxnum) return end		
	end
end

local function Skill1Fn(inst) ----------  R
if inst.components.timer:TimerExists("sskill1cd") then return end 

local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
CanUseSkill(inst, equip)
if not inst.canuseskill then return end 
if inst.kenjutsulevel < nskill1 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill1, 1, true) return end 
	
	inst.components.timer:StartTimer("sskill1cd",1)
	
	if inst.mindpower >= 3 then		
			if inst:HasTag("michimonji") or inst:HasTag("misshin") or inst:HasTag("ryusen")  then	SkillRemove(inst) inst.components.talker:Say("Later...", 1, true) return 
			elseif inst:HasTag("mflipskill") and equip and equip:HasTag("katanaskill") then 
				if inst.kenjutsulevel < nskill4 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill4, 1, true) 	SkillRemove(inst)
				elseif inst.mindpower >= 7 then	if inst.components.timer:TimerExists("skillT2cd") then inst.components.talker:Say("Tier2: Cooldown", 1, true) SkillRemove(inst) return end
						SkillRemove(inst) inst:AddTag("misshin") inst.components.combat:SetRange(3) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL4START..inst.mindpower.."/7\n ", 1, true)
					return
					else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/7\n ", 1, true) SkillRemove(inst) return
					end	
			elseif not inst:HasTag("michimonji") then if inst.components.timer:TimerExists("skill1cd") then inst.components.talker:Say("Cooldown", 1, true) SkillRemove(inst) return end
				SkillRemove(inst) inst:AddTag("michimonji") inst.components.combat:SetRange(3.5) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL1START..inst.mindpower.."/3\n ", 1, true) 
			end		
	else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/3\n ", 1, true) SkillRemove(inst) end
end
 
local function Skill2Fn(inst) ----------  C
if inst.components.timer:TimerExists("sskill2cd") then return end 

local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
CanUseSkill(inst, equip)
if not inst.canuseskill then return end 
if inst.kenjutsulevel < nskill2 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill2, 1, true) return end --5	
	
	inst.components.timer:StartTimer("sskill2cd",1)
	
	if inst.mindpower >= 4 then		
			if inst:HasTag("mflipskill") or inst:HasTag("ryusen") or inst:HasTag("susanoo")  then	SkillRemove(inst) inst.components.talker:Say("Later...", 1, true) return 
			elseif inst:HasTag("michimonji") and equip and equip:HasTag("katanaskill") then 
				if inst.kenjutsulevel < nskill6 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill6, 1, true) 	SkillRemove(inst)
				elseif inst.mindpower >= 8 then	if inst.components.timer:TimerExists("skillT3cd") then inst.components.talker:Say("Tier3: Cooldown", 1, true) SkillRemove(inst) return end	
						SkillRemove(inst) inst:AddTag("ryusen") inst.components.combat:SetRange(10) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL6START..inst.mindpower.."/8\n ", 1, true) 
					return
					else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/8\n ", 1, true) SkillRemove(inst) return
					end	
			elseif inst:HasTag("mthrustskill") and equip and equip:HasTag("katanaskill") then 
				if inst.kenjutsulevel < nskill7 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill7, 1, true) 	SkillRemove(inst)
				elseif inst.mindpower >= 10 then if inst.components.timer:TimerExists("skillT3cd") then inst.components.talker:Say("Tier3: Cooldown", 1, true) SkillRemove(inst) return end	
						SkillRemove(inst) inst:AddTag("susanoo") inst.components.combat:SetRange(3) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL7START..inst.mindpower.."/10\n ", 1, true) 
					return 
					else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/10\n ", 1, true) SkillRemove(inst) return
					end	
			elseif not inst:HasTag("mflipskill") then if inst.components.timer:TimerExists("skill2cd") then inst.components.talker:Say("Cooldown", 1, true) SkillRemove(inst) return end
				SkillRemove(inst) inst:AddTag("mflipskill") inst.components.combat:SetRange(3.5) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL2START..inst.mindpower.."/4\n ", 1, true) 
			end		
	else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/4\n ", 1, true) SkillRemove(inst) end
end
 
local function Skill3Fn(inst) ----------  T
if inst.components.timer:TimerExists("sskill3cd") then return end 

local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)	
CanUseSkill(inst, equip)
if not inst.canuseskill then return end 
if inst.kenjutsulevel < nskill3 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill3, 1, true) return end 
	
	inst.components.timer:StartTimer("sskill3cd",1)	
	if inst.mindpower >= 4 then		
			if inst:HasTag("heavenlystrike") or inst:HasTag("mthrustskill") or inst:HasTag("susanoo")  then	
				SkillRemove(inst) 
					inst.components.talker:Say("Later...", 1, true) 
				return 
			elseif inst:HasTag("mflipskill") and equip and equip:HasTag("katanaskill") then 
				if inst.kenjutsulevel < nskill5 then inst.components.talker:Say("[UNLOCK] 󰀍: "..nskill5, 1, true) 	SkillRemove(inst)
				elseif inst.mindpower >= 5 then	if inst.components.timer:TimerExists("skillT2cd") then inst.components.talker:Say("Tier2: Cooldown", 1, true) SkillRemove(inst) return end
						SkillRemove(inst) inst:AddTag("heavenlystrike") inst.components.combat:SetRange(3) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL5START..inst.mindpower.."/5\n ", 1, true)
					return
					else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/5\n ", 1, true) SkillRemove(inst) return
					end	
			elseif not inst:HasTag("mthrustskill") then if inst.components.timer:TimerExists("skill3cd") then inst.components.talker:Say("Cooldown", 1, true) SkillRemove(inst) return end
				SkillRemove(inst) inst:AddTag("mthrustskill") inst.components.combat:SetRange(3) inst.components.talker:Say(TUNING.MANUTSAWEESKILLSPEECH.SKILL3START..inst.mindpower.."/4\n ", 1, true) 
			end		
	else inst.components.talker:Say("Not now!\n󰀈: "..inst.mindpower.."/4\n ", 1, true) SkillRemove(inst) end
end
 
local function SkillCounterAttackFn(inst) ---------- counter Z
if inst.components.timer:TimerExists("skillcountercd") then inst.components.talker:Say("Cooldown", 1, true) SkillRemove(inst) return end
local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
CanUseSkill(inst, equip)
if not inst.canuseskill then return end
if inst.kenjutsulevel < ncountskill then inst.components.talker:Say("[UNLOCK] 󰀍: "..ncountskill, 1, true) return end --1
	if not inst.components.timer:TimerExists("counterCD") then	
		inst.components.timer:StartTimer("counterCD",.63)
		SkillRemove(inst)
		inst.sg:GoToState("counterstart")		
	end
end

local function SkillCancelFn(inst)
if inst.components.timer:TimerExists("cancelskillcd") then return end
	local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
CanUseSkill(inst, equip)
if not inst.canuseskill then return end

inst.components.timer:StartTimer("cancelskillcd",1)
SkillRemove(inst)
inst.components.talker:Say("Maybe next time.", 1, true)
end

local function QuickSheathFn(inst)
if inst.kenjutsulevel < ncountskill then inst.components.talker:Say("[UNLOCK] 󰀍: "..ncountskill, 1, true) return end 
if inst.components.timer:TimerExists("mQSCd") then return end
local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) 
CanUseSkill(inst, equip)
if not inst.canuseskill then return end
	if equip and equip.wpstatus ~= nil and equip:HasTag("katanaskill") then		
		inst.components.timer:StartTimer("mQSCd",.4)
		inst.sg:GoToState("mquicksheath")
	end
end

local function GlassesFn(inst, skinname) -------- put glasses
if inst.components.health ~= nil and inst.components.health:IsDead() and inst.sg:HasStateTag("dead") or inst:HasTag("playerghost") then return end
	if not (inst.sg:HasStateTag("doing") or inst.components.inventory:IsHeavyLifting()) then
		if (inst.sg == nil or inst.sg:HasStateTag("idle") or inst:HasTag("idle"))and not(inst.sg:HasStateTag("moving") or inst:HasTag("moving")) and not inst.components.timer:TimerExists("GlassesCD") then			
					
			inst.components.timer:StartTimer("GlassesCD",1)
			inst:DoTaskInTime(.1, function() inst:PushEvent("putglasses") end)			
			inst:DoTaskInTime(.6, function()			
			
			if inst.glassesstatus == 0 then inst.glassesstatus = 1 PutGlasses(inst, skinname)
			else inst.AnimState:ClearOverrideSymbol("face") inst.glassesstatus = 0
			end	
			end)
		end
	end
end

local function HairsFn(inst, skinname)	--------- change hair style
if inst.components.health ~= nil and inst.components.health:IsDead() and inst.sg:HasStateTag("dead") or inst:HasTag("playerghost") then return end
	if not (inst.sg:HasStateTag("doing") or inst.components.inventory:IsHeavyLifting()) then
		if inst.hairlong == 1 then	inst.components.talker:Say("My hair isn't long enough for this.") return end
		if (inst.sg == nil or inst.sg:HasStateTag("idle") or inst:HasTag("idle"))and not(inst.sg:HasStateTag("moving") or inst:HasTag("moving")) and not inst.components.timer:TimerExists("HairCD") then		
			
			inst.components.timer:StartTimer("HairCD",1.4)
			inst:DoTaskInTime(.1, function() inst:PushEvent("changehair") end)			
			inst:DoTaskInTime(1, function()	
			
			if inst.hairtype < #HAIR_TYPES then inst.hairtype = inst.hairtype + 1
			OnChangehair(inst, skinname)			
			else inst.hairtype = 1 
			OnChangehair(inst, skinname)			
			end			
			end)
		end
	end
end

local function OnChangeChar(inst)
	SkillRemove(inst)
    if inst.kenjutsulevel > 0 then        
        local x, y, z = inst.Transform:GetWorldPosition()
        for i = 1, inst.kenjutsulevel do
            local fruit = SpawnPrefab("mfruit")
            if fruit ~= nil then
                if fruit.Physics ~= nil then
                    local speed = 2 + math.random()
                    local angle = math.random() * 2 * PI
                    fruit.Physics:Teleport(x, y + 1, z)
                    fruit.Physics:SetVel(speed * math.cos(angle), speed * 3, speed * math.sin(angle))
                else
                    fruit.Transform:SetPosition(x, y, z)
                end

                if fruit.components.propagator ~= nil then
                    fruit.components.propagator:Delay(5)
                end
            end
        end
        inst.kenjutsulevel = 0
    end
end
 
local function OnEat(inst, food)
    if food ~= nil and food.components.edible ~= nil then
        if food.prefab == "mfruit" and inst.kenjutsulevel < 10 then
            kenjutsulevelup(inst)
        end
    end   
end

AddModRPCHandler("manutsawee", "levelcheck", LevelCheckFn)	
AddModRPCHandler("manutsawee", "skill1", Skill1Fn)	
AddModRPCHandler("manutsawee", "skill2", Skill2Fn)	
AddModRPCHandler("manutsawee", "skill3", Skill3Fn)	
AddModRPCHandler("manutsawee", "skillcounterattack", SkillCounterAttackFn)	
AddModRPCHandler("manutsawee", "quicksheath", QuickSheathFn)	
AddModRPCHandler("manutsawee", "skillcancel", SkillCancelFn)	
AddModRPCHandler("manutsawee", "glasses", GlassesFn)
AddModRPCHandler("manutsawee", "Hairs", HairsFn)

local function OnMounted(inst)
  SkillRemove(inst)
end

local common_postinit = function(inst) 
	-- Minimap icon	
	inst.MiniMapEntity:SetIcon( "manutsawee.tex" )
		
	inst:AddTag("bearded")		 
	inst:AddTag("manutsaweecraft")	
	inst:AddTag("stronggrip")
	 
	if TUNING.MANUTSAWEE.PTENT then	inst:AddTag("pinetreepioneer")	end
	if TUNING.MANUTSAWEE.NSTICK then	inst:AddTag("slingshot_sharpshooter") inst:AddTag("pebblemaker")end

	------------------------------------------------------------------------------------
	
	inst:AddComponent("keyhandler") 
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYLEVELCHECK, "levelcheck")	
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYGLASSES, "glasses")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYHAIRS, "Hairs")
	
	if TUNING.MANUTSAWEE.SKILL then	
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSKILL1, "skill1")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSKILL2, "skill2")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSKILL3, "skill3")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSKILLCOUNTERATK, "skillcounterattack")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSQUICKSHEATH, "quicksheath")
	inst.components.keyhandler:AddActionListener("manutsawee", TUNING.MANUTSAWEE.KEYSKILLCANCEL, "skillcancel")
	end
	
end

local BEARD_DAYS = { 3, 7, 16 }
local BEARD_BITS = { 2, 3,  3 }

local function OnGrowShortHair(inst, skinname)
	inst.hairlong = 2
	inst.components.beard.bits = BEARD_BITS[1]	
    OnChangehair(inst, skinname)
end

local function OnGrowMediumHair(inst, skinname)
	inst.hairlong = 3
	inst.components.beard.bits = BEARD_BITS[2]	
	OnChangehair(inst, skinname)
end

local function OnGrowLongHair(inst, skinname)
	inst.hairlong = 4
	inst.components.beard.bits = BEARD_BITS[3]	
	OnChangehair(inst, skinname)
end

local function OnResetHair(inst, skinname)
	if inst.hairlong == 4 then
		inst.components.beard.daysgrowth = BEARD_DAYS[2]
		OnGrowMediumHair(inst, skinname)
	elseif inst.hairlong == 3 then
		inst.components.beard.daysgrowth = BEARD_DAYS[1]
		OnGrowShortHair(inst, skinname)
	else
	inst.hairlong = 1
	inst.hairtype = 1
    inst.AnimState:ClearOverrideSymbol("hairpigtails")
    inst.AnimState:ClearOverrideSymbol("hair")
    inst.AnimState:ClearOverrideSymbol("hair_hat")
    inst.AnimState:ClearOverrideSymbol("headbase")
    inst.AnimState:ClearOverrideSymbol("headbase_hat")   
	end	
end

local master_postinit = function(inst)	
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	--------------------------------LevelKenjutsu
	inst.kenjutsulevel = 0
	inst.kenjutsuexp = 0
	inst.kenjutsumaxexp = 250
	
	inst.mindpower = 0
	inst.max_mindpower = TUNING.MANUTSAWEE.MINDMAX
	
	--custom start level	
	if TUNING.MANUTSAWEE.MASTER then inst:DoTaskInTime(2, function() if inst.kenjutsulevel < TUNING.MANUTSAWEE.MASTERVALUE then  inst.kenjutsulevel = TUNING.MANUTSAWEE.MASTERVALUE kenjutsuupgrades(inst)end end)  end
	
	-------------------------------------------- 
	inst.glassesstatus = 0		 
	inst.hairlong = 1
	inst.hairtype = 1	
	
	inst.oldrange = inst.components.combat.hitrange
		
	--small character inst.AnimState:SetScale(0.94, 0.96, 1) 	

	--------------------HoundTarget
	if inst.components.houndedtarget == nil then
		inst:AddComponent("houndedtarget")
	end
	inst.components.houndedtarget.target_weight_mult:SetModifier(inst, TUNING.WES_HOUND_TARGET_MULT, "misfortune")
	inst.components.houndedtarget.hound_thief = true
	--------------------
	if inst.components.timer == nil then
		inst:AddComponent("timer")
	end
		
	-- choose which sounds this character will play	
	inst.soundsname = "wortox"
	
	inst.components.foodaffinity:AddPrefabAffinity("baconeggs", TUNING.AFFINITY_15_CALORIES_HUGE)
	inst.components.foodaffinity:AddPrefabAffinity("unagi", TUNING.AFFINITY_15_CALORIES_HUGE)
	inst.components.foodaffinity:AddPrefabAffinity("kelp_cooked",   1) 
    inst.components.foodaffinity:AddPrefabAffinity("durian",        1)
    inst.components.foodaffinity:AddPrefabAffinity("durian_cooked", 1)    
	
	if inst.components.beard == nil then
		inst:AddComponent("beard")
	end
	inst.components.beard.insulation_factor = 1
    inst.components.beard.onreset = OnResetHair
    inst.components.beard.prize = "beardhair"
    inst.components.beard.is_skinnable = false
    inst.components.beard:AddCallback(BEARD_DAYS[1], OnGrowShortHair)
    inst.components.beard:AddCallback(BEARD_DAYS[2], OnGrowMediumHair)
    inst.components.beard:AddCallback(BEARD_DAYS[3], OnGrowLongHair)
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.MANUTSAWEE_HEALTH)
    inst.components.hunger:SetMax(TUNING.MANUTSAWEE_HUNGER)	
    inst.components.sanity:SetMax(TUNING.MANUTSAWEE_SANITY)
	
	if inst.components.eater ~= nil then
		local eater = inst.components.eater
		table.insert(eater.preferseating, FOODTYPE.MFRUIT)
		table.insert(eater.caneat, FOODTYPE.MFRUIT)
		eater.inst:AddTag(FOODTYPE.MFRUIT.."_eater")
		
		local _TestFood = eater.TestFood
		eater.TestFood = function(self, food, testvalues)			
			if food and food.components.edible and food.components.edible.foodtype == FOODTYPE.MFRUIT then
				return food.prefab == "mfruit"
			end
			return _TestFood(self, food, testvalues)
		end		
		eater:SetOnEatFn(OnEat)		
	end

	-- Damage multiplier (optional)	
    inst.components.combat.damagemultiplier = MANUTSAWEE_DMG
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
	
	inst.components.grogginess.decayrate = TUNING.WES_GROGGINESS_DECAY_RATE
	
	-- clothing is less effective
	inst.components.temperature.inherentinsulation = -TUNING.INSULATION_TINY
	inst.components.temperature.inherentsummerinsulation = -TUNING.INSULATION_TINY
	
	-- Slow Worker
	inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)

	if inst.components.efficientuser == nil then inst:AddComponent("efficientuser")	end
	inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	
	----------------------------------------------------------------------------------------------------------------	
	inst.OnLoad = onload
	inst.OnSave = onsave	
		
	inst:ListenForEvent("death", ondeath)	
	inst:ListenForEvent("ms_playerreroll", OnChangeChar)
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("onattackother", Onattack)
	inst:ListenForEvent("killed", onkilled)

	inst:ListenForEvent("mounted", OnMounted)
	inst:ListenForEvent("unequip", function(inst, data)	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then  SkillRemove(inst) end end)
	inst:ListenForEvent("equip", function(inst, data)	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil then  OnChangehair(inst) end end)
end
return MakePlayerCharacter("manutsawee", prefabs, assets, common_postinit, master_postinit, start_inv)