local mod	= DBM:NewMod("Maexxna", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15952)

mod:RegisterCombat("combat")

mod:EnableModel()

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"PLAYER_ALIVE",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)
-----WEB WRAP-----
local warnWebWrap			= mod:NewTargetAnnounce(28622, 2)
local timerWebWrapInitial	= mod:NewTimer(20, "Web Wrap", 28622)
local timerWebWrap			= mod:NewTimer(40, "Web Wrap", 28622)
local soundWebWrap			= mod:SoundAlert(28622)
-----WEB SPRAY-----
local warnWebSpraySoon		= mod:NewSoonAnnounce(29484, 1)
local warnWebSprayNow		= mod:NewSpellAnnounce(29484, 3)
local timerWebSpray			= mod:NewNextTimer(40, 29484)
local soundWebSpray			= mod:SoundAlarm(29484)
-----SPIDERLINGS-----
local timerSpiderInitial	= mod:NewTimer(8, "Spiderlings Spawn", 17332)
local timerSpider			= mod:NewTimer(16, "Spiderlings Spawn", 17332)
local soundSpider			= mod:SoundInfo(17332)

function mod:OnCombatStart(delay)
	self:ScheduleMethod(0, "getBestKill")
	warnWebSpraySoon:Schedule(35 - delay)
	timerWebSpray:Start(40 - delay)
	timerWebWrapInitial:Start(20-delay)
	timerSpiderInitial:Start(8 - delay)
	soundSpider:Schedule(8-delay)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L.Spiderlings) then
		timerSpider:Start()
		soundSpider:Schedule(16)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28622) then -- Web Wrap
		warnWebWrap:Show(args.destName)
		soundWebWrap:Play();
		timerWebWrap:Start()
		if args.destName == UnitName("player") then
			SendChatMessage(L.YellWebWrap, "YELL")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29484, 54125) then -- Web Spray
		warnWebSprayNow:Show()
		soundWebSpray:Play();
		warnWebSpraySoon:Schedule(35)
		timerWebSpray:Start()
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

---------- SPEED KILL FUNCTION ----------
local timerSpeedKill		= mod:NewTimer(0, "Fastest Kill", 48266)function mod:getBestKill()
	local bestkillTime = (mod:IsDifficulty("heroic5", "heroic25") and mod.stats.heroicBestTime) or mod:IsDifficulty("normal5", "heroic10") and mod.stats.bestTime
	timerSpeedKill:Show(bestkillTime)
end
---------- SPEED KILL FUNCTION ----------