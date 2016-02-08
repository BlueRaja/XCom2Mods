class LMOE_XComGameState_Unit extends XComGameState_Unit dependson(XComCoverInterface);

function OnCreation(X2CharacterTemplate CharTemplate)
{
    if(CharTemplate.bIsCivilian || CharTemplate.bIsScientist || CharTemplate.bIsEngineer)
    {
        CharTemplate.DefaultAppearance.iGender = eGender_Female;
        CharTemplate.ForceAppearance.iGender = eGender_Female;
    }
    Super.OnCreation(CharTemplate);
}