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

local hpCounter
local prewarnEnrage					= mod:NewAnnounce("Soft Enrage Soon", 3, 1002069)
local warnAdds						= mod:NewAnnounce("Adds Spawned", 2, 985050)
local warnEnrage					= mod:NewAnnounce("Soft Enrage", 2, 1002069)
local soundEnrage					= mod:SoundAlarmLong(1002069)
local timerAdds						= mod:NewTimer(3, "Adds Spawn", 985050)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	hpCounter = 0
end

function mod:preEnrage()
	prewarnEnrage:Show()
end

function mod:alertEnrage()
	warnEnrage:Show()
	soundEnrage:Play();
end

function mod:alertAdds()
	warnAdds:Show()
end

function mod:addSpawn()
	timerAdds:Show()
	self:ScheduleMethod(3, "alertAdds")
end

function mod:UNIT_HEALTH(args)
    kuriHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	if kuriHealth <= 90 and hpCounter == 0 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 1
	elseif kuriHealth <= 80 and hpCounter == 1 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 2
	elseif kuriHealth == 70 and hpCounter == 2 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 3
	elseif kuriHealth == 60 and hpCounter == 3 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 4
	elseif kuriHealth == 50 and hpCounter == 4 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 5
	elseif kuriHealth == 40 and hpCounter == 5 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 6
	elseif kuriHealth == 35 and hpCounter == 6 then
		self:ScheduleMethod(0, "preEnrage")
		hpCounter = 7
	elseif kuriHealth == 30 and hpCounter == 7 then
		self:ScheduleMethod(0, "addSpawn")
		self:ScheduleMethod(0, "warnEnrage")
		hpCounter = 8
	elseif kuriHealth == 20 and hpCounter == 8 then
		self:ScheduleMethod(0, "addSpawn")
		hpCounter = 9 
	elseif kuriHealth == 10 and hpCounter == 9 then
		self:ScheduleMethod(0, "addSpawn")	
		hpCounter = 10
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------