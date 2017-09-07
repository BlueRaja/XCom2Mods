class XComHQ_IAM extends XComHQPresentationLayer;

var private Vector2D DoomEntityLoc; // for doom panning

var protected int TicksTillMap;

function UIArmory_MainMenu(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false)
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	if(ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(ScreenStack.Push(Spawn(class'UIArmory_MainMenu', self), Get3DMovie())).InitArmory(UnitRef, , SoldSpawnEvent, , HideEvent, RemoveEvent, bInstant || settings.InstantRoomTransitions);
}

reliable client function CAMLookAtNamedLocation( string strLocation, optional float fInterpTime = 2, optional bool bSkipBaseViewTransition, optional Vector ForceLocation, optional Rotator ForceRotation )
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	if(settings.InstantRoomTransitions)
		fInterpTime *= 0.001f;
	super.CAMLookAtNamedLocation (strLocation, fInterpTime, bSkipBaseViewTransition, ForceLocation, ForceRotation);
}

reliable client function CAMLookAtHQTile( int x, int y, optional float fInterpTime = 2, optional Vector ForceLocation, optional Rotator ForceRotation )
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	if(settings.InstantRoomTransitions)
		fInterpTime *= 0.001f;
	super.CAMLookAtHQTile (x, y, fInterpTime, ForceLocation, ForceRotation);
}

//----------------------------------------------------
// HOLOGLOBE DISSOLVE ANIMATION
//----------------------------------------------------

function UIEnterStrategyMap(bool bSmoothTransitionFromSideView = false)
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	if(!settings.SkipHologlobeDissolveAnimation || !bSmoothTransitionFromSideView)
	{
		super.UIEnterStrategyMap(bSmoothTransitionFromSideView);
		return;
	}

	m_bCanPause = false;
	WorldInfo.RemoteEventListeners.AddItem(self);

	// We need at least 5 ticks for it to not break when instantly transitioning
	// Anything less than 5 will cause the issue
	TicksTillMap = 5;
	
	m_kAvengerHUD.ClearResources();
	m_kAvengerHUD.HideEventQueue();
	m_kFacilityGrid.Hide();
	m_kAvengerHUD.Shortcuts.Hide();
	m_kAvengerHUD.ToDoWidget.Hide();
}

simulated function Tick( float DeltaTime )
{
	super.Tick (DeltaTime);
	
	if (TicksTillMap > 0)
	{
		TicksTillMap --;
		if (TicksTillMap <= 1)
		{
			//`log("--------------------------------------------------------------------------------------");
			// -- Put the test `log functions here,
			// if we ever want to figure out why we need to wait 5 ticks before instantly transitioning to the globe
			//`log("--------------------------------------------------------------------------------------");
		}
		if (TicksTillMap == 0)
		{
			OnRemoteEvent ('FinishedTransitionIntoMap');

			// Display event messages next-tick instead of waiting ~1s
			if(!IsTimerActive(nameof(StrategyMap_TriggerGeoscapeEntryEvent)))
				SetTimer(0.01, false, nameof(StrategyMap_TriggerGeoscapeEntryEvent));
		}
	}
}

function ExitStrategyMap(bool bSmoothTransitionFromSideView = false)
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	if(!settings.SkipHologlobeDissolveAnimation || !bSmoothTransitionFromSideView)
	{
		super.ExitStrategyMap(bSmoothTransitionFromSideView);
		return;
	}

	m_kXComStrategyMap.ExitStrategyMap();

	//Normally we'd call OnRemoteEvent('FinishedTransitionFromMap') here
	//However 'FinishedTransitionFromMap' event is all wonky, hiding the UI and then showing it again on a timer, 
	//causing all sorts of issues.  Avoid that entirely by handling the outcome ourselves
	if (StrategyMap2D != none)
		StrategyMap2D.Hide();
	CAMLookAtNamedLocation("Base", 0.0);
	SetTimer(0.01, false, nameof(StrategyMap_FinishTransitionExit)); //Trick to call private function!  hehehe
}

//----------------------------------------------------
// DOOM EFFECT
//----------------------------------------------------

//---------------------------------------------------------------------------------------
function NonPanClearDoom(bool bPositive)
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';
	StrategyMap2D.SetUIState(eSMS_Flight);

	if(bPositive)
	{
		StrategyMap2D.StrategyMapHUD.StartDoomRemovedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_DecreaseScreenTear_ON");
	}
	else
	{
		StrategyMap2D.StrategyMapHUD.StartDoomAddedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_IncreasedScreenTear_ON");
	}

	SetTimer(3.0f*settings.AvatarPauseMultiplier, false, nameof(NoPanClearDoomPt2));
}

