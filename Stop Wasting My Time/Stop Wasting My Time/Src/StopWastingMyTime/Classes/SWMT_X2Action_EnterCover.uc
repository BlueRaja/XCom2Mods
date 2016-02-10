class SWMT_X2Action_EnterCover extends X2Action_EnterCover dependson(XGUnitNativeBase, XComAnimNodeBlendDynamic);

function Init(const out VisualizationTrack InTrack)
{
    bInstantEnterCover = true;
    Super.Init(InTrack);
}
