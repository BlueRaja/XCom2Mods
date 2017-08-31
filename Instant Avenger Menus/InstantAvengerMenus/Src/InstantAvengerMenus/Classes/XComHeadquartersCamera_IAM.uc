class XComHeadquartersCamera_IAM extends XComHeadquartersCamera;

function XComCameraState SetCameraState( class<XComCameraState> NewStateClass, float InInterpTime )
{
    local IAM_Settings settings;
    if(NewStateClass == class'XComCamState_HQ_FreeMovement')
    {
        settings = new class'IAM_Settings';
        if(settings.InstantRoomTransitions)
        {
            InInterpTime *= 0.001f;
        }
    }
    return super.SetCameraState(NewStateClass, InInterpTime);
}