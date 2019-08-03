local mod	= DBM:NewMod("Shazzrah", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(12264)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
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



local warnCurse		= mod:NewSpellAnnounce(19713)
local warnGrounding	= mod:NewSpellAnnounce(19714, 2, nil, false)
local warnCntrSpell	= mod:NewSpellAnnounce(19715)
local warnBlink		= mod:NewSpellAnnounce(21655)

local timerCurseCD		= mod:NewNextTimer(20, 19713)
local timerGrounding	= mod:NewBuffActiveTimer(30, 19714, nil, false)
local timerBlinkCD		= mod:NewNextTimer(30, 21655)

local specWarnBomb	= mod:NewSpecialWarningYou(965153)

function mod:OnCombatStart(delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(19714) and self:IsInCombat() and not args:IsDestTypePlayer() then
		warnGrounding:Show()
		timerGrounding:Start()
	elseif args:IsSpellID(965153) and args:IsPlayer() then
		specWarnBomb:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(19714) then
		timerGrounding:Cancel()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19713) and self:IsInCombat() then
		warnCurse:Show()
		timerCurseCD:Start()
	elseif args:IsSpellID(19715) and self:IsInCombat() then
		warnCntrSpell:Show()
	elseif args:IsSpellID(21655) and self:IsInCombat() then
		warnBlink:Show()
		timerBlinkCD:Start()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------