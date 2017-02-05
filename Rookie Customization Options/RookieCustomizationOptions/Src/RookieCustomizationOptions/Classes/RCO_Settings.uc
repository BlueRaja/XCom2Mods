class RCO_Settings extends UIScreenListener config(RCO_Settings);

var config bool ShouldColorEye;
var config bool ShouldColorSkin;
var config bool ShouldColorHair;
var config bool ShouldColorArmor;
var config bool ShouldColorArmor2;
var config bool ShouldColorWeapon;
var config bool ShouldColorTattoo;

var config float ChanceFemale;
var config float ChanceHat;
var config float ChanceUpperFace;
var config float ChanceLowerFace;
var config float ChanceBeard;
var config float ChanceTattoo;
var config float ChanceFacePaint;
var config float ChanceScars;
var config float ChanceWeaponCamo;
var config float ChanceArmorCamo;

var config int ConfigVersion;

`include(RookieCustomizationOptions/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(RookieCustomizationOptions/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_CH_VersionChecker(class'RCO_Settings_Defaults'.default.ConfigVersion, ConfigVersion)

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

    LoadSavedSettings();

    page = ConfigAPI.NewSettingsPage("Rookie Customization Options");
    page.SetPageTitle("Rookie Customization Options");
    page.SetSaveHandler(SaveButtonClicked);

    group1 = Page.AddGroup('Group1', "Pick from all colors");
    CreatePickColorCheckboxes(group1);

    group2 = Page.Addgroup('Group2', "Chance to spawn");
    CreateChanceToSpawnSliders(group2);

    page.ShowSettings();
}

function CreatePickColorCheckboxes(MCM_API_SettingsGroup group)
{
    group.AddCheckbox('ShouldColorEye', // Name
      "Eye color", // Text
      "Pick eye color randomly from all colors available", // Tooltip
      ShouldColorEye, // Initial value
      SaveShouldColorEye // Save handler
    );
    group.AddCheckbox('ShouldColorSkin', // Name
      "Skin color", // Text
      "Pick skin color randomly from all colors available", // Tooltip
      ShouldColorSkin, // Initial value
      SaveShouldColorSkin // Save handler
    );
    group.AddCheckbox('ShouldColorHair', // Name
      "Hair color", // Text
      "Pick hair color randomly from all colors available", // Tooltip
      ShouldColorHair, // Initial value
      SaveShouldColorHair // Save handler
    );
    group.AddCheckbox('ShouldColorArmor', // Name
      "Armor (main) color", // Text
      "Pick main armor color randomly from all colors available", // Tooltip
      ShouldColorArmor, // Initial value
      SaveShouldColorArmor // Save handler
    );
    group.AddCheckbox('ShouldColorArmor2', // Name
      "Armor (secondary) color", // Text
      "Pick secondary armor color randomly from all colors available", // Tooltip
      ShouldColorArmor2, // Initial value
      SaveShouldColorArmor2 // Save handler
    );
    group.AddCheckbox('ShouldColorWeapon', // Name
      "Weapon color", // Text
      "Pick weapon color randomly from all colors available", // Tooltip
      ShouldColorWeapon, // Initial value
      SaveShouldColorWeapon // Save handler
    );
    group.AddCheckbox('ShouldColorTattoo', // Name
      "Tattoo color", // Text
      "Pick tattoo color randomly from all colors available", // Tooltip
      ShouldColorTattoo, // Initial value
      SaveShouldColorTattoo // Save handler
    );
}

`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorEye, ShouldColorEye)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorSkin, ShouldColorSkin)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorHair, ShouldColorHair)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorArmor, ShouldColorArmor)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorArmor2, ShouldColorArmor2)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorWeapon, ShouldColorWeapon)
`MCM_API_BasicCheckboxSaveHandler(SaveShouldColorTattoo, ShouldColorTattoo)

function CreateChanceToSpawnSliders(MCM_API_SettingsGroup group)
{
    group.AddSlider('ChanceFemale', // Name
      "Female chance", // Text
      "Chance to spawn a female soldier (0.0 = all male, 1.0 = all female)", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceFemale, // Initial value
      SaveChanceFemale // Save handler
    );
    group.AddSlider('ChanceHat', // Name
      "Hat chance", // Text
      "Chance to spawn a hat", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceHat, // Initial value
      SaveChanceHat // Save handler
    );
    group.AddSlider('ChanceUpperFace', // Name
      "Upper face gear chance", // Text
      "Chance to spawn top-half-of-the-face gear", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceUpperFace, // Initial value
      SaveChanceUpperFace // Save handler
    );
    group.AddSlider('ChanceLowerFace', // Name
      "Lower face gear chance", // Text
      "Chance to spawn lower-half-of-head gear", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceLowerFace, // Initial value
      SaveChanceLowerFace // Save handler
    );
    group.AddSlider('ChanceBeard', // Name
      "Beard chance", // Text
      "Chance to spawn a beard (men only)", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceBeard, // Initial value
      SaveChanceBeard // Save handler
    );
    group.AddSlider('ChanceTattoo', // Name
      "Tattoo chance", // Text
      "Chance to spawn a Tattoo", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceTattoo, // Initial value
      SaveChanceTattoo // Save handler
    );
    group.AddSlider('ChanceFacePaint', // Name
      "Face paint chance", // Text
      "Chance to spawn face paint", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceFacePaint, // Initial value
      SaveChanceFacePaint // Save handler
    );
    group.AddSlider('ChanceScars', // Name
      "Scar chance", // Text
      "Chance to spawn a scar", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceScars, // Initial value
      SaveChanceScars // Save handler
    );
    group.AddSlider('ChanceWeaponCamo', // Name
      "Weapon camo chance", // Text
      "Chance to spawn weapon with camo", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceWeaponCamo, // Initial value
      SaveChanceWeaponCamo // Save handler
    );
    group.AddSlider('ChanceArmorCamo', // Name
      "Armor camo chance", // Text
      "Chance to spawn armor with camo", // Tooltip
      0, 1, 0, // Min, Max, Step
      ChanceArmorCamo, // Initial value
      SaveChanceArmorCamo // Save handler
    );
}

`MCM_API_BasicSliderSaveHandler(SaveChanceFemale, ChanceFemale)
`MCM_API_BasicSliderSaveHandler(SaveChanceHat, ChanceHat)
`MCM_API_BasicSliderSaveHandler(SaveChanceUpperFace, ChanceUpperFace)
`MCM_API_BasicSliderSaveHandler(SaveChanceLowerFace, ChanceLowerFace)
`MCM_API_BasicSliderSaveHandler(SaveChanceBeard, ChanceBeard)
`MCM_API_BasicSliderSaveHandler(SaveChanceTattoo, ChanceTattoo)
`MCM_API_BasicSliderSaveHandler(SaveChanceFacePaint, ChanceFacePaint)
`MCM_API_BasicSliderSaveHandler(SaveChanceScars, ChanceScars)
`MCM_API_BasicSliderSaveHandler(SaveChanceWeaponCamo, ChanceWeaponCamo)
`MCM_API_BasicSliderSaveHandler(SaveChanceArmorCamo, ChanceArmorCamo)

function LoadSavedSettings()
{
    ShouldColorEye = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorEye, ShouldColorEye);
    ShouldColorSkin = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorSkin, ShouldColorSkin);
    ShouldColorHair = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorHair, ShouldColorHair);
    ShouldColorArmor = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorArmor, ShouldColorArmor);
    ShouldColorArmor2 = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorArmor2, ShouldColorArmor2);
    ShouldColorWeapon = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorWeapon, ShouldColorWeapon);
    ShouldColorTattoo = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ShouldColorTattoo, ShouldColorTattoo);

    ChanceFemale = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceFemale, ChanceFemale);
    ChanceHat = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceHat, ChanceHat);
    ChanceUpperFace = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceUpperFace, ChanceUpperFace);
    ChanceLowerFace = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceLowerFace, ChanceLowerFace);
    ChanceBeard = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceBeard, ChanceBeard);
    ChanceTattoo = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceTattoo, ChanceTattoo);
    ChanceFacePaint = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceFacePaint, ChanceFacePaint);
    ChanceScars = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceScars, ChanceScars);
    ChanceWeaponCamo = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceWeaponCamo, ChanceWeaponCamo);
    ChanceArmorCamo = `MCM_CH_GetValue(class'RCO_Settings_Defaults'.default.ChanceArmorCamo, ChanceArmorCamo);
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