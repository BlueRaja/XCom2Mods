class ACU_PromotionPsiOpListener extends UIScreenListener;

var ACU_UnitColorer unitColorer;

event OnInit(UIScreen screen)
{
    if(unitColorer == none)
    {
        unitColorer = new class'ACU_UnitColorer';
    }

    unitColorer.UpdateUnitColor(UIArmory(screen).GetUnit());
}

defaultproperties
{
    ScreenClass = UIArmory_PromotionPsiOp;
}