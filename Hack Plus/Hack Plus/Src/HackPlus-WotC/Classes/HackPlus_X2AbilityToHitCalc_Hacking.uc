class HackPlus_X2AbilityToHitCalc_Hacking extends X2AbilityToHitCalc_Hacking;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Hacker;
	local XComGameState_BaseObject TargetState;

	History = `XCOMHISTORY;
	Hacker = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetState = History.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID);

	if (Hacker != None && TargetState != None)
	{
		ResultContext.StatContestResult = 0;
		ResultContext.HitResult = eHit_Success;

		`COMBATLOG(Hacker.GetName(eNameType_RankFull) @ "uses hack. Rolls:" @ ResultContext.StatContestResult $ "%" @ ResultContext.HitResult);
	}
	else
	{
		`COMBATLOG("Hack failed due to no Hacker or no Target!");
		ResultContext.HitResult = eHit_Miss;
	}
}
