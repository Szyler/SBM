local mod	= DBM:NewMod("Vaelastrasz", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 175 $"):sub(12, -3))
mod:SetCreatureID(13020)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
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

local prewarnFlame		= mod:NewAnnounce("Flame Breath Soon", 3)

local warnBreath		= mod:NewCastAnnounce(23461)
local warnAdrenaline	= mod:NewTargetAnnounce(18173)

local specWarnAdrenaline	= mod:NewSpecialWarningYou(18173)

local timerFlame		= mod:NewCDTimer(12, 23461)
local timerAdrenaline	= mod:NewTargetTimer(20, 18173)
local timerCombatStart	= mod:NewTimer(41, "Combat Starts", 2457)

local berserkTimer	=	mod:NewBerserkTimer(300)

function mod:preFlame()
	prewarnFlame:Show()
end

function mod:flameBreath()
	timer1 = 12
	timerFlame:Start()
	self:ScheduleMethod(timer1-5, "preFlame")
	self:ScheduleMethod(timer1, "flameBreath")
end

function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "getBestKill")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(23461) then
		warnBreath:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(18173) then
		warnAdrenaline:Show(args.destName)
		timerAdrenaline:Start(args.destName)
		if args:IsPlayer() then
			specWarnAdrenaline:Show()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Event or msg:find(L.Event) then
		timerCombatStart:Start()
	end
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------