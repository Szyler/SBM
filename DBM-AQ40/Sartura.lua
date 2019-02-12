local mod	= DBM:NewMod("Sartura", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15516)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

-----MISC TIMERS-----
local berserkTimer				= mod:NewBerserkTimer(360)
local kickAnnounce				= mod:NewSpellAnnounce(1766, 4)
local meleeOut					= mod:NewAnnounce("MELEE OUT - MELEE OUT", 4)
-----PREWARNINGS-----
local prewarnSTranslocation		= mod:NewAnnounce("Song of Translocation Soon", 3)
local prewarnDTranslocation		= mod:NewAnnounce("Dance of Translocation Soon", 3)
local prewarnSColossus			= mod:NewAnnounce("Song of The Colossus Soon", 3)
local prewarnDHaste				= mod:NewAnnounce("Dance of Haste Soon", 3)
local prewarnSOppression		= mod:NewAnnounce("Song of Oppression Soon", 3)
local prewarnDHunt				= mod:NewAnnounce("Dance of The Hunt Soon", 3)
local prewarnSDeath				= mod:NewAnnounce("Song of Death Soon", 3)
-----ALERTS-----
local warnSTranslocation		= mod:NewSpellAnnounce(1002345, 2)
local warnDTranslocation		= mod:NewSpellAnnounce(1002323, 2)
local warnSColossus				= mod:NewSpellAnnounce(1002346, 2)
local warnDHaste				= mod:NewSpellAnnounce(1002324, 2)
local warnSOppression			= mod:NewSpellAnnounce(1002347, 2)
local warnDHunt					= mod:NewSpellAnnounce(1002325, 2)
local warnSDeath				= mod:NewSpellAnnounce(1002348, 2)
-----TIMERS-----
local timerStacks				= mod:NewTimer(60, "Time Remaining: Stacks")
local timerSongRemaining		= mod:NewTimer(17, "Time Remaining: Song")
local timerDanceRemaining		= mod:NewTimer(17, "Time Remaining: Dance")
local timerSTranslocation		= mod:NewCDTimer(30, 1002345)
local timerDTranslocation		= mod:NewCDTimer(30, 1002323)
local timerSColossus			= mod:NewCDTimer(30, 1002346)
local timerDHaste				= mod:NewCDTimer(30, 1002324)
local timerSOppression			= mod:NewCDTimer(30, 1002347)
local timerDHunt				= mod:NewCDTimer(30, 1002325)
local timerSDeath				= mod:NewCDTimer(30, 1002348)
-----SOUND-----
local soundMelee				= mod:NewSound(1002347)
local soundKick					= mod:NewSound2(1766)
local castNumber
-----PREWARNING FUNCTIONS-----
function mod:preSTranslocation()
	prewarnSTranslocation:Show()
end
function mod:preDTranslocation()
	prewarnDTranslocation:Show()
end
function mod:preSColossus()
	prewarnSColossus:Show()
end
function mod:preDHaste()
	prewarnDHaste:Show()
end
function mod:preSOppression()
	prewarnSOppression:Show()
end
function mod:preDHunt()
	prewarnDHunt:Show()
end
function mod:preSDeath()
	prewarnSDeath:Show()
end

-----ALERT FUNCTIONS-----
function mod:alertSTranslocation()
	warnSTranslocation:Show()
end
function mod:alertDTranslocation()
	warnDTranslocation:Show()
end
function mod:alertSColossus()
	warnSColossus:Show()
end
function mod:alertDHaste()
	warnDHaste:Show()
end
function mod:alertSOppression()
	warnSOppression:Show()
end
function mod:alertDHunt()
	warnDHunt:Show()
end
function mod:alertSDeath()
	warnSDeath:Show()
end

-----MISC FUNCTIONS-----
function mod:alarmSound()
	soundKick:Play()
end
function mod:kickThisCunt()
	kickAnnounce:Show()
end
function mod:runBitch()
	soundMelee:Play()
	meleeOut:Show()
