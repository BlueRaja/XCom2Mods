class LSS_Settings extends UIScreenListener config(LSS_Settings);

var config bool TryToFitEveryoneOnSquadSelectScreen;
var config int ConfigVersion;

`include(LargerStartingSquad/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(LargerStartingSquad/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'LSS_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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

    page = ConfigAPI.NewSettingsPage("Larger Starting Squad");
    page.SetPageTitle("Larger Starting Squad");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "");
    group.AddCheckbox('TryToFitEveryoneOnSquadSelectScreen', // Name
      "Try to fit all soldiers on screen", // Text
      "If true, mod will attempt to display all 8 soldiers on squad select.  If you're having graphical issues at the squad-select screen, disable this", // Tooltip
      TryToFitEveryoneOnSquadSelectScreen, // Initial value
      SaveTryToFitEveryoneOnSquadSelectScreen // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicCheckboxSaveHandler(SaveTryToFitEveryoneOnSquadSelectScreen, TryToFitEveryoneOnSquadSelectScreen)

function LoadSavedSettings()
{
    TryToFitEveryoneOnSquadSelectScreen = `MCM_CH_GetValue(class'LSS_Settings_Defaults'.default.TryToFitEveryoneOnSquadSelectScreen, TryToFitEveryoneOnSquadSelectScreen);
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