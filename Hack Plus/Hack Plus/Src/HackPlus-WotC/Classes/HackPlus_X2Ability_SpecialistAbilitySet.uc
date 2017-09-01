class HackPlus_X2Ability_SpecialistAbilitySet extends X2Ability_SpecialistAbilitySet;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	return Templates;
}

static function X2AbilityTemplate FinalizeIntrusion(name FinalizeName, bool bHaywire)
{
	local X2AbilityTemplate                 Template;		

	Template = super.FinalizeIntrusion(FinalizeName, bHaywire);
	Template = class'HackPlus_X2Ability_DefaultAbilitySet'.static.InjectHackPlus(Template);

	return Template;
}
