local mod	= DBM:NewMod("Gothik", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16060)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"PLAYER_ALIVE"
)

-----ADD DEATHS-----
local warnRiderDown		= mod:NewAnnounce("WarningRiderDown", 4)
local warnKnightDown	= mod:NewAnnounce("WarningKnightDown", 2)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

-----TBM GLOBAL FUNCTIONS-----
function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
-----TBM GLOBAL FUNCTIONS-----