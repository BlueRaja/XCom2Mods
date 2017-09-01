class HackPlusUIScreenListener extends UIScreenListener;
 
var bool didUpdateTemplates;
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	if(!didUpdateTemplates)
	{
		UpdateTemplates();
		didUpdateTemplates = true;
	}   
}

function bool IsStrategyState()
{
    return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

function UpdateTemplates()
{
	local X2AbilityTemplateManager Manager;
	local X2AbilityTemplate Template;

	Manager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = class'HackPlus_X2Ability_DefaultAbilitySet'.static.FinalizeHack();
	Manager.AddAbilityTemplate(Template, true);

	Template = class'HackPlus_X2Ability_SpecialistAbilitySet'.static.FinalizeIntrusion('FinalizeIntrusion', false);
	Manager.AddAbilityTemplate(Template, true);

	Template = class'HackPlus_X2Ability_SpecialistAbilitySet'.static.FinalizeIntrusion('FinalizeHaywire', true);
	Manager.AddAbilityTemplate(Template, true);
}
