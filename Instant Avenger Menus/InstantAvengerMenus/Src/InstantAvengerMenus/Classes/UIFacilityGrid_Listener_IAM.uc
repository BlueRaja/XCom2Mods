// The room --> main base transition is controlled by UIFacilityGrid, so we can't disable it from XComHQ_IAM

class UIFacilityGrid_Listener_IAM extends UIScreenListener;

function OnInit(UIScreen screen)
{
    local IAM_Settings settings;
	if(UIFacilityGrid(screen) != none)
	{
        settings = new class'IAM_Settings';
        if(settings.InstantRoomTransitions)
        {
		    UIFacilityGrid(screen).bInstantInterp = true;
        }
	}
}

function OnLoseFocus(UIScreen screen)
{
    local IAM_Settings settings;
	if(UIFacilityGrid(screen) != none)
	{
        settings = new class'IAM_Settings';
		if(settings.InstantRoomTransitions)
        {
		    UIFacilityGrid(screen).bInstantInterp = true;
        }
	}
}

// Fix for never-ending skyranger noise
// Credit to Robojumper: http://steamcommunity.com/sharedfiles/filedetails/?id=868937841
event OnRemoved(UIScreen screen)
{
	if (UIInventory_LootRecovered(screen) != none)	
	{
		class'WorldInfo'.static.GetWorldInfo().PostAkEvent(AkEvent'SoundSkyranger.Stop_Skyranger_Lower_Interior_LP');
	}
}

defaultproperties
{
	ScreenClass = none
}