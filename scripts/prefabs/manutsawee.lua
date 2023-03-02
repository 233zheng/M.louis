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

    -- I very like this idle :D
    Asset("ANIM", "anim/player_idles_wanda.zip"),
}

local MANUTSAWEE_DMG = 1
local MANUTSAWEE_CRIDMG = 0.1
local hitcount = 0 --attackcount regen mind
local criticalrate = 5 --critical hit rate

local mstartitem = {"shinai","raikiri","shirasaya","koshirae","hitokiri","katanablade"}

local start_inv = {}
if MCONFIG.MSTARTITEM > 0 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MANUTSAWEE = {mstartitem[MCONFIG.MSTARTITEM]}
    else
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MANUTSAWEE = {}
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
	inst.mindpower = inst.mindpower + 1
	local mindregenfx = SpawnPrefab("battlesong_instant_electric_fx")
		mindregenfx.Transform:SetScale(.7, .7, .7)
		mindregenfx.Transform:SetPosition(inst:GetPosition():Get())
		mindregenfx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
	if inst.mindpower >= 3 then
        inst.components.talker:Say("󰀈: "..inst.mindpower.."\n", 2, true)
    end
end

local function mindregen(inst)
	if inst.mindpower < inst.max_mindpower/2 then
		 mindregenfn(inst)
	end
	inst:DoTaskInTime(MCONFIG.MINDREGENRATE, mindregen)
end

local HAIR_BITS = { "_cut", "_short", "_medium",  "_long" }
local HAIR_TYPES = { "", "_yoto", "_ronin", "_pony", "_twin", "_htwin","_ball"}
local function OnChangehair(inst, skinname)
    if inst.hairlong == 1 and inst.hairtype > 1 then
        inst.hairtype = 1
    end

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

    if inst.hairtype <= 2 then
        inst.components.beard.insulation_factor = 1
    else
        inst.components.beard.insulation_factor = .1
    end
end

local function PutGlasses(inst, skinname)
    if skinname == nil then
        inst.AnimState:OverrideSymbol("face", "eyeglasses", "face")
    else
        inst.AnimState:OverrideSkinSymbol("face", skinname, "face" )
    end
end

local function kenjutsuupgrades(inst)
	if inst.kenjutsulevel >= 2 and not inst:HasTag("kenjutsu") then
        inst:AddTag("kenjutsu")
    end

    if inst.kenjutsulevel >= 4 and inst.startregen == nil then
        inst.startregen = inst:DoTaskInTime(MCONFIG.MINDREGENRATE, mindregen)
    end

    if inst.kenjutsulevel >= 5 and not inst:HasTag("manutsaweecraft2") then
        inst:AddTag("manutsaweecraft2")
    end

	if inst.kenjutsulevel >= 1 then
		inst.components.sanity.neg_aura_mult = 1 - ((inst.kenjutsulevel / 2) / 10)
		inst.kenjutsumaxexp = 500 * inst.kenjutsulevel

		local hunger_percent = inst.components.hunger:GetPercent()
		local health_percent = inst.components.health:GetPercent()
		local sanity_percent = inst.components.sanity:GetPercent()

		if MCONFIG.HEALTHMAX > 0 then
            inst.components.health.maxhealth = math.ceil(TUNING.MANUTSAWEE_HEALTH + inst.kenjutsulevel * MCONFIG.HEALTHMAX)
            inst.components.health:SetPercent(health_percent)
		end
		if MCONFIG.HUNGERMAX > 0 then
            inst.components.hunger.max = math.ceil(TUNING.MANUTSAWEE_HUNGER + inst.kenjutsulevel * MCONFIG.HUNGERMAX)
            inst.components.hunger:SetPercent(hunger_percent)
		end
		if MCONFIG.SANITYMAX > 0 then
            inst.components.sanity.max = math.ceil(TUNING.MANUTSAWEE_SANITY + inst.kenjutsulevel * MCONFIG.SANITYMAX)
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

    if inst.kenjutsulevel >= 10 then
        inst.kenjutsuexp = 0
    end

	MANUTSAWEE_CRIDMG = 0.1 + ((inst.kenjutsulevel / 2) / 10)

	inst.max_mindpower = MCONFIG.MINDMAX + inst.kenjutsulevel

	local fx = SpawnPrefab("fx_book_light_upgraded")
    fx.Transform:SetScale(.9, 2.5, 1)
    fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
