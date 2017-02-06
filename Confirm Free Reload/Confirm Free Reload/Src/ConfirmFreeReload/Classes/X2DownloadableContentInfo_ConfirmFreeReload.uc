class X2DownloadableContentInfo_ConfirmFreeReload extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager abilityManager;
    local X2AbilityTemplate reloadTemplate;
    
    abilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    reloadTemplate = abilityManager.FindAbilityTemplate('Reload');
    reloadTemplate.TargetingMethod = class'X2TargetingMethod_ConfirmFreeReload';
}