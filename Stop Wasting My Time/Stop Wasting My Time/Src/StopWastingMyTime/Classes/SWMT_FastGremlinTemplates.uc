class SWMT_FastGremlinTemplates extends X2Character;

//---------------------------------------------------------------------------------------
//  We speed up the gremlins by modifying their move speed modifiers when templates are
//    initiated when the game is started.
//  As a result, this method of speeding up the gremlins doesn't interfere with any other mods.
//  Though, there might be some conflict with other mods that modify gremlin attributes. Particularly
//    if they don't modify the tmeplates like we do here, and instead replace them.
//---------------------------------------------------------------------------------------

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
    
    local X2CharacterTemplateManager CharTemplateMgr;
    
    CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
    
    // At 1000, Gremlins will move very quickly towards their targets, usually "teleporting" to the end somewhere along the path
    
    // IphStich: "I think that at 1000 they move down each path segment very quickly, this can make the movement a little choppy, but
    //            very fast. Also, as a result, the gremlin will appear to "teleport" down any straight line it sees, in particular
    //            the straight line towards the target at the end of the path. But all of this saves time, and there doesn't
    //            appear to be any other of speeding up the animation. Not without serious complicated class overwritting,
    //            which has the potential of mod conflict."
    
    CharTemplateMgr.FindCharacterTemplate('GremlinMk1').SoloMoveSpeedModifier = 1000;
    CharTemplateMgr.FindCharacterTemplate('GremlinMk2').SoloMoveSpeedModifier = 1000;
    CharTemplateMgr.FindCharacterTemplate('GremlinMk3').SoloMoveSpeedModifier = 1000;
    
    return Templates;
}