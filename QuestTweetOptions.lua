-- ===========================================================================
-- = QuestTweetOptions.lua 
-- ===========================================================================
-- DESC : This handles the options frame ui
-- ===========================================================================

-- ========= Globals =========================================================
CONTROLTYPE_CHECKBOX = 1;
CONTROLTYPE_DROPDOWN = 2;
CONTROLTYPE_SLIDER = 3;
CONTROLTYPE_EDITBOX = 4;
QuestTweetOptionsFrame = nil;
QS_UpdatedOptions = {};

-- ========= Option Panel Labels and Settings ================================

QuestTweetOptionLabels = 
{ 
	["QuestTweetOn"] = {toggle = "on", text = QUESTTWEET_ON_LABEL, tooltip = QUESTTWEET_ON_TOOLTIP },
	["QuestTweetLocal"] = {toggle = "local", text = QUESTTWEET_LOCAL_LABEL, tooltip = QUESTTWEET_LOCAL_TOOLTIP },
	["QuestTweetRaid"] = {toggle = "raid", text = QUESTTWEET_RAID_LABEL, tooltip = QUESTTWEET_RAID_TOOLTIP },
	["QuestTweetParty"] = {toggle = "party", text = QUESTTWEET_PARTY_LABEL, tooltip = QUESTTWEET_PARTY_TOOLTIP },
	["QuestTweetGuild"] = {toggle = "guild", text = QUESTTWEET_GUILD_LABEL, tooltip = QUESTTWEET_GUILD_TOOLTIP },
	["QuestTweetChannel"] = {toggle = "channel", text = QUESTTWEET_CHANNEL_LABEL, tooltip = QUESTTWEET_CHANNEL_TOOLTIP },
	["QuestTweetChannelId"] = {field = "channelid", text = QUESTTWEET_CHANNELID_LABEL, tooltip = QUESTTWEET_CHANNELID_TOOLTIP },
	["QuestTweetAchievements"] = {toggle = "achievement", text = QUESTTWEET_ACHIEVEMENTS_LABEL, tooltip = QUESTTWEET_ACHIEVEMENTS_TOOLTIP },
	["QuestTweetDetails"] = {toggle = "details", text = QUESTTWEET_QUESTDETAILS_LABEL, tooltip = QUESTTWEET_QUESTDETAILS_TOOLTIP },
	["QuestTweetDiscovery"] = {toggle = "discovery", text = QUESTTWEET_DISCOVERY_LABEL, tooltip = QUESTTWEET_DISCOVERY_TOOLTIP },
	["QuestTweetCombatXP"] = {toggle = "killxp", text = QUESTTWEET_COMBATXP_LABEL, tooltip = QUESTTWEET_COMBATXP_TOOLTIP },
	["QuestTweetLevelUp"] = {toggle = "levelup", text = QUESTTWEET_LEVELUP_LABEL, tooltip = QUESTTWEET_LEVELUP_TOOLTIP },
	["QuestTweetQuestProgress"] = {toggle = "questxp", text = QUESTTWEET_QUESTPROGRESS_LABEL, tooltip = QUESTTWEET_QUESTPROGRESS_TOOLTIP },
}

-- ========= Functions =======================================================

-- ===========================================================================
-- NAME : QuestTweetOptions_CancelOrLoad(panel)
-- DESC : Called when the Cancel is pressed
-- PARAMS
-- panel : frame : options panel frame
-- ===========================================================================
function QuestTweetOptions_Cancel(panel)
	QSTrace("QuestTweetOptions:Cancel");
	QS_UpdatedOptions = {};
end

-- ===========================================================================
-- NAME : QuestTweetOptions_Close(panel)
-- DESC : Called when the ok button is pressed; This will commit the changes
-- PARAMS
-- panel : frame : options panel frame
-- ===========================================================================
function QuestTweetOptions_Close(panel)
	if (panel) then
		local control;
		local parentId = panel:GetName();
		-- This will save the values
		QSTrace("QuestTweetOptions:Close");
    for key, val in pairs(QuestTweetOptionLabels) do
      control = _G[(parentId .. key)];
			if (control) then
        if (val.toggle ~= nil and control.type == CONTROLTYPE_CHECKBOX) then
          QuestTweetPref[val.toggle] = control:GetChecked()
          QSTrace(val.toggle .. " set to " .. tostring(QuestTweetPref[val.toggle]));
        end
        if (val.field and QuestTweetPref[val.field] ~= nil and control.type == CONTROLTYPE_EDITBOX) then
        	QuestTweetPref[val.field] = control:GetText();
          QSTrace(val.field .. " set to " .. control:GetText());
        end
			end
		end
		QuestTweetLoadOptionValues();
	end
end

-- ===========================================================================
-- NAME : QuestTweetOptions_OnLoad(panel)
-- DESC : handles the options panel frame onload event
-- PARAMS
-- panel : frame : options panel frame
-- ===========================================================================
function QuestTweetOptions_OnLoad(panel)
  QSTrace("QuestTweetOptions_OnLoad");
  QuestTweetOptionsFrame = panel;
	panel.name = "Quest Tweet" -- .. GetAddOnMetadata("QuestTweet", "Version");
	panel.okay = function (panel) QuestTweetOptions_Close(panel); end;
	panel.cancel = function (panel)  QuestTweetOptions_Cancel(panel);  end;
	InterfaceOptions_AddCategory(panel);
	if ( QS_VariablesLoaded ) then
		QuestTweetLoadOptionValues();
		QS_OptionsLoaded = true;
	end
end

-- ===========================================================================
-- NAME : QuestTweetLoadOptionValues()
-- DESC : handles the checkboxes on the options panel
-- ===========================================================================
function QuestTweetLoadOptionValues()
  QSTrace("QuestTweetLoadOptionValues");
	local panel = QuestTweetOptionsFrame;
	if (panel) then
		local label,control;
		local parentId = panel:GetName();
		for key, val in pairs(QuestTweetOptionLabels) do
			-- Set the label text, tooltip, etc (I derived this pattern from Blizzard's OptionsPanelTemplates.lua Nice!);
			control = _G[(parentId .. key)];
			label = _G[(parentId .. key .. "Text")];
			if (control) then
        if (val.tooltip) then
					control.tooltipText = val.tooltip;
				end
				if (val.toggle and control.type == CONTROLTYPE_CHECKBOX) then
        	control:SetChecked(QuestTweetPref[val.toggle]);
					control.toggle = val.toggle;
				end
				if (val.field and QuestTweetPref[val.field] ~= nil and control.type == CONTROLTYPE_EDITBOX) then
					control:SetText(QuestTweetPref[val.field]);
					control:SetCursorPosition(0);
				end
			end
			if (label and val.text) then
				label:SetText(val.text);
			end
		end
	end
end

-- ===========================================================================
-- NAME : QuestTweetOptionsPanel_CheckButton_OnClick(checkbox)
-- DESC : handles the checkboxe changes on the options panel; It does not commit them though unless you click OK
-- PARAMS
-- checkbox : CheckButtonElement : options panel checkbutton object
-- ===========================================================================
function QuestTweetOptionsPanel_CheckButton_OnClick(checkbox)
	if ( checkbox.type == CONTROLTYPE_CHECKBOX and checkbox.toggle ) then

	end
end