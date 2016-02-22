class ACU_PromotionListener extends UIScreenListener;

var ACU_UnitColorer unitColorer;
var UIArmory armoryScreen;

event OnInit(UIScreen screen)
{
    if(unitColorer == none)
    {
        unitColorer = new class'ACU_UnitColorer';
    }

    armoryScreen = UIArmory(screen);
    `XCOMHISTORY.RegisterOnNewGameStateDelegate(OnNewGameState);

    unitColorer.UpdateUnitColor(armoryScreen.GetUnit());
}

event OnRemoved(UIScreen screen)
{
    `XCOMHISTORY.UnRegisterOnNewGameStateDelegate(OnNewGameState);
    armoryScreen = none;
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

defaultproperties
{
    ScreenClass = UIArmory_Promotion;
}