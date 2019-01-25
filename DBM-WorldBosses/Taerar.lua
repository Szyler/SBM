local mod	= DBM:NewMod("Taerar", "DBM-WorldBosses")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))
mod:SetCreatureID(14890)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_HEALTH",
	"UNIT_DIED"
)
local prewarnShades				= mod:NewAnnounce("Shades of Taerar Soon", 3)
local warnShades				= mod:NewSpellAnnounce(24841, 2)

local preshadesCount
local shadesCount

function mod:preShades()
	prewarnShades:Show()
end

function mod:alertShades()
	warnShades:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:alarmSound()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end

function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if UnitName("player") == "Sky" then
		print(recapID)
	end
end

function mod:OnCombatStart()
	preshadesCount = 0
	shadesCount = 0
	self:ScheduleMethod(0, "getBestKill")
	aspamOne = 1
	self:ScheduleMethod(1, "antiSpamone")
	DBM:AddMsg("This boss is not completed in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

---------- NIGHTMARE DRAKES SHARED ----------
local aspamOne
function mod:antiSpamone()
	if aspamOne == 2 then
		warnBreath:Show()
		aspamOne = 1
	end
	self:ScheduleMethod(1, "antiSpamone")
end

local warnBreath				= mod:NewSpellAnnounce(24818, 3)
function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24818) then
		aspamOne = 2
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 14890 then
		self:ScheduleMethod(0, "checkShades")
	end
end

function mod:checkShades()
	if self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 80 and preshadesCount == 0 then
		preshadesCount = 1
		self:ScheduleMethod(0, "preShades")
	elseif self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 75 and shadesCount == 0 then
		shadesCount = 1
		self:ScheduleMethod(0, "alertShades")
	elseif self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 55 and preshadesCount == 1 then
		preshadesCount = 2
		self:ScheduleMethod(0, "preShades")	
	elseif self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 50 and shadesCount == 1 then
		shadesCount = 2 
		self:ScheduleMethod(0, "alertShades")
	elseif self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 30 and preshadesCount == 2 then
		preshadesCount = 3 
		self:ScheduleMethod(0, "preShades")
	elseif self:GetUnitCreatureId(uId) == 14890 and UnitHealth(uId) / UnitHealthMax(uId) <= 25 and shadesCount == 2 then 
		shadesCount = 3
		self:ScheduleMethod(0, "alertShades")
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