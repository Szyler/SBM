local mod	= DBM:NewMod("Ysondre", "DBM-WorldBosses")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))
mod:SetCreatureID(14887)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"PLAYER_ALIVE"
)

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

local ysondreHealth = 100

local prewarnDruids				= mod:NewAnnounce("Demented Druid Spirits Soon", 3)
local warnDruids				= mod:NewSpellAnnounce(24795, 2)

local predruidCount
local druidCount

local soundDruid		= mod:NewSound2(24795)

function mod:preDruid()
	prewarnDruids:Show()
end

function mod:alertDruid()
	warnDruids:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:alarmSound()
	soundDruid:Play()
end

function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if UnitName("player") == "Sky" then
		print(recapID)
	end
end

function mod:OnCombatStart()
	predruidCount = 0
	druidCount = 0
	self:ScheduleMethod(0, "getBestKill")
	aspamOne = 1
	self:ScheduleMethod(1, "antiSpamone")
	DBM:AddMsg("This boss is not completed in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

---------- NIGHTMARE DRAKES SHARED ----------
local warnBreath				= mod:NewSpellAnnounce(24818, 3)
local aspamOne
function mod:antiSpamone()
	if aspamOne == 2 then
		warnBreath:Show()
		aspamOne = 1
	end
	self:ScheduleMethod(1, "antiSpamone")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24818) then
		aspamOne = 2
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 14887 then
		ysondreHealth = UnitHealth(uId) / UnitHealthMax(uId) * 100
	end
	self:ScheduleMethod(0, "checkDruid")
end

function mod:checkDruid()
	if ysondreHealth <= 80 and predruidCount == 0 then
		predruidCount = 1
		self:ScheduleMethod(0, "preDruid")
	elseif ysondreHealth <= 75 and druidCount == 0 then
		druidCount = 1
		self:ScheduleMethod(0, "alertDruid")
	elseif ysondreHealth <= 55 and predruidCount == 1 then
		predruidCount = 2
		self:ScheduleMethod(0, "preDruid")	
	elseif ysondreHealth <= 50 and druidCount == 1 then
		druidCount = 2 
		self:ScheduleMethod(0, "alertDruid")
	elseif ysondreHealth <= 30 and predruidCount == 2 then
		predruidCount = 3 
		self:ScheduleMethod(0, "preDruid")
	elseif ysondreHealth <= 25 and druidCount == 2 then 
		druidCount = 3
		self:ScheduleMethod(0, "alertDruid")
	end
end
---------- NIGHTMARE DRAKES SHARED ----------

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------