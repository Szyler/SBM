local mod	= DBM:NewMod("Ossirian", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 175 $"):sub(12, -3))
mod:SetCreatureID(15339)
mod:RegisterCombat("combat")

local prewarnVoid					= mod:NewAnnounce("Void Singularity Soon", 3)
local prewarnAdds					= mod:NewAnnounce("Adds Soon", 3)

local warnVoid						= mod:NewAnnounce("Void Singularity Spawned", 2)
local warnAdds						= mod:NewAnnounce("Adds Spawned", 2)

local timerVoid						= mod:NewTimer(45, "Void Singularity Spawn")
local timerAdds						= mod:NewTimer(15, "Next Add Wave")

local soundVoid						= mod:NewSound2(0, "Play Sound on Void Singularity Spawn")

function mod:preVoid()
	prewarnVoid:Show()
end
function mod:preAdds()
	prewarnAdds:Show()
end
function mod:alertVoid()
	warnVoid:Show()
	soundVoid:Play()
end
function mod:alertAdds()
	warnAdds:Show()
end

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0-delay, "initialAdds")
	self:ScheduleMethod(0-delay, "repeatVoid")
	self:ScheduleMethod(0, "getBestKill")
end

function mod:initialAdds()
	timer1 = 10
	timerAdds:Show(timer1)
	self:ScheduleMethod(timer1-5, "preAdds")
	self:ScheduleMethod(timer1, "alertAdds")
	self:ScheduleMethod(timer1, "repeatAdds")
end

function mod:repeatAdds()
	timer2 = 15
	timerAdds:Show(timer2)
	self:ScheduleMethod(timer2-5, "preAdds")
	self:ScheduleMethod(timer2, "alertAdds")
	self:ScheduleMethod(timer2, "repeatAdds")
end

function mod:repeatVoid()
	timer4 = 45
	timerVoid:Show(timer4)
	self:ScheduleMethod(timer4-5, "preVoid")
	self:ScheduleMethod(timer4, "alertVoid")
	self:ScheduleMethod(timer4, "repeatVoid")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------