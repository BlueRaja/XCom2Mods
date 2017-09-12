class IAM_Settings extends UIScreenListener config(IAM_Settings);

var config float AvatarPauseMultiplier;
var config bool InstantRoomTransitions;
var config bool SkipHologlobeDissolveAnimation;
var config int ConfigVersion;

`include(InstantAvengerMenus/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(InstantAvengerMenus/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'IAM_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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

    page = ConfigAPI.NewSettingsPage("Instant Avenger Menus");
    page.SetPageTitle("Instant Avenger Menus");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "");
    group.AddSlider('AvatarPauseMultiplier', // Name
      "Avatar Pause", // Text
      "The percentage of time to pause during Avatar updates. 0.0 = no pause, 1.0 = same as the base-game", // Tooltip
      0, 1, 0, // Min, Max, Step
      AvatarPauseMultiplier, // Initial value
      SaveAvatarPauseMultiplier // Save handler
    );
    group.AddCheckbox('InstantRoomTransitions', // Name
      "Instant Room Transitions", // Text
      "Instantly move between rooms in the Avenger", // Tooltip
      InstantRoomTransitions, // Initial value
      SaveInstantRoomTransitions // Save handler
    );
    group.AddCheckbox('SkipHologlobeDissolveAnimation', // Name
      "Skip Hologlobe Dissolve Animation", // Text
      "Skip the animation when zooming into/out of the Hologlobe", // Tooltip
      SkipHologlobeDissolveAnimation, // Initial value
      SaveSkipHologlobeDissolveAnimation // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(SaveAvatarPauseMultiplier, AvatarPauseMultiplier)
`MCM_API_BasicCheckboxSaveHandler(SaveInstantRoomTransitions, InstantRoomTransitions)
`MCM_API_BasicCheckboxSaveHandler(SaveSkipHologlobeDissolveAnimation, SkipHologlobeDissolveAnimation)

function LoadSavedSettings()
{
    AvatarPauseMultiplier = `MCM_CH_GetValue(class'IAM_Settings_Defaults'.default.AvatarPauseMultiplier, AvatarPauseMultiplier);
    InstantRoomTransitions = `MCM_CH_GetValue(class'IAM_Settings_Defaults'.default.InstantRoomTransitions, InstantRoomTransitions);
    SkipHologlobeDissolveAnimation = `MCM_CH_GetValue(class'IAM_Settings_Defaults'.default.SkipHologlobeDissolveAnimation, SkipHologlobeDissolveAnimation);
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