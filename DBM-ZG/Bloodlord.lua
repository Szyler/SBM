local mod = DBM:NewMod("Bloodlord", "DBM-ZG", 1)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))

mod:SetCreatureID(11382, 14988)
mod:RegisterCombat("combat")
mod:SetBossHealthInfo(
	11382, L.Bloodlord,
	14988, L.Ohgan
)

mod:RegisterEvents(
	"UNIT_DIED",
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

local warnOghan					= mod:NewAnnounce("Mandokir Enrage - Oghan Died", 3)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if recapID == 14988 then
		warnOghan:Show() 
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------