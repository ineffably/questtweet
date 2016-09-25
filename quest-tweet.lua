-- ===========================================================================
-- = Quest Tweet.lua Version 7.0.2
-- ===========================================================================
-- = by Wizwonk, Gigantomancer
-- =
-- = Credits: The inspiration came from FastQuest Classic
-- = Thanks goes to:
-- =  My Brother who through contunious updates helped me with 
-- =  features and bugs.
-- =  Gold Tracker developer : I derived my commenting scheme from you, well done.  
-- =
-- = P.S: 
-- =  Hi, I am also Wizwonk, but, I lost my old curse account when I 
-- =  let my domain lapse and my email expired. 
-- =  This is a continuation of Quest Spam: 
-- =  https://mods.curse.com/addons/wow/questspam
-- =  When (if) curse respolves my ticket, I'll forward Quest Spam to Quest Tweet
-- =
-- ===========================================================================

-- ========= Changes =========================================================
-- v0.2.1 Nov 06, 2008  alpha stage, basic features in place, but has no options menu
-- v0.2.2 Nov 08, 2008  Options Menu added and functional
-- v0.3.0 Nov 09, 2008  FIX: QuestComplete XP calculated post turn-in
--						FIX: Moved some rogue loc text into the loctext file
-- v1.0.1 Nov 18, 2008  FIX: Debug mode now defaulted to off.
-- v1.1.0 Dec 27, 2011  UPDATE: Update to newest version of wow and prepping for re-release.
-- v1.2.0 Feb 23, 2014  UPDATE: Update to wow version 5.4.
-- v1.2.1 Feb 26, 2014  UPDATE: New Quests are now links; Streamlined text values
-- v7.0.0 Sep 19, 2016  UPDATE: Renamed Quest Spam to Quest Tweet
--                              Fixed updated breaking changes to ui_info_message parameters

-- ========= Globals =========================================================
QS_DEBUG = false;
QuestTweetLog = {};
QuestTweetPref = {};
SLASH_QuestTweet1 = "/questtweet";
SLASH_QuestTweet2 = "/qtweet";
QuestTweetLastMsg = "";
local QSVer = GetAddOnMetadata("quest-tweet", "Version");

-- ========= Flags ===========================================================
QS_VariablesLoaded  = false;
QS_OptionsLoaded    = false;
QS_IsTestOn         = false;

-- ========= Frames ==========================================================
QuestTweet = CreateFrame("Button");
QuestTweet:Hide();
QuestTweet.questComplete = 
{ 
	xpgained = "", 
	iscompleted = false,
}

QuestTweet:SetFrameStrata("TOOLTIP")

-- ========= Defaul Preferences ==============================================
QuestTweetBasePref =
{
	["Version"]     = QSVer,
	["on"] 			= true,
	["party"]		= true,
	["raid"] 		= false,
	["guild"] 		= false,
	["channel"] 	= false,
	["channelid"] 	= "",
	["local"] 		= false,
	["achievement"] = true,
	["details"] 	= true,
	["discovery"] 	= true,
	["questxp"]     = true,
	["levelup"]		= true,
	["killxp"]		= false,    -- TODO: hanlde rested : Ashenvale Bear dies, you gain 270 experience (+135 exp Rested Bonus)
	["debug"]		= false,
  ["professions"] = true, 
  ["debugchannel"] = "qtdebug"
};

if ( QS_DEBUG ) then
	QuestTweetPref = { ["debug"] = QS_DEBUG, };
end


-- ========= Functions and Handlers ==========================================