//---------------------------------------------------------------------------------------
function NoPanClearDoomPt2()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
    local IAM_Settings settings;

    settings = new class'IAM_Settings';
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ.ClearPendingDoom();

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(AlienHQ.PendingDoomData.Length > 0)
	{
		SetTimer(4.0f*settings.AvatarPauseMultiplier, false, nameof(NoPanClearDoomPt2));
	}
	else
	{
		SetTimer(4.0f*settings.AvatarPauseMultiplier, false, nameof(UnPanDoomFinished));
	}
}

//---------------------------------------------------------------------------------------
function DoomCameraPan(XComGameState_GeoscapeEntity EntityState, bool bPositive, optional bool bFirstFacility = false)
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';

	CAMSaveCurrentLocation();
	StrategyMap2D.SetUIState(eSMS_Flight);

	// Stop Scanning
	if(`GAME.GetGeoscape().IsScanning())
	{
		StrategyMap2D.ToggleScan();
	}

	if(bPositive)
	{
		StrategyMap2D.StrategyMapHUD.StartDoomRemovedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_DecreaseScreenTear_ON");
	}
	else
	{
		StrategyMap2D.StrategyMapHUD.StartDoomAddedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_IncreasedScreenTear_ON");
	}

	DoomEntityLoc = EntityState.Get2DLocation();

	if(bFirstFacility)
	{
		SetTimer(3.0f*settings.AvatarPauseMultiplier, false, nameof(StartFirstFacilityCameraPan));
	}
	else
	{
		SetTimer(3.0f*settings.AvatarPauseMultiplier, false, nameof(StartDoomCameraPan));
	}
}

//---------------------------------------------------------------------------------------
function StartDoomCameraPan()
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';

	// Pan to the location
	CAMLookAtEarth(DoomEntityLoc, 0.5f, `HQINTERPTIME);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME + 3.0f*settings.AvatarPauseMultiplier), false, nameof(DoomCameraPanComplete));
}

//---------------------------------------------------------------------------------------
function StartFirstFacilityCameraPan()
{
	CAMLookAtEarth(DoomEntityLoc, 0.5f, `HQINTERPTIME);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME), false, nameof(FirstFacilityCameraPanComplete));
}

//---------------------------------------------------------------------------------------
function DoomCameraPanComplete()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
    local IAM_Settings settings;
    settings = new class'IAM_Settings';

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ.ClearPendingDoom();

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(AlienHQ.PendingDoomData.Length > 0)
	{
		SetTimer(4.0f*settings.AvatarPauseMultiplier, false, nameof(DoomCameraPanComplete));
	}
	else
	{
		SetTimer(4.0f*settings.AvatarPauseMultiplier, false, nameof(UnpanDoomCamera));
	}
}

//---------------------------------------------------------------------------------------
function FirstFacilityCameraPanComplete()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState NewGameState;
	local StateObjectReference EmptyRef;
	local XComGameState_MissionSite MissionState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fire First Facility Event");
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	NewGameState.AddStateObject(AlienHQ);

	if(AlienHQ.PendingDoomEvent != '')
	{
		`XEVENTMGR.TriggerEvent(AlienHQ.PendingDoomEvent, , , NewGameState);
	}

	AlienHQ.PendingDoomEvent = '';
	AlienHQ.PendingDoomEntity = EmptyRef;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.GetMissionSource().bAlienNetwork)
		{
			break;
		}
	}

	StrategyMap2D.StrategyMapHUD.StopDoomAddedEffect();
	StrategyMap2D.SetUIState(eSMS_Default);
	OnMissionSelected(MissionState, false);
}

//---------------------------------------------------------------------------------------
function UnpanDoomCamera()
{
    local IAM_Settings settings;
    settings = new class'IAM_Settings';

	CAMRestoreSavedLocation();
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME + 3.0f*settings.AvatarPauseMultiplier), false, nameof(UnPanDoomFinished));
}

//---------------------------------------------------------------------------------------
function UnPanDoomFinished()
{
	StrategyMap2D.StrategyMapHUD.StopDoomRemovedEffect();
	StrategyMap2D.StrategyMapHUD.StopDoomAddedEffect();
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Increase_and_Decrease_Off");
	StrategyMap2D.SetUIState(eSMS_Default);

	if(m_bDelayGeoscapeEntryEvent)
	{
		GeoscapeEntryEvent();
	}
}

DefaultProperties
{
	TicksTillMap=0;
}