class ACU_AllScreenListener extends UIScreenListener;
// Just receive events from all Screens to prevent conflicts with LW_Toolbox

var ACU_UnitColorer unitColorer;
var UIArmory armoryScreen;

event OnInit(UIScreen screen)
{
	if(unitColorer == none)
	{
		unitColorer = new class'ACU_UnitColorer';
	}

	if (UIArmory_MainMenu(screen) != none || UIArmory_PromotionPsiOp(screen) != none)
	{
		unitColorer.UpdateUnitColor(UIArmory(screen).GetUnit());
	} else if (UISquadSelect(screen) != none)
	{
		unitColorer.UpdateAllUnitsColor();
	} else if (UIArmory_Promotion(screen) != none)
	{
		armoryScreen = UIArmory(screen);
		`XCOMHISTORY.RegisterOnNewGameStateDelegate(OnNewGameState);
		unitColorer.UpdateUnitColor(armoryScreen.GetUnit());
	}
}

event OnRemoved(UIScreen screen)
{
	if (UIArmory_Promotion(screen) != none )
	{
		`XCOMHISTORY.UnRegisterOnNewGameStateDelegate(OnNewGameState);
		armoryScreen = none;
	}
}

private function OnNewGameState(XComGameState newGameState)
{
    local XComGameStateContext context;
    context = newGameState.GetContext();

    if(context.IsA('XComGameStateContext_ChangeContainer'))
    {
        if(XComGameStateContext_ChangeContainer(context).ChangeInfo == "Soldier Promotion")
        {
            unitColorer.UpdateUnitColor(armoryScreen.GetUnit());
        }
    }
}