-- ===========================================================================
-- NAME : QSTrace(msg)
-- DESC : Logs a message to the DEFAULT_CHAT_FRAME for debug purposes
-- PARAMS
-- msg  : string : message to send to the DEFAULT_CHAT_FRAME
-- ===========================================================================
function QSTrace(msg)
	if (QuestTweetPref["debug"]) then
		QuestTweetLog[#QuestTweetLog+1] = msg;
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa11[QS]:" .. msg);
	end
end

QSTrace("Ver : " .. QSVer);
-- ===========================================================================
-- NAME : QSError(msg)
-- DESC : Sends any lua error messages to the DEFAULT_CHAT_FRAME
-- PARAMS
-- msg  : string : error message
-- ===========================================================================
function QSError(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffff0000!QSERR:" .. msg);
end

-- native: this will setup the error event handler
seterrorhandler(QSError);  

-- ===========================================================================
-- NAME : QuestTweet_Chat(msg)
-- DESC : Used for sending confirmation to the DEFAULT_CHAT_FRAME
-- ===========================================================================
function QuestTweet_Chat(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffffff" .. msg);
end

-- Sets up a quick command Chat for sending feedback/confirmation
local Chat = QuestTweet_Chat;

-- ===========================================================================
-- NAME : QuestTweet:TogglePrefFlag(flagname)
-- DESC : Used for sending confirmation to the DEFAULT_CHAT_FRAME
-- PARAMS
-- flagname : string : flag that you would like to toggle
-- ===========================================================================
function QuestTweet:TogglePrefFlag(flagname)
	-- Ensure that we have a correct flagname
	if (QuestTweetPref[flagname] ~= nil) and (type(QuestTweetPref[flagname]) == "boolean" ) then
		QuestTweetPref[flagname] = (not QuestTweetPref[flagname]);
	end
end

-- ===========================================================================
-- NAME : QuestTweet:SpamMessage(msg,event)
-- DESC : This does the spamming and sends the messages to the correct location
-- PARAMS
-- msg   : string : The message that that will be spammed
-- event : string : The event is the reason the message was spammed (optional)
-- ===========================================================================
function QuestTweet:SpamMessage(msg,event)
	QuestTweetLastMsg = msg; -- This is mainly for test purposes
	local SendChat = SendChatMessage;
	if (QS_IsTestOn) then
    if (QuestTweetPref["debugchannel"]) then
      local id, name = GetChannelName(QuestTweetPref["debugchannel"]);
      if (id > 0 and name ~= nil) then
        msg = msg or ""
        SendChat(msg, "CHANNEL", nil, id);
      end
    else 
      SendChat = function(chatmsg)
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. msg);
      end
    end
	end

	if (msg and QuestTweetPref["on"]) then
		if (QuestTweetPref["local"]) then
			SendChat(msg, "SAY");
		end
		if (QuestTweetPref["party"] and GetNumGroupMembers() > 0 ) then
			SendChat(msg, "PARTY");
		end
		if (QuestTweetPref["raid"] and GetNumGroupMembers() > 0) then
			SendChat(msg, "RAID");
		end
		if (QuestTweetPref["guild"]) then
			SendChat(msg, "GUILD");
		end
		if (QuestTweetPref["channel"]) then 
			local id, name = GetChannelName(QuestTweetPref["channelid"]);
			if (id > 0 and name ~= nil) then
			  SendChat(msg, "CHANNEL", nil, id);
			end
			-- TODO: Achievements will have seperate rules for where they are spammed.
			-- It's cool to send your Achievment to your party so you can link it to them
			if (event and event == "ACHIEVEMENT_EARNED" and not QuestTweetPref["party"] and GetNumGroupMembers() > 0 ) then
			  SendChat(msg, "PARTY");
			end
		end
	end
end

-- ===========================================================================
-- NAME : QuestTweet:ParseMessage(msg)
-- DESC : This is used to parse the UI_INFO_MESSAGE to determine if it's worth sending
-- PARAMS
-- msg   : string : The message that that will be parsed
-- ===========================================================================
function QuestTweet:ParseMessage(msg)
	for index, value in pairs(QUESTTWEET_UI_INFO_MATCH) do
		if ( string.find(msg, value) ) then
			-- nice to have some bools hanging around for later usage
			local questAccepted = (value == QUESTTWEET_UI_INFO_MATCH[4]);
			local questxp = (value == QUESTTWEET_UI_INFO_MATCH[5]);
			local discovery = (value == QUESTTWEET_UI_INFO_MATCH[6]);
			local killxp = (value == QUESTTWEET_UI_INFO_MATCH[7]);

			-- Early return if the option is not enabled
			if (questxp and not QuestTweetPref["questxp"]) then 
				break;
			elseif (discovery and not QuestTweetPref["discovery"]) then
				break;
			elseif (killxp and not QuestTweetPref["killxp"]) then
				break;
			else
				if (questAccepted) then
					break;
				end
				
				if (questxp) then
					QuestTweet.questComplete.xpgained = string.gsub(msg,QUESTTWEET_EXP_GAINED,"%1");
					QuestTweet.questComplete.iscompleted = true;
					break;
				end

				if (killxp) then
					-- Lets change the message so it's shorter
          -- QUESTTWEET_KILLEXP_MESSAGE = "kills %1 for %2 exp";
          -- QUESTTWEET_KILLEXP_MATCH = "^(.*) dies, you gain (.*) experience(.*)";
					msg = string.gsub(msg,QUESTTWEET_KILLEXP_MATCH,QUESTTWEET_KILLEXP_MESSAGE);
				end
				
				-- TODO: maybe I should setup another variable to be safe?
				-- the message sent (msg) is modified at this point; 
				QuestTweet:SpamMessage(msg);
			end
			break;
		end
	end
end


-- ===========================================================================
-- NAME : QuestTweet:OnEvent(event, message)
-- DESC : Event handling
-- PARAMS
-- event   : string : The event string (enum)
-- message : string : The message sent by the event
-- ===========================================================================
function QuestTweet:OnEvent(event, message, arg2, arg3)
	-- for debugging
	if (QuestTweetPref["debug"] and event ~= nil) then
		local msg = message or "";
		local arg2 = arg2 or "";
		local arg3 = arg3 or "";
		QSTrace("OnEvent:(" .. event .. "; " .. msg .. "; " .. arg2 .. "; " .. arg3 .. ")");
  end
  
	-- initialize QuestTweet
	if event == "VARIABLES_LOADED" then
		self:Initialize();
		--TODO: Is there a more elegant way of handling the options menu loading out of sync?
		QS_VariablesLoaded = true;
		if ( QuestTweetOptionsFrame ~= nil and not QS_OptionsLoaded) then
			QuestTweetLoadOptionValues();
		end
	end

	if (message and QuestTweetPref["on"]) then
		if (event == "UI_INFO_MESSAGE") then
      -- Quest Progress:
      -- breaking changes happened with ui_info_message recently it seems
      -- arg1 (message) is now an id of sorts, arg2 is the message
      local infoMessage = message;
      if (arg2) then
        infoMessage = arg2;
      end
			local uQuestText = gsub(infoMessage, QUESTTWEET_QUESTTEXT, "%1", 1);
			if ( uQuestText ~= infoMessage) then
				if (QuestTweetPref["details"]) then
					QuestTweet:SpamMessage(infoMessage);
				end
			else
				QuestTweet:ParseMessage(infoMessage);
			end	
		end

    if (event == "CHAT_MSG_SKILL" and QuestTweetPref["professions"]) then
      local profmsg = gsub(message, QUESTTWEET_SKILL_MATCH, QUESTTWEET_SKILL_TEXT)
      QuestTweet:SpamMessage(profmsg);
    end

		if (event == "QUEST_ACCEPTED") then
			-- QUEST_WATCH_UPDATE
			local questLink = GetQuestLink(message);
			QuestTweet:SpamMessage(string.format("New Quest: %s", questLink));
		end

		if (event == "CHAT_MSG_COMBAT_XP_GAIN") then
			QuestTweet:ParseMessage(message);
		end

		if (event == "PLAYER_XP_UPDATE" and QuestTweet.questComplete.iscompleted) then
			QuestTweet:ShowExperience();
		end

		if (event == "ACHIEVEMENT_EARNED") then
			QuestTweet:ShowAchievement(message);
		end
		
		if (event == "PLAYER_LEVEL_UP" and QuestTweetPref["levelup"]) then
			-- message will be the new level #
			QuestTweet:SpamMessage(string.format(QUESTTWEET_LEVELUPMESSAGE,message));
		end
		
		if (event == "CHAT_MSG_SYSTEM") then
			QuestTweet:ParseMessage(message);
		end
	end
end

-- ===========================================================================
-- NAME : QuestTweet:ShowAchievement()
-- DESC : This will spam with the latest or current achievement and link.
-- PARAMS
-- achievementId   : string : The achievementid that you want info about, if not sent, the latest achievement will be used
-- ===========================================================================
function QuestTweet:ShowAchievement(achievementId)
	-- New Achievement! [Murloc Hater] for 10 pts for total of 20 Achievements at 200 pts
	-- TODO: Use string.format instead of concatenation
	local ach1,ach2,ach3,ach4,ach5;
	local messageFormat = QUESTTWEET_ACHIEVEMENT_MESSAGE;

	if (achievementId == nil) then
		ach1,ach2,ach3,ach4,ach5 = GetLatestCompletedAchievements();
		achievementId = ach1;
		messageFormat = QUESTTWEET_LATESTACHIEVEMENT .. QUESTTWEET_ACHIEVEMENT_MESSAGE;
	end
	
	local IDNumber, Title, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(achievementId);
	local achievementLink = GetAchievementLink(achievementId) or Title or string.format("[unknown $s",tostring(achievementId));
	local achTotal, achCompleted = GetNumCompletedAchievements();
	
	QuestTweet:SpamMessage(string.format(messageFormat,achievementLink,(Points or 0),tostring(achCompleted),tostring(GetTotalAchievementPoints())));
end



-- ===========================================================================
-- NAME : QuestTweet:ShowExperience()
-- DESC : Called when the PLAYER_XP_UPDATE event occurs and quest completed
-- ===========================================================================
function QuestTweet:ShowExperience()
	-- This allows me to show the percentage of the current level when you turn in a quest
	-- TODO: possible feature is choosing to show percent to next level
	local messagePrefix = ""; 
	local nextLevel = UnitLevel("player")+1
	if nextLevel > 80 then nextLevel = 80 end
	local totalXP = UnitXPMax("player");
	local currentXP = UnitXP("player");
	local toLevelXP = totalXP - currentXP;
	local currentXPPercent = math.floor(currentXP / totalXP * 10000) / 100;
	local toLevelXPPercent = math.floor(toLevelXP / totalXP * 10000) / 100;
	
	if QuestTweet.questComplete.iscompleted then
		-- Message : Gained 50 XP and is at 40% of level 3
		messagePrefix = string.format(QUESTTWEET_EXP_MESSAGE_1, QuestTweet.questComplete.xpgained);
		QuestTweet.questComplete.iscompleted = false;
	end

	local messageFormat = string.format(QUESTTWEET_EXP_MESSAGE_2,messagePrefix, tostring(currentXPPercent),tostring(UnitLevel("player")));
	QuestTweet:SpamMessage(messageFormat);

end

-- ===========================================================================
-- NAME : QuestTweet:Initialize()
-- DESC : Called when the VARIABLES_LOADED event occurs
-- ===========================================================================
function QuestTweet:Initialize()
	QSTrace("Starting log at position:" .. #QuestTweetLog .. " : " .. UnitName("player"));

	QuestTweet:LoadDefaults();
	
	-- Welcome Message ; Also good for knowing if QSpam was loaded (!Swatter can knock error message out)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffaa11Quest Tweet " .. QuestTweetPref["Version"] .. " loaded");


	-- Register / Unregister for events
	self:UnregisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("ACHIEVEMENT_EARNED");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("PLAYER_XP_UPDATE");
	self:RegisterEvent("QUEST_ACCEPTED");
	self:RegisterEvent("QUEST_COMPLETE");
	self:RegisterEvent("QUEST_FINISHED");
	self:RegisterEvent("QUEST_ITEM_UPDATE");
	self:RegisterEvent("QUEST_PROGRESS");
	self:RegisterEvent("CHAT_MSG_SKILL");
	-- self:RegisterEvent("QUEST_WATCH_UPDATE");
	-- self:RegisterEvent("QUEST_GREETING");
	-- self:RegisterEvent("QUEST_LOG_UPDATE");
	-- self:RegisterEvent("UNIT_PET");
	-- self:RegisterEvent("UNIT_PET_EXPERIENCE");
	-- self:RegisterEvent("PET_BATTLE_CAPTURED");
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
	self:RegisterEvent("UI_INFO_MESSAGE");
end

-- ===========================================================================
-- NAME : QuestTweet:LoadDefaults()
-- DESC : This will reload the default values into the current global
-- ===========================================================================
function QuestTweet:LoadDefaults()
	-- Setup Defaults
	for key, def in pairs(QuestTweetBasePref) do
		if QuestTweetPref[key] == nil then
		  QuestTweetPref[key] = def
		end
	end

	if (QSVer ~= QuestTweetPref["Version"]) then
		-- Do version updates here
        QSTrace("Verion Updated to " .. QSVer);
		QuestTweetPref["Version"] = QSVer;
	end

	QuestTweetPref["debug"] = QS_DEBUG;

end

-- ===========================================================================
-- NAME : anonymous function(text)
-- DESC : Slash handler for slash commands
-- ===========================================================================
SlashCmdList["QuestTweet"] = function(text)
	if (text) then
		-- TODO: single commands only right now, need to update to multiple commands
		local cmd = gsub(text, "%s*([^%s]+).*", "%1");
		QSTrace("CMD:"..cmd);
		
		-- automatic handling of toggle parameters
		for key, def in pairs(QuestTweetPref) do
			if (cmd == key and type(QuestTweetPref[key]) == "boolean" ) then
				QuestTweet:TogglePrefFlag(cmd);
				Chat(cmd .. " is now : " .. tostring(QuestTweetPref[cmd]));
				QuestTweetLoadOptionValues();
			end
		end

		-- handler for the channel id
		-- TODO: Determine if I can set channels by name.
		if (cmd == "channelid") or (cmd == "spamchannelid") then
			local trychannelid = gsub(text, cmd .. "%s*([^%s]+).*", "%1");
			QSTrace("Trying to set channel: " .. trychannelid);
			if gsub(text, cmd .. "%s*([^%s]+).*", "%1") then
				QuestTweetPref["channelid"] = trychannelid;
				Chat(cmd .. " is now : " .. tostring(QuestTweetPref["channelid"]));
				QuestTweetLoadOptionValues();
			end
		end

		if (cmd == "stats") then
			QuestTweet:ShowExperience();	
			QuestTweet:ShowAchievement(nil);	
		end
		
		if (cmd == "forcereset") then
			QuestTweetForceReset();	
		end

		if (cmd == "test") then
			QuestTweetRunTests();
		end

		if (cmd == "realtest") then
			QuestTweetRunTests("real");
		end

		if (cmd == "xp") then
			QuestTweet:ShowExperience();
		end
		
		-- The help message
		-- TODO: I need a better help message
		if (cmd == "" or cmd == "status") then
			Chat("Quest Tweet Status");
			for key, def in pairs(QuestTweetPref) do
				Chat("qtweet " .. string.lower(key) .. " = " .. tostring(QuestTweetPref[key]));
			end
		end

	end
end

-- ===========================================================================
-- NAME : QuestTweet_RunTests()
-- DESC : This will run my test cases for messaging
-- ===========================================================================
function QuestTweetRunTests(val)
	if(val ~= "real") then
		QS_IsTestOn = true;
	end
	QSTrace("Start Tests");

	QSTrace("TEST : Quest Accepted");
	QuestTweet:OnEvent("CHAT_MSG_SYSTEM", "Quest accepted: Healing the Lake");

	QSTrace("TEST : Quest Completed");
	QuestTweet:OnEvent("CHAT_MSG_SYSTEM", "Investigate Echo Ridge completed.");
	QuestTweet:OnEvent("CHAT_MSG_SYSTEM", "Volatile Mutations completed.");

	QSTrace("TEST : Quest exp");
	QuestTweet:OnEvent("CHAT_MSG_SYSTEM", "Experience gained: 170.");

	QSTrace("TEST : Discovery");
	QuestTweet:OnEvent("UI_INFO_MESSAGE", 368, "Discovered: Echo Ridge Mine");

	QSTrace("TEST : Leveling");
	QuestTweet:OnEvent("PLAYER_LEVEL_UP", "20");
	QuestTweet:OnEvent("PLAYER_LEVEL_UP", "50");

	QSTrace("TEST : QuestProgress");
	QuestTweet:OnEvent("UI_INFO_MESSAGE", 286, "Kobold Workers slain: 1/10");
	QuestTweet:OnEvent("UI_INFO_MESSAGE", 286, "Kobold Workers slain: 2/10");
	QuestTweet:OnEvent("UI_INFO_MESSAGE", 286, "Kobold Workers slain: 10/10");

	QSTrace("TEST : Combat exp");
	QuestTweet:OnEvent("CHAT_MSG_COMBAT_XP_GAIN", "Vale Moth dies, you gain 26 experience.");
	QuestTweet:OnEvent("CHAT_MSG_COMBAT_XP_GAIN", "Ashenvale Bear dies, you gain 270 experience (+135 exp Rested Bonus)");

	QSTrace("TEST : Achievement");
	QuestTweet:OnEvent("ACHIEVEMENT_EARNED", "1017");

	QSTrace("TEST : Professions");
	QuestTweet:OnEvent("CHAT_MSG_SKILL", "Your skill in Herbalism has increased to 62");
  
	QSTrace("End Tests");
	QS_IsTestOn = false;
end

-- ===========================================================================
-- NAME : QuestTweetForceReset()
-- DESC : This will force a reset on the preferences and log
-- ===========================================================================
function QuestTweetForceReset()
	QuestTweetLog = {};
	QuestTweetPref ={};
	QuestTweet:LoadDefaults();
	Chat("Log Cleared and Defaults Reset");
end

-- ========= Register Events  ================================================
QuestTweet:RegisterEvent("VARIABLES_LOADED");
QuestTweet:SetScript("OnEvent", QuestTweet.OnEvent);
