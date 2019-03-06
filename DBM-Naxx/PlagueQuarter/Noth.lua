local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15954)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"PLAYER_ALIVE"
)

local warnTeleportNow	= mod:NewAnnounce("WarningTeleportNow", 3, 46573)
local warnTeleportSoon	= mod:NewAnnounce("WarningTeleportSoon", 1, 46573)
local warnCurse			= mod:NewSpellAnnounce(29213, 2)

local timerTeleport		= mod:NewTimer(90, "TimerTeleport", 46573)
local timerTeleportBack	= mod:NewTimer(70, "TimerTeleportBack", 46573)

local phase = 0

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	phase = 0
	self:BackInRoom(delay)
end

function mod:Balcony()
	local timer
	if phase == 1 then timer = 70
	elseif phase == 2 then timer = 97
	elseif phase == 3 then timer = 120
	else return	end
	timerTeleportBack:Show(timer)
	warnTeleportSoon:Schedule(timer - 20)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "BackInRoom")
end

function mod:BackInRoom(delay)
	delay = delay or 0
	phase = phase + 1
	local timer
	if phase == 1 then timer = 90 - delay
	elseif phase == 2 then timer = 110 - delay
	elseif phase == 3 then timer = 180 - delay
	else return end
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer - 20)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "Balcony")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29213, 54835) then	-- Curse of the Plaguebringer
		warnCurse:Show()
	end
end

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------