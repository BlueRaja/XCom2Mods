class SWMT_X2Action_EnterCover extends X2Action_EnterCover dependson(XGUnitNativeBase, XComAnimNodeBlendDynamic);

var bool wasInstantEnterCoverChanged;

function Init(const out VisualizationTrack InTrack)
{
    Super.Init(InTrack);

    //During kill shots, setting bInstantEnterCover=true causes the killshot cinematic/voice to not play
    //We prevent this by only removing the delay on non-killshots
    wasInstantEnterCoverChanged = !bInstantEnterCover && !WasKillShot();
    if(wasInstantEnterCoverChanged)
    {
        bInstantEnterCover = true;
    }
}

function bool WasKillShot()
{
    return PrimaryTarget != None && XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(PrimaryTarget.ObjectID)).IsDead();
}

simulated state Executing
{
	function CheckAmmoUnitSpeak()
	{
        //Another hack - if we set bInstantEnterCover=true, then RespondToShotSpeak() is never called.  To hack it in, we call it here.
        //We then need to sleep if the low-ammo speech needs to be played
		local XComGameState_Item WeaponUsed;
        local bool respondedToShotSpeak;
        local name ammoCallout;
        local int waitTime;

        //Code to call RespondToShotSpeak(), adapted from X2Action_EnterCover.Init()
        if(wasInstantEnterCoverChanged)
        {
            respondedToShotSpeak = RespondToShotSpeak();
            if (respondedToShotSpeak)
            {
                `CAMERASTACK.OnCinescriptAnimNotify("EnterCoverCut");
		    }
        }

        //Original code from CheckAmmoUnitSpeak()
		if( AbilityContext.InputContext.AbilityTemplateName == 'StandardShot')
		{
			WeaponUsed = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
			if( WeaponUsed != None )
			{
				if( WeaponUsed.Ammo == 1 )
				{
                    ammoCallout = 'DelayLowAmmo';
				}
				else if ( WeaponUsed.Ammo == 0 )
				{
					ammoCallout = 'DelayNoAmmo';
				}
			}
		}

        //New code:  Original code had random timeout from [0.5, 2.5].  Reduce that to always 0.5, but add the Sleep(1.25) back if we have to wait
        //for 'respond to shot' speech.  Apparently we can't actually Sleep() here, so increase the wait timeout instead.
        if(ammoCallout != '')
        {
            waitTime = 0.5f;

            //Wait extra time if RespondToShotSpeak happened also
            if(respondedToShotSpeak)
            {
                waitTime += 1.25f;
            }

            Unit.SetTimer(waitTime, false, ammoCallout);
        }
	}
}
