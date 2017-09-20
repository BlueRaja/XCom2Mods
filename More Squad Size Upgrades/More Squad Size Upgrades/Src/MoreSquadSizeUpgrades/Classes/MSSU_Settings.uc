class MSSU_Settings extends UIScreenListener config(MSSU_Settings);

var config int StartingSquadSize;
var config int SquadSizeIIICost;
var config int SquadSizeIIIRequiredRank;
var config int SquadSizeIVCost;
var config int SquadSizeIVRequiredRank;
var config string SquadSelectUI;
var config int ConfigVersion;

`include(MoreSquadSizeUpgrades/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(MoreSquadSizeUpgrades/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'MSSU_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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
    local MCM_API_SettingsGroup group1, group2;
    local array<string> squadSelectUIChoices;

    squadSelectUIChoices.AddItem("Fit all soldiers");
    squadSelectUIChoices.AddItem("Scrollbar");
    squadSelectUIChoices.AddItem("Compatibility mode");

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("More Squad Size Upgrades");
    page.SetPageTitle("More Squad Size Upgrades");
    page.SetSaveHandler(SaveButtonClicked);

    group1 = Page.AddGroup('GroupVisuals', "Visuals");
    group1.AddDropdown('SquadSelectUI', // Name
      "Squad Select UI", // Text
      "Fit all soldiers: Shrink squad UI to fit everyone on the screen\n\nScrollbar: Use a scrollbar to select 7th/8th soldier\n\nCompatibility mode: Use another mod to manage squad select screen", // Tooltip
      squadSelectUIChoices, // Dropdown options
      SquadSelectUI, // Initial value
      SaveSquadSelectUI // Save handler
    );

    group2 = Page.AddGroup('GroupCosts', "Costs");
    group2.AddSlider('SquadSizeIIICost', // Name
      "Squad Size III Cost", // Text
      "The cost (in supplies) for the Squad Size III upgrade (send 7 units on mission)", // Tooltip
      0, 500, 5, // Min, Max, Step
      SquadSizeIIICost, // Initial value
      SaveSquadSizeIIICost // Save handler
    );
    group2.AddSlider('SquadSizeIIIRequiredRank', // Name
      "Squad Size III Required Rank", // Text
      "The rank required to have a unit at before this upgrade is unlocked.  0 = rookie, 7 = colonel", // Tooltip
      0, 7, 1, // Min, Max, Step
      SquadSizeIIIRequiredRank, // Initial value
      SaveSquadSizeIIIRequiredRank // Save handler
    );
    group2.AddSlider('SquadSizeIVCost', // Name
      "Squad Size IV Cost", // Text
      "The cost (in supplies) for the Squad Size IV upgrade (send 8 units on mission)", // Tooltip
      0, 500, 5, // Min, Max, Step
      SquadSizeIVCost, // Initial value
      SaveSquadSizeIVCost // Save handler
    );
    group2.AddSlider('SquadSizeIVRequiredRank', // Name
      "Squad Size IV Required Rank", // Text
      "The rank required to have a unit at before this upgrade is unlocked.  0 = rookie, 7 = colonel", // Tooltip
      0, 7, 1, // Min, Max, Step
      SquadSizeIVRequiredRank, // Initial value
      SaveSquadSizeIVRequiredRank // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicDropdownSaveHandler(SaveSquadSelectUI, SquadSelectUI)
`MCM_API_BasicSliderSaveHandler(SaveSquadSizeIIICost, SquadSizeIIICost)
`MCM_API_BasicSliderSaveHandler(SaveSquadSizeIIIRequiredRank, SquadSizeIIIRequiredRank)
`MCM_API_BasicSliderSaveHandler(SaveSquadSizeIVCost, SquadSizeIVCost)
`MCM_API_BasicSliderSaveHandler(SaveSquadSizeIVRequiredRank, SquadSizeIVRequiredRank)

function LoadSavedSettings()
{
    SquadSelectUI = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.SquadSelectUI, SquadSelectUI);
    SquadSizeIIICost = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.SquadSizeIIICost, SquadSizeIIICost);
    SquadSizeIIIRequiredRank = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.SquadSizeIIIRequiredRank, SquadSizeIIIRequiredRank);
    SquadSizeIVCost = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.SquadSizeIVCost, SquadSizeIVCost);
    SquadSizeIVRequiredRank = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.SquadSizeIVRequiredRank, SquadSizeIVRequiredRank);
    StartingSquadSize = `MCM_CH_GetValue(class'MSSU_Settings_Defaults'.default.StartingSquadSize, StartingSquadSize);
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