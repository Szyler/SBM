local mod	= DBM:NewMod("Lucifron", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12118)--, 12119
mod:RegisterCombat("combat", 12118)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnDoom		= mod:NewSpellAnnounce(19702)
local warnCurse		= mod:NewSpellAnnounce(19703)
local warnMC		= mod:NewTargetAnnounce(20604)

local timerCurseCD	= mod:NewNextTimer(20, 19703)
local timerDoomCD	= mod:NewNextTimer(20, 19702)
local timerDoom		= mod:NewCastTimer(10, 19702)
local timerMC		= mod:NewTargetTimer(5, 20604)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	DBM:AddMsg("This boss has not yet been re-scripted in OBM. In order to assist with scripting, please record your attempts and send the footage to Sky17#0017 on Discord.")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19702) then
		warnDoom:Show()
		timerDoom:Start()
		timerDoomCD:Start()
	elseif args:IsSpellID(19703) then
		timerCurseCD:Start()
		warnCurse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(20604) then
		warnMC:Show(args.destName)
		timerMC:Start(args.destName)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------