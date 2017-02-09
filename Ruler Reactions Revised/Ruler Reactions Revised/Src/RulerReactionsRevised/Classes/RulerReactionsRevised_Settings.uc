class RulerReactionsRevised_Settings extends UIScreenListener config(RulerReactionsRevised_Settings);

var config float ChanceReactToOffensive;
var config float ChanceReactToDefensive;
var config float ChanceReactToNeutral;
var config float ChanceReactToMovement;
var config int ConfigVersion;

`include(RulerReactionsRevised/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(RulerReactionsRevised/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'RulerReactionsRevised_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage page;
    local MCM_API_SettingsGroup group;

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("Ruler Reactions Revised");
    page.SetPageTitle("Ruler Reactions Revised");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "Probability to react to actions");
    group.AddSlider('ChanceReactToOffensive', // Name
      "Reaction Chance - Offensive Actions", // Text
      "The chance that the ruler will react to offensive actions (anything that does immediate damage)", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceReactToOffensive, // Initial value
      SaveChanceReactToOffensive // Save handler
    );
    group.AddSlider('ChanceReactToDefensive', // Name
      "Reaction Chance - Defensive Actions", // Text
      "The chance that the ruler will react to defensive actions (eg. overwatch, healing, shield)", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceReactToDefensive, // Initial value
      SaveChanceReactToDefensive // Save handler
    );
    group.AddSlider('ChanceReactToNeutral', // Name
      "Reaction Chance - Neutral Actions", // Text
      "The chance that the ruler will react to neutral actions made by the player (eg. reload, hack, evac)", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceReactToNeutral, // Initial value
      SaveChanceReactToNeutral // Save handler
    );
    group.AddSlider('ChanceReactToMovement', // Name
      "Reaction Chance - Movement", // Text
      "The chance that the ruler will react to movement made by the player", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceReactToMovement, // Initial value
      SaveChanceReactToMovement // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(SaveChanceReactToOffensive, ChanceReactToOffensive)
`MCM_API_BasicSliderSaveHandler(SaveChanceReactToDefensive, ChanceReactToDefensive)
`MCM_API_BasicSliderSaveHandler(SaveChanceReactToNeutral, ChanceReactToNeutral)
`MCM_API_BasicSliderSaveHandler(SaveChanceReactToMovement, ChanceReactToMovement)

function LoadSavedSettings()
{
    ChanceReactToOffensive = `MCM_CH_GetValue(class'RulerReactionsRevised_Settings_Defaults'.default.ChanceReactToOffensive, ChanceReactToOffensive);
    ChanceReactToDefensive = `MCM_CH_GetValue(class'RulerReactionsRevised_Settings_Defaults'.default.ChanceReactToDefensive, ChanceReactToDefensive);
    ChanceReactToNeutral = `MCM_CH_GetValue(class'RulerReactionsRevised_Settings_Defaults'.default.ChanceReactToNeutral, ChanceReactToNeutral);
    ChanceReactToMovement = `MCM_CH_GetValue(class'RulerReactionsRevised_Settings_Defaults'.default.ChanceReactToMovement, ChanceReactToMovement);
}

////////////////////////////////////////
/// Boilerplate, same for every mod
////////////////////////////////////////

event OnInit(UIScreen Screen)
{
    `MCM_API_Register(Screen, ClientModCallback);

    if(UIShell(Screen) != none)
    {
        EnsureConfigExists();
    }
}

function EnsureConfigExists()
{
    if(ConfigVersion == 0)
    {
        LoadSavedSettings();
        SaveButtonClicked(none);
    }
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    self.ConfigVersion = `MCM_CH_GetCompositeVersion();
    self.SaveConfig();
}

defaultproperties
{
    ScreenClass = none;
}