class X2DownloadableContentInfo_RulerReactionsRevised extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    OverwriteRulerAbilityTrigger();
}

static function OverwriteRulerAbilityTrigger()
{
    local X2AbilityTemplateManager templateManager;
    local X2AbilityTemplate abilityTemplate;
    local RulerReactionsRevised_X2AbilityTrigger_DLC_Day60OnAbilityActivated trigger;
    local int i;
    
    templateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    abilityTemplate = templateManager.FindAbilityTemplate('AlienRulerActionSystem');

    trigger = new class'RulerReactionsRevised_X2AbilityTrigger_DLC_Day60OnAbilityActivated';
    trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    trigger.ListenerData.EventID = 'AbilityActivated';
    trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.OnAbilityActivated;
    trigger.ListenerData.Filter = eFilter_None;

    for(i = 0; i < abilityTemplate.AbilityTriggers.Length; i++)
    {
        if(abilityTemplate.AbilityTriggers[i].IsA('X2AbilityTrigger_DLC_Day60OnAbilityActivated'))
        {
            abilityTemplate.AbilityTriggers[0] = trigger;
            return;
        }
    }
    abilityTemplate.AbilityTriggers.AddItem(trigger);
}