end

local function kenjutsulevelup(inst)
	inst.kenjutsulevel = inst.kenjutsulevel + 1
	kenjutsuupgrades(inst)
end

local smallScale = 1
local medScale = 2
local largeScale = 4
local function onkilled(inst, data)
	local target = data.victim
	local scale = (target:HasTag("smallcreature") and smallScale) or (target:HasTag("largecreature") and largeScale) or medScale

    if target and scale then
		if not ((target:HasTag("prey")or target:HasTag("bird")or target:HasTag("insect")) and not target:HasTag("hostile")) and inst.components.sanity:GetPercent() <= .8  then
            inst.components.sanity:DoDelta(scale)
        end
	end
end

local function Onattack(inst, data)
if not inst.components.rider:IsRiding() then
	local target = data.target
	local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local tx, ty, tz = target.Transform:GetWorldPosition()

	if equip ~= nil and not equip:HasTag("projectile") and not equip:HasTag("rangedweapon") then
		if equip:HasTag("katanaskill") and not inst.components.timer:TimerExists("HitCD") and not inst.sg:HasStateTag("skilling") then 	--GainKenExp
			if inst.kenjutsulevel < 10 then
                inst.kenjutsuexp = inst.kenjutsuexp + (1 * MCONFIG.KEXPMTP)
            end
			inst.components.timer:StartTimer("HitCD",.5)
		end

	if inst.kenjutsuexp >= inst.kenjutsumaxexp then
        inst.kenjutsuexp = inst.kenjutsuexp - inst.kenjutsumaxexp kenjutsulevelup(inst)
    end

	if not ((target:HasTag("prey") or target:HasTag("bird") or target:HasTag("insect") or target:HasTag("wall")) and not target:HasTag("hostile")) then
        if math.random(1,100) <= criticalrate + inst.kenjutsulevel and not inst.components.timer:TimerExists("CriCD") and not inst.sg:HasStateTag("skilling") then
            inst.components.timer:StartTimer("CriCD",15 - (inst.kenjutsulevel/2))	--critical
            local hitfx = SpawnPrefab("slingshotammo_hitfx_rock")
            if hitfx then
                hitfx.Transform:SetScale(.8, .8, .8)
                hitfx.Transform:SetPosition(tx, ty, tz)
            end
            inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
            inst.components.combat.damagemultiplier = (MANUTSAWEE_DMG+MANUTSAWEE_CRIDMG)
            inst:DoTaskInTime(.1, function(inst)
                inst.components.combat.damagemultiplier = MANUTSAWEE_DMG
            end)
        end
	end

	if not ((target:HasTag("prey") or target:HasTag("bird") or target:HasTag("insect") or target:HasTag("wall")) and not target:HasTag("hostile")) then
		if not inst.components.timer:TimerExists("HeartCD") and not inst.sg:HasStateTag("skilling") and not inst.inspskill then
            inst.components.timer:StartTimer("HeartCD",.3)  --mind gain
                hitcount = hitcount + 1
                    if hitcount >= MCONFIG.MINDREGENCOUNT and inst.kenjutsulevel >= 1 then
                        if inst.mindpower < inst.max_mindpower then
                            mindregenfn(inst)
                        else
                            inst.components.sanity:DoDelta(1)
                        end
                        hitcount = 0
                    end
                end
            end
        end
    end
end

local function OnDeath(inst)
	SkillRemove(inst)
end

