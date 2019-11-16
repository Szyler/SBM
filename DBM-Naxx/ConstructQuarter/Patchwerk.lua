local mod	= DBM:NewMod("Patchwerk", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(16028)
mod:RegisterCombat("yell", L.yell1, L.yell2)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"PLAYER_ALIVE"
)

mod:AddBoolOption("WarningHateful", false, "announce")
-----GASTRIC AFFLICTION-----
local specWarnGastric		= mod:NewSpecialWarningYou(1003086)
local soundGastric			= mod:SoundAlert(1003086)
-----MISC-----
local enrageTimer	= mod:NewBerserkTimer(360)
local timerAchieve	= mod:NewAchievementTimer(180, 1857, "TimerSpeedKill")

-----BOSS FUNCTIONS-----
local function announceStrike(target, damage)
	SendChatMessage(L.HatefulStrike:format(target, damage), "RAID")
end

function mod:OnCombatStart(delay)
	mod:getBestKill()
	enrageTimer:Start(-delay)
	timerAchieve:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003086) then 
		if args:IsPlayer() then
			timer = 5
			specWarnGastric:Show(timer);
			soundGastric:Play();
		end
	end	
end	

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, args.amount or 0)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(28308, 59192) and self.Options.WarningHateful and DBM:GetRaidRank() >= 1 then
		announceStrike(args.destName, getglobal("ACTION_SPELL_MISSED_"..(args.missType)) or "")
	end	
end

function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
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