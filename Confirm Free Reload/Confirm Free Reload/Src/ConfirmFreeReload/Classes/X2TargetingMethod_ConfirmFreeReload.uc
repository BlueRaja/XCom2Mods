class X2TargetingMethod_ConfirmFreeReload extends X2TargetingMethod;

var localized string PopupTitle;
var localized string PopupBody;
var localized string AcceptMessage;
var localized string CancelMessage;

var bool IsConfirmed;
var XComGameState_Ability AbilityState;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    super.Init(InAction, NewTargetIndex);
    IsConfirmed = false;
    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(InAction.AbilityObjectRef.ObjectID));
}

function bool VerifyTargetableFromIndividualMethod(delegate<ConfirmAbilityCallback> callback)
{
    if (!IsConfirmed && HasAmmo() && IsLimitedFreeReload())
    {
        ShowFreeReloadPopup(callback);
        return false;
    }

    return true;
}

private function ShowFreeReloadPopup(delegate<ConfirmAbilityCallback> callback)
{
    local TDialogueBoxData dialog;
    local XComPresentationLayerBase presentationLayer;

    m_fnConfirmAbilityCallback = callback;
    presentationLayer = XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres;

    dialog.eType = eDialog_Warning;
    dialog.strTitle = PopupTitle;
    dialog.strText = PopupBody;
    dialog.strAccept = AcceptMessage;
    dialog.strCancel = CancelMessage;
    dialog.fnCallback = DialogCallback;

    presentationLayer.UIRaiseDialog(dialog);
}

simulated private function DialogCallback(Name eAction)
{
    if (eAction == 'eUIAction_Accept')
    {
        IsConfirmed = true;
        m_fnConfirmAbilityCallback();
    }
}

private function bool IsLimitedFreeReload()
{
    local XComGameState_Item weaponState;
    local array<X2WeaponUpgradeTemplate> weaponUpgrades;
    local UnitValue numFreeReloadsUsed;
    local int numFreeReloadsRemaining, i;

    weaponState = AbilityState.GetSourceWeapon();
    weaponUpgrades = weaponState.GetMyWeaponUpgradeTemplates();
    UnitState.GetUnitValue('FreeReload', numFreeReloadsUsed);

    for (i = 0; i < weaponUpgrades.Length; i++)
    {
        if(weaponUpgrades[i].NumFreeReloads > 0)
        {
            numFreeReloadsRemaining = int(weaponUpgrades[i].NumFreeReloads - numFreeReloadsUsed.fValue);
            if(numFreeReloadsRemaining > 0 && numFreeReloadsRemaining < 10) //Check it's a small number to support mods that have "infinite" free reloads
            {
                return true;
            }
        }
    }
    return false;
}

private function bool HasAmmo()
{
    return AbilityState.GetSourceWeapon().Ammo > 0;
}

// Necessary to prevent red-screens, for some reason
function int GetTargetIndex()
{
    return 0;
}