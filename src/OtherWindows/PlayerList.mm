//
//  PlayerList.mm
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/23/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"



static bool FreezeUpdateMenu = false;

void PlayerList::RequestPlayerInfo(){
    UObject* ShooterPlayerState = gameUtils.GetPlayerState();
    if(utils.isValidAdress(ShooterPlayerState)){
        functions.ProcessEventCall(ShooterPlayerState, (wchar_t*)L"ServerGetAlivePlayerConnectedData", nullptr);
    }
}
bool PlayerList::FilterPlayers(FAlivePlayerDataInfo Player){
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    int MyTeamID = gameUtils.GetMyTeam();
    
    if(!utils.isValidAdress((long)MyTribeData)) return true;
    
    bool isTribe = MyTeamID == (int)Player.TargetingTeamID;
    bool isAlly = gameUtils.IsTribeAlliedWith(MyTribeData, (int)Player.TargetingTeamID);
    bool isEnemy = !isAlly;
    
    if(PlayerListDisplayIndex == 0 && isTribe){
        return false;
    } else if(PlayerListDisplayIndex == 1 && isAlly && !isTribe){
        return false;
    } else if(PlayerListDisplayIndex == 2 && isEnemy){
        return false;
    } else if(PlayerListDisplayIndex == 3){
        return false;
    }
    return true;
}
static ESPTeam GetPlayerTeam(FAlivePlayerDataInfo Player){
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    int MyTeamID = gameUtils.GetMyTeam();
    
    if(!utils.isValidAdress((long)MyTribeData)) return Team_Enemy;
    
    bool isTribe = MyTeamID == (int)Player.TargetingTeamID;
    bool isAlly = gameUtils.IsTribeAlliedWith(MyTribeData, (int)Player.TargetingTeamID);
    
    
    if(isTribe) return Team_Tribe;
    else if(isAlly) return Team_Ally;
    return Team_Enemy;
}
void PlayerList::HandleReceivePlayerInfo(UObject* ShooterPlayerState, ClientGetAlivePlayerConnectedData_Params* ReceivingParams){
    if(FreezeUpdateMenu) return;
    
    AlivePlayerInfos.clear();
    OnlineTribeInfos.clear();
    
    vector<long> OnlineTribeIDs;
    
    
    TArray<FAlivePlayerDataInfo> list = ReceivingParams->list;
    
    if(!list.IsValidArray()) return;
    
    for(int i = 0; i<list.Count; i++)
    {
        FAlivePlayerDataInfo CurrentPlayer = list[i];
        
        if(FilterPlayers(CurrentPlayer)) continue;
        
        long TribeID = CurrentPlayer.TargetingTeamID;
        long PlayerID = CurrentPlayer.PlayerID;
        string PlayerName = gameUtils.FStringToString(CurrentPlayer.PlayerName);
        string TribeName = gameUtils.FStringToString(CurrentPlayer.TribeName);
        
        ESPTeam PlayerTeam = GetPlayerTeam(CurrentPlayer);
        
        MenuAlivePlayerDataInfo newAlivePlayerEntry = {PlayerName, TribeName, PlayerID, TribeID, PlayerTeam};
        AlivePlayerInfos.push_back(newAlivePlayerEntry);
        
        bool UniqueID = true;
        for(int j = 0; j<OnlineTribeIDs.size(); ++j){
            if(OnlineTribeIDs[j] == TribeID && TribeName != "Null") UniqueID = false;
        }
        
        if(UniqueID)
            OnlineTribeIDs.push_back(TribeID);
    }
    
    sort(OnlineTribeIDs.begin(), OnlineTribeIDs.end());
    
    //Make a list of the online tribe IDs / Players
    for(int i = 0; i<OnlineTribeIDs.size(); ++i){
        long CurrentTribeID = OnlineTribeIDs[i];
        
        if(CurrentTribeID == 0) continue;
        
        TribeListEntry newTribeEntry;
        newTribeEntry.TribeID = CurrentTribeID;
        
        for(int j = 0; j<list.Count; ++j){
            FAlivePlayerDataInfo CurrentPlayer = list[j];
            if(FilterPlayers(CurrentPlayer)) continue;
            
            if(CurrentPlayer.TargetingTeamID == CurrentTribeID){
                
                if(CurrentPlayer.TribeName.Count <= 0) continue;
                
                string TribeName = gameUtils.FStringToString(CurrentPlayer.TribeName);
                std::size_t EndingRank = TribeName.find(" - ");
                if (EndingRank!=std::string::npos)
                    TribeName = TribeName.substr(0, EndingRank);
                
                newTribeEntry.TribeName = TribeName;//CurrentPlayer.TribeName.Count > 0 ? CurrentPlayer.TribeName.ToString() : "Null";
                
                
                PlayerTribeEntry newPlayerEntry;
                newPlayerEntry.PlayerID = CurrentPlayer.PlayerID;
                newPlayerEntry.PlayerName = gameUtils.FStringToString(CurrentPlayer.PlayerName);
                
                newTribeEntry.Players.push_back(newPlayerEntry);
            }
        }
        
        if(newTribeEntry.Players.size() > 0){
            OnlineTribeInfos.push_back(newTribeEntry);
        }
    }
    
    
    
    
    return;
}
FLinearColor TeamColors[4] = {Green, Blue, Red, Purple};
void PlayerList::DrawPlayerEntry(MenuAlivePlayerDataInfo CurrentPlayer){
    ImGui::PushStyleColor(ImGuiCol_Text, TeamColors[CurrentPlayer.PlayerTeam].toU32());
    
    ImGui::Text("%s", CurrentPlayer.PlayerName.c_str()); ImGui::NextColumn();
    ImGui::Text("%s", CurrentPlayer.TribeName.c_str()); ImGui::NextColumn();
    
    ImGui::PopStyleColor();
    
    ImGui::PushID((int)CurrentPlayer.PlayerID + 1);
    
    if(ImGui::Button("Actions")){
        ShowActions = true;
        ActionsTribeID = CurrentPlayer.TribeID;
        ActionsPlayerID = CurrentPlayer.PlayerID;
        ActionsPlayerName = CurrentPlayer.PlayerName;
        ActionsTribeName = CurrentPlayer.TribeName;
    } ImGui::NextColumn();
    
    ImGui::PopID();
}
void PlayerList::DrawPlayerMenu(){
    
    ImGui::SameLine();
    
    string PlayersOnlineText = utils.string_format("%d Players Online", AlivePlayerInfos.size());
    ImGui::Text("%s", PlayersOnlineText.c_str());
    
    ImGui::Columns(3, NULL, false);
    
    ImGui::SetColumnWidth(0,150);
    ImGui::SetColumnWidth(1,180);
    ImGui::SetColumnWidth(2,60);
    
    ImGui::Text("Player Name"); ImGui::NextColumn();
    ImGui::Text("Tribe Name"); ImGui::NextColumn();
    ImGui::Text("Actions"); ImGui::NextColumn();
    
    
    
    for(int i = 0; i<AlivePlayerInfos.size(); i++){
        MenuAlivePlayerDataInfo CurrentPlayer = AlivePlayerInfos[i];
        DrawPlayerEntry(CurrentPlayer);
    }
    
    ImGui::Columns();
    
    
}
void PlayerList::DrawTribeMenu(){
    ImGui::SameLine();
    
    string TribesOnlineText = utils.string_format("%d Tribes Online \\ %d Players Online", OnlineTribeInfos.size(), AlivePlayerInfos.size());
    ImGui::Text("%s", TribesOnlineText.c_str());
    
    for(int i = 0; i<OnlineTribeInfos.size(); ++i){
        TribeListEntry CurrentEntry = OnlineTribeInfos[i];
          
        string PlayerStr = CurrentEntry.Players.size() > 1 ? " Players" : " Player";
        string HeaderDisplayText = CurrentEntry.TribeName + "   -    " + to_string(CurrentEntry.Players.size()) + PlayerStr  + " Online";
        
        if(ImGui::CollapsingHeader(HeaderDisplayText.c_str())){
            vector<PlayerTribeEntry> Players = CurrentEntry.Players;
            
            
            
            ImGui::Indent();
            
            ImGui::PushID((int)CurrentEntry.TribeID);
            if(ImGui::Button("Tribe Actions", ImVec2(300,20))){
                ShowActions = true;
                ActionsTribeID = CurrentEntry.TribeID;
                ActionsPlayerID = 0;
                ActionsPlayerName = "NULL";
                ActionsTribeName = CurrentEntry.TribeName;
            }
            ImGui::PopID();
            
            ImGui::Columns(2);
            
            ImGui::Text("Player Name: "); ImGui::NextColumn();
            ImGui::Text("Actions: "); ImGui::NextColumn();
            
            for(int j = 0; j<Players.size(); ++j){
                PlayerTribeEntry CurrentPlayerEntry = Players[j];
                ImGui::Text("%s", CurrentPlayerEntry.PlayerName.c_str()); ImGui::NextColumn();
                ImGui::PushID((int)CurrentPlayerEntry.PlayerID);
                
                if(ImGui::Button("Actions", ImVec2(ImGui::GetColumnWidth() - 20, 20))){
                    ShowActions = true;
                    ActionsTribeID = CurrentEntry.TribeID;
                    ActionsPlayerID = CurrentPlayerEntry.PlayerID;
                    ActionsPlayerName = CurrentPlayerEntry.PlayerName;
                    ActionsTribeName = CurrentEntry.TribeName;
                }ImGui::NextColumn();
                
                
                ImGui::PopID();
            }
            
            ImGui::Columns();
            ImGui::Unindent();
        }
    }
    
}
void PlayerList::DrawActionsMenu(){
    if(ImGui::Button("Back", ImVec2(300, 20))){
        ShowActions = false;
        ActionsTribeID = 0;
        ActionsPlayerID = 0;
        ActionsPlayerName = "NULL";
        ActionsTribeName = "NULL";
    }
    
    string Displaying = "Player Name: " + ActionsPlayerName + "\nTribe Name: " + ActionsTribeName + "\nPlayerID: " + to_string(ActionsPlayerID) + "\nTribeID: " + to_string(ActionsTribeID);
    ImGui::Text("%s", Displaying.c_str());
    
    ImGui::Separator();
    ImGui::Text("Server Admin Actions: ");
    
    ImGui::Columns(3, NULL, false);
    
    ImGui::SetColumnWidth(0, 110);
    ImGui::SetColumnWidth(1, 110);
    ImGui::SetColumnWidth(2, 110);
    
    if(ActionsPlayerID != 0){
        if(ImGui::Button(GetMenuText("Ban Player"), ImVec2(90, 20))){
            BanPlayer(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Kick Player"), ImVec2(90, 20))){
            KickPlayer(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Rename Player"), ImVec2(90, 20))){
            RenamePlayer(ActionsPlayerName);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Clear Inventory"), ImVec2(90, 20))){
            ClearInventory(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Teleport"), ImVec2(90, 20))){
            Teleport(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Remove Amber"), ImVec2(90, 20))){
            RemoveAmber(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Give EXP"), ImVec2(90, 20))){
            GiveEXP(ActionsPlayerID);
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Join My Tribe"), ImVec2(90, 20))){
            JoinMyTribe(ActionsPlayerID);
        } ImGui::NextColumn();
        
        if(ImGui::Button(GetMenuText("Kill Player"), ImVec2(90, 20))){
            KillPlayer(ActionsPlayerID);
        } ImGui::NextColumn();
    }
    if(ActionsTribeID != 0){
        if(ImGui::Button(GetMenuText("Join Tribe"), ImVec2(90, 20))){
            JoinTribe(ActionsTribeName);
        } ImGui::NextColumn();

        if(ImGui::Button(GetMenuText("Rename Tribe"), ImVec2(90, 20))){
            RenameTribe(ActionsTribeName);
        } ImGui::NextColumn();
        
        if(ImGui::Button(GetMenuText("Ban Tribe"), ImVec2(90, 20))){
            BanTribe(ActionsTribeID);
        } ImGui::NextColumn();
    }

    
    ImGui::Columns();
    
}
void PlayerList::DrawMenu(){
    FreezeUpdateMenu = true;
    
    const char* PlayerListFilterEntries[] = {GetMenuText("Show Tribes"), GetMenuText("Show Player")};
    const char* PlayerListDisplayEntries[] = {GetMenuText("Tribemates"), GetMenuText("Allies"), GetMenuText("Enemies"), GetMenuText("Everyone")};
    
    //GetMenuText
    if(!ShowActions){
        ImGui::Combo("Filter By ", &PlayerListFilterIndex, PlayerListFilterEntries, IM_ARRAYSIZE(PlayerListFilterEntries));
        ImGui::Combo("Display", &PlayerListDisplayIndex, PlayerListDisplayEntries, IM_ARRAYSIZE(PlayerListDisplayEntries));
        ImGui::Checkbox("Fetch Player Info", &FetchPlayerInfo);
    }
    
    if(FetchPlayerInfo){
        if(ShowActions){
            DrawActionsMenu();
        } else {
            if(PlayerListFilterIndex == 0){
                DrawTribeMenu();
            } else {
                DrawPlayerMenu();
            }
        }
    }
    
    FreezeUpdateMenu = false;
}


void PlayerList::BanPlayer(long PlayerID){
    string PlayerBanString = "BanPlayer " + to_string(PlayerID) + " 9999 \"Banned\"";
    functions.ExecuteConsoleCommand(PlayerBanString);
}
void PlayerList::AllyTribe(long TribeID){
    functions.TribeRequestNewAlliance((int)TribeID);
}
void PlayerList::KickPlayer(long PlayerID){
    string ConsoleCommand = "KickPlayer " + to_string(PlayerID);
    functions.ExecuteConsoleCommand(ConsoleCommand);
}
void PlayerList::RenamePlayer(string CurrentName){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename Player"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"New Player Name";}];
    
    UIAlertAction* Send = AlertAction(@"Rename"){
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        string MessageText = [enteredText UTF8String];
        
        string RealPlayerName = CurrentName;
        std::size_t EndingRank = RealPlayerName.find(" - ");
        if (EndingRank!=std::string::npos)
            RealPlayerName = RealPlayerName.substr(0, EndingRank);
        
        string RenameString = "RenamePlayer \"" + RealPlayerName + "\" \"" + MessageText + "\"";
        functions.ExecuteConsoleCommand(RenameString);
        
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
    
}
void PlayerList::ClearInventory(long PlayerID){
    string ConsoleCommand = "ClearPlayerInventory " + to_string(PlayerID) + " 1 1 1";
    functions.ExecuteConsoleCommand(ConsoleCommand);
}
void PlayerList::Teleport(long PlayerID){
    functions.TeleportToPlayerLocation(PlayerID);
}
void PlayerList::RemoveAmber(long PlayerID){
    string ConsoleCommand = "RemoveAllAmber " + to_string(PlayerID) + " 0";
    functions.ExecuteConsoleCommand(ConsoleCommand);
}
void PlayerList::GiveEXP(long PlayerID){
    string ConsoleCommand = "GiveExpToPlayer " + to_string(PlayerID) + " 999999999999999 0 1";
    functions.ExecuteConsoleCommand(ConsoleCommand);
}
void PlayerList::JoinMyTribe(long PlayerID){
    UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        FString FTribeName = *(FString*)(ShooterCharacter + 0xad0);
        string MyTribeName = gameUtils.FStringToString(FTribeName);
        
        string RealTribeName = MyTribeName;
        std::size_t EndingRank = RealTribeName.find(" - ");
        if (EndingRank!=std::string::npos)
            RealTribeName = RealTribeName.substr(0, EndingRank);
        
        string CommandString = "ForcePlayerToJoinTribe " + to_string(PlayerID) + " \"" + RealTribeName + "\"";
        
        functions.ExecuteConsoleCommand(CommandString);
    }
}
void PlayerList::KillPlayer(long PlayerID){
    string CommandString = "KillPlayer " + to_string(PlayerID);
    functions.ExecuteConsoleCommand(CommandString);
}
void PlayerList::JoinTribe(string TribeNameToJoin){
    UObject* PlayerState = gameUtils.GetPlayerState();
    if(utils.isValidAdress(PlayerState)){
        int PlayerID = utils.Read<int>(PlayerState + 0x690);
        
        string RealTribeName = TribeNameToJoin;
        std::size_t EndingRank = RealTribeName.find(" - ");
        if (EndingRank!=std::string::npos)
            RealTribeName = RealTribeName.substr(0, EndingRank);
        
        
        string CommandString = "ForcePlayerToJoinTribe " + to_string(PlayerID) + " \"" + RealTribeName + "\"";
        functions.ExecuteConsoleCommand(CommandString);
    }
}
void PlayerList::RenameTribe(string CurrentTribeName){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rename Tribe"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"New Tribe Name";}];
    
    UIAlertAction* Send = AlertAction(@"Rename"){
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        string MessageText = [enteredText UTF8String];
        
        
        string RealTribeName = CurrentTribeName;
        std::size_t EndingRank = RealTribeName.find(" - ");
        if (EndingRank!=std::string::npos)
            RealTribeName = RealTribeName.substr(0, EndingRank);
        
        string RenameString = "RenameTribe \"" + RealTribeName + "\" \"" + MessageText + "\"";
        functions.ExecuteConsoleCommand(RenameString);
        
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}
void PlayerList::BanTribe(long TribeID){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ban Tribe"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* BanPlayers = AlertAction(@"Just Ban"){functions.BanTribe(TribeID, NO, NO);}];
    UIAlertAction* DestroyDinos = AlertAction(@"Destroy Dinos"){functions.BanTribe(TribeID, NO, YES);}];
    UIAlertAction* DestroyStructures = AlertAction(@"Destroy Struc"){functions.BanTribe(TribeID, YES, NO);}];
    UIAlertAction* DestroyDinosAndStructures = AlertAction(@"Destroy Dino and Struc"){functions.BanTribe(TribeID, YES, YES);}];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    [alertController addAction:BanPlayers];
    [alertController addAction:DestroyDinos];
    [alertController addAction:DestroyStructures];
    [alertController addAction:DestroyDinosAndStructures];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}
