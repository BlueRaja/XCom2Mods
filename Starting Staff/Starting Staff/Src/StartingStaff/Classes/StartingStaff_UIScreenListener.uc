class StartingStaff_UIScreenListener extends UIScreenListener config(StartingStaff);

var config int NumStartingEngineers;
var config int NumStartingScientists;

event OnReceiveFocus(UIScreen Screen)
{
    if(IsModEnabled() && IsStrategyState() && IsNewGame())
    {
        GiveScientistsAndEngineers();
    }
}

function bool IsStrategyState()
{
    return `HQGAME != none && `HQPC != None && `HQPRES != none;
}

function bool IsModEnabled()
{
    return NumStartingEngineers > 0 || NumStartingScientists > 0;
}

function bool IsNewGame()
{
    //Hack: Since engineers/scientists are never lost (right...?), we can assume that we haven't given them any scientists/engineers yet
    return `XCOMHQ != none && `XCOMHQ.GetNumberOfEngineers() == 0 && `XCOMHQ.GetNumberOfScientists() == 0;
}

function GiveScientistsAndEngineers()
{
    local int i;

    for(i = 0; i < NumStartingScientists; i++)
    {
        GiveStaff('Scientist');
    }

    for(i = 0; i < NumStartingEngineers; i++)
    {
        GiveStaff('Engineer');
    }
}

function GiveStaff(name staffType)
{
    //Copied+edited from XComHeadquartersCheatManager:GiveScientist()
    local XComGameState NewGameState;
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameStateHistory History;
    local XComGameState_Unit UnitState;
    local CharacterPoolManager CharMgr;

    History = `XCOMHISTORY;
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Give " $ staffType);

    CharMgr = `CHARACTERPOOLMGR;

    UnitState = CharMgr.CreateCharacter(NewGameState, eCPSM_Mixed, staffType);
    
    UnitState.SetSkillLevel(5); //Default skill-level, apparently
    NewGameState.AddStateObject(UnitState);

    XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    NewGameState.AddStateObject(XComHQ);
    XComHQ.AddToCrew(NewGameState, UnitState);
    XComHQ.HandlePowerOrStaffingChange(NewGameState);

    if( NewGameState.GetNumGameStateObjects() > 0 )
    {
        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    }
    else
    {
        History.CleanupPendingGameState(NewGameState);
    }
}

defaultproperties
{
    ScreenClass = class'UIAvengerShortcuts';
}