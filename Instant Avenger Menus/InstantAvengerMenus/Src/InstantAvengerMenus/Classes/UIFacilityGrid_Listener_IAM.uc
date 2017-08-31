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

defaultproperties
{
	ScreenClass = none
}