local function OnSave(inst, data)

	data.kenjutsulevel = inst.kenjutsulevel
	data.kenjutsuexp = inst.kenjutsuexp

	data.mindpower = inst.mindpower

	data._mlouis_health = inst.components.health.currenthealth
    data._mlouis_sanity = inst.components.sanity.current
    data._mlouis_hunger = inst.components.hunger.current

	data.hairlong = inst.hairlong
	data.hairtype = inst.hairtype

    data.glassesstatus = inst.glassesstatus
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.kenjutsulevel ~= nil then
            inst.kenjutsulevel = data.kenjutsulevel
        end

        if data.kenjutsuexp  ~= nil then
            inst.kenjutsuexp = data.kenjutsuexp
        end

		if data.mindpower  ~= nil then
            inst.mindpower = data.mindpower
        end

		kenjutsuupgrades(inst)

		if inst.kenjutsulevel > 0 and data._mlouis_health ~= nil and data._mlouis_sanity ~= nil and data._mlouis_hunger ~= nil then
			inst.components.health:SetCurrentHealth(data._mlouis_health)
			inst.components.sanity.current = data._mlouis_sanity
			inst.components.hunger.current = data._mlouis_hunger
		end

		if data.hairlong ~= nil then
            inst.hairlong = data.hairlong
        end

        if data.hairtype ~= nil then
            inst.hairtype = data.hairtype
        end

        if data.glassesstatus ~= nil then
            inst.glassesstatus = data.glassesstatus
            if inst.glassesstatus == 0 then
                inst.glassesstatus = 1
                PutGlasses(inst)
            else
                inst.AnimState:ClearOverrideSymbol("face")
                inst.glassesstatus = 0
            end
        end

        OnChangehair(inst)
	end
end

local function CooldownSkillFx(inst, fxnum)
    local fxlist = {
        "ghostlyelixir_retaliation_dripfx",
        "ghostlyelixir_shield_dripfx",
        "ghostlyelixir_speed_dripfx",
        "battlesong_instant_panic_fx",
        "monkey_deform_pre_fx","fx_book_birds"
    }
    local fx = SpawnPrefab(fxlist[fxnum])
    fx.Transform:SetScale(.9, .9, .9)
    fx.entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
end

local function OnTimerDone(inst, data)
	if data.name then
        local name = data.name
        local fxnum

        if name == "skill1cd" then
            fxnum = 1
            CooldownSkillFx(inst,fxnum)
            return
        end

        if name == "skill2cd" then
            fxnum = 2
            CooldownSkillFx(inst,fxnum)
            return
        end

        if name == "skill3cd" then
            fxnum = 3
            CooldownSkillFx(inst,fxnum)
            return
        end

        if name == "skillcountercd" then
            fxnum = 4
            CooldownSkillFx(inst,fxnum)
            return
        end

        if name == "skillT2cd" then
            fxnum = 5
            CooldownSkillFx(inst,fxnum)
            return
        end

        if name == "skillT3cd" then
            fxnum = 6
            CooldownSkillFx(inst,fxnum)
            return
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

local function OnMounted(inst)
    SkillRemove(inst)
end

local common_postinit = function(inst)
	-- Minimap icon
	inst.MiniMapEntity:SetIcon("manutsawee.tex")

    if MCONFIG.IDLEANIM then
        inst.AnimState:AddOverrideBuild("player_idles_wanda")
    end

	inst:AddTag("bearded")
	inst:AddTag("manutsaweecraft")
	inst:AddTag("stronggrip")

	if MCONFIG.PTENT then
        inst:AddTag("pinetreepioneer")
    end

    if MCONFIG.NSTICK then
        inst:AddTag("slingshot_sharpshooter")
        inst:AddTag("pebblemaker")
    end

	inst:AddComponent("keyhandler")
	inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYLEVELCHECK, "levelcheck")
	inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYGLASSES, "glasses")
	inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYHAIRS, "Hairs")

	if MCONFIG.SKILL then
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSKILL1, "skill1")
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSKILL2, "skill2")
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSKILL3, "skill3")
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSKILLCOUNTERATK, "skillcounterattack")
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSQUICKSHEATH, "quicksheath")
        inst.components.keyhandler:AddActionListener("manutsawee", MCONFIG.KEYSKILLCANCEL, "skillcancel")
	end

