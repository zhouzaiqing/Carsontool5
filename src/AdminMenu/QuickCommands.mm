//
//  QuickCommands.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/23/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

void QuickCommands::DrawMenu(){
    ImGui::Columns(3, NULL, false);
    
    if(ImGui::Button(GetMenuText("Players Only"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("PlayersOnly");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Force Tame"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("ForceTame");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Save World"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("SaveWorld");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Take All Dinos"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("TakeAllDino");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Take All Structures"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("TakeAllStructure");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Clear My Inventory"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand(utils.string_format("ClearPlayerInventory %d 1 1 0", gameUtils.GetPlayerID()));
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Force Join Tribe"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand(utils.string_format("ForcePlayerToJoinTargetTribe %d", gameUtils.GetPlayerID()));
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("GMBuff"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("GMBuff");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Force Owner"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("MakeTribeFounder");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Force Admin"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("MakeTribeAdmin");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Leave Me Alone"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("LeaveMeAlone");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Infinite Stats"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("InfiniteStats");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Give To Me"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("GiveToMe");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Refresh Gift Time"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("Gift");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Forcemate"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("Forcemate");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Fly"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("Fly");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Ghost"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("Ghost");
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Walk"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
        functions.ExecuteConsoleCommand("Walk");
    } ImGui::NextColumn();
    
    ImGui::Columns();
    
    
    
}
