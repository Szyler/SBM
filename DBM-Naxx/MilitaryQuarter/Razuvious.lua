local mod	= DBM:NewMod("Razuvious", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16061)

mod:RegisterCombat("yell", L.Yell1, L.Yell2, L.Yell3, L.Yell4)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

-----Shout-----
local warnShoutNow			= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoon			= mod:NewSoonAnnounce(29107, 3)
local timerShout			= mod:NewNextTimer(10, 29107)
local soundShout			= mod:SoundInfo(29107)
local delayShout
-----Shadow Burst-----
local warnShadowBurstNow	= mod:NewSpellAnnounce(1003108, 2)
local warnShadowBurstSoon	= mod:NewSoonAnnounce(1003108, 3)
local timerShadowBurst		= mod:NewNextTimer(25, 1003108)
local soundShadowBurst		= mod:SoundAlert(1003108)
-----Jagged Knife-----
local warnKnifeNow			= mod:NewTargetAnnounce(55550, 2)
local specWarnKnife			= mod:NewSpecialWarningSpell(55550, nil, nil, nil, 10)
local soundKnife			= mod:SoundAirHorn(55550)
-----Bruising Blow-----
local warnBlowNow			= mod:NewSpellAnnounce(26613, 2)
local warnBlowSoon			= mod:NewSoonAnnounce(26613, 3)
local timerBlow				= mod:NewNextTimer(15, 26613)
local soundBlow				= mod:SoundInfo(26613)
local delayBlow
-----Curse of Feebleness-----
local warnCurseNow			= mod:NewSpellAnnounce(1003253, 2)
local warnCurseEndSoon		= mod:NewSoonAnnounce(1003253, 3)
local timerCurse			= mod:NewBuffActiveTimer(120, 1003253)
local soundCurse			= mod:SoundAlarmLong(1003253)
-----Phase 2-----
local razHealth
local phase
local warnPhase2			= mod:NewPhaseAnnounce(2)
local soundPhaseTwo			= mod:SoundInfoLong(29125, "Play the 'Long Info' sound effect on Phase Two.")

function mod:OnCombatStart(delay)
	mod:getBestKill()
	phase = 1
	-----Shout-----
	warnShoutNow:Schedule(16 - delay)
	warnShoutSoon:Schedule(11 - delay)
	timerShout:Start(16 - delay)
	soundShout:Schedule(16-delay)
	delayShout = 0
	-----Shadow Burst-----
	warnShadowBurstNow:Schedule(25-delay)
	warnShadowBurstSoon:Schedule(20-delay)
	timerShadowBurst:Start(25-delay)
	soundShadowBurst:Schedule(25-delay)
	-----Bruising Blow-----
	warnBlowNow:Schedule(15-delay)
	warnBlowSoon:Schedule(10-delay)
	timerBlow:Start(15-delay)
	soundBlow:Schedule(15-delay)
	delayBlow = 0
end

function mod:delayDShout()
	delayShout = 1
end

function mod:shoutDelayTimer()
	timer = 10
	timerShout:Start(timer)
end

function mod:delayBBlow()
	delayBlow = 1
end

function mod:blowDelayTimer()
	timer = 15
	timerBlow:Start(timer)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(55550) then 
		warnKnifeNow:Show(args.destName)
		if args:IsPlayer() then
			specWarnKnife:Show(10);
			soundKnife:Play();
			SendChatMessage(L.YellKnife, "YELL")
		end
	elseif args:IsSpellID(55550) then 
		timer = 120
		warnCurseNow:Schedule(timer)
		warnCurseEndSoon:Schedule(timer-10)
		timerCurse:Start(timer)
	end		
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(55543, 29107) then  -- Disrupting Shout
		if delayShout == 0 then
			timer = 10
			warnShoutNow:Schedule(timer)
			warnShoutSoon:Schedule(timer-5)
			timerShout:Start(timer)
			soundShout:Schedule(timer)
		elseif delayShout == 1 then
			timer = 20
			warnShoutNow:Schedule(timer)
			warnShoutSoon:Schedule(timer-5)
			self:ScheduleMethod(timer-10, "shoutDelayTimer")
			soundShout:Schedule(timer)
			delayShout = 0
		end
	elseif args:IsSpellID(26613) then
		if delayBBlow == 0 then
			timer = 15
			warnBlowNow:Schedule(timer)
			warnBlowSoon:Schedule(timer-5)
			timerBlow:Start(timer)
			soundBlow:Schedule(timer)
		elseif delayBBlow == 1 then
			timer = 30
			warnBlowNow:Schedule(timer)
			warnBlowSoon:Schedule(timer-5)
			self:ScheduleMethod(timer-15, "blowDelayTimer")
			soundBlow:Schedule(timer)
			delayBlow = 0
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(1003108) then
		timer = 25
		warnShadowBurstNow:Schedule(timer)
		warnShadowBurstSoon:Schedule(timer-5)
		timerShadowBurst:Start(timer)
		soundShadowBurst:Schedule(timer)
		self:ScheduleMethod(timer-10, "delayDShout")
		self:ScheduleMethod(timer-15, "delayBBlow")
	end
end

function mod:UNIT_HEALTH(args)
    razHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	
	if razHealth < 45 and phase == 1 then
		phase = 2
		warnPhase2:Show();
		soundPhaseTwo:Play();
		-----Shadow Burst-----
		warnShadowBurstNow:Cancel();
		warnShadowBurstSoon:Cancel();
		timerShadowBurst:Cancel();
		soundShadowBurst:Cancel();
	end
end

function mod:OnCombatEnd(wipe)
	self:Stop();
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