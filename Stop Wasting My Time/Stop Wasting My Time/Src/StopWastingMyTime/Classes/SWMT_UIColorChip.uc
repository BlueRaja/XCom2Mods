class SWMT_UIColorChip extends UIColorChip;

//Remove the fade-in for color chips that causes it to look like we're loading from a slow webpage...
simulated function AnimateIn(optional float Delay = -1.0)
{
    super.AnimateIn(Delay == -1 ? 0.0 : Delay/10);
}

simulated function AnimateOut(optional float Delay = -1.0)
{
    super.AnimateOut(Delay == -1 ? 0.0 : Delay/10);
}