class ACU_UnitColorer extends object config(AutomaticallyColorUnits);

struct UnitColorInfo
{
    var name SoldierClass;
    var int AbilityBranch;
    var int MainColor;
    var int SecondaryColor;
    var int WeaponColor;
    var int WeaponCamo;
    var int ArmorCamo;
};

var config array<UnitColorInfo> UnitColors;

//Update the colors of all units to the correct colors
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

//Update the color of the given unit to the correct color
function UpdateUnitColor(XComGameState_Unit unit)
{
    local UnitColorInfo currentColorInfo;

    foreach UnitColors(currentColorInfo)
    {
        if(IsValidTemplateForUnit(unit, currentColorInfo))
        {
            UpdateColorsIfNecessary(unit, currentColorInfo);
            return;
        }
    }
}

// Returns true if the given UnitColorInfo applies for the given unit
protected function bool IsValidTemplateForUnit(XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    if(unit.GetSoldierClassTemplateName() != colorInfo.SoldierClass)
        return false;

    //Config 'AbilityBranch' values start at 1, while in-game ability.iBranch values start at 0, hence the -1
    return colorInfo.AbilityBranch == 0 || IsPrimaryAbilityBranch(unit.m_SoldierProgressionAbilties, colorInfo.AbilityBranch-1);
}

// Returns true if the given branch is one of the primary branches this unit is assigned to
protected function bool IsPrimaryAbilityBranch(array<SCATProgression> abilities, int branchNumber)
{
    local array<int> branchCounts;
    branchCounts = GetBranchCounts(abilities);
    return branchCounts[branchNumber] == ArrayMax(branchCounts);
}

// Returns an array containing the count of each iBranch in the given abilities list
protected function array<int> GetBranchCounts(array<SCATProgression> abilities)
{
    local array<int> branchCounts;
    local SCATProgression ability;

    branchCounts.Add(30); //Should be more than enough for any mod ever

    foreach abilities(ability)
    {
        //Skip the ability at rank 0, it has no branches so it doesn't count
        if(ability.iRank == 0)
            continue;
        branchCounts[ability.iBranch]++;
    }

    return branchCounts;
}

//Returns the max of all values in an array of ints
protected function int ArrayMax(array<int> intArray)
{
    local int maxValue;
    local int currentValue;

    maxValue = -2147483648;
    foreach intArray(currentValue)
    {
        if(currentValue > maxValue)
        {
            maxValue = currentValue;
        }
    }
    return maxValue;
}

//Returns all soldiers
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

//Update the colors for the given soldier
protected function UpdateColorsIfNecessary(XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    local XComPresentationLayerBase presentation;
    local XComCharacterCustomization customizeManager;

    if(HasUpdatedColor(unit, colorInfo))
    {
        presentation = `PRESBASE;
        presentation.InitializeCustomizeManager(unit);
        customizeManager = presentation.GetCustomizeManager();

        UpdateColor(customizeManager, eUICustomizeCat_PrimaryArmorColor, colorInfo.MainColor);
        UpdateColor(customizeManager, eUICustomizeCat_SecondaryArmorColor, colorInfo.SecondaryColor);
        UpdateColor(customizeManager, eUICustomizeCat_WeaponColor, colorInfo.WeaponColor);
        UpdateColor(customizeManager, eUICustomizeCat_WeaponPatterns, colorInfo.WeaponCamo);
        UpdateColor(customizeManager, eUICustomizeCat_ArmorPatterns, colorInfo.ArmorCamo);

        presentation.DeactivateCustomizationManager(true);
    }
}

//Returns true if the soldier needs their colors updated
protected function bool HasUpdatedColor(XComGameState_Unit unit, UnitColorInfo colorInfo)
{
    return (colorInfo.MainColor != -1 && unit.kAppearance.iArmorTint != colorInfo.MainColor)
        || (colorInfo.SecondaryColor != -1 && unit.kAppearance.iArmorTintSecondary != colorInfo.SecondaryColor)
        || (colorInfo.WeaponColor != -1 && unit.kAppearance.iWeaponTint != colorInfo.WeaponColor)
        || colorInfo.WeaponCamo != -1 || colorInfo.ArmorCamo != -1; // Couldn't find a quick/simple way to check for Weapon/Armor camo
}

protected function UpdateColor(XComCharacterCustomization customizeManager, EUICustomizeCategory category, int newValue)
{
    if(newValue != -1)
    {
        customizeManager.OnCategoryValueChange(category, -1, newValue);
    }
}