local mod	= DBM:NewMod("ThreeBugs", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 184 $"):sub(12, -3))
mod:SetCreatureID(15544, 15511, 15543)
mod:RegisterCombat("combat")

mod:RegisterEvents(
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

mod:SetBossHealthInfo(
	15543, L.Yauj,
	15544, L.Vem,
	15511, L.Kri
)
local berserkTimer					= mod:NewBerserkTimer(540)
local prewarnBurrow 				= mod:NewAnnounce("Burrow Soon", 3, 1002251)
local warnBurrow 					= mod:NewAnnounce("Burrow Now", 2, 1002251)
local timerBurrow					= mod:NewTimer(35, "Vem: Next Burrow", 1002251)

local soundBurrow					= mod:SoundAirHorn(1002251)

local timerCheck

function mod:OnCombatStart(delay)
	berserkTimer:Start()
	timerCheck = 1
	self:ScheduleMethod(0.1, "checkIsVis")
	self:ScheduleMethod(0, "getBestKill")
end

function mod:alarmSound()
	soundBurrow:Play()
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
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------