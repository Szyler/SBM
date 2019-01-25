local mod	= DBM:NewMod("ThreeBugs", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 184 $"):sub(12, -3))
mod:SetCreatureID(15544, 15511, 15543)
mod:RegisterCombat("combat")

mod:SetBossHealthInfo(
	15543, L.Yauj,
	15544, L.Vem,
	15511, L.Kri
)
local berserkTimer					= mod:NewBerserkTimer(540)
local prewarnBurrow 				= mod:NewAnnounce("Burrow Soon", 3)
local warnBurrow 					= mod:NewAnnounce("Burrow Now", 2)
local timerBurrow					= mod:NewTimer(35, "Vem: Next Burrow")

local timerCheck

function mod:OnCombatStart(delay)
	berserkTimer:Start()
	timerCheck = 1
	self:ScheduleMethod(0.1, "checkIsVis")
	self:ScheduleMethod(0, "getBestKill")
end

function mod:alarmSound()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end

function mod:preBurrow()
	prewarnBurrow:Show()
end

function mod:alertBurrow()
	warnBurrow:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:checkIsVis()
	if UnitIsVisible(15544) and timerCheck == 1 then
	elseif UnitIsVisible(15544) and timerCheck == 2 then
		timerCheck = 1
		local timera = 35
		timerBurrow:Show(timera)
		self:ScheduleMethod(timera-5, "preBurrow")
		self:ScheduleMethod(timera, "alertBurrow")
	elseif not UnitIsVisible(15544) then
	timerCheck = 2
	end
	self:ScheduleMethod(0.1, "checkIsVis")
end

--todo: burrow tracking

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------