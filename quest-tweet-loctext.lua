-- ============================================================================
-- = Localized Text for Quest Tweet
-- ============================================================================

-- ========== English : =======================================================

-- ========== Spam Templates and Detectors ====================================
QUESTTWEET_UI_INFO_MATCH = {	                            -- UI_INFO_MESSAGE 
	"^(.+): %s*[-%d]+%s*/%s*[-%d]+%s*$",				-- Credits: Some of this was derived from Fast Quest Classic; Kudos and thanks
	"^(.+)[^Trade]completed.$",							-- 
	"^(.+)\(Complete\)$",								-- 
	"^Quest accepted: .+$",								-- 
	"^Experience gained: .+$",							-- 
	"^Discovered: .+$",									-- 
	"^(.+)dies, you gain(.+)$",							-- Mutated Owlkin dies, you gain 65 experience. "^(.*) dies, you gain (.*)
	"^Received item: .+$",								-- 
}

-- ========== Quest Tweet Messaging Templates ==================================
QUESTTWEET_QUESTTEXT = "(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$";
QUESTTWEET_QUESTPROGRESS = "Progress: ";
QUESTTWEET_LEVELUPMESSAGE = "{star}{star} DING!! LEVEL %s! {star}{star}";
QUESTTWEET_KILLEXP_MESSAGE = "kills %1 for %2 exp {skull}";
QUESTTWEET_KILLEXP_MATCH = "^(.*) dies, you gain (.*) experience(.*)";
QUESTTWEET_ACHIEVEMENT_MESSAGE = "{triangle} Achievement!! {triangle} %s for %s pts for total of %s Achievements at %s pts";
QUESTTWEET_LATESTACHIEVEMENT = "Latest Achievement: ";
QUESTTWEET_EXP_MESSAGE_1 = "{triangle} Gained %s XP: ";
QUESTTWEET_EXP_MESSAGE_2 = "%s%s%% of level %s!";
QUESTTWEET_EXP_GAINED = "^Experience gained: (.*)\.$"
QUESTTWEET_SKILL_MATCH = "^Your skill in (.*) has increased to (.*)"
QUESTTWEET_SKILL_TEXT = "{square} Skill {square} level of %1 is %2"

-- ========== Quest Tweet About ================================================
QUESTTWEET_ABOUT = "Share your Achievements and Quest progress with your friends. Here you can customize what to tweet and who to tweet.";
QUESTTWEET_TITLE = "Quest Tweet";

-- ========== Quest Tweet Targets ==============================================
QUESTTWEET_ON_LABEL = "Turn on Quest Tweet";
QUESTTWEET_ON_TOOLTIP = "This will turn on Quest Tweet. The Master Switch! Nothing works if this is off.";
QUESTTWEET_LOCAL_LABEL = "Local area";
QUESTTWEET_LOCAL_TOOLTIP = "This will notify the local area, like using /say";
QUESTTWEET_PARTY_LABEL = "Party chat";
QUESTTWEET_PARTY_TOOLTIP = "This will notify the pary chat, like using /party";
QUESTTWEET_RAID_LABEL = "Raid chat";
QUESTTWEET_RAID_TOOLTIP = "This will notify the raid chat, like using /raid";
QUESTTWEET_GUILD_LABEL = "Guild chat";
QUESTTWEET_GUILD_TOOLTIP = "This will notify the guild chat, like using /guild";
QUESTTWEET_CHANNEL_LABEL = "Channel";
QUESTTWEET_CHANNEL_TOOLTIP = "My preferred method of using Quest Tweet. Setup a Chat Channel and share your progress with your friends.";
QUESTTWEET_CHANNELID_LABEL = " Channel name or id ex:qspamfriends";
QUESTTWEET_CHANNELID_TOOLTIP = "The Channel you create/join will always have the same numeric id.";

-- ========== Quest Tweet Categories ===========================================
QUESTTWEET_CATAREA_LABEL = "Categories";
QUESTTWEET_ACHIEVEMENTS_LABEL = "Achievements";
QUESTTWEET_ACHIEVEMENTS_TOOLTIP = "This will tweet Achievements! It will link the achievement (if in a group chat) and how many pts it was worth along with your current achievement pts and status.";
QUESTTWEET_LEVELUP_LABEL = "Leveling";
QUESTTWEET_LEVELUP_TOOLTIP = "A must have for those who say DING! Tweets when you level up and also sends your new level.";
QUESTTWEET_QUESTPROGRESS_LABEL = "Quest Progress";
QUESTTWEET_QUESTPROGRESS_TOOLTIP = "This will tweet when quests are accepted and completed along with the exp and %% of your current level.";
QUESTTWEET_QUESTDETAILS_LABEL = "Quest Details";
QUESTTWEET_QUESTDETAILS_TOOLTIP = "This will tweet how many item/creatures you have completed while doing your quests.";
QUESTTWEET_DISCOVERY_LABEL = "Discovery";
QUESTTWEET_DISCOVERY_TOOLTIP = "This will tweet a discovery notification every time you discover a new area.";
QUESTTWEET_COMBATXP_LABEL = "Combat Exp";
QUESTTWEET_COMBATXP_TOOLTIP = "The Uber Tweeters! This will tweet your every kill that you make exp on. A true way to share the experience or annoy your friends!";
QUESTTWEET_PROFESSIONS_LABEL = "Professions";
QUESTTWEET_PROFESSIONS_TOOLTIP = "This will tweet a profession skill increase notifications.";

-- ========== Quest Achievement Options =======================================
QUESTTWEET_ACHIEVESETTINGS_LABEL = "Achievement Settings";
QUESTTWEET_ACHIEVE_SPAMALL_LABEL = "Share with Everyone";
QUESTTWEET_ACHIEVE_SPAMALL_TOOLTIP = "Share your Achievements with those around you and your current chat groups (guild,raid,party) regardless of your tweet targets.";
QUESTTWEET_ACHIEVE_NOTLOCAL_LABEL = "Share with your buddies";
QUESTTWEET_ACHIEVE_NOTLOCAL_TOOLTIP = "If you feel funny about blurting out your achievements, just keep them to your current chat group.";
