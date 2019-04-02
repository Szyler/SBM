local mod	= DBM:NewMod("Nefarian", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 188 $"):sub(12, -3))
mod:SetCreatureID(11583)
mod:RegisterCombat("yell", L.YellPull)
mod:SetWipeTime(25)--guesswork

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"UNIT_HEALTH",
	"CHAT_MSG_MONSTER_YELL",
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

local warnPhaseSoon		= mod:NewAnnounce("WarnPhaseSoon", 2)
local warnPhase			= mod:NewAnnounce("WarnPhase", 3)
local prewarnFear		= mod:NewAnnounce("Bellowing Roar Soon", 3, 22686)
local warnShadowFlame	= mod:NewCastAnnounce(22539, 2)
local warnFear			= mod:NewCastAnnounce(22686, 2)
local warnVeilShadow	= mod:NewTargetAnnounce(22687, 3)

local timerShadowFlame	= mod:NewCastTimer(2, 22539)
local timerFearNext		= mod:NewNextTimer(28.5, 22686)
local timerVeilShadow	= mod:NewTargetTimer(6, 22687)

local prewarn_P3
local warn_P3
function mod:OnCombatStart(delay)
	prewarn_P3 = false
	warn_P3 = false
	self:ScheduleMethod(0, "getBestKill")
end

function mod:preFear()
	prewarnFear:Show()
end

function mod:alertFear()
	warnFear:Show()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(22539) and self:IsInCombat() then
		warnShadowFlame:Show()
		timerShadowFlame:Start()
	elseif args:IsSpellID(22686) and self:IsInCombat() then
		timer1 = 28.5
		timerFearNext:Start(timer1)
		self:ScheduleMethod(timer1, "alertFear")
		self:ScheduleMethod(timer1-5, "preFear")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(22687) then
		warnVeilShadow:Show(args.destName)
		timerVeilShadow:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(22687) then
		timerVeilShadow:Cancel(args.destName)
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitHealth(uId) / UnitHealthMax(uId) <= 0.25 and self:GetUnitCreatureId(uId) == 11583 and not prewarn_P3 then
		warnPhaseSoon:Show("3")
		prewarn_P3 = true
	elseif UnitHealth(uId) / UnitHealthMax(uId) <= 0.20 and self:GetUnitCreatureId(uId) == 11583 and not warn_P3 then
		warnPhase:Show("3")
		warn_P3 = true
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 then
		self:SendSync("Phase", 2)
	elseif msg == L.YellPhase3 then
		self:SendSync("Phase", 3)
	end
end

function mod:OnSync(msg, arg)
	if msg == "Phase" then
		warnPhase:Show(arg)
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------