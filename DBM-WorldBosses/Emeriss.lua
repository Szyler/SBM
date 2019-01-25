local mod	= DBM:NewMod("Emeriss", "DBM-WorldBosses")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))
mod:SetCreatureID(14889)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_HEALTH"
)

local prewarnCorruption			= mod:NewAnnounce("Corruption of the Earth Soon", 3)
local warnCorruption			= mod:NewSpellAnnounce(24910, 2)
local warnInfection				= mod:NewSpellAnnounce(24928, 3)

local precorruptionCount
local corruptionCount
local aspamOne
local aspamTwo

function mod:preCorruption()
	prewarnCorruption:Show()
end

function mod:alertCorruption()
	warnCorruption:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:alarmSound()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end

function mod:OnCombatStart()
	self:ScheduleMethod(0, "getBestKill")
	corruptionCount = 0
	precorruptionCount = 0
	aspamOne = 1
	aspamTwo = 1
	self:ScheduleMethod(1, "antiSpamone")
	self:ScheduleMethod(1, "antiSpamtwo")
end

---------- NIGHTMARE DRAKES SHARED ----------
function mod:antiSpamone()
	if aspamOne == 2 then
		warnBreath:Show()
		aspamOne = 1
	end
	self:ScheduleMethod(1, "antiSpamone")
end

function mod:antiSpamtwo()
	if aspamTwo == 2 then
		warnInfection:Show()
		aspamTwo = 1
	end
	self:ScheduleMethod(1, "antiSpamtwo")
end

local warnBreath				= mod:NewSpellAnnounce(24818, 3)
function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24818) then
		aspamOne = 2
	elseif args:IsSpellID(24928) then
		aspamTwo = 2
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 14889 then
		self:ScheduleMethod(0, "checkCorruption")
	end
end

function mod:checkCorruption()
	if self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 80 and precorruptionCount == 0 then
		precorruptionCount = 1
		self:ScheduleMethod(0, "preCorruption")
	elseif self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 75 and corruptionCount == 0 then
		corruptionCount = 1
		self:ScheduleMethod(0, "alertCorruption")
	elseif self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 55 and precorruptionCount == 1 then
		precorruptionCount = 2
		self:ScheduleMethod(0, "preCorruption")	
	elseif self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 50 and corruptionCount == 1 then
		corruptionCount = 2 
		self:ScheduleMethod(0, "alertCorruption")
	elseif self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 30 and precorruptionCount == 2 then
		precorruptionCount = 3 
		self:ScheduleMethod(0, "preCorruption")
	elseif self:GetUnitCreatureId(uId) == 14889 and UnitHealth(uId) / UnitHealthMax(uId) <= 25 and corruptionCount == 2 then 
		corruptionCount = 3
		self:ScheduleMethod(0, "alertCorruption")
	end
end
---------- NIGHTMARE DRAKES SHARED ----------

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------