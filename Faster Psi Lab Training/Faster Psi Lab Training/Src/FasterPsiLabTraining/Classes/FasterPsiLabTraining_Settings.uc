class FasterPsiLabTraining_Settings extends UIScreenListener config(FasterPsiLabTraining_Settings);

var config float PsiTrainingRateMultiplier;
var config int ConfigVersion;

`include(FasterPsiLabTraining/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(FasterPsiLabTraining/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'FasterPsiLabTraining_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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

    page = ConfigAPI.NewSettingsPage("Faster Psi Lab Training");
    page.SetPageTitle("Faster Psi Lab Training");
    page.SetSaveHandler(SaveButtonClicked);

    group = Page.AddGroup('Group1', "");
    group.AddSlider('PsiTrainingRateMultiplier', // Name
      "Psi Training Rate Multiplier", // Text
      "Number to multiply the Psi Training Rate by.  1.0 is normal speed; 0.5 is half-speed; 2.0 is double-speed; etc.", // Tooltip
      0.1, 5.0, 0.1, // Min, Max, Step
      PsiTrainingRateMultiplier, // Initial value
      SavePsiTrainingRateMultiplier // Save handler
    );

    page.ShowSettings();
}

`MCM_API_BasicSliderSaveHandler(SavePsiTrainingRateMultiplier, PsiTrainingRateMultiplier)

function LoadSavedSettings()
{
    PsiTrainingRateMultiplier = `MCM_CH_GetValue(class'FasterPsiLabTraining_Settings_Defaults'.default.PsiTrainingRateMultiplier, PsiTrainingRateMultiplier);
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