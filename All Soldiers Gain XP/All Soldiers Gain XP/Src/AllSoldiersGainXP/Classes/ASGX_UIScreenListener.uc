class ASGX_UIScreenListener extends UIScreenListener dependson(XComGameState_Unit) config (AllSoldiersGainXP);

var config float PassiveXPPercentage;
var config bool UnitsCanLevelUpOutsideOfMission;
var config bool WoundedAndTrainingUnitsGainXP;
var config bool RookiesGainXP;

const DEFAULT_KILL_ASSISTS_PER_KILL = 4;

event OnInit(UIScreen Screen)
{
    local UIMissionSummary missionSummary;
    local int enemiesKilled, enemiesTotal, numKillsToAdd, killAssistsPerKill;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> allUnits;

    missionSummary = UIMissionSummary(Screen);

    if(PassiveXPPercentage <= 0 || missionSummary == none)
    {
        return;
    }

    enemiesKilled = missionSummary.GetNumEnemiesKilled(enemiesTotal);
    allUnits = GetAllUnits();
    foreach allUnits(unit)
    {
        if(ShouldGainPassiveXP(unit))
        {
            killAssistsPerKill = unit.GetSoldierClassTemplate().KillAssistsPerKill;

            //Long War 2 sets this to 0, so default it to a nice number
            killAssistsPerKill = (killAssistsPerKill > 0 ? killAssistsPerKill : DEFAULT_KILL_ASSISTS_PER_KILL);

            numKillsToAdd = GetNumKillsToAdd(enemiesKilled, killAssistsPerKill);
            GainKills(unit, numKillsToAdd);
        }
    }
}

function array<XComGameState_Unit> GetAllUnits()
{
    local int i;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> unitList;

    for(i = 0; i < `XCOMHQ.Crew.Length; i++)
    {
        Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.Crew[i].ObjectID));

        if(Unit.IsASoldier() && Unit.IsAlive())
        {
            unitList.AddItem(unit);
        }
    }

    return unitList;
}

function bool IsOnMission(XComGameState_Unit unit)
{
    local StateObjectReference squadUnitRef;

    foreach `XCOMHQ.Squad(squadUnitRef)
    {
        if(squadUnitRef.ObjectId == unit.ObjectId)
        {
            return true;
        }
    }
    return false;
}

function bool IsIdle(XComGameState_Unit unit)
{
    return unit.GetStatus() == eStatus_Active;
}

function bool ShouldGainPassiveXP(XComGameState_Unit unit)
{
    if(!unit.IsSoldier() || unit.IsDead())
        return false;
    if(IsOnMission(unit))
        return false; //Already gained XP from being on mission
    if(unit.GetRank() == 0 && !RookiesGainXP)
        return false;
    return WoundedAndTrainingUnitsGainXP || IsIdle(unit);
}

function int GetNumKillsToAdd(int enemiesKilledOnMission, int killAssistsPerKill)
{
    //Give a percentage of the kills to people in the barracks
    //Since this could result in a fractional value, randomly give an extra kill based on the fractional value
    local float fractionalKills, randomChance;
    local int killsToAdd;

    fractionalKills = PassiveXPPercentage*enemiesKilledOnMission/killAssistsPerKill;
    killsToAdd = int(fractionalKills);
    randomChance = fractionalKills - killsToAdd;

    if(int(randomChance*1000) > Rand(1000))
    {
        killsToAdd++;
    }

    return killsToAdd;
}

function GainKills(XComGameState_Unit unit, int numKills)
{
    //Mostly adapted from XComGameState_Unit.OnUnitDied()
    local int i;
    local XComGameState NewGameState;
    local XComGameState_Unit killAssistant;

    if(numKills <= 0)
    {
        return;
    }

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("End of mission KillAssists");
    KillAssistant = XComGameState_Unit(NewGameState.CreateStateObject(unit.Class, unit.ObjectID));
    KillAssistant.bRankedUp = false; //Hack - for some reason this value is set to true, causing CanRankUpSoldier() to return false

    for(i = 0; i < numKills; i++)
    {
        KillAssistant.SimGetKill(unit.GetReference()); //Parameter here doesn't really matter
    }

    if (ShouldLevelUpSoldier(KillAssistant))
    {
        LevelUpSoldier(KillAssistant, NewGameState);
    }

    NewGameState.AddStateObject(KillAssistant);
    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

function bool ShouldLevelUpSoldier(XComGameState_Unit unit)
{
    return UnitsCanLevelUpOutsideOfMission && unit.CanRankUpSoldier();
}

function LevelUpSoldier(XComGameState_Unit unit, XComGameState newGameState)
{
    if(unit.GetRank() == 0)
    {
        //Have to apply class and change weapons when going from Rookie to Squaddie
        unit.RankUpSoldier(newGameState, `XCOMHQ.SelectNextSoldierClass());
        unit.ApplySquaddieLoadout(newGameState);
        unit.ApplyBestGearLoadout(newGameState);
    }
    else
    {
        unit.RankUpSoldier(newGameState, unit.GetSoldierClassTemplate().DataName);
    }
    
    unit.bRankedUp = true;
}

defaultProperties
{
    ScreenClass = none
}