end

-----ACTUAL FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "initialSarturaCast")
	self:ScheduleMethod(0, "getBestKill")
	castNumber = 0
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(1002345) then --Song of Translocation
		self:ScheduleMethod(0, "sotCast")
		mod:alarmSound()
		mod:kickThisCunt()		
		if castNumber == 0 then
			castNumber = castNumber+1
		elseif castNumber == 7 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002323) then --Dance of Translocation
		self:ScheduleMethod(0, "dotCast")
		mod:alarmSound()
		mod:kickThisCunt()
		if castNumber == 1 then
			castNumber = castNumber+1
		elseif castNumber == 8 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002346) then --Song of the Colossus
		self:ScheduleMethod(0, "socCast")
		if castNumber == 2 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		elseif castNumber == 9 then
			castNumber = castNumber+1 
			mod:runBitch()
		end
	elseif args:IsSpellID(1002324) then --Dance of Haste
		self:ScheduleMethod(0, "dohCast")
		if castNumber == 3 then
			castNumber = castNumber+1
		elseif castNumber == 10 then
			castNumber = castNumber+1
		end
	elseif args:IsSpellID(1002347) then --Song of Oppression
		self:ScheduleMethod(0, "sooCast")
		if castNumber == 4 then
			castNumber = castNumber+1
			mod:runBitch()
		elseif castNumber == 11 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	elseif args:IsSpellID(1002325) then --Dance of the Hunt
		self:ScheduleMethod(0, "dothCast")
		if castNumber == 5 then
			castNumber = castNumber+1
		elseif castNumber == 12 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	elseif args:IsSpellID(1002348) then --Song of Death
		self:ScheduleMethod(0, "sodCast")
		mod:alarmSound()
		mod:kickThisCunt()
		if castNumber == 6 then
			castNumber = castNumber+1
		elseif castNumber == 13 then
			castNumber = castNumber+1
			mod:alarmSound()
			mod:kickThisCunt()
		end
	end
end

function mod:initialSarturaCast()
	local timer1 = 10
	timerSTranslocation:Start(timer1)
	self:ScheduleMethod(timer1-5, "preSTranslocation")
	self:ScheduleMethod(timer1, "alertSTranslocation")
end

function mod:sodCast()
	local timer1 = 25
	timerSTranslocation:Start(timer1)
	self:ScheduleMethod(timer1-5, "preSTranslocation")
	self:ScheduleMethod(timer1, "alertSTranslocation")
end

function mod:sotCast()
	local timer2 = 25
	timerDTranslocation:Start(timer2)
	self:ScheduleMethod(timer2-5, "preDTranslocation")
	self:ScheduleMethod(timer2, "alertDTranslocation")
end

function mod:dotCast()
	local timer3 = 25
	timerSColossus:Start(timer3)
	self:ScheduleMethod(timer3-5, "preSColossus")
	self:ScheduleMethod(timer3, "alertSColossus")
end

function mod:socCast()
	local timer4 = 25
	timerDHaste:Start(timer4)
	self:ScheduleMethod(timer4-5, "preDHaste")
	self:ScheduleMethod(timer4, "alertDHaste")
end

function mod:dohCast()
	local timer5 = 25
	timerDanceRemaining:Start()
	timerSOppression:Start(timer5)
	self:ScheduleMethod(timer5-5, "preSOppression")
	self:ScheduleMethod(timer5, "alertSOppression")
end

function mod:sooCast()
	local timer6 = 25
	timerSongRemaining:Start()	
	timerDHunt:Start(timer6)
	self:ScheduleMethod(timer6-5, "preDHunt")
	self:ScheduleMethod(timer6, "alertDHunt")
end

function mod:dothCast()
	local timer7 = 25
	timerDanceRemaining:Start()
	timerSDeath:Start(timer7)
	self:ScheduleMethod(timer7-5, "preSDeath")
	self:ScheduleMethod(timer7, "alertSDeath")
end

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(5, "Fastest Kill")
function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------