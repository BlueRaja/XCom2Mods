//Allows extra units to actually be selected.  Thanks to hairlessOrphan ( http://steamcommunity.com/sharedfiles/filedetails/?id=619112580 ) for the fix.
class LSS_SquadSelectWorkaround extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UISquadSelect SquadSelect;
	local int i;

	SquadSelect = UISquadSelect(Screen);

	if (SquadSelect.SlotListOrder.Length < SquadSelect.SoldierSlotCount)
	{
		for (i = SquadSelect.SlotListOrder.Length; i < SquadSelect.SoldierSlotCount; i++)
		{
			SquadSelect.SlotListOrder[i] = i;
		}
	}

	SquadSelect.UpdateData();
}

defaultproperties
{
	ScreenClass = UISquadSelect;
}