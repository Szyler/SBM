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

-----DISRUPTING SHOUT-----
local warnShoutNow			= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoon			= mod:NewSoonAnnounce(29107, 3)
local timerShout			= mod:NewCDTimer(10, 29107)
local soundShout			= mod:SoundInfo(29107)
-----SHADOW BURST-----
local warnShadowBurstNow	= mod:NewSpellAnnounce(1003108, 2)
local warnShadowBurstSoon	= mod:NewSoonAnnounce(1003108, 3)
local timerShadowBurst		= mod:NewNextTimer(25, 1003108)
local soundShadowBurst		= mod:SoundAlert(1003108)
-----JAGGED KNIFE-----
local warnKnifeNow			= mod:NewTargetAnnounce(55550, 2)
local specWarnKnife			= mod:NewSpecialWarningSpell(55550, nil, nil, nil, 10)
local soundKnife			= mod:SoundAirHorn(55550)
-----BRUISING BLOW-----
local warnBlowNow			= mod:NewSpellAnnounce(26613, 2)
local warnBlowSoon			= mod:NewSoonAnnounce(26613, 3)
local timerBlow				= mod:NewNextTimer(15, 26613)
local soundBlow				= mod:SoundInfo(26613)
-----CURSE OF FEEBLENESS-----
local warnCurseNow			= mod:NewSpellAnnounce(1003253, 2)
local warnCurseEndSoon		= mod:NewSoonAnnounce(1003253, 3)
local timerCurse			= mod:NewBuffActiveTimer(120, 1003253)
local soundCurse			= mod:SoundAlarmLong(1003253)
-----MISC-----
local razHealth
local phase
local warnPhase2			= mod:NewPhaseAnnounce(2)
local soundPhaseTwo			= mod:SoundInfoLong(29125, "Play the 'Long Info' sound effect on Phase Two.")

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	mod:getBestKill()
	phase = 1
	-----Shout-----
	warnShoutNow:Schedule(16 - delay)
	warnShoutSoon:Schedule(11 - delay)
	timerShout:Start(16 - delay)
	soundShout:Schedule(16 - delay)
	-----Shout Reschedule-----
	self:ScheduleMethod(16 - delay, "shoutRepeat")
	self:ScheduleMethod(26 - delay, "shoutRepeat")
	self:ScheduleMethod(36 - delay, "shoutRepeat")
	self:ScheduleMethod(46 - delay, "shoutRepeat")
	self:ScheduleMethod(56 - delay, "shoutRepeat")
	self:ScheduleMethod(66 - delay, "shoutRepeat")
	self:ScheduleMethod(76 - delay, "shoutRepeat")
	self:ScheduleMethod(86 - delay, "shoutRepeat")
	self:ScheduleMethod(96 - delay, "shoutRepeat")
	self:ScheduleMethod(106 - delay, "shoutRepeat")
	self:ScheduleMethod(116 - delay, "shoutRepeat")
	self:ScheduleMethod(126 - delay, "shoutRepeat")
	self:ScheduleMethod(136 - delay, "shoutRepeat")
	self:ScheduleMethod(146 - delay, "shoutRepeat")
	self:ScheduleMethod(156 - delay, "shoutRepeat")
	self:ScheduleMethod(166 - delay, "shoutRepeat")
	self:ScheduleMethod(176 - delay, "shoutRepeat")
	self:ScheduleMethod(186 - delay, "shoutRepeat")
	self:ScheduleMethod(196 - delay, "shoutRepeat")
	self:ScheduleMethod(206 - delay, "shoutRepeat")
	self:ScheduleMethod(216 - delay, "shoutRepeat")
	self:ScheduleMethod(226 - delay, "shoutRepeat")
	self:ScheduleMethod(236 - delay, "shoutRepeat")
	self:ScheduleMethod(246 - delay, "shoutRepeat")
	self:ScheduleMethod(256 - delay, "shoutRepeat")
	self:ScheduleMethod(266 - delay, "shoutRepeat")
	self:ScheduleMethod(276 - delay, "shoutRepeat")
	self:ScheduleMethod(286 - delay, "shoutRepeat")
	self:ScheduleMethod(296 - delay, "shoutRepeat")
	self:ScheduleMethod(306 - delay, "shoutRepeat")	
	self:ScheduleMethod(316 - delay, "shoutRepeat")	
	self:ScheduleMethod(326 - delay, "shoutRepeat")	
	self:ScheduleMethod(336 - delay, "shoutRepeat")	
	self:ScheduleMethod(346 - delay, "shoutRepeat")	
	self:ScheduleMethod(356 - delay, "shoutRepeat")	
	self:ScheduleMethod(366 - delay, "shoutRepeat")	
	self:ScheduleMethod(376 - delay, "shoutRepeat")	
	self:ScheduleMethod(386 - delay, "shoutRepeat")	
	self:ScheduleMethod(396 - delay, "shoutRepeat")	
	self:ScheduleMethod(406 - delay, "shoutRepeat")	
	self:ScheduleMethod(416 - delay, "shoutRepeat")	
	self:ScheduleMethod(426 - delay, "shoutRepeat")	
	self:ScheduleMethod(436 - delay, "shoutRepeat")	
	self:ScheduleMethod(446 - delay, "shoutRepeat")	
	self:ScheduleMethod(456 - delay, "shoutRepeat")	
	self:ScheduleMethod(466 - delay, "shoutRepeat")	
	self:ScheduleMethod(476 - delay, "shoutRepeat")	
	self:ScheduleMethod(486 - delay, "shoutRepeat")	
	self:ScheduleMethod(496 - delay, "shoutRepeat")		
	self:ScheduleMethod(506 - delay, "shoutRepeat")	
	self:ScheduleMethod(516 - delay, "shoutRepeat")	
	self:ScheduleMethod(526 - delay, "shoutRepeat")	
	self:ScheduleMethod(536 - delay, "shoutRepeat")	
	self:ScheduleMethod(546 - delay, "shoutRepeat")	
	self:ScheduleMethod(556 - delay, "shoutRepeat")	
	self:ScheduleMethod(566 - delay, "shoutRepeat")	
	self:ScheduleMethod(576 - delay, "shoutRepeat")	
	self:ScheduleMethod(586 - delay, "shoutRepeat")	
	self:ScheduleMethod(596 - delay, "shoutRepeat")
	self:ScheduleMethod(606 - delay, "shoutRepeat")	
	self:ScheduleMethod(616 - delay, "shoutRepeat")	
	self:ScheduleMethod(626 - delay, "shoutRepeat")	
	self:ScheduleMethod(636 - delay, "shoutRepeat")	
	self:ScheduleMethod(646 - delay, "shoutRepeat")	
	self:ScheduleMethod(656 - delay, "shoutRepeat")	
	self:ScheduleMethod(666 - delay, "shoutRepeat")	
	self:ScheduleMethod(676 - delay, "shoutRepeat")	
	self:ScheduleMethod(686 - delay, "shoutRepeat")	
	self:ScheduleMethod(696 - delay, "shoutRepeat")
	self:ScheduleMethod(706 - delay, "shoutRepeat")	
	self:ScheduleMethod(716 - delay, "shoutRepeat")	
	self:ScheduleMethod(726 - delay, "shoutRepeat")	
	self:ScheduleMethod(736 - delay, "shoutRepeat")	
	self:ScheduleMethod(746 - delay, "shoutRepeat")	
	self:ScheduleMethod(756 - delay, "shoutRepeat")	
	self:ScheduleMethod(766 - delay, "shoutRepeat")	
	self:ScheduleMethod(776 - delay, "shoutRepeat")	
	self:ScheduleMethod(786 - delay, "shoutRepeat")	
	self:ScheduleMethod(796 - delay, "shoutRepeat")
	self:ScheduleMethod(806 - delay, "shoutRepeat")	
	self:ScheduleMethod(816 - delay, "shoutRepeat")	
	self:ScheduleMethod(826 - delay, "shoutRepeat")	
	self:ScheduleMethod(836 - delay, "shoutRepeat")	
	self:ScheduleMethod(846 - delay, "shoutRepeat")	
	self:ScheduleMethod(856 - delay, "shoutRepeat")	
	self:ScheduleMethod(866 - delay, "shoutRepeat")	
	self:ScheduleMethod(876 - delay, "shoutRepeat")	
	self:ScheduleMethod(886 - delay, "shoutRepeat")	
	self:ScheduleMethod(896 - delay, "shoutRepeat")
	self:ScheduleMethod(906 - delay, "shoutRepeat")	
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
end

function mod:shoutRepeat()
	timer = 10
	warnShoutNow:Schedule(timer)
	warnShoutSoon:Schedule(timer-5)
	timerShout:Start(timer)
	soundShout:Schedule(timer)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(55550) then 
		warnKnifeNow:Show(args.destName)
		if args:IsPlayer() then
			specWarnKnife:Show(10);
			soundKnife:Play();
			SendChatMessage(L.YellKnife, "YELL")
		end
	elseif args:IsSpellID(1003253) then 
		timer = 120
		warnCurseNow:Schedule(timer)
		warnCurseEndSoon:Schedule(timer-10)
		timerCurse:Start(timer)
	end		
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(26613) then
		timer = 15
		warnBlowNow:Schedule(timer)
		warnBlowSoon:Schedule(timer-5)
		timerBlow:Start(timer)
		soundBlow:Schedule(timer)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(1003108) then
		timer = 25
		warnShadowBurstNow:Schedule(timer)
		warnShadowBurstSoon:Schedule(timer-5)
		timerShadowBurst:Start(timer)
		soundShadowBurst:Schedule(timer)
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

-----SBM GLOBAL FUNCTIONS-----
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
-----SBM GLOBAL FUNCTIONS-----