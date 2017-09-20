class MSSU_UISquadSelect extends UIScreenListener config(MoreSquadSizeUpgrades);

event OnInit(UIScreen screen)
{
    local UISquadSelect squadSelect;
    local MSSU_Settings settings;

    squadSelect = UISquadSelect(screen);
    if(squadSelect == none)
    {
        return;
    }

    settings = new class'MSSU_Settings';
    if(settings.SquadSelectUI == "Compatibility mode")
    {
        return;
    }

    ShowButtonsForEveryUnit(squadSelect);

    if(settings.SquadSelectUI == "Fit all soldiers")
    {
        TryToFitListItems(SquadSelect.m_kSlotList, SquadSelect.Movie.UI_RES_X);
    }
}

//Allows extra units to actually be selected.  Thanks to hairlessOrphan ( http://steamcommunity.com/sharedfiles/filedetails/?id=619112580 ) for the fix.
function ShowButtonsForEveryUnit(UISquadSelect squadSelect)
{
    local int i;

    if (squadSelect.SlotListOrder.Length < squadSelect.SoldierSlotCount)
    {
        for (i = squadSelect.SlotListOrder.Length; i < squadSelect.SoldierSlotCount; i++)
        {
            squadSelect.SlotListOrder[i] = i;
        }
    }

    squadSelect.UpdateData();
}

//Attempts to shrink all the unit icons so they fit on the screen
function TryToFitListItems(UIList unitList, int screenWidth)
{
    UpdateListSize(unitList, screenWidth);

    UpdateItemsSizeAndLocation(unitList);

    unitList.RealizeList();
}

//Resize the list and center everything in it so items aren't left-aligned
//(UIList supports center-alignment, but for some reason UISquadScreen tries to do it manually.  Here we reenable the center-alignment
// to keep the math simple)
function UpdateListSize(UIList unitList, int screenWidth)
{
    local int availableScreenWidth;

    const listMargin = 10;

    availableScreenWidth = screenWidth - listMargin*2;

    unitList.bCenterNoScroll = true;
    unitList.SetWidth(availableScreenWidth);
    unitList.SetX(listMargin);
}

//Resize the unit icons on the squad-select screen to all fit on the screen
function UpdateItemsSizeAndLocation(UIList unitList)
{
    local UISquadSelect_ListItem unitListItem;
    local int totalPadding, itemWidth, totalItemWidth, paddingLeft, i;

    const minItemWidth = 225;
    const maxItemWidth = 285;
    const itemPadding = 3;
    const flashMultiplier = 1.19;

    // Hack, we set our own padding
    unitList.ItemPadding = 0;
    unitList.TotalItemSize = unitList.Width;

    totalPadding = itemPadding*(unitList.ItemCount-1);
    itemWidth = (unitList.Width - totalPadding)/unitList.ItemCount;
    itemWidth = Clamp(itemWidth, minItemWidth, maxItemWidth);
    totalItemWidth = itemWidth*unitList.ItemCount + totalPadding;
    paddingLeft = (unitList.Width - totalItemWidth)/2;

    for (i = 0; i < unitList.ItemCount; ++i) 
    {
        unitListItem = UISquadSelect_ListItem(unitList.GetItem(i));
        unitListItem.SetWidth(itemWidth * flashMultiplier); // For some reason the Flash layer shrinks the item by 17%
        unitListItem.SetX(paddingLeft + i*(itemWidth + itemPadding));
    }
}

defaultproperties
{
    ScreenClass = none;
}