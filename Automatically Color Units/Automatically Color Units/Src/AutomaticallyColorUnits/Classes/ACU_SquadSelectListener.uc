class ACU_SquadSelectListener extends UIScreenListener;

var ACU_UnitColorer unitColorer;

event OnInit(UIScreen screen)
{
    if(unitColorer == none)
    {
        unitColorer = new class'ACU_UnitColorer';
    }

    unitColorer.UpdateAllUnitsColor();
}

defaultproperties
{
    ScreenClass = UISquadSelect;
}