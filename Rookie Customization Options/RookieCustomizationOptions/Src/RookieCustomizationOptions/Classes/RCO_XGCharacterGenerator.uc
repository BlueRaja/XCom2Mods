class RCO_XGCharacterGenerator extends XGCharacterGenerator dependson(X2StrategyGameRulesetDataStructures) config(NameList);

var RCO_Settings Settings;

delegate bool FilterCallback(X2BodyPartTemplate Template);

function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, 
                                 optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
{
    local float tattooProbability;

    if(!IsSoldier(CharacterTemplateName))
    {
        return super.CreateTSoldier(CharacterTemplateName, eForceGender, nmCountry, iRace, ArmorName);
    }

    Settings = new class'RCO_Settings';

    SetFaceProbabilities();
    eForceGender = GetGender(eForceGender);

    // This sets kSoldier
    super.CreateTSoldier(CharacterTemplateName, eForceGender, nmCountry, iRace, ArmorName);

    SetColorPalettes();
    SetPartTemplates();

    return kSoldier;
}

function EColorPalette GetSkinPaletteIndex(int iRace)
{
    switch(iRace)
    {
    case eRace_African:
        return ePalette_AfricanSkin;
    case eRace_Hispanic:
        return ePalette_HispanicSkin;
    case eRace_Asian:
        return ePalette_AsianSkin;
    default:
        return ePalette_CaucasianSkin;
    }
}

function int RandIndexForPalette(EColorPalette palette)
{
    return Rand(`CONTENT.GetColorPalette(palette).Entries.Length);
}

function SetFaceProbabilities()
{
    NewSoldier_HatChance = Settings.ChanceHat;
    NewSoldier_UpperFacePropChance = Settings.ChanceUpperFace;
    NewSoldier_LowerFacePropChance = Settings.ChanceLowerFace;
    NewSoldier_BeardChance = Settings.ChanceBeard;
}

function bool IsSoldier(name CharacterTemplateName)
{
    return CharacterTemplateName == 'Soldier' || CharacterTemplateName == '';
}

function EGender GetGender(EGender eForceGender)
{
    if(eForceGender != eGender_None)
    {
        return eForceGender;
    }
    return FRand() < Settings.ChanceFemale ? eGender_Female : eGender_Male;
}

function SetColorPalettes()
{
    if(Settings.ShouldColorEye)
        kSoldier.kAppearance.iEyeColor = RandIndexForPalette(ePalette_EyeColor);
    if(Settings.ShouldColorSkin)
        kSoldier.kAppearance.iSkinColor = RandIndexForPalette(GetSkinPaletteIndex(kSoldier.kAppearance.iRace));
    if(Settings.ShouldColorHair)
        kSoldier.kAppearance.iHairColor = RandIndexForPalette(ePalette_HairColor);
    if(Settings.ShouldColorArmor)
        kSoldier.kAppearance.iArmorTint = RandIndexForPalette(ePalette_ArmorTint);
    if(Settings.ShouldColorArmor2)
        kSoldier.kAppearance.iArmorTintSecondary = RandIndexForPalette(ePalette_ArmorTint);
    if(Settings.ShouldColorWeapon)
        kSoldier.kAppearance.iWeaponTint = RandIndexForPalette(ePalette_ArmorTint);
    if(Settings.ShouldColorTattoo)
        kSoldier.kAppearance.iTattooTint = RandIndexForPalette(ePalette_ArmorTint);
}

function SetPartTemplates()
{
    local X2BodyPartTemplateManager PartTemplateManager;
    local X2SimpleBodyPartFilter BodyPartFilter;
    local delegate<FilterCallback> filterAny;
    local float tattooProbability;

    PartTemplateManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
    BodyPartFilter = `XCOMGAME.SharedBodyPartFilter;
    BodyPartFilter.Set(EGender(kSoldier.kAppearance.iGender), ECharacterRace(kSoldier.kAppearance.iRace), kSoldier.kAppearance.nmTorso, false, , DLCNames);
    filterAny = BodyPartFilter.FilterAny;

    // Finally putting that math degree to work.  This ensures the probability we generate AT LEAST one tattoo is correct.
    tattooProbability = 1-Sqrt(1-Settings.ChanceTattoo);
    if(FRand() < tattooProbability)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmTattoo_LeftArm, "Tattoos", filterAny);
    if(FRand() < tattooProbability)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmTattoo_RightArm, "Tattoos", filterAny);
    if(FRand() < Settings.ChanceFacePaint)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmFacePaint, "Facepaint", filterAny);
    if(FRand() < Settings.ChanceScars)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmScars, "Scars", filterAny);
    if(FRand() < Settings.ChanceWeaponCamo)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmWeaponPattern, "Patterns", filterAny);
    if(FRand() < Settings.ChanceArmorCamo)
        RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmPatterns, "Patterns", filterAny);
}