class StartingStaff_Settings extends UIScreenListener config(StartingStaff_Settings);

var config int NumStartingEngineers;
var config int NumStartingScientists;
var config int ConfigVersion;

`include(StartingStaff/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(StartingStaff/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'StartingStaff_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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

    page = ConfigAPI.NewSettingsPage("Starting Staff");
    page.SetPageTitle("Starting Staff");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "");
    group.AddSlider('NumStartingEngineers', // Name
      "Starting Engineers", // Text
      "The number of engineers to start the game with", // Tooltip
      0, 30, 1, // Min, Max, Step
      NumStartingEngineers, // Initial value
      SaveNumStartingEngineers // Save handler
    );
    group.AddSlider('NumStartingScientists', // Name
      "Starting Scientists", // Text
      "The number of scientists to start the game with", // Tooltip
      0, 30, 1, // Min, Max, Step
      NumStartingScientists, // Initial value
      SaveNumStartingScientists // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(SaveNumStartingEngineers, NumStartingEngineers)
`MCM_API_BasicSliderSaveHandler(SaveNumStartingScientists, NumStartingScientists)

function LoadSavedSettings()
{
    NumStartingEngineers = `MCM_CH_GetValue(class'StartingStaff_Settings_Defaults'.default.NumStartingEngineers, NumStartingEngineers);
    NumStartingScientists = `MCM_CH_GetValue(class'StartingStaff_Settings_Defaults'.default.NumStartingScientists, NumStartingScientists);
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