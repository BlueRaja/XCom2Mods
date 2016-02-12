class ACU_PromotionListener extends UIScreenListener;

var ACU_UnitColorer unitColorer;

// This event is triggered after a screen is initialized
event OnInit(UIScreen screen)
{
    if(unitColorer == none)
    {
        unitColorer = new class'ACU_UnitColorer';
    }

    unitColorer.UpdateCurrentUnitColor(UIArmory_Promotion(screen));
}

defaultproperties
{
    ScreenClass = UIArmory_Promotion;
}