class ASGX_UIScreenListener extends UIScreenListener dependson(XComGameState_Unit);

const DEFAULT_KILL_ASSISTS_PER_KILL = 4;
var ASGX_Settings Settings;

event OnInit(UIScreen Screen)
{
    local UIMissionSummary missionSummary;
    local float numKillAssists;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> allUnits;

    missionSummary = UIMissionSummary(Screen);
    if(missionSummary == none)
    {
        return;
    }

    Settings = new class'ASGX_Settings';
    if(Settings.PassiveXPPercentage <= 0)
    {
        return;
    }

    numKillAssists = (GetNumKillAssists() + GetNumKillsFromTransferMission()) * Settings.PassiveXPPercentage;
    allUnits = GetAllUnits();
    foreach allUnits(unit)
    {
        if(ShouldGainPassiveXP(unit))
        {
            GainKillAssists(unit, numKillAssists);
        }
    }
}

function array<XComGameState_Unit> GetAllEnemies()
{
    local XGAIPlayer_TheLost lostPlayer;
    local XGBattle_SP battle;
    local array<XComGameState_Unit> killedEnemies;

    battle = XGBattle_SP(`BATTLE);
    battle.GetAIPlayer().GetOriginalUnits(killedEnemies);

	lostPlayer = battle.GetTheLostPlayer();
	if (lostPlayer != none)
    {
		lostPlayer.GetOriginalUnits(killedEnemies);
    }

    return killedEnemies;
}

function float GetNumKillAssists()
{
    local array<XComGameState_Unit> allEnemies;
    local float numKillAssists;
    local XComGameState_Unit enemy;

    numKillAssists = 0;
    allEnemies = GetAllEnemies();
    foreach allEnemies(enemy)
    {
        if(enemy.IsDead())
        {
            numKillAssists += enemy.GetMyTemplate().KillContribution;
        }
    }

    return numKillAssists;
}

function int GetNumKillsFromTransferMission()
{
    // Hack: If the mission is a "direct transfer mission", there was no mission over screen so we didn't get credit for the last mission's kills
    // However, there is no way of knowing which enemies were killed on the last mission
    // The best we can do is give 1 kill assist for each enemy killed
    local XComGameState_BattleData StaticBattleData;
    StaticBattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    if(StaticBattleData.DirectTransferInfo.IsDirectMissionTransfer)
    {
        return StaticBattleData.DirectTransferInfo.AliensKilled;
    }
    return 0;
}

function array<XComGameState_Unit> GetAllUnits()
{
    local int i;
    local XComGameState_Unit unit;
    local array<XComGameState_Unit> unitList;

    for(i = 0; i < `XCOMHQ.Crew.Length; i++)
    {
        Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.Crew[i].ObjectID));

        if(Unit.IsSoldier() && Unit.IsAlive())
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

function bool IsWounded(XComGameState_Unit unit)
{
    return unit.GetStatus() == eStatus_Healing;
}

function bool IsCovertOperative(XComGameState_Unit unit)
{
    return unit.GetStatus() == eStatus_CovertAction;
}

function bool ShouldGainPassiveXP(XComGameState_Unit unit)
{
    if(!unit.IsSoldier() || unit.IsDead())
        return false;
    if(IsOnMission(unit))
        return false; //Already gained XP from being on mission
    if(unit.GetRank() == 0 && !Settings.RookiesGainXP)
        return false;
    if(IsWounded(unit) && !Settings.WoundedUnitsGainXP)
        return false;
    if(IsCovertOperative(unit) && !Settings.CovertOperativesGainXP)
        return false;
    return Settings.TrainingUnitsGainXP || IsIdle(unit);
}

function GainKillAssists(XComGameState_Unit unit, int numKillAssists)
{
    //Mostly adapted from XComGameState_Unit.OnUnitDied()
    local XComGameState newGameState;
    local XComGameState_Unit killAssistant;

    if(numKillAssists <= 0)
    {
        return;
    }

    newGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("End of mission KillAssists");
    killAssistant = XComGameState_Unit(NewGameState.CreateStateObject(unit.Class, unit.ObjectID));
    killAssistant.bRankedUp = false; //Hack - for some reason this value is set to true, causing CanRankUpSoldier() to return false

    killAssistant.KillAssistsCount += numKillAssists;

    if (ShouldLevelUpSoldier(killAssistant))
    {
        LevelUpSoldier(killAssistant, newGameState);
    }

    newGameState.AddStateObject(killAssistant);
    `XCOMGAME.GameRuleset.SubmitGameState(newGameState);
}

function bool ShouldLevelUpSoldier(XComGameState_Unit unit)
{
    return Settings.UnitsCanLevelUpOutsideOfMission && unit.CanRankUpSoldier();
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
