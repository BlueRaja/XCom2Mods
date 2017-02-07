class FasterPsiLabTraining_UIScreenListener extends UIScreenListener;

var FasterPsiLabTraining_Settings Settings;

event OnReceiveFocus(UIScreen Screen)
{
    if(IsStrategyState())
    {
        Settings = new class'FasterPsiLabTraining_Settings';
        `XCOMHQ.PsiTrainingRate = GetNewPsiTrainingRate();
    }
}

function int GetNewPsiTrainingRate()
{
    local float newTrainingRate;
    newTrainingRate = GetCurrentPsiTrainingRate()*Settings.PsiTrainingRateMultiplier;
    return Max(1, Round(newTrainingRate));
}

function int GetCurrentPsiTrainingRate()
{
    local int trainingRate;
    local StateObjectReference facilityState;
    local XComGameState_FacilityXCom facility;
    trainingRate = class'XComGameState_HeadquartersXCom'.default.XComHeadquarters_DefaultPsiTrainingWorkPerHour;

    //Loop through buildings, find Psi Labs, apply engineer bonuses
    foreach `XCOMHQ.Facilities(facilityState)
    {
        facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(facilityState.ObjectID));
        if(facility.GetMyTemplateName() == 'PsiChamber')
        {
            trainingRate += GetTrainingBonusForPsiLab(facility);
        }
    }

    return trainingRate;
}

function int GetTrainingBonusForPsiLab(XComGameState_FacilityXCom facility)
{
    local XComGameState_StaffSlot staffSlot;
    local StateObjectReference staffSlotState;
    local XComGameState_Unit staffUnit;
    local int trainingBonus;

    trainingBonus = 0;
    foreach facility.StaffSlots(staffSlotState)
    {
        staffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(staffSlotState.ObjectID));
        staffUnit = staffSlot.GetAssignedStaff();
        if(staffSlot.GetMyTemplateName() == 'PsiChamberScientistStaffSlot' && staffUnit != none)
        {
            trainingBonus += staffSlot.GetMyTemplate().GetContributionFromSkillFn(staffUnit);
        }
    }

    return trainingBonus;
}

function bool IsStrategyState()
{
    return `HQGAME != none && `HQPC != None && `HQPRES != none;
}

defaultproperties
{
    ScreenClass = none;
}