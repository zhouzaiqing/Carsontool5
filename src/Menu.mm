//
//  Menu.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"


static string GetTimeString(std::time_t Time){
    string ok = std::asctime(std::localtime(&Time));
    int fpos = ok.find(":");
    string nstr = ok.substr(fpos-2, 8);
    return nstr;
}
struct ConsoleEntry{
    std::time_t Time;
    string Sender;
    string Entry;
    FLinearColor Color;
};
struct MultiConsoleEntry{
    std::time_t Time;
    string Entry;
    FLinearColor Color;
};
struct SenderList{
    string Sender;
    int Num;
};
vector<ConsoleEntry> ConsoleEntries;
vector<MultiConsoleEntry> MultiEntries;
vector<SenderList> Senders;
static bool FreezeConsole = false;
void Menu::ConsoleClear(){ 
    ConsoleEntries.clear();
}
void Menu::ConsoleLog(string Sender, string Entry, FLinearColor Color = Red){
    if(FreezeConsole) return;
    ConsoleEntry newEntry = {std::time(nullptr), Sender, Entry, Color};
    ConsoleEntries.push_back(newEntry);
}
static void MakeSenderList(){
    Senders.clear();
    std::map<string, int> entryCounts;
    vector<string> LoggedSenders;
    for (const auto& CurrentEntry : ConsoleEntries) {
        if(entryCounts.find(CurrentEntry.Sender) == entryCounts.end()){
            LoggedSenders.push_back(CurrentEntry.Sender);
            entryCounts[CurrentEntry.Sender] = 1;
        }
        else {
            entryCounts[CurrentEntry.Sender] = entryCounts[CurrentEntry.Sender] + 1;
        }
    }
    
    for (const auto& CurrentSenderName : LoggedSenders) {
        SenderList newSender;
        newSender.Sender = CurrentSenderName;
        newSender.Num = entryCounts[CurrentSenderName];
        Senders.push_back(newSender);
    }
    
    std::reverse(Senders.begin(),Senders.end());
    return;
}
static void CreateMultiEntries(string Sender){
    MultiEntries.clear();
    for (const auto& CurrentEntry : ConsoleEntries) {
        if(CurrentEntry.Sender == Sender)
            MultiEntries.push_back({CurrentEntry.Time, CurrentEntry.Entry, CurrentEntry.Color});
    }
    std::reverse(MultiEntries.begin(),MultiEntries.end());
    
}
static void DrawConsole(){
    
    if(ImGui::BeginTabBar("ConsoleTabBar")){
        if(ImGui::BeginTabItem("Display All")){
            
            if(ImGui::Button("NewEntry")){
                ConsoleEntry newEntry = {std::time(nullptr), "TestSender", "TestMessage", Red};
                ConsoleEntries.push_back(newEntry);
                ConsoleEntry nEntry = {std::time(nullptr), "Testender", "TestMessage", Red};
                ConsoleEntries.push_back(nEntry);
            }
            ImGui::SameLine();
            if(ImGui::Button("Clear")){
                ConsoleEntries.clear();
            } ImGui::SameLine();
            ImGui::Checkbox("Freeze Console", &FreezeConsole);
            
            
            for(int i = ConsoleEntries.size()-1; i>=0; i--){
                ConsoleEntry currentEntry = ConsoleEntries[i];
                string currentTime = GetTimeString(currentEntry.Time);
                
                ImGui::TextColored(ImVec4(0,1,0,1), "%s", currentTime.c_str()); ImGui::SameLine();
                ImGui::TextColored(ImVec4(currentEntry.Color.r, currentEntry.Color.g, currentEntry.Color.b, 1),"%s", currentEntry.Sender.c_str());
                ImGui::Indent(); ImGui::Text("%s", currentEntry.Entry.c_str()); ImGui::Unindent();
            }
            ImGui::EndTabItem();
        }
        if(ImGui::BeginTabItem("Filter Display")){
            
            if(ImGui::Button("NewEntry")){
                ConsoleEntry newEntry = {std::time(nullptr), "TestSender", "TestMessage", Red};
                ConsoleEntries.push_back(newEntry);
                ConsoleEntry nEntry = {std::time(nullptr), "Testender", "TestMessage", Red};
                ConsoleEntries.push_back(nEntry);
            }
            ImGui::SameLine();
            if(ImGui::Button("Clear")){
                ConsoleEntries.clear();
            } ImGui::SameLine();
            ImGui::Checkbox("Freeze Console", &FreezeConsole);
            
            
            static bool ShowSenders = true;
            static string SenderFilter = "";
            if(ShowSenders){
                MakeSenderList();
                for (const auto& CurrentSender : Senders) {
                    ImGui::TextColored(ImVec4(0,1,1,1), "%s", CurrentSender.Sender.c_str());
                    ImGui::SameLine();
                    string ID = CurrentSender.Sender + to_string(CurrentSender.Num);
                    ImGui::PushID(ID.c_str());
                    if(ImGui::Button(to_string(CurrentSender.Num).c_str(), ImVec2(ImGui::GetContentRegionAvailWidth() - 40,20))){
                        ShowSenders = false;
                        SenderFilter = CurrentSender.Sender;
                    }
                    ImGui::PopID();
                    //ImGui::TextColored(ImVec4(1,0,0,1), "%s", to_string(CurrentSender.Num).c_str());
                    //ImGui::Unindent();
                }
            }
            else {
                if(ImGui::Button("Back")){
                    ShowSenders = true;
                    SenderFilter = "";
                }
                ImGui::Text(SenderFilter.c_str());
                CreateMultiEntries(SenderFilter);
                for (const auto& CurrentSender : MultiEntries) {
                    string currentTime = GetTimeString(CurrentSender.Time);
                    ImGui::TextColored(ImVec4(0,1,0,1), "%s", currentTime.c_str()); ImGui::SameLine();
                    ImGui::TextColored(ImVec4(CurrentSender.Color.r, CurrentSender.Color.g, CurrentSender.Color.b, 1),"%s", CurrentSender.Entry.c_str());
                }
                
                
            }
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }
    
    //ImGui::End();
}






static bool Sliders, PVP, Buttons, ESP, Other;
static void MenuToggle(int Page){
    Sliders = false;
    PVP = false;
    Buttons = false;
    ESP = false;
    Other = false;
    
    ImGui::GetStateStorage()->SetInt(ImGui::GetID("PVP"), 0);
    ImGui::GetStateStorage()->SetInt(ImGui::GetID("Buttons"), 0);
    ImGui::GetStateStorage()->SetInt(ImGui::GetID("ESP"), 0);
    ImGui::GetStateStorage()->SetInt(ImGui::GetID("Other"), 0);
    ImGui::GetStateStorage()->SetInt(ImGui::GetID("Sliders"), 0);
    
    switch(Page){
        case 0:{
            Sliders = true;
            ImGui::GetStateStorage()->SetInt(ImGui::GetID("Sliders"), 1);
            break;
        }
        case 1:{
            PVP = true;
            ImGui::GetStateStorage()->SetInt(ImGui::GetID("PVP"), 1);
            break;
        }
        case 2:{
            Buttons = true;
            ImGui::GetStateStorage()->SetInt(ImGui::GetID("Buttons"), 1);
            break;
        }
        case 3:{
            ESP = true;
            ImGui::GetStateStorage()->SetInt(ImGui::GetID("ESP"), 1);
            break;
        }
        case 4:{
            Other = true;
            ImGui::GetStateStorage()->SetInt(ImGui::GetID("Other"), 1);
            break;
        }
    }
}

static void QueueStructurePlacement(int Index){
    functions.ForcePlaceStructure(Index);
    return;
}



static void DrawColorsList(){
    ImGuiColorEditFlags flags = ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoLabel;
    
    ImGui::Columns(5, NULL, false);
    
    ImGui::Text("%s", GetMenuText("Category")); ImGui::NextColumn();
    ImGui::Text("%s", GetMenuText("Tribe")); ImGui::NextColumn();
    ImGui::Text("%s", GetMenuText("Ally")); ImGui::NextColumn();
    ImGui::Text("%s", GetMenuText("Enemy")); ImGui::NextColumn();
    ImGui::Text("%s", GetMenuText("Wild")); ImGui::NextColumn();
    
    ImGui::Separator();
    
    ImGui::Text("%s", GetMenuText("Dinos")); ImGui::NextColumn();
    ImGui::ColorEdit3("DinoTribe", Dinos.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("DinoAlly", Dinos.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("DinoEnemy", Dinos.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("DinoWild", Dinos.Wild, flags); ImGui::NextColumn();
    
    ImGui::Text("%s", GetMenuText("Players")); ImGui::NextColumn();
    ImGui::ColorEdit3("PlayersTribe", Players.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("PlayersAlly", Players.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("PlayersEnemy", Players.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("PlayersWild", Players.Wild, flags); ImGui::NextColumn();
    
    ImGui::Text("%s", GetMenuText("Structures")); ImGui::NextColumn();
    ImGui::ColorEdit3("StructuresTribe", Structures.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("StructuresAlly", Structures.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("StructuresEnemy", Structures.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("StructuresWild", Structures.Wild, flags); ImGui::NextColumn();
    
    ImGui::Text("%s", GetMenuText("Containers")); ImGui::NextColumn();
    ImGui::ColorEdit3("ContainersTribe", Containers.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("ContainersAlly", Containers.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("ContainersEnemy", Containers.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("ContainersWild", Containers.Wild, flags); ImGui::NextColumn();
    
    ImGui::Text("%s", GetMenuText("Beds")); ImGui::NextColumn();
    ImGui::ColorEdit3("BedsTribe", Beds.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("BedsAlly", Beds.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("BedsEnemy", Beds.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("BedsWild", Beds.Wild, flags); ImGui::NextColumn();
    
    ImGui::Text("%s", GetMenuText("Turrets")); ImGui::NextColumn();
    ImGui::ColorEdit3("TurretsTribe", Turrets.Tribe, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("TurretsAlly", Turrets.Ally, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("TurretsEnemy", Turrets.Enemy, flags); ImGui::NextColumn();
    ImGui::ColorEdit3("TurretsWild", Turrets.Wild, flags); ImGui::NextColumn();
    
    ImGui::Columns(1);
}

static void DrawSlidersMenu(){
    ImGui::SliderFloat(GetMenuText("Speed"), &Speed, 1, 50);
    ImGui::SliderFloat(GetMenuText("LocalSpeed"), &LocalSpeed, 1, 50);
    ImGui::SliderFloat(GetMenuText("TimeOfDay"), &TimeOfDay, 0, 10);
    ImGui::SliderFloat(GetMenuText("FOV"), &FOV, 0.75, 1.75);
    ImGui::SliderFloat(GetMenuText("FarView"), &FarView, 300, 12000);
    ImGui::SliderFloat(GetMenuText("ESP Size"), &ESPSize, 5, 40);
    ImGui::SliderFloat(GetMenuText("ESP Distance"), &ESPDistance, 100, 10000);
    ImGui::SliderInt(GetMenuText("MenuFPS"), &MenuFPS, 10, 120);
    ImGui::SliderFloat(GetMenuText("GameFPS"), &GameFPS, 10, 120, "%.0f");
}



static void DrawPVPMenu(){
    
    //const char* AimbotTargets[]{
    //    "Weakest", "Head", "Chest", "Leggings", "Gauntlet", "Boots", "All"
    //};
    const char* AimbotTargets[]{
        GetMenuText("Weakest"), GetMenuText("Head"), GetMenuText("Chest"), GetMenuText("Leggings"), GetMenuText("Gauntlets"), GetMenuText("Boots"), GetMenuText("All")
    };
    ImGui::Combo("Aimbot Target", &TargettingIndex, AimbotTargets, IM_ARRAYSIZE(AimbotTargets));
    ImGui::Columns(3, NULL, false);

    ImGui::Checkbox(GetMenuText("Magic Bullet"), &PVPMagicBullet); ImGui::NextColumn();

    ImGui::Checkbox(GetMenuText("Tame Shooting"), &PVPTameShooting); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Infinite Pistol"), &PVPInfinitePistol); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Projectile Spam"), &PVPProjectileSpam); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Armor"), &PVPAutoArmor); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Med"), &PVPAutoMed); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Stam"), &PVPAutoStam); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("UW Shoot"), &PVPUWShoot); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Drop"), &PVPAutoDrop); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Rocket Spam"), &PVPRocketSpam); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Rocket Spread"), &PVPRocketSpread); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Ghost"), &PVPGhost); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Chat Spam"), &PVPChatSpam); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Speed Zero"), &PVPSpeedZero); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Launcher"), &PVPAutoLauncher); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("BoomBoom"), &PVPBoomBoom); ImGui::NextColumn();

    if(userCode.isProCode())
    {
        ImGui::Checkbox(GetMenuText("Dino Spin"), &PVPDinoSpin); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Instant Turn"), &PVPInstantTurn); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Strafing"), &PVPStrafing); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Hide Login"), &PVPHideLogin); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Auto Fire"), &PVPAutoFire); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Steal All"), &PVPStealAll); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Infinite C4"), &PVPInfiniteC4); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Auto Eat"), &PVPAutoEat); ImGui::NextColumn();
    }
    if(userCode.isMaxCode())
    {
        ImGui::Checkbox(GetMenuText("Explosions"), &PVPExplosions); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Cache Steal"), &ItemCacheSteal); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Auto Steal"), &PVPAutoSteal); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Force Feed"), &PVPForceFeed); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Request Dino"), &PVPRequestDino); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Request Imp"), &PVPRequestImplant); ImGui::NextColumn();
    }
    
    
    ImGui::Columns();
    
}
static void DrawButtonsMenu(){
    ImGui::Columns(4, NULL, false);
    if(ImGui::Button(GetMenuText("ChangeIcon"), ImVec2(75,20))){
        IconSwitcher::getInstance().ShowIconSwitcher();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Relog"), ImVec2(75,20))){
        functions.Relog();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Teleport"), ImVec2(75,20))){
        functions.BedTeleport(0);
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Raptor Skin"), ImVec2(75,20))){
        functions.GiveRaptorSkin();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Unlock Notes"), ImVec2(75,20))){
        functions.UnlockAllNotes();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Dungeon Menu"), ImVec2(75,20))){
        functions.ShowDungeonMenu();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Set Lighting"), ImVec2(75,20))){
        functions.ShowLightingMenu();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("One Click PVE"), ImVec2(75,20))){
        functions.OneClickPVE();
    } ImGui::NextColumn();

    if(ImGui::Button(GetMenuText("Announcement"), ImVec2(75,20))){
        functions.ShowAnnouncementMenu();
    } ImGui::NextColumn();

    if(ImGui::Button(GetMenuText("Whistle Aggro"), ImVec2(75,20))){
        functions.WhistleAggressive();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Fake Admin"), ImVec2(75,20))){
        functions.ActivateFakeAdmin();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Suicide"), ImVec2(75,20))){
        functions.Suicide();
    } ImGui::NextColumn();

    if(userCode.isProCode())
    {
        if(ImGui::Button(GetMenuText("Crash"), ImVec2(75,20))){
            functions.CrashTheServer();
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Bed ID TP"), ImVec2(75,20))){
            functions.BedIDTP();
        } ImGui::NextColumn();
    }

    if(userCode.isMaxCode())
    {
        if(ImGui::Button(GetMenuText("Crash Bot"), ImVec2(75,20))){
            crashBot.CrashBotButtonPushed();
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Revive"), ImVec2(75,20))){
            functions.ReviveDinosaur();
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("WhitePlatform"), ImVec2(75,20))){
            functions.GoToWhitePlatform();
        } ImGui::NextColumn();
        if(ImGui::Button(GetMenuText("Unclaim Tapejaras"), ImVec2(75,20))){
            functions.UnclaimEnemyMultiseatDinos();
        } ImGui::NextColumn();
    }
    
    //TestFireC4
    //if(ImGui::Button("TEST", ImVec2(75,20))){
    //    tests.TestFireC4();
    //} ImGui::NextColumn();
    
    ImGui::Columns(1);
}


