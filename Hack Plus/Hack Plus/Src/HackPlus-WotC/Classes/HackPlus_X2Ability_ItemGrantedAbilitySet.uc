class HackPlus_X2Ability_ItemGrantedAbilitySet extends X2Ability_ItemGrantedAbilitySet;


static function X2AbilityTemplate FinalizeSKULLJACK()
{
	local X2AbilityTemplate                 Template;

	Template = super.FinalizeSKULLJACK();
	Template = class'HackPlus_X2Ability_DefaultAbilitySet'.static.InjectHackPlus(Template);

	return Template;
}

static function X2AbilityTemplate FinalizeSKULLMINE()
{
	local X2AbilityTemplate                 Template;

	Template = super.FinalizeSKULLMINE();
	Template = class'HackPlus_X2Ability_DefaultAbilitySet'.static.InjectHackPlus(Template);

	return Template;
}