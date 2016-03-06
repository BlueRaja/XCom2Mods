class MSSU_X2DownloadableContentInfo extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
    ResetSquadSize();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
    ResetSquadSize();
}

private static function ResetSquadSize()
{
    class'X2StrategyGameRulesetDataStructures'.default.m_iMaxSoldiersOnMission = 4;
    class'UISquadSelect'.default.MaxDisplayedSlots = 6;
}