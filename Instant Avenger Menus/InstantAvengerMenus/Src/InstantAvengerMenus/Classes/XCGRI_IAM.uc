class XCGRI_IAM extends XComGameReplicationInfo;

simulated function DoRemoteEvent(name evt, optional bool bRunOnClient)
{
    local IAM_Settings settings;
	if (evt == 'PreM_GoToSoldier')
    {
        settings = new class'IAM_Settings';
        if(settings.InstantRoomTransitions)
        {
		    return;
        }
    }

	super.DoRemoteEvent (evt, bRunOnClient);
}