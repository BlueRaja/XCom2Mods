class SWMT_X2Action_MoveDirect extends X2Action_MoveDirect;

function Init(const out VisualizationTrack InTrack)
{
	local X2CharacterTemplate UnitTemplate;

	// Get the animating unit's template
	UnitTemplate = XComGameState_Unit(InTrack.StateObject_NewState).GetMyTemplate();

	if (UnitTemplate != none)
	{
		// If the animating unit is a cosmetic unit,
		if (UnitTemplate.bIsCosmetic)
		{
			// Reset the animation modifier to the proper/default value
			AnimationRateModifier = UnitTemplate.SoloMoveSpeedModifier;
		}
	}

	Super.Init (InTrack);
}