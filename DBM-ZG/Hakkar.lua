local mod	= DBM:NewMod("Hakkar", "DBM-ZG", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14834)
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

local warnMindControl		= mod:NewTargetAnnounce(24718, 2)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end
		
function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24718) then 
		warnMindControl:Show(args.destName)
		if args.destName == UnitName("player") then
			SendChatMessage(L.YellMindControl, "YELL")
		end
	end
end		
		
---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------