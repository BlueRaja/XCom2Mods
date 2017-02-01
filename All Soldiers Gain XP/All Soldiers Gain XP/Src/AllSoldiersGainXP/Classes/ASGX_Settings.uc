class ASGX_Settings extends UIScreenListener config(ASGX_Settings);

var config float PassiveXPPercentage;
var config bool UnitsCanLevelUpOutsideOfMission;
var config bool WoundedAndTrainingUnitsGainXP;
var config bool RookiesGainXP;
var config int ConfigVersion;

`include(AllSoldiersGainXP/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(AllSoldiersGainXP/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'ASGX_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

event OnInit(UIScreen Screen)
{
    `MCM_API_Register(Screen, ClientModCallback);

    if(UIShell(Screen) != none)
    {
        EnsureConfigExists();
    }
}

function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage page;
    local MCM_API_SettingsGroup group;

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("All Soldiers Gain XP");
    page.SetPageTitle("All Soldiers Gain XP");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "");
    group.AddSlider('PassiveXPPercentage', // Name
      "XP bonus percentage", // Text
      "At 0.0, units not on mission gain no bonus XP.  At 1.0, units not on mission gain as much bonus XP as units on the mission", // Tooltip
      0, 1, 0.01, // Min, Max, Step
      PassiveXPPercentage, // Initial value
      SavePassiveXPPercentage // Save handler
    );
    group.AddCheckbox('UnitsCanLevelUpOutsideOfMission', // Name
      "Units can level up outside of missions", // Text
      "If enabled, units not on mission can level up.  If disabled, units must go on a mission before leveling up", // Tooltip
      UnitsCanLevelUpOutsideOfMission, // Initial value
      SaveUnitsCanLevelUpOutsideOfMission // Save handler
    );
    group.AddCheckbox('WoundedAndTrainingUnitsGainXP', // Name
      "Wounded and training units gain XP", // Text
      "If enabled, wounded units and units in Psi training/AWC/etc gain XP too", // Tooltip
      WoundedAndTrainingUnitsGainXP, // Initial value
      SaveWoundedAndTrainingUnitsGainXP // Save handler
    );
    group.AddCheckbox('RookiesGainXP', // Name
      "Rookies gain XP", // Text
      "If enabled, all units gain XP outside of missions.  If disabled, only non-rookies gain XP outside of missions", // Tooltip
      RookiesGainXP, // Initial value
      SaveRookiesGainXP // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(SavePassiveXPPercentage, PassiveXPPercentage)
`MCM_API_BasicCheckboxSaveHandler(SaveUnitsCanLevelUpOutsideOfMission, UnitsCanLevelUpOutsideOfMission)
`MCM_API_BasicCheckboxSaveHandler(SaveWoundedAndTrainingUnitsGainXP, WoundedAndTrainingUnitsGainXP)
`MCM_API_BasicCheckboxSaveHandler(SaveRookiesGainXP, RookiesGainXP)

function LoadSavedSettings()
{
    PassiveXPPercentage = `MCM_CH_GetValue(class'ASGX_Settings_Defaults'.default.PassiveXPPercentage, PassiveXPPercentage);
    UnitsCanLevelUpOutsideOfMission = `MCM_CH_GetValue(class'ASGX_Settings_Defaults'.default.UnitsCanLevelUpOutsideOfMission, UnitsCanLevelUpOutsideOfMission);
    WoundedAndTrainingUnitsGainXP = `MCM_CH_GetValue(class'ASGX_Settings_Defaults'.default.WoundedAndTrainingUnitsGainXP, WoundedAndTrainingUnitsGainXP);
    RookiesGainXP = `MCM_CH_GetValue(class'ASGX_Settings_Defaults'.default.RookiesGainXP, RookiesGainXP);
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    self.ConfigVersion = `MCM_CH_GetCompositeVersion();
    self.SaveConfig();
}

function EnsureConfigExists()
{
    if(ConfigVersion == 0)
    {
        LoadSavedSettings();
        SaveButtonClicked(none);
    }
}

defaultproperties
{
    ScreenClass = none;
}