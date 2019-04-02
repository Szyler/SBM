local mod	= DBM:NewMod("Azuregos", "DBM-WorldBosses")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4181 $"):sub(12, -3))
mod:SetCreatureID(6109)

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


function mod:OnCombatStart()
	self:ScheduleMethod(0, "getBestKill")
	DBM:AddMsg("This boss is not yet scripted in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------