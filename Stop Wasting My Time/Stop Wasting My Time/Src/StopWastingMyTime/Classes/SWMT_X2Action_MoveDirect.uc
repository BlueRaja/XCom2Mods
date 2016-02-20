class SWMT_X2Action_MoveDirect extends X2Action_MoveDirect config(StopWastingMyTime);

var config float GremlinSpeedMultiplier;

function Init(const out VisualizationTrack InTrack)
{
    local X2CharacterTemplate template;
    template = XComGameState_Unit(InTrack.StateObject_NewState).GetMyTemplate();

    if (IsGremlinTemplate(template))
    {
        AnimationRateModifier = GremlinSpeedMultiplier;
    }

    Super.Init (InTrack);
}

function bool IsGremlinTemplate(X2CharacterTemplate template)
{
    return template != none && InStr(template.DataName, 'GremlinMk') == 0;
}