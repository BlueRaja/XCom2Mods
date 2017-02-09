class RulerReactionsRevised_X2AbilityTrigger_DLC_Day60OnAbilityActivated extends X2AbilityTrigger_DLC_Day60OnAbilityActivated;

function bool AbilityCanTriggerAlienRulerAction(XComGameState_Ability ability, XComGameState gameState)
{
    local RulerReactionsRevised_Settings settings;
    local EAbilityHostility hostility;
    local float reactChance;

    if(!super.AbilityCanTriggerAlienRulerAction(ability, gameState))
    {
        return false;
    }
    
    settings = new class'RulerReactionsRevised_Settings';
    hostility = ability.GetMyTemplate().Hostility;
    reactChance = hostility == eHostility_Offensive ? settings.ChanceReactToOffensive :
                  hostility == eHostility_Defensive ? settings.ChanceReactToDefensive :
                  hostility == eHostility_Neutral ? settings.ChanceReactToNeutral :
                  settings.ChanceReactToMovement;

    return `SYNC_FRAND < reactChance;
}