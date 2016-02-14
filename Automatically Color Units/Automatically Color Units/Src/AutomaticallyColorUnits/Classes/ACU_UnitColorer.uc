class ACU_UnitColorer extends object config(AutomaticallyColorUnits);

struct UnitColorInfo
{
    var name SoldierClass;
    var int MainColor;
    var int SecondaryColor;
    var int WeaponColor;    
};

var config array<UnitColorInfo> UnitColors;

function UpdateCurrentUnitColor(UIArmory_Promotion promotionScreen)
{
    local UnitColorInfo currentColorInfo;
    local XComGameState_Unit unit;

    unit = promotionScreen.GetUnit();

    if(!ShouldChangeColor(promotionScreen, unit))
    {
        return;
    }

    foreach UnitColors(currentColorInfo)
    {
        if(unit.GetSoldierClassTemplateName() == currentColorInfo.SoldierClass)
        {
            ChangeColor(promotionScreen.Movie.Pres, unit, currentColorInfo);
            return;
        }
    }
}

protected function bool ShouldChangeColor(UIArmory_Promotion promotionScreen, XComGameState_Unit unit)
{
    //return promotionScreen.bAfterActionPromotion && unit.GetRank() == 1;
    return true; //Always set color when entering promotion screen!
}

protected function ChangeColor(XComPresentationLayerBase presentation, XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    local XComCharacterCustomization customizeManager;

    presentation.InitializeCustomizeManager(unit);
    customizeManager = presentation.GetCustomizeManager();
    customizeManager.OnCategoryValueChange(eUICustomizeCat_PrimaryArmorColor, -1, colorInfo.MainColor);
    customizeManager.OnCategoryValueChange(eUICustomizeCat_SecondaryArmorColor, -1, colorInfo.SecondaryColor);
    customizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, -1, colorInfo.WeaponColor);
    presentation.DeactivateCustomizationManager(true);
}