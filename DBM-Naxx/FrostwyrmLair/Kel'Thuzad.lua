local mod	= DBM:NewMod("Kel'Thuzad", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2574 $"):sub(12, -3))
mod:SetCreatureID(15990)
mod:SetUsedIcons(1,2,3,4,8)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START", --This should allow the addon to process this Event using the scripting from Anub'Rekhan for Impale.
	"SPELL_CAST_SUCCESS",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

----------PHASE 1----------
-----MAJOR ADD WAVE-----
local warnMajorWave		= mod:NewAnnounce("Major Wave Spawned", 2, 1003064, nil, "Show warning for Major Wave spawn")
local warnMajorWaveSoon	= mod:NewAnnounce("Major Wave Spawns Soon", 3, 1003064, nil, "Show pre-warning for Major Wave spawn")
local timerMajorWave	= mod:NewTimer(30, "Next Major Wave", 1003064, nil, "Show timer for Major Wave spawn")
local soundMajorWave	= mod:SoundInfo(1003064, "Play the 'Info' sound effect for Major Wave Spawn")
-----CONSTRICTING CHAINS-----
local warnChains		= mod:NewTargetAnnounce(1003114, 2)
local soundChains		= mod:SoundAlert(1003114)
-----WAIL OF SOULS-----
local warnWailSoul		= mod:NewSpellAnnounce(1003115, 2)
-----PHASE 1 -> 2 TRANSITION-----
local warnPhase2		= mod:NewPhaseAnnounce(2, 3)
local warnPhase2Soon	= mod:NewPhaseSoonAnnounce(2, 3)
local timerPhase2		= mod:NewTimer(153, "Phase Two", 29485, nil, "Show timer for Phase Two")
local soundPhase2		= mod:SoundInfoLong(29485, "Play the 'Long Info' sound effect for Phase Two")
-----PHASE 2 -> 3 TRANSITION-----
local warnPhase3		= mod:NewPhaseAnnounce(3, 3)
local warnPhase3Soon	= mod:NewPhaseSoonAnnounce(3, 3)
local timerPhase3		= mod:NewTimer(378, "Phase Three", 29485, nil, "Show timer for Phase Three")
local soundPhase3		= mod:SoundInfoLong(29485, "Play the 'Long Info' sound effect for Phase Three")
----------PHASE 2----------
-----SHADE OF NAXXRAMAS-----
local warnNaxxShade		= mod:NewAnnounce("Shade of Naxx Spawned", 2, 25228, nil, "Show warning for Shade of Naxxramas spawn")
local warnNaxxShadeSoon	= mod:NewAnnounce("Shade of Naxx Spawns Soon", 3, 25228, nil, "Show pre-warning for Shade of Naxxramas spawn")
local timerNaxxShade	= mod:NewTimer(60, "Next Shade of Naxx", 25228, nil, "Show timer for Shade of Naxxramas spawn")
local soundNaxxShade	= mod:SoundAlarm(25228, "Play the 'Alarm' sound effect for Shade of Naxxramas Spawn")
-----DISRUPTING SHOUT-----
local warnShout			= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoon		= mod:NewSoonAnnounce(29107, 3)
local timerShout		= mod:NewCDTimer(16, 29107)
local soundShout		= mod:SoundInfo(29107)
-----SEEING RED-----
local warnSeeingRed		= mod:NewSpellAnnounce(1003255, 2)
-----GASTRIC AFFLICTION-----
local warnGastric		= mod:NewTargetAnnounce(1003086, 2)
local specWarnGastric	= mod:NewSpecialWarningYou(1003086)
local soundGastric		= mod:SoundAlert(1003086)
-----VOID ZONE-----
local specWarnVoid		= mod:NewSpecialWarningYou(28865)
-----SAFETY DANCE-----
local warnDanceSoon		= mod:NewAnnounce("Safety Dance Soon", 2, 46573, nil, "Show pre-warning for the Safetyy Dance")
local warnDance			= mod:NewAnnounce("Dance Ends Now", 3, 46573, nil, "Show warning for the Safety Dance")
local timerDance		= mod:NewTimer(22, "Safety Dance Starts", 46573, nil, "Show timer for the Safety Dance")
local soundDance		= mod:SoundAlarm(46573, "Play the 'Alarm' sound effect at the start of the Safety Dance")
-----HARVEST SOUL-----
local warnHarvestSoon	= mod:NewSoonAnnounce(28679, 3)
local warnHarvest		= mod:NewSpellAnnounce(28679, 2)
local timerHarvest		= mod:NewNextTimer(15, 28679)
-----MAEXXNA SPIDERLINGS-----
local timerSpider		= mod:NewNextTimer(16, 43134)
local soundSpider		= mod:SoundInfo(43134)
-----NOTH'S SHADE (UNSCRIPTED)-----
local warnNothShade		= mod:NewAnnounce("Noth's Shade Spawned", 2, 1003072, nil, "Show warning for Noth's Shade spawn")
local timerNothShade	= mod:NewTimer(60, "Next Noth's Shade", 1003072, nil, "Show timer for Noth's Shade spawn")
local soundNothShade	= mod:SoundInfo(1003072, "Play the 'Info' sound effect for Noth's Shade")
-----FROST BLAST-----
local warnBlast			= mod:NewSpellAnnounce(29879, 2)
local timerBlast		= mod:NewCDTimer(16, 29879)
local soundBlast		= mod:SoundInfo(29879)
-----DETONATE MANA-----
local warnMana			= mod:NewSpellAnnounce(27819, 2)
local timerMana			= mod:NewCDTimer(30, 27819)
local soundMana			= mod:SoundAlert(27819)
-----DEATH AND DECAY-----
local specWarnDnD		= mod:NewSpecialWarningYou(1003113)
-----CHAINS OF KEL'THUZAD-----
local warnChains		= mod:NewSpellAnnounce(28410, 2)
local timerChains		= mod:NewCDTimer(16, 28410)
local soundChains		= mod:SoundInfo(28410)
-----RANGE CHECK-----
mod:AddBoolOption("ShowRange", true)
----------MISC----------
local notRealRazuv		= 0
local phase 			= 0
local berserkTimer		= mod:NewBerserkTimer(1140)
-----CODE START-----
function mod:OnCombatStart(delay)
	mod:getBestKill()
	mod:phaseOne()
	berserkTimer:Start(1140)
	notRealRazuv = 1
