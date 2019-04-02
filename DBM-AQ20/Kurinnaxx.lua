local mod	= DBM:NewMod("Kurinnaxx", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 167 $"):sub(12, -3))
mod:SetCreatureID(15348)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"UNIT_HEALTH",
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

local prewarnEnrage					= mod:NewAnnounce("Soft Enrage Soon", 3)
local warnAdds						= mod:NewAnnounce("Adds Spawned", 2)
local warnEnrage					= mod:NewAnnounce("Soft Enrage", 2)
local timerAdds						= mod:NewTimer(3, "Adds Spawn")

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

function mod:preEnrage()
	prewarnEnrage:Show()
end

function mod:alertEnrage()
	warnEnrage:Show()
	PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.mp3")
end

function mod:alertAdds()
	warnAdds:Show()
end

function mod:addSpawn()
	timerAdds:Show()
	self:ScheduleMethod(3, "alertAdds")
end

function mod:checkHealth()
	if kuriHealth == 90 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 80 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 70 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 60 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 50 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 40 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 35 then
		self:ScheduleMethod(0, "preEnrage")
	elseif kuriHealth == 30 then
		self:ScheduleMethod(0, "addSpawn")
		self:ScheduleMethod(0, "warnEnrage")
	elseif kuriHealth == 20 then
		self:ScheduleMethod(0, "addSpawn")
	elseif kuriHealth == 10 then
		self:ScheduleMethod(0, "addSpawn")		
	end
end

function mod:UNIT_HEALTH(args)
    kuriHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	self:ScheduleMethod(0, "checkHealth")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------