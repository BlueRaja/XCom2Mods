class SWMT_ScreenListener_UITacticalHUD extends UIScreenListener config (StopWastingMyTime);

var config array<string> NarrativesToRemove;

event OnInit(UIScreen Screen)
{
    local XComTacticalMissionManager missionManager;
    local X2MissionNarrativeTemplateManager templateManager;
    local X2MissionNarrativeTemplate narrativeTemplate;
    local string narrativeName;

    missionManager = `TACTICALMISSIONMGR;
    templateManager = class'X2MissionNarrativeTemplateManager'.static.GetMissionNarrativeTemplateManager();
    narrativeTemplate = templateManager.FindMissionNarrativeTemplate(missionManager.ActiveMission.sType, missionManager.MissionQuestItemTemplate);

    foreach NarrativesToRemove(narrativeName)
    {
        RemoveNarrative(NarrativeTemplate, narrativeName);
    }

    templateManager.AddMissionNarrativeTemplate(narrativeTemplate, true);
}

function RemoveNarrative(X2MissionNarrativeTemplate narrativeTemplate, string narrativeName)
{
    local int i;

    i = narrativeTemplate.NarrativeMoments.Find(narrativeName);
    if (i >= 0) 
    {
        //Replace the narrative with an empty string
        narrativeTemplate.NarrativeMoments[i] = "";
    }
}

defaultProperties
{
    ScreenClass = UITacticalHUD
}