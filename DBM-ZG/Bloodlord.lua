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
	"UNIT_DIED"
)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	DBM:AddMsg("This boss is currently in progress in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if UnitName("player") == "Sky" then
		DBM:AddMsg("ID:"+recapID)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------