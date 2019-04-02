local mod	= DBM:NewMod("Skeram", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 133 $"):sub(12, -3))
mod:SetCreatureID(15263)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"UNIT_HEALTH"
)

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

local berserkTimer	=	mod:NewBerserkTimer(540)
local prewarnClones					= mod:NewAnnounce("Skeram Clones Soon", 3, 1002181)

local check1
local check2
local check3

function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "getBestKill")
	check1 = 0
	check2 = 0
	check3 = 0
end

function mod:UNIT_HEALTH(args)
    skeramHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	
	if skeramHealth < 80 and check1 == 0 then
		check1 = 1
		prewarnClones:Show()
	elseif skeramHealth < 55 and check2 == 0 then
		check2 = 1
		prewarnClones:Show()
	elseif skeramHealth < 30 and check3 == 0 then
		check3 = 1
		prewarnClones:Show()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------