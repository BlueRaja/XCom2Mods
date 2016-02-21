class ACU_UnitColorer extends object config(AutomaticallyColorUnits);

struct UnitColorInfo
{
    var name SoldierClass;
    var int MainColor;
    var int SecondaryColor;
    var int WeaponColor;    
};

var config array<UnitColorInfo> UnitColors;

function UpdateAllUnitsColor()
{
    local array<XComGameState_Unit> unitList;
    local XComGameState_Unit unit;

    unitList = GetAllUnits();
    foreach unitList(unit)
    {
        UpdateUnitColor(unit);
    }
}

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

protected function array<XComGameState_Unit> GetAllUnits()
{
    local int i;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> unitList;

    for(i = 0; i < `XCOMHQ.Crew.Length; i++)
    {
        unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.Crew[i].ObjectID));

        if(unit.IsASoldier() && unit.IsAlive())
        {
            unitList.AddItem(unit);
        }
    }

    return unitList;
}

protected function ChangeColor(XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    local XComPresentationLayerBase presentation;
    local XComCharacterCustomization customizeManager;

    presentation = `PRES;
    presentation.InitializeCustomizeManager(unit);
    customizeManager = presentation.GetCustomizeManager();

    if(unit.kAppearance.iArmorTint != colorInfo.MainColor 
      || unit.kAppearance.iArmorTintSecondary != colorInfo.SecondaryColor 
      || unit.kAppearance.iWeaponTint != colorInfo.WeaponColor)
    {
        customizeManager.OnCategoryValueChange(eUICustomizeCat_PrimaryArmorColor, -1, colorInfo.MainColor);
        customizeManager.OnCategoryValueChange(eUICustomizeCat_SecondaryArmorColor, -1, colorInfo.SecondaryColor);
        customizeManager.OnCategoryValueChange(eUICustomizeCat_WeaponColor, -1, colorInfo.WeaponColor);
    }

    presentation.DeactivateCustomizationManager(true);
}