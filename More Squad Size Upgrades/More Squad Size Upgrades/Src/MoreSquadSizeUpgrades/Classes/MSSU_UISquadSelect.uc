class MSSU_UISquadSelect extends UIScreenListener config(MoreSquadSizeUpgrades);

var config bool TryToFitEveryoneOnSquadSelectScreen;

event OnInit(UIScreen screen)
{
    local UISquadSelect squadSelect;
    squadSelect = UISquadSelect(screen);

    ShowButtonsForEveryUnit(squadSelect);

    if(TryToFitEveryoneOnSquadSelectScreen)
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
    local int totalPadding, itemWidth, i, flashPaddingPixels;

    const minItemWidth = 225;
    const maxItemWidth = 282;
    const flashPaddingPercentage = 0.04;

    totalPadding = unitList.ItemPadding*(unitList.ItemCount-1);
    itemWidth = (unitList.Width - totalPadding)/unitList.ItemCount;
    itemWidth = Clamp(itemWidth, minItemWidth, maxItemWidth);

    if(itemWidth != maxItemWidth)
    {
        //BUG WORKAROUND: The call to unitListItem.SetWidth() calls some actionScript code which inexplicably adds padding to the listItem.
        //I have no idea why, but to work around that we have to
        //1. Determine how much padding is added
        //2. Lie to SetWidth() so that the size of the actual listItem is correct
        //3. Manually set the Width property
        //4. Adjust the X-coordinate manually to get rid of the padding
        unitList.ItemPadding = 3;
        flashPaddingPixels = itemWidth*flashPaddingPercentage;

        for (i = 0; i < unitList.ItemCount; ++i) 
        {
            unitListItem = UISquadSelect_ListItem(unitList.GetItem(i));
            unitListItem.SetWidth(itemWidth + 2*flashPaddingPixels);
            unitListItem.Width = itemWidth;
            unitListItem.SetX(i*(itemWidth + unitList.ItemPadding) - flashPaddingPixels);
        }

        unitList.TotalItemSize = unitList.ItemCount*(itemWidth + unitList.ItemPadding) - unitList.ItemPadding;
    }
}

defaultproperties
{
    ScreenClass = UISquadSelect;
}