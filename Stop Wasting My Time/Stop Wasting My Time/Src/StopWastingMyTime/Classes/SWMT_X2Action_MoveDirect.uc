// Increase the Gremlin move speed

class SWMT_X2Action_MoveDirect extends X2Action_MoveDirect config(StopWastingMyTime);

var config float GremlinSpeedMultiplier;

function Init()
{
    local X2CharacterTemplate template;
    template = XComGameState_Unit(Metadata.StateObject_NewState).GetMyTemplate();

    if (IsGremlinTemplate(template))
    {
        AnimationRateModifier = GremlinSpeedMultiplier;
    }

    Super.Init();
}

function bool IsGremlinTemplate(X2CharacterTemplate template)
{
    return template != none && InStr(template.DataName, 'GremlinMk') == 0;
}