end

function mod:phaseOne()
	phase = 1
	mod:phase2Transition()
	mod:timerMajorWaveRepeat()
	self:ScheduleMethod(30, "timerMajorWaveRepeat")
	self:ScheduleMethod(60, "timerMajorWaveRepeat")
	self:ScheduleMethod(90, "timerMajorWaveRepeat")
end

function mod:timerMajorWaveRepeat()
	timer = 30
	warnMajorWave:Schedule(timer)
	warnMajorWaveSoon:Schedule(timer-5)
	timerMajorWave:Start(timer)
	soundMajorWave:Schedule(timer)
end

function mod:phase2Transition()
	timer = 153
	warnPhase2:Schedule(timer)
	warnPhase2Soon:Schedule(timer-10)
	timerPhase2:Start(timer)
	soundPhase2:Schedule(timer)
	self:ScheduleMethod(timer, "phaseTwo")
end

function mod:phaseTwo()
	phase = 2	
	-----SHADE SPAWNS-----
	mod:timerNaxxShadeRepeat()
	mod:phase3Transition()
	timer = 34
	self:ScheduleMethod(timer, "timerNaxxShadeRepeat")
	self:ScheduleMethod(timer+60, "timerNaxxShadeRepeat")
	self:ScheduleMethod(timer+120, "timerNaxxShadeRepeat")
	-----HEALTH CHECK DEBUGS-----
	local shade1 = UnitGUID("boss1")
	local shade2 = UnitGUID("boss2")
	local shade3 = UnitGUID("boss3")
	local shade4 = UnitGUID("boss4")
	mod:checkHealth()
end

function mod:phase3Transition()
	timer = 378
	warnPhase3:Schedule(timer)
	warnPhase3Soon:Schedule(timer-10)
	timerPhase3:Start(timer)
	soundPhase3:Schedule(timer)
	self:ScheduleMethod(timer, "phaseThree")
end

function mod:phaseThree()
	phase = 3
	if self.Options.ShowRange then
		mod:RangeToggle()
	end
	timerBlast:Start(45)
	timerMana:Start(30)
	timerChains:Start(90)
