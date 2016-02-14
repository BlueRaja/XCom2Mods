class ASGX_UIScreenListener extends UIScreenListener dependson(XComGameState_Unit) config (AllSoldiersGainXP);

var config float PassiveXPPercentage;
var config bool UnitsCanLevelUpOutsideOfMission;
var config bool WoundedAndTrainingUnitsGainXP;

event OnInit(UIScreen Screen)
{
	local UIMissionSummary missionSummary;
    local int enemiesKilled, enemiesTotal;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> allUnits;
    
    missionSummary = UIMissionSummary(Screen);
    enemiesKilled = missionSummary.GetNumEnemiesKilled(enemiesTotal);

    allUnits = GetAllUnits();
    foreach allUnits(unit)
    {
        if(ShouldGainPassiveXP(unit))
        {
            GainKills(unit, GetRandomNumKills(enemiesKilled));
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
    return unit.GetHQLocation() == eSoldierLoc_Dropship;
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

    return WoundedAndTrainingUnitsGainXP || IsIdle(unit);
}

function int GetRandomNumKills(int enemiesKilledOnMission)
{
    local int numKillsToAdd, i;

    for(i = 0; i < enemiesKilledOnMission; i++)
    {
        //There's normally about 4 "KillAssists" to one Kill.  However, we can't add KillAssists, so we emulate it by randomly giving a kill 1/4th of the time.
        if(0.25*PassiveXPPercentage*100 > Rand(100))
        {
            numKillsToAdd++;
        }
    }
    return numKillsToAdd;
}

function GainKills(XComGameState_Unit unit, int numKills)
{
    //Mostly adapted from XComGameState_Unit.OnUnitDied()
    local int i;
    local XComGameState NewGameState;
    local XComGameState_Unit killAssistant;
    local UnitValue RankUpValue;

    if(numKills <= 0)
    {
        return;
    }

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("End of mission KillAssists");
    KillAssistant = XComGameState_Unit(NewGameState.CreateStateObject(unit.Class, unit.ObjectID));

    for(i = 0; i < numKills; i++)
    {
        KillAssistant.SimGetKill(unit.GetReference()); //Parameter here doesn't really matter
    }

    if (UnitsCanLevelUpOutsideOfMission && KillAssistant.CanRankUpSoldier())
	{
		RankUpValue.fValue = 0;
		KillAssistant.GetUnitValue('RankUpMessage', RankUpValue);
		if (RankUpValue.fValue == 0)
		{
			//`XEVENTMGR.TriggerEvent('RankUpMessage', KillAssistant, KillAssistant, NewGameState);
			KillAssistant.SetUnitFloatValue('RankUpMessage', 1, eCleanup_BeginTactical);
		}
	}

    NewGameState.AddStateObject(KillAssistant);
    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

defaultProperties
{
    ScreenClass = UIMissionSummary
}