static void DrawESPMenu(){
    ImGui::Columns(3, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Enable ESP"), &EnableESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Dino ESP"), &DinoESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Player ESP"), &PlayerESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Structure ESP"), &StructureESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Container ESP"), &ContainerESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Bed ESP"), &BedESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Turret ESP"), &TurretESP); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Show Enemy"), &ESPShowEnemy); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Show Wild"), &ESPShowWild); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Containers"), &ESPFriendlyContainers); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Turrets"), &ESPFriendlyTurrets); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Players"), &ESPFriendlyPlayers); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Structures"), &ESPFriendlyStructures); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Dinos"), &ESPFriendlyDinos); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Friendly Beds"), &ESPFriendlyBeds); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Turret Bullets"), &ESPTurretBullets); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Player Number"), &ESPPlayerNumber); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Player Name"), &ESPPlayerName); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Tribe Name"), &ESPTribeName); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Health Bar"), &ESPHealthBar); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Player Line"), &ESPTopLine); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Sleeping Players"), &ESPSleepingPlayers); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("GPS"), &ESPGPS); ImGui::NextColumn();

    if(userCode.isProCode())
    {
        ImGui::Checkbox(GetMenuText("Show Bed IDs"), &ESPBedIDs); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Container Steal"), &ESPContainerSteal); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Armor Icon"), &ESPArmorIcons); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Icon Dura"), &ESPArmorIconDura); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Weapon Icon"), &ESPWeaponIcon); ImGui::NextColumn();
    }
    if(userCode.isMaxCode())
    {
        ImGui::Checkbox(GetMenuText("Bed Teleport"), &ESPBedTeleport); ImGui::NextColumn();
    }
    
    ImGui::Columns(1);
}



