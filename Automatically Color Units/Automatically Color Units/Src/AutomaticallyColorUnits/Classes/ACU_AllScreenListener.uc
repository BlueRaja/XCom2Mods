class ACU_AllScreenListener extends UIScreenListener;

var ACU_UnitColorer unitColorer;
var UIArmory armoryScreen;

event OnInit(UIScreen screen)
{
    if (unitColorer == none)
    {
        unitColorer = new class'ACU_UnitColorer';
    }

    if (UIArmory_Promotion(screen) != none)
    {
        armoryScreen = UIArmory(screen);
        `XCOMHISTORY.RegisterOnNewGameStateDelegate(OnNewGameState);
    }

    ColorUnitsForScreen(screen);
}

event OnReceiveFocus(UIScreen screen)
{
    ColorUnitsForScreen(screen);
}

event OnRemoved(UIScreen screen)
{
    if (UIArmory_Promotion(screen) != none )
    {
        `XCOMHISTORY.UnRegisterOnNewGameStateDelegate(OnNewGameState);
        armoryScreen = none;
    }
}

private function ColorUnitsForScreen(UIScreen screen)
{
    if (UIArmory_PromotionPsiOp(screen) != none
     || UIArmory_Promotion(screen) != none
     || UIArmory_MainMenu(screen) != none)
    {
        unitColorer.UpdateUnitColor(UIArmory(screen).GetUnit());
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

defaultproperties
{
    ScreenClass = none;
} 