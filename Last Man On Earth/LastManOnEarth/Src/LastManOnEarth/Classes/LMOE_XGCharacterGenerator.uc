class LMOE_XGCharacterGenerator extends XGCharacterGenerator dependson(X2StrategyGameRulesetDataStructures);

var int numSoldiersCreated;

function TSoldier CreateTSoldier( optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName )
{
    local bool shouldCreateMale;

    if(eForceGender == eGender_None)
    {
        //We only want to create a male at the start of the game.  checking for any history is a super-hacky way to do this..
        //The first ten (or so) soliders generated get sent to the "recruit" screen, so make them all female.
        shouldCreateMale = (`XCOMHISTORY.GetNumGameStates() <= 1 && numSoldiersCreated == 10);

        eForceGender = (shouldCreateMale ? eGender_Male : eGender_Female);
        numSoldiersCreated++;
    }

    return Super.CreateTSoldier(CharacterTemplateName, eForceGender, nmCountry, iRace, ArmorName);
}