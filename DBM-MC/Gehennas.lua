local mod	= DBM:NewMod("Gehennas", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12259)--, 11661
mod:RegisterCombat("combat", 12259)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

--local warnRainFire	= mod:NewSpellAnnounce(19717)
local warnCurse		= mod:NewSpellAnnounce(19716)
local warnFist		= mod:NewTargetAnnounce(20277)

local timerCurse	= mod:NewNextTimer(30, 19716)
local timerFist		= mod:NewBuffActiveTimer(4, 20277)

local FistTargets = {}

function mod:OnCombatStart(delay)
	table.wipe(FistTargets)
	DBM:AddMsg("This boss has not yet been re-scripted in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

function mod:warnFistTargets()
		warnFist:Show(table.concat(FistTargets, "<, >"))
		timerFist:Start()
		table.wipe(FistTargets)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19716) then
		timerCurse:Start()
		warnCurse:Show()
--	elseif args:IsSpellID(19717) and self:IsInCombat() then
--		warnRainFire:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(20277) and args:IsDestTypePlayer() then
		self:UnscheduleMethod("warnFistTargets")
		FistTargets[#FistTargets + 1] = args.destName
		self:ScheduleMethod(0.3, "warnFistTargets")
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------