class MSSU_UIScreenListener extends UIScreenListener;

var MSSU_Settings Settings;
var bool didUpdateTemplates;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen screen)
{
    if(!IsMainMenu(screen) && !IsStrategyState())
    {
        return;
    }

    Settings = new class'MSSU_Settings';

    if(IsMainMenu(screen))
    {
        ResetSquadSize();
    }
    else //if(IsStrategyState())
    {
        SetMaxSoldiers(GetMaxSoldiers());

        if(!didUpdateTemplates)
        {
            UpdateTemplates();
            didUpdateTemplates = true;
        }   
    }
}

function bool IsMainMenu(UIScreen screen)
{
    return screen.IsA('UIShell_NavHelpScreen');
}

function bool IsStrategyState()
{
    return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

function SetMaxSoldiers(int maxSoldiers)
{
    //m_iMaxSoldiersOnMission doesn't include the 2 for SquadSideI and SquadSizeII upgrades
    class'X2StrategyGameRulesetDataStructures'.default.m_iMaxSoldiersOnMission = maxSoldiers-2;
    class'UISquadSelect'.default.MaxDisplayedSlots = maxSoldiers;
}

function int GetMaxSoldiers()
{
    local int maxSoldiers;
    maxSoldiers = Settings.StartingSquadSize+2; //SquadSizeI/II are handled separately
    if(IsUpgradeUnlocked('SquadSizeIIIUnlock'))
        maxSoldiers++;
    if(IsUpgradeUnlocked('SquadSizeIVUnlock'))
        maxSoldiers++;
    return maxSoldiers;
}

function bool IsUpgradeUnlocked(name upgradeName)
{
    return (`XCOMHQ.SoldierUnlockTemplates.Find(upgradeName) != INDEX_NONE);
}

function UpdateTemplates()
{
    local X2StrategyElementTemplateManager templateManager;
    local X2FacilityTemplate officerSchoolTemplate;

    templateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    templateManager.AddStrategyElementTemplate(GenerateSquadSizeIIITemplate());
    templateManager.AddStrategyElementTemplate(GenerateSquadSizeIVTemplate());

    officerSchoolTemplate = X2FacilityTemplate(templateManager.FindStrategyElementTemplate('OfficerTrainingSchool'));
    officerSchoolTemplate.SoldierUnlockTemplates.AddItem('SquadSizeIIIUnlock');
    officerSchoolTemplate.SoldierUnlockTemplates.AddItem('SquadSizeIVUnlock');
    templateManager.AddStrategyElementTemplate(officerSchoolTemplate, true);
}

function X2SoldierUnlockTemplate GenerateSquadSizeIIITemplate()
{
    local X2SoldierUnlockTemplate Template;
    local ArtifactCost Resources;

    `CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'SquadSizeIIIUnlock');

    Template.bAllClasses = true;
    Template.strImage = "img:///MoreSquadSizeUpgrades_UILibrary.GTS.GTS_SquadSize3";

    // Requirements
    Template.Requirements.RequiredHighestSoldierRank = Settings.SquadSizeIIIRequiredRank;
    Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

    // Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = Settings.SquadSizeIIICost;
    Template.Cost.ResourceCosts.AddItem(Resources);

    return Template;
}

function X2SoldierUnlockTemplate GenerateSquadSizeIVTemplate()
{
    local X2SoldierUnlockTemplate Template;
    local ArtifactCost Resources;

    `CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'SquadSizeIVUnlock');

    Template.bAllClasses = true;
    Template.strImage = "img:///MoreSquadSizeUpgrades_UILibrary.GTS.GTS_SquadSize4";

    // Requirements
    Template.Requirements.RequiredHighestSoldierRank = Settings.SquadSizeIVRequiredRank;
    Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

    // Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = Settings.SquadSizeIVCost;
    Template.Cost.ResourceCosts.AddItem(Resources);

    return Template;
}
 
function ResetSquadSize()
{
    SetMaxSoldiers(Settings.StartingSquadSize+2);
}
 
defaultproperties
{
    // Leaving this assigned to none will cause every screen to trigger its signals on this class
    ScreenClass = none;
}