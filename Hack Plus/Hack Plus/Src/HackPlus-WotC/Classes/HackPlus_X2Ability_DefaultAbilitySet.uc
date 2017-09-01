class HackPlus_X2Ability_DefaultAbilitySet extends X2Ability_DefaultAbilitySet;

var int finalReward;
var bool hackSuccess;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	return Templates;
}

static function X2AbilityTemplate InjectHackPlus(X2AbilityTemplate Template) {
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local HackPlusConfig hackConfig;

	hackConfig = new class'HackPlusConfig';
	if (hackConfig.getFreeAction()) {
		// successfully completing the hack requires no action point
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = 0;
		Template.AbilityCosts.Remove(0, Template.AbilityCosts.length);
		Template.AbilityCosts.AddItem(ActionPointCost);
	}

	if (hackConfig.getAlwaysSucceed()) {
		Template.AbilityToHitCalc = new class'HackPlus_X2AbilityToHitCalc_Hacking';
	}

	Template.BuildNewGameStateFn = class'HackPlus_X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildGameState;
	Template.BuildVisualizationFn = class'HackPlus_X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate FinalizeHack()
{
	local X2AbilityTemplate                 Template;		

	Template = super.FinalizeHack();
	InjectHackPlus(Template);

	return Template;
}

simulated function XComGameState FinalizeHackAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_BaseObject TargetState;
	local XComGameState_InteractiveObject ObjectState;
	local XComGameState_Unit UnitState, TargetUnit;
	local XComGameStateContext_Ability AbilityContext;
	local HackPlusConfig hackConfig;
	local int rewardValue;
	local int userRewardChoice;
	local int levelsAbove;
	local int timesAbove;

	History = `XCOMHISTORY;

	NewGameState = super.FinalizeHackAbility_BuildGameState(Context);
	hackConfig = new class'HackPlusConfig';

	AbilityContext = XComGameStateContext_Ability(Context);	
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	TargetState = NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID);

	ObjectState = XComGameState_InteractiveObject(TargetState);
	if (ObjectState == none)
		TargetUnit = XComGameState_Unit(TargetState);	
	userRewardChoice = ObjectState == none ? TargetUnit.UserSelectedHackReward : ObjectState.UserSelectedHackReward;

	if ((ObjectState != none && ObjectState.bHasBeenHacked) || TargetUnit.bHasBeenHacked) {
		rewardValue = userRewardChoice >= 2 ? hackConfig.getHackPointRewardOnSuccess() : hackConfig.getHackPointRewardEasyOnSuccess();
		hackSuccess = true;
	}
	else {
		rewardValue = hackConfig.getHackPointRewardOnFail();
		hackSuccess = false;
	}

	if (hackConfig.getDiminishingReturns()) {
		levelsAbove = UnitState.GetMaxStat(eStat_Hacking) - hackConfig.getDiminishingReturnsStartsAbove();
		if (levelsAbove > 0) {
			timesAbove = 1 + ffloor(levelsAbove / 20) - (levelsAbove % 20 == 0 ? 1 : 0);
			rewardValue -= timesAbove;
			if (rewardValue < 0)
				rewardValue = 0;
		}
	}

	if (hackConfig.getRandomizeReward() && rewardValue > 0) {
		rewardValue = `SYNC_RAND(rewardValue);
		if (rewardValue == 0)
			rewardValue = 1;
	}
	
	finalReward = rewardValue;
	if (rewardValue <= 0)
		return NewGameState;

	// Apply award
	NewGameState.AddStateObject(UnitState);
	UnitState.SetBaseMaxStat(eStat_Hacking, UnitState.GetMaxStat(eStat_Hacking) + rewardValue);	

	return NewGameState;
}

simulated function FinalizeHackAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	super.FinalizeHackAbility_BuildVisualization(VisualizeGameState);

	History = `XCOMHISTORY;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	if (finalReward > 0) {
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "+" $ finalReward $ " Hack", 'None', hackSuccess ? eColor_Good : eColor_xcom);
		SoundAndFlyOver.LookAtDuration = `DEFAULTFLYOVERLOOKATTIME;
		//SoundAndFlyOver.BlockUntilFinished = true;
		SoundAndFlyOver.DelayDuration = 1.5f;
	}
}

defaultproperties {
	finalReward = 0;
	hackSuccess = false;
}