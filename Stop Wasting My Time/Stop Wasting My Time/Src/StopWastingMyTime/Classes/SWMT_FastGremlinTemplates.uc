class SWMT_FastGremlinTemplates extends X2Character;

//---------------------------------------------------------------------------------------
//  We speed up the gremlins by modifying their move speed modifiers when templates are
//    initiated when the game is started. This value is then applied properly in
//    SWMT_X2Action_MoveDirect, which I consider a fix to the game-code as SoloMoveSpeedModifier
//    is ignored in odd circumstances.
//  As a result, this method of speeding up the gremlins doesn't interfere with any other mods.
//  Though, there might be some conflict with other mods that modify gremlin attributes. Particularly
//    if they don't modify the templates like we do here, and instead replace them.
//---------------------------------------------------------------------------------------

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
    
    local X2CharacterTemplateManager CharTemplateMgr;
    
    CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
    
    CharTemplateMgr.FindCharacterTemplate('GremlinMk1').SoloMoveSpeedModifier = 4;
    CharTemplateMgr.FindCharacterTemplate('GremlinMk2').SoloMoveSpeedModifier = 4;
    CharTemplateMgr.FindCharacterTemplate('GremlinMk3').SoloMoveSpeedModifier = 4;
    
    return Templates;
}