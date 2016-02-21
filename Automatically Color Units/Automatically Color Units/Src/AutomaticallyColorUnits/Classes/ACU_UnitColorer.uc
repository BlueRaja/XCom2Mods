class ACU_UnitColorer extends object config(AutomaticallyColorUnits);

struct UnitColorInfo
{
    var name SoldierClass;
    var int MainColor;
    var int SecondaryColor;
    var int WeaponColor;    
};

var config array<UnitColorInfo> UnitColors;

function UpdateUnitColor(XComGameState_Unit unit)
{
    local UnitColorInfo currentColorInfo;

    foreach UnitColors(currentColorInfo)
    {
        if(unit.GetSoldierClassTemplateName() == currentColorInfo.SoldierClass)
        {
            ChangeColor(unit, currentColorInfo);
            return;
        }
    }
}

protected function ChangeColor(XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    local XComPresentationLayerBase presentation;
    local XComCharacterCustomization customizeManager;

    presentation = `PRES;
    presentation.InitializeCustomizeManager(unit);
    customizeManager = presentation.GetCustomizeManager();

    customizeManager.OnCategoryValueChange(eUICustomizeCat_PrimaryArmorColor, -1, colorInfo.MainColor);
    customizeManager.OnCategoryValueChange(eUICustomizeCat_SecondaryArmorColor, -1, colorInfo.SecondaryColor);
    customizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, -1, colorInfo.WeaponColor);

    presentation.DeactivateCustomizationManager(true);
}