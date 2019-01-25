local mod	= DBM:NewMod("Flamegor", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 168 $"):sub(12, -3))
mod:SetCreatureID(11981, 14601, 11983)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warnEnrage		= mod:NewSpellAnnounce(23342)
local warnFlameBuffet	= mod:NewSpellAnnounce(23341)
local warnShadow		= mod:NewTargetAnnounce(23340)

local timerShadow		= mod:NewTargetTimer(8, 23340)
local timerEnrageNext 	= mod:NewNextTimer(10, 23342)
--local timerFlameBuffetCD = mod:NewCDTimer(10, 23341)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(23342) then
		warnEnrage:Show()
		timerEnrageNext:Start()
	elseif args:IsSpellID(23341) then
		warnFlameBuffet:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(23340) then
		warnShadow:Show(args.destName)
		timerShadow:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(23340) then
		timerShadow:Cancel(args.destName)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------