end

local BEARD_DAYS = {3, 7, 16}
local BEARD_BITS = {2, 3, 3}

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

local function OnUnEquip(inst)
    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then
        SkillRemove(inst)
    end
end

local function OnEquip(inst)
    if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ~= nil then
        OnChangehair(inst)
    end
end

local master_postinit = function(inst)
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    if MCONFIG.IDLEANIM then
        inst.customidleanim = "idle_wanda"
    end

	--custom start level
	if MCONFIG.MASTER then
        inst:DoTaskInTime(2, function()
            if inst.kenjutsulevel < MCONFIG.MASTERVALUE then
                inst.kenjutsulevel = MCONFIG.MASTERVALUE
                kenjutsuupgrades(inst)
            end
        end)
    end

	--small character
    inst.AnimState:SetScale(0.88, 0.90, 1)

	--------------------HoundTarget
	if inst.components.houndedtarget == nil then
		inst:AddComponent("houndedtarget")
	end

    inst.components.houndedtarget.target_weight_mult:SetModifier(inst, TUNING.WES_HOUND_TARGET_MULT, "misfortune")
	inst.components.houndedtarget.hound_thief = true

    if inst.components.timer == nil then
		inst:AddComponent("timer")
	end

	-- choose which sounds this character will play
	-- inst.soundsname = "wortox"
	inst.soundsname = "louis"

	inst.components.foodaffinity:AddPrefabAffinity("baconeggs", TUNING.AFFINITY_15_CALORIES_HUGE)
	inst.components.foodaffinity:AddPrefabAffinity("unagi", TUNING.AFFINITY_15_CALORIES_TINY)
	inst.components.foodaffinity:AddPrefabAffinity("kelp_cooked", 1)
    inst.components.foodaffinity:AddPrefabAffinity("durian", 1)
    inst.components.foodaffinity:AddPrefabAffinity("durian_cooked", 1)

    -- Sushi
    if MCONFIG.COMPATIBLE then
        inst.components.foodaffinity:AddPrefabAffinity("californiaroll", TUNING.AFFINITY_15_CALORIES_TINY)
        inst.components.foodaffinity:AddPrefabAffinity("caviar", TUNING.AFFINITY_15_CALORIES_TINY)
    end

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

        local function TestFood(self, food, testvalues)
			if food and food.components.edible and food.components.edible.foodtype == FOODTYPE.MFRUIT then
				return food.prefab == "mfruit"
			end
			return _TestFood(self, food, testvalues)
        end

		eater.TestFood = TestFood
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

	if inst.components.efficientuser == nil then
        inst:AddComponent("efficientuser")
    end

    inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)
	inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, TUNING.WES_WORKEFFECTIVENESS_MODIFIER, inst)

	inst.kenjutsulevel = 0
	inst.kenjutsuexp = 0
	inst.kenjutsumaxexp = 250

	inst.mindpower = 0
	inst.max_mindpower = MCONFIG.MINDMAX

	inst.glassesstatus = 0
	inst.hairlong = 1
	inst.hairtype = 1
	inst.oldrange = inst.components.combat.hitrange

    inst.PutGlasses = PutGlasses
    inst.OnChangehair = OnChangehair
	inst.OnLoad = OnLoad
	inst.OnSave = OnSave

	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("ms_playerreroll", OnChangeChar)
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("onattackother", Onattack)
	inst:ListenForEvent("killed", onkilled)
	inst:ListenForEvent("mounted", OnMounted)
	inst:ListenForEvent("unequip", OnUnEquip)
    inst:ListenForEvent("equip", OnEquip)

end

return MakePlayerCharacter("manutsawee", prefabs, assets, common_postinit, master_postinit, start_inv)