end

function mod:timerNaxxShadeRepeat()
	if shadesSpawned == 0 then
		timer = 34
		warnNaxxShade:Schedule(timer)
		warnNaxxShadeSoon:Schedule(timer-10)
		soundNaxxShade:Schedule(timer)
		timerNaxxShade:Start(timer)
		shadesSpawned = shadesSpawned+1
	else
		timer = 60
		warnNaxxShade:Schedule(timer)
		warnNaxxShadeSoon:Schedule(timer-10)
		soundNaxxShade:Schedule(timer)
		timerNaxxShade:Start(timer)
		shadesSpawned = shadesSpawned+1
	end
end

function mod:SPELL_AURA_APPLIED(args)
	-----CONSTRICTING CHAINS-----
	if args:IsSpellID(1003114) then
		warnChains:Show(args.destName)
		if args.destName == UnitName("player") then
			soundChains:Play()
		end
	end
	-----HARVEST SOUL-----
	if args:IsSpellID(28679) then 
		if args:IsPlayer() then
			timer = 15
			warnHarvestSoon:Schedule(timer-5)
			warnHarvest:Schedule(timer)
			timerHarvest:Start(timer)
		end
	end
	-----SEEING RED-----
	if args:IsSpellID(1003255) then
		warnSeeingRed:Show()
	end
	-----GASTRIC AFFLICTION-----
	if args:IsSpellID(1003086) then
		warnGastric:Show(args.destName)
		if args.destName == UnitName("player") then
			specWarnGastric:Show()
			soundGastric:Play()
		end
	end
	-----VOID ZONE-----
	if args:IsSpellID(28865) then
		if args.destName == UnitName("player") then
			specWarnVoid:Show()
		end
	end
	-----DEATH AND DECAY-----
	if args:IsSpellID(1003113) then
		if args.destName == UnitName("player") then
			specWarnDnD:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	-----HARVEST SOUL-----
	if args:IsSpellID(28679) then 
		if args:IsPlayer() then
			timer = 15
			warnHarvestSoon:Schedule(timer-5)
			warnHarvest:Schedule(timer)
			timerHarvest:Start(timer)
		end
	end
	-----GASTRIC AFFLICTION-----
	if args:IsSpellID(1003086) then
		warnGastric:Show(args.destName)
		if args.destName == UnitName("player") then
			specWarnGastric:Show()
			soundGastric:Play()
		end
	end
	-----VOID ZONE-----
	if args:IsSpellID(28865) then
		if args.destName == UnitName("player") then
			specWarnVoid:Show()
		end
	end
	-----DEATH AND DECAY-----
	if args:IsSpellID(1003113) then
		if args.destName == UnitName("player") then
			specWarnDnD:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	----------SPELL TRACKING----------
	-----DISRUPTING SHOUT-----
	if args:IsSpellID(29107) then
		if notRealRazuv == 1 then
			timer = 16
			warnShout:Show()
			warnShoutSoon:Schedule(timer-5)
			timerShout:Start(timer)
			soundShout:Play()
		end
	-----WAIL OF SOULS-----
	elseif args:IsSpellID(1003115) then
		warnWailSoul:Show()
	-----FROST BLAST-----
	elseif args:IsSpellID(29879) then 
		warnBlast:Show()
		soundBlast:Play()
		timerBlast:Start(45)
	-----MANA DETONATION-----
	elseif args:IsSpellID(27819) then
		warnMana:Show()
		soundMana:Play()
		timerMana:Start(30)
	-----CHAINS-----
	elseif args:IsSpellID(28410) then
		warnChains:Show()
		soundChains:Play()
		timerChains:Start(90)
	end
end

function mod:UNIT_HEALTH(uId)
end

function mod:checkHealth()
end

function mod:spiderTimerRepeat()
	if maexx == 0 then
	else
		timer = 16
		timerSpider:Start(timer)
		soundSpider:Schedule(timer)
		self:ScheduleMethod(timer, "spiderTimerRepeat")
	end
end

function mod:RangeToggle(show)
	if show then
		DBM.RangeCheck:Show(10)
	else
		DBM.RangeCheck:Hide()
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