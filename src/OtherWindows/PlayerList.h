//
//  PlayerList.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/23/23.
//
class PlayerList {
public:
    static PlayerList& getInstance() {
        static PlayerList instance; // The single instance
        return instance;
    }
    
    void RequestPlayerInfo();
    bool FilterPlayers(FAlivePlayerDataInfo Player);
    void HandleReceivePlayerInfo(UObject* ShooterPlayerState, ClientGetAlivePlayerConnectedData_Params* ReceivingParams);
    
    void DrawMenu();
    void DrawPlayerMenu();
    void DrawTribeMenu();
    void DrawActionsMenu();
    void DrawPlayerEntry(MenuAlivePlayerDataInfo CurrentPlayer);
    void DrawTribeActionsMenu(long TribeID, string TribeName);
    
private:
    bool ShowActions;
    
    long ActionsPlayerID;
    long ActionsTribeID;
    string ActionsPlayerName;
    string ActionsTribeName;
    
    
    vector<MenuAlivePlayerDataInfo> AlivePlayerInfos;
    vector<TribeListEntry> OnlineTribeInfos;
    
    void BanPlayer(long PlayerID);
    void AllyTribe(long TribeID);
    void KickPlayer(long PlayerID);
    void RenamePlayer(string CurrentName);
    void ClearInventory(long PlayerID);
    void Teleport(long PlayerID);
    void RemoveAmber(long PlayerID);
    void GiveEXP(long PlayerID);
    void JoinMyTribe(long PlayerID);
    void KillPlayer(long PlayerID);
    void JoinTribe(string TribeNameToJoin);
    void RenameTribe(string CurrentTribeName);
    void BanTribe(long TribeID);
};
