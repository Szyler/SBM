local mod	= DBM:NewMod("Rajaxx", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 171 $"):sub(12, -3))
mod:SetCreatureID(15341)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED"
)

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

local specWarnSpellReflect	= mod:NewSpecialWarning("Spell Reflect: Stop Casting", nil, "Special warning for Spell Reflect") --4500009)
local warnSpellReflect    = mod:NewSpellAnnounce(1002113)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1002113) then
		warnSpellReflect:Show()
		specWarnSpellReflect:Show()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------