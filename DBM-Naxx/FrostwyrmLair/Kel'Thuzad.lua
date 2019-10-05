local mod	= DBM:NewMod("Kel'Thuzad", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2574 $"):sub(12, -3))
mod:SetCreatureID(15990)
--mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
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
local warnWailSoul		= mod:NewTargetAnnounce(1003115, 2)
local soundWailSoul		= mod:SoundAlert(1003115)
-----PHASE 1 -> 2 TRANSITION-----
local warnPhase2		= mod:NewPhaseAnnounce(2, 3)
local warnPhase2Soon	= mod:NewPhaseSoonAnnounce(2, 3)
local timerPhase2		= mod:NewTimer(213, "Phase Two", 29485, nil, "Show timer for Phase Two")
local soundPhase2		= mod:SoundInfoLong(29485, "Play the 'Long Info' sound effect for Phase Two")
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
----------BOSS TRACKING----------
local anub
local faerlina
local maexx
local noth
local heigan
local loatheb
local razuv
local gothik
local horse
local patch
local grobb
local gluth
local thadd

local spiderHealth
local plagueHealth
local militaryHealth
local constructHealth

local spiderBoss
local plagueBoss
local militaryBoss
local constructBoss

local heiganDanceStart
----------MISC----------
local phase 			= 0
local shadesSpawned		= 0
local berserkTimer		= mod:NewBerserkTimer(1140)
-----CODE START-----
function mod:OnCombatStart(delay)
	mod:getBestKill()
	mod:phaseOne()
	berserkTimer:Start(1140)
end

function mod:phaseOne()
	phase = 1
	anub = 0
	faerlina = 0
	maexx = 0
	noth = 0
	heigan = 0
	loatheb = 0
	razuv = 0
	gothik = 0
	horse = 0
	patch = 0
	grobb = 0
	gluth = 0
	thadd = 0
	spiderBoss = 0
	plagueBoss = 0
	militaryBoss = 0
	constructBoss = 0
	heiganDanceStart = 0
	shadesSpawned = 0
	mod:phase2Transition()
end

function mod:timerMajorWaveRepeat()
	timer = 30
	warnMajorWave:Schedule(timer)
	warnMajorWaveSoon:Schedule(timer-5)
	timerMajorWave:Start(timer)
	soundMajorWave:Schedule(timer)
end

function mod:phase2Transition()
	timer = 213
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

function mod:timerNaxxShadeRepeat()
	if shadesSpawned == 0 then
		timer = 34
		warnNaxxShade:Schedule(timer)
		warnNaxxShadeSoon:Schedule(timer-10)
		soundNaxxShade:Schedule(timer)
		timerNaxxShade:Start(timer)
		shadesSpawned == shadesSpawned+1
	else
		timer = 60
		warnNaxxShade:Schedule(timer)
		warnNaxxShadeSoon:Schedule(timer-10)
		soundNaxxShade:Schedule(timer)
		timerNaxxShade:Start(timer)
		shadesSpawned == shadesSpawned+1
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
end

function mod:SPELL_CAST_SUCCESS(args)
	----------SPELL TRACKING----------
	-----DISRUPTING SHOUT-----
	if args:IsSpellID(29107) then
		timer = 16
		warnShout:Show()
		warnShoutSoon:Schedule(timer-5)
		timerShout:Start(timer)
		soundShout:Play()
	end
	-----WAIL OF SOULS-----
	if args:IsSpellID(1003115) then
		warnWailSoul:Show()
		soundWailSoul:Play()
	end
	if args:IsSpellID(29107) then
		warnShout:Show()
		warnShoutSoon:Schedule(timer-5)
		timerShout:Start(timer)
		soundShout:Play()
	end
	----------BOSS CHECKING TOOLS----------
	-----ANUB-----
	if args:IsSpellID(28783) and args:sourceGUID(shade1) and spiderBoss == 0 then
		spiderBoss = 1
		anub = 1
	elseif args:IsSpellID(28783) and args:sourceGUID(shade2) and spiderBoss == 0 then
		spiderBoss = 2
		anub = 2
	elseif args:IsSpellID(28783) and args:sourceGUID(shade3) and spiderBoss == 0 then
		spiderBoss = 3
		anub = 3
	elseif args:IsSpellID(28783) and args:sourceGUID(shade4) and spiderBoss == 0 then
		spiderBoss = 4
		anub = 4
	end
	-----NOTH-----
	if args:IsSpellID(29213) and args:sourceGUID(shade1) and plagueBoss == 0 then
		plagueBoss = 1
		noth = 1
	elseif args:IsSpellID(29213) and args:sourceGUID(shade2) and plagueBoss == 0 then
		plagueBoss = 2
		noth = 2
	elseif args:IsSpellID(29213) and args:sourceGUID(shade3) and plagueBoss == 0 then
		plagueBoss = 3
		noth = 3
	elseif args:IsSpellID(29213) and args:sourceGUID(shade4) and plagueBoss == 0 then
		plagueBoss = 4
		noth = 4
	end
	-----RAZUVIOUS-----
	if args:IsSpellID(29107) and args:sourceGUID(shade1) and militaryBoss == 0 then
		militaryBoss = 1
		razuv = 1
	elseif args:IsSpellID(29107) and args:sourceGUID(shade2) and militaryBoss == 0 then
		militaryBoss = 2
		razuv = 2
	elseif args:IsSpellID(29107) and args:sourceGUID(shade3) and militaryBoss == 0 then
		militaryBoss = 3
		razuv = 3
	elseif args:IsSpellID(29107) and args:sourceGUID(shade4) and militaryBoss == 0 then
		militaryBoss = 4
		razuv = 4
	end
	-----PATCHWERK-----
	if args:IsSpellID(28308) and args:sourceGUID(shade1) and constructBoss == 0 then
		constructBoss = 1
		patch = 1
	elseif args:IsSpellID(28308) and args:sourceGUID(shade2) and constructBoss == 0 then
		constructBoss = 2
		patch = 2
	elseif args:IsSpellID(28308) and args:sourceGUID(shade3) and constructBoss == 0 then
		constructBoss = 3
		patch = 3
	elseif args:IsSpellID(28308) and args:sourceGUID(shade4) and constructBoss == 0 then
		constructBoss = 4
		patch = 4
	end
end

function mod:UNIT_HEALTH(uId)
	if phase == 2 then
		-----SPIDER WING-----
		if spiderBoss == 1 then
			spiderHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif spiderBoss == 2 then
			spiderHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif spiderBoss == 3 then
			spiderHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif spiderBoss == 4 then
			spiderHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----PLAGUE WING-----
		if plagueBoss == 1 then
			plagueHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif plagueBoss == 2 then
			plagueHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif plagueBoss == 3 then
			plagueHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif plagueBoss == 4 then
			plagueHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----MILITARY WING-----
		if militaryBoss == 1 then
			militaryHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif militaryBoss == 2 then
			militaryHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif militaryBoss == 3 then
			militaryHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif militaryBoss == 4 then
			militaryHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----CONSTRUCT WING-----
		if constructBoss == 1 then
			constructHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif constructBoss == 2 then
			constructHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif constructBoss == 3 then
			constructHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif constructBoss == 4 then
			constructHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
	end
end

function mod:checkHealth()
	self:ScheduleMethod(1, checkHealth)
	-----SPIDER WING-----
	if spiderHealth < 67 then
		anub = spiderBoss
	elseif spiderHealth > 67 and spiderHealth < 34 then
		anub = 0 
		faerlina = spiderBoss
	elseif spiderHealth > 34 and spiderHealth < 1 then
		faerlina = 0
		maexx = spiderBoss
		timer = 8
		timerSpider:Start(timer)
		soundSpider:Schedule(timer)
		self:ScheduleMethod(timer, "spiderTimerRepeat)
	elseif spiderHealth == 0 then
		maexx = 0
	end
	-----PLAGUE WING-----
	if plagueHealth < 67 then
		noth = plagueBoss
	elseif plagueHealth > 67 and plagueHealth < 34 then
		noth = 0 
		heigan = plagueBoss
		if heiganDanceStart == 0 then
			heiganDanceStart = 1
			timer = 21
			timerDance:Start(timer)
			warnDance:Schedule(timer)
			warnDanceSoon:Schedule(timer-5)
			soundDance:Schedule(timer)
		end		
	elseif plagueHealth > 34 and spiderHealth < 1 then
		heigan = 0
		loatheb = plagueBoss
	elseif plagueHealth == 0 then
		loatheb = 0
	end
	-----MILITARY WING-----
	if militaryHealth < 67 then
		razuv = militaryBoss
	elseif militaryHealth > 67 and militaryHealth < 34 then
		razuv = 0 
		gothik = militaryBoss
		timer = 15
		warnHarvestSoon:Schedule(timer-5)
		warnHarvest:Schedule(timer)
		timerHarvest:Start(timer)
	elseif militaryHealth > 34 and militaryHealth < 1 then
		gothik = 0
		horse = militaryBoss
		warnHarvestSoon:Cancel()
		warnHarvest:Cancel()
		timerHarvest:Stop()
	elseif militaryHealth == 0 then
		horse = 0
	end
	-----CONSTRUCT WING-----
	if constructHealth < 75 then
		patch = constructBoss
	elseif constructHealth > 75 and constructHealth < 50 then
		patch = 0 
		grobb = constructBoss
	elseif constructHealth > 50 and constructHealth < 25 then
		grobb = 0 
		gluth = constructBoss
	elseif constructHealth > 25 and constructHealth < 1 then
		gluth = 0
		thadd = constructBoss
	elseif constructHealth == 0 then
		thadd = 0
	end
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

---------- TBM FUNCTIONS ----------
function mod:OnCombatEnd(wipe)
	self:Stop();
	phase = 0
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end
---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)
function mod:getBestKill()	
local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------