#define PLACE(index) QueueStructurePlacement(index);
#define PLACEBUTTON(name, index) if(ImGui::Button(GetMenuText(name), ImVec2(85,15))){ PLACE(index) }
#define COLUMN_PLACE_BUTTON(name, index)  PLACEBUTTON(name, index) ImGui::NextColumn();
static void DrawOtherMenu(){
    
    const char* PlaceOptions[]{GetMenuText("Auto Turret"), GetMenuText("Eerie Turret"), GetMenuText("Plant X")};
    const char* TurretRange[]{GetMenuText("Low"), GetMenuText("Medium"), GetMenuText("High")};
    const char* TurretSettings[]{GetMenuText("All Targets"), GetMenuText("Player / Tamed"), GetMenuText("Players Only"), GetMenuText("Only Wild")};
    
    
    static int SettingsPage = 0;
    ImGui::BeginChild("OtherStuff", ImVec2(90, 190), false, ImGuiWindowFlags_None);
    
    if(ImGui::Button("Rotation", ImVec2(85,20))){ // Pitch/Yaw/Roll
        SettingsPage = 1;
    }
    if(userCode.isMaxCode())
    {
        if(ImGui::Button("Auto Place", ImVec2(85,20))){ // Auto Place on hatchframes
            SettingsPage = 2;
        }
    }
    if(userCode.isProCode())
    {
        if(ImGui::Button("Auto Turret Fill", ImVec2(85,20))){ // Turret Fill and settings
            SettingsPage = 3;
        }
    }
    
    if(ImGui::Button("Dupe", ImVec2(85,20))){//Floaters,
        SettingsPage = 4;
    }
    if(ImGui::Button("Other Stuff", ImVec2(85,20))){ //Hide Login, Chat Spam
        SettingsPage = 5;
    }
    ImGui::EndChild();
    
    
    ImGui::SameLine();
    
    ImGui::BeginChild("Settings", ImVec2(280, 190), false, ImGuiWindowFlags_None);
    
    switch(SettingsPage){
        case 1:{
            ImGui::SliderFloat(GetMenuText("Pitch"), &StructurePitch, -180, 180);
            ImGui::SliderFloat(GetMenuText("Yaw"), &StructureYaw, -180, 180);
            ImGui::SliderFloat(GetMenuText("Roll"), &StructureRoll, -180, 180);
            
            
            ImGui::Checkbox(GetMenuText("Enable Pitch"), &EnablePitch);
            ImGui::Checkbox(GetMenuText("Enable Yaw"), &EnableYaw);
            ImGui::Checkbox(GetMenuText("Enable Roll"), &EnableRoll);
            
            break;
        }
        case 2:{
            ImGui::Text("%s", GetMenuText("Hatchframe Turret Place")); ImGui::SameLine();
            if(ImGui::Button("Turret Demonstation")){
                NSURL *url = [NSURL URLWithString:@"https://youtube.com/watch?v=d-fQJSZIsEs&feature=sharec"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
            ImGui::SliderFloat(GetMenuText("Place Distance"), &PlacementRange, 1, 20);
            ImGui::Combo(GetMenuText("Place Options"), &PlaceOptionsInt, PlaceOptions, IM_ARRAYSIZE(PlaceOptions));
            ImGui::Checkbox(GetMenuText("Enable Place"), &EnablePlacement);
            const char* BearTrapTypes[] = {GetMenuText("Small Trap"), GetMenuText("Large Trap"), GetMenuText("Plant X")};
            ImGui::Separator();
            
            ImGui::Text("%s", GetMenuText("Beartrap Place"));
            
            ImGui::Combo(GetMenuText("Bear Trap Type"), &AutoPlaceBearTrapInt, BearTrapTypes, IM_ARRAYSIZE(BearTrapTypes));
            ImGui::Checkbox(GetMenuText("Auto Bear Trap Place"), &AutoPlaceBearTraps);
            
            ImGui::Separator();
            
            ImGui::Text("%s", GetMenuText("Underground Ballista Place")); ImGui::SameLine();
            if(ImGui::Button("Ballista Demonstation")){
                NSURL *url = [NSURL URLWithString:@"https://youtube.com/watch?v=x7e2M2IiGA0&feature=sharec"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
            
            ImGui::Checkbox(GetMenuText("Ballista Place"), &EnableBallistaPlace);\
            
            
            
            break;
        }
        case 3:{
            ImGui::Combo(GetMenuText("Turret Range"), &TurretRangeInt, TurretRange, IM_ARRAYSIZE(TurretRange));
            ImGui::Combo(GetMenuText("Turret Settings"), &TurretSettingsInt, TurretSettings, IM_ARRAYSIZE(TurretSettings));
            
            ImGui::Columns(3, NULL, false);
            ImGui::Checkbox(GetMenuText("Range"), &ChangeRange); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Settings"), &ChangeSettings); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Name"), &ChangeName); ImGui::NextColumn();
            ImGui::Columns(1, NULL, false);
            
            ImGui::Separator();
            
            ImGui::SliderInt(GetMenuText("Auto Ammo Ammount"), &AutoAmmoFillAmmount, 1, 1200);
            ImGui::Columns(2, NULL, false);
            ImGui::Checkbox(GetMenuText("Eerie Fill"), &EerieFill); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Auto Fill"), &AutoFill); ImGui::NextColumn();
            ImGui::Columns(1, NULL, false);
            
            ImGui::Separator();
            
            ImGui::SliderInt(GetMenuText("Generator Fill Ammount"), &GeneratorFillAmmount, 1, 800);
            ImGui::SliderInt(GetMenuText("Tek Gen Fill Ammount"), &TekGeneratorFillAmmount, 1, 1000);
            
            ImGui::Columns(2, NULL, false);
            ImGui::Checkbox(GetMenuText("Generator Fill"), &GeneratorFill); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Tek Gen Fill"), &TekGeneratorFill); ImGui::NextColumn();
            ImGui::Columns(1);
            
            break;
            
        }
        case 4:{
            
            
            
            ImGui::Columns(3,NULL,false);
            ImGui::Checkbox(GetMenuText("Enable Dupe"), &EnableDupe); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Place BPs"), &PlaceBlueprints); ImGui::NextColumn();
            
            if(userCode.isProCode())
            {
                ImGui::Checkbox(GetMenuText("Floaters"), &Floaters); ImGui::NextColumn();
            }
            ImGui::Columns(1);
            
            if(ImGui::BeginTabBar("Dupe")){
                if(ImGui::BeginTabItem("Stations")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("Eerie", 292)
                    COLUMN_PLACE_BUTTON("Auto", 102)
                    COLUMN_PLACE_BUTTON("Plant X", 67)
                    COLUMN_PLACE_BUTTON("Ballista", 48)
                    COLUMN_PLACE_BUTTON("Catapult", 222)
                    COLUMN_PLACE_BUTTON("Minigun", 223)
                    COLUMN_PLACE_BUTTON("Rocket Turret", 224)
                    COLUMN_PLACE_BUTTON("Large Trap", 220)
                    COLUMN_PLACE_BUTTON("Small Trap", 219)
                    COLUMN_PLACE_BUTTON("Loading Bench", 348)
                    COLUMN_PLACE_BUTTON("Tannery", 351)
                    COLUMN_PLACE_BUTTON("Chef Station", 346)
                    COLUMN_PLACE_BUTTON("Outpost", 345)
                    COLUMN_PLACE_BUTTON("Metal Foundry", 349)
                    COLUMN_PLACE_BUTTON("Dye Studio", 352)
                    COLUMN_PLACE_BUTTON("Stone Station", 350)
                    COLUMN_PLACE_BUTTON("Wood Station", 344)
                    COLUMN_PLACE_BUTTON("Factory", 347)

                    ImGui::Columns(1);
                    
                    ImGui::EndTabItem();
                }
                if(ImGui::BeginTabItem("TEK")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("TEKFoundation", 306)
                    COLUMN_PLACE_BUTTON("TEKCeiling", 309)
                    COLUMN_PLACE_BUTTON("TEKRoof", 310)
                    COLUMN_PLACE_BUTTON("TEKFence Found", 312)
                    COLUMN_PLACE_BUTTON("TEKWall", 322)
                    COLUMN_PLACE_BUTTON("TEKRamp", 318)
                    COLUMN_PLACE_BUTTON("TEKPillar", 319)
                    COLUMN_PLACE_BUTTON("TEKLadder", 317)
                    COLUMN_PLACE_BUTTON("TEKRailing", 311)
                    COLUMN_PLACE_BUTTON("TEKSloped Left", 314)
                    COLUMN_PLACE_BUTTON("TEKSloped Right", 315)
                    COLUMN_PLACE_BUTTON("TEKStairs", 316)
                    COLUMN_PLACE_BUTTON("TEKWindow", 303)
                    COLUMN_PLACE_BUTTON("TEKWindow Frame", 305)
                    COLUMN_PLACE_BUTTON("TEKTrapdoor", 304)
                    COLUMN_PLACE_BUTTON("TEKHatchframe", 320)
                    COLUMN_PLACE_BUTTON("TEKDoor", 307)
                    COLUMN_PLACE_BUTTON("TEKDoorframe", 308)
                    COLUMN_PLACE_BUTTON("TEKTrough", 325)
                    COLUMN_PLACE_BUTTON("TEKChamber", 324)
                    COLUMN_PLACE_BUTTON("TEKProcessor", 328)
                    COLUMN_PLACE_BUTTON("TEKTeleporter", 329)
                    COLUMN_PLACE_BUTTON("TEKLight", 330)
                    COLUMN_PLACE_BUTTON("TEKSleeping Pod", 327)
                    
                    ImGui::Columns(1);
                    ImGui::EndTabItem();
                }
                if(ImGui::BeginTabItem("Boxes")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("Loot Crate", 336)
                    COLUMN_PLACE_BUTTON("Thatch Crate", 337)
                    COLUMN_PLACE_BUTTON("Wood Crate", 338)
                    COLUMN_PLACE_BUTTON("Stone Crate", 339)
                    COLUMN_PLACE_BUTTON("Metal Crate", 340)
                    COLUMN_PLACE_BUTTON("Amber Crate", 341)
                    COLUMN_PLACE_BUTTON("Random Crate", 342)
                    
                    ImGui::Columns(1);
                    ImGui::EndTabItem();
                }
                if(ImGui::BeginTabItem("CS")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("Sleeping Bag", 168)
                    COLUMN_PLACE_BUTTON("Simple Bed", 130)
                    COLUMN_PLACE_BUTTON("Bunk Bed", 32)
                    COLUMN_PLACE_BUTTON("Elegent Bed", 232)
                    COLUMN_PLACE_BUTTON("Sleeping Pod", 327)
                    COLUMN_PLACE_BUTTON("Revival Plat", 343)
                    COLUMN_PLACE_BUTTON("Tek Rep", 323)
                    COLUMN_PLACE_BUTTON("Tek Gen", 326)
                    COLUMN_PLACE_BUTTON("Vault", 207)
                    COLUMN_PLACE_BUTTON("Smithy", 131)
                    COLUMN_PLACE_BUTTON("Fabricator", 90)
                    COLUMN_PLACE_BUTTON("Chem", 16)
                    COLUMN_PLACE_BUTTON("Indi Forge", 34)
                    COLUMN_PLACE_BUTTON("Refining Forge", 132)
                    COLUMN_PLACE_BUTTON("Indi Cooker", 31)
                    COLUMN_PLACE_BUTTON("Mortar", 153)
                    COLUMN_PLACE_BUTTON("Air Con", 104)
                    COLUMN_PLACE_BUTTON("Grill", 218)
                    COLUMN_PLACE_BUTTON("Refridgerator", 103)
                    COLUMN_PLACE_BUTTON("Intake Pipe", 193)
                    COLUMN_PLACE_BUTTON("Vertical Pipe", 197)
                    COLUMN_PLACE_BUTTON("Metal Water Tank", 213)
                    COLUMN_PLACE_BUTTON("Generator", 106)
                    COLUMN_PLACE_BUTTON("Cable", 191)
                    COLUMN_PLACE_BUTTON("Straight Cable", 107)
                    COLUMN_PLACE_BUTTON("Intersection Cable", 189)
                    COLUMN_PLACE_BUTTON("Outlet", 108)
                    COLUMN_PLACE_BUTTON("Beer", 26)
                    
                    ImGui::Columns(1);
                    ImGui::EndTabItem();
                }
                if(ImGui::BeginTabItem("Metal")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("Hatchframe", 3)
                    COLUMN_PLACE_BUTTON("Trapdoor", 4)
                    COLUMN_PLACE_BUTTON("Stairs", 7)
                    COLUMN_PLACE_BUTTON("Railing", 40)
                    COLUMN_PLACE_BUTTON("Elevator Track", 49)
                    COLUMN_PLACE_BUTTON("Large Platform", 52)
                    COLUMN_PLACE_BUTTON("Ladder", 53)
                    COLUMN_PLACE_BUTTON("Roof", 55)
                    COLUMN_PLACE_BUTTON("Sloped Left", 56)
                    COLUMN_PLACE_BUTTON("Sloped Right", 57)
                    COLUMN_PLACE_BUTTON("Billboard", 84)
                    COLUMN_PLACE_BUTTON("Fence Found", 87)
                    COLUMN_PLACE_BUTTON("Gate Frame", 88)
                    COLUMN_PLACE_BUTTON("Gate", 89)
                    COLUMN_PLACE_BUTTON("Foundation", 94)
                    COLUMN_PLACE_BUTTON("Wall", 95)
                    COLUMN_PLACE_BUTTON("Ceiling", 96)
                    COLUMN_PLACE_BUTTON("Door", 97)
                    COLUMN_PLACE_BUTTON("Doorframe", 98)
                    COLUMN_PLACE_BUTTON("SM Hatchframe", 174)
                    COLUMN_PLACE_BUTTON("SM Trapdoor", 175)
                    COLUMN_PLACE_BUTTON("Pillar", 184)
                    COLUMN_PLACE_BUTTON("Ramp", 185)
                    COLUMN_PLACE_BUTTON("Spikes", 157)
                    COLUMN_PLACE_BUTTON("Battlement", 301)
                    COLUMN_PLACE_BUTTON("CurvedBattlment", 300)
                    COLUMN_PLACE_BUTTON("Giant Gate Frame", 182)
                    COLUMN_PLACE_BUTTON("Giant Gate", 181)
                    
                    
                    ImGui::Columns(1);
                    ImGui::EndTabItem();
                }
                if(ImGui::BeginTabItem("Premium")){
                    ImGui::Columns(3, NULL, false);
                    
                    COLUMN_PLACE_BUTTON("Toilet Paper", 353)
                    COLUMN_PLACE_BUTTON("Rex Statue", 333)
                    COLUMN_PLACE_BUTTON("Race Flag", 302)
                    COLUMN_PLACE_BUTTON("Alarm Tower", 296)
                    COLUMN_PLACE_BUTTON("Canti Plat", 294)
                    COLUMN_PLACE_BUTTON("Tuso Statue", 280)
                    COLUMN_PLACE_BUTTON("Spino Statue", 279)
                    COLUMN_PLACE_BUTTON("Giga Statue", 276)
                    COLUMN_PLACE_BUTTON("Gnome", 259)
                    COLUMN_PLACE_BUTTON("Wall Mount", 253)
                    COLUMN_PLACE_BUTTON("Large Wall Mount", 250)
                    COLUMN_PLACE_BUTTON("Vase", 252)
                    COLUMN_PLACE_BUTTON("Armor Stand", 243)
                    COLUMN_PLACE_BUTTON("Mailbox", 230)
                    COLUMN_PLACE_BUTTON("Dragon Flag", 14)
                    COLUMN_PLACE_BUTTON("Gorilla Flag", 15)
                    COLUMN_PLACE_BUTTON("Spider Flag", 82)
                    COLUMN_PLACE_BUTTON("Spider Flag", 82)
                    COLUMN_PLACE_BUTTON("Spider Flag", 82)
                    COLUMN_PLACE_BUTTON("Geopolymer Pillar", 331)
                    COLUMN_PLACE_BUTTON("Geopolymer Floor", 293)
                    COLUMN_PLACE_BUTTON("Stone Stairs", 285)

                    ImGui::Columns(1);
                    ImGui::EndTabItem();
                }
                ImGui::EndTabBar();
            }
            break;
        }
        case 5:{
            ImGui::SliderInt(GetMenuText("Station Purchase Ammount"), &StationPurchaseAmmount, 1, 500);
            ImGui::SliderInt(GetMenuText("Amber Purchase Ammount"), &AmberPurchaseAmmount, 1, 500);
            
            ImGui::Columns(2, NULL, false);
            ImGui::Checkbox(GetMenuText("Station Purchase"), &StationPurchase); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Amber Purchase"), &AmberPurhcase); ImGui::NextColumn();
            
            if(userCode.isMaxCode())
            {
                ImGui::Checkbox(GetMenuText("Unlock Remote Engrams"), &UnlockEngrams); ImGui::NextColumn();
                ImGui::Checkbox(GetMenuText("Crate Drop"), &PVPDropNearby); ImGui::NextColumn();
            }
            
            ImGui::Checkbox(GetMenuText("MovableMenu"), &MoveableMenu); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("StreamerMode"), &StreamerMode); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("IgnoreShots"), &IgnoreShots);
            
            
            
            
            ImGui::Columns(1);
            break;
        }
            
    }
    
    ImGui::EndChild();
}
void Menu::DrawMainMenu(){
    if(userCode.isNormalCode()){
        if(AuthString != "You Are Logged In"){
            return;
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            //Clamp menu to an appropriate size / position if it is bad
            if(MenuSize.x > SCREEN_WIDTH) MenuSize.x = 400;
            if(MenuSize.y > SCREEN_HEIGHT) MenuSize.y = 370;
            if(MenuOrigin.x < 0) MenuOrigin.x = 0;
            if(MenuOrigin.y < 0) MenuOrigin.y = 0;
            if(MenuOrigin.x + MenuSize.x > SCREEN_WIDTH + 10) MenuOrigin.x = SCREEN_WIDTH - MenuSize.x;
            if(MenuOrigin.y + MenuSize.y > SCREEN_HEIGHT + 10) MenuOrigin.y = SCREEN_HEIGHT - MenuSize.y;
            
            if(MoveableMenu)
            {
                ImGui::SetNextWindowPos(MenuOrigin);
                ImGui::SetNextWindowSize(MenuSize);
            }
            else
            {
                ImGui::SetNextWindowPos(ImVec2((SCREEN_WIDTH - 400), (0)), 0, ImVec2(0, 0));
                ImGui::SetNextWindowSize(ImVec2(400, 370));
            }
        });
        
        
        if(!MoveableMenu)
        {
            ImGui::SetNextWindowPos(ImVec2((SCREEN_WIDTH - 400), (0)), 0, ImVec2(0, 0));
            ImGui::SetNextWindowSize(ImVec2(400, 370));
        }
        
        ImGuiWindowFlags MenuFlags = MoveableMenu ? ImGuiWindowFlags_NoCollapse : ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove;
        
        ImGui::Begin("Carsontool", NULL, MenuFlags);
        
        MenuOrigin = ImGui::GetWindowPos();
        MenuSize = ImGui::GetWindowSize();
        
        if(ImGui::BeginTabBar("Tab Bar")){
            if(ImGui::BeginTabItem("Main")){
                
                if(ImGui::CollapsingHeader("Sliders")){
                    if(!Sliders) MenuToggle(0);
                    DrawSlidersMenu();
                }
                if(ImGui::CollapsingHeader("PVP")){
                    if(!PVP) MenuToggle(1);
                    DrawPVPMenu();
                }
                if(ImGui::CollapsingHeader("Buttons")){
                    if(!Buttons) MenuToggle(2);
                    DrawButtonsMenu();
                }
                if(ImGui::CollapsingHeader("ESP")){
                    if(!ESP) MenuToggle(3);
                    DrawESPMenu();
                }
                if(ImGui::CollapsingHeader("Other")){
                    if(!Other) MenuToggle(4);
                    DrawOtherMenu();
                }
                ImGui::EndTabItem();
            }
            
            if(ImGui::BeginTabItem("Other Windows"))
            {
                if(ImGui::BeginTabBar("OtherWindowsTB"))
                {
                    if(userCode.isProCode())
                    {
                        if(ImGui::BeginTabItem("Player List")){
                            playerList.DrawMenu();
                            ImGui::EndTabItem();
                        }
                        if(ImGui::BeginTabItem("Bed List")){
                            bedList.DrawBedListMenu();
                            ImGui::EndTabItem();
                        }
                        if(ImGui::BeginTabItem("World")){
                            weaponColor.DrawWeaponColorMenu();
                            ImGui::EndTabItem();
                        }
                        if(ImGui::BeginTabItem("Aimbot")){
                            aimAssist.DrawAimAssistMenu();
                            ImGui::EndTabItem();
                        }
                    }
                    if(ImGui::BeginTabItem("Crosshair")){
                        crosshair.DrawCrosshairMenu();
                        ImGui::EndTabItem();
                    }
                    if(ImGui::BeginTabItem("Chat")){
                        chatMessages.DrawChatMenu();
                        ImGui::EndTabItem();
                    }
                    if(userCode.isProCode()){
                        if(ImGui::BeginTabItem("PVE Destroy")){
                            PVEDestruction::getInstance().ShowPVEDestructionMenu();
                            ImGui::EndTabItem();
                        }
                    }
                    
                    if(userCode.isDevCode()){
                        if(ImGui::BeginTabItem("Debug")){
                        DinoSteal::getInstance().DrawDinoStealMenu();
                        ImGui::EndTabItem();
                        }
                    } 
                    ImGui::EndTabBar();
                }
                
                //Dino Color, Crosshair, Player List, Style
                ImGui::EndTabItem();
            }
            
            
            
            if(ImGui::BeginTabItem("Customize")){
                if(ImGui::BeginTabBar("CustomizeTabBar")){
                    
                    if(ImGui::BeginTabItem("ESP Colors")){
                        DrawColorsList();
                        ImGui::EndTabItem();
                    }
                    
                    if(ImGui::BeginTabItem("Player Colors")){
                        playerColors.DrawMenu();
                        ImGui::EndTabItem();
                    }
                    if(ImGui::BeginTabItem("Dino Colors")){
                        dinoColors.DrawDinoColorMenu();
                        ImGui::EndTabItem();
                    }
                    
                    if(ImGui::BeginTabItem("Menu Style")){
                        menuStyle.DrawMenu();
                        ImGui::EndTabItem();
                    }
                    if(ImGui::BeginTabItem("Language")){
                        const char* LanguageChoices[] = {"English", "Chinese"};
                        ImGui::Combo("Language", &LanguageValue, LanguageChoices, IM_ARRAYSIZE(LanguageChoices));
                        ImGui::EndTabItem();
                    }
                    ImGui::EndTabBar();
                }
                ImGui::EndTabItem();
            }
            
            if(ImGui::BeginTabItem("Unofficial")){
                if(ImGui::BeginTabBar("UnofficialTB")){
                    if(ImGui::BeginTabItem("Quick")){
                        QuickCommands::getInstance().DrawMenu();
                        ImGui::EndTabItem();
                    }
                    if(userCode.isMaxCode())
                    {
                        if(ImGui::BeginTabItem("Dino Spawn")){
                            DinoSpawn::getInstance().DrawMenu();
                            ImGui::EndTabItem();
                        }
                        if(ImGui::BeginTabItem("Item Spawn")){
                            ItemSpawn::getInstance().DrawMenu();
                            ImGui::EndTabItem();
                        }
                    }
                    if(ImGui::BeginTabItem("Other")){
                        OtherCommands::getInstance().DrawMenu();
                        ImGui::EndTabItem();
                    }
                    if(ImGui::BeginTabItem("Waypoints")){
                        Waypoints::getInstance().DrawMenu();
                        ImGui::EndTabItem();
                    }
                    if(ImGui::BeginTabItem("Mat Spawn")){
                        MatSpawn::getInstance().DrawMenu();
                        ImGui::EndTabItem();
                    }
                    ImGui::EndTabBar();
                }
                ImGui::EndTabItem();
            }
            if(userCode.isProCode()){
                // if(ImGui::BeginTabItem("Console")){
                //     DrawConsole();
                //     ImGui::EndTabItem();
                // }
                
                if(ImGui::BeginTabItem("Minimap")){
                    Minimap::getInstance().DrawMinimapSettingsMenu();
                    ImGui::EndTabItem();
                }
            }
            ImGui::EndTabBar();
        }
        ImGui::End();
    }
}
