//
//  CrashBot.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/25/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"

static void (*ClientTravel)(UObject* Engine, UObject* World, wchar_t* ServerIP, int TravelType) = (void(*)(UObject*,UObject*,wchar_t*,int))utils.getOffset(0x2b9dc88);


void CrashBot::CrashBotButtonPushed(){
    if(isActive){
        NSString* NSServerName = [NSString stringWithCString:ServerName.c_str() encoding:[NSString defaultCStringEncoding]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stop Crashing"
                                                                                         message:NSServerName
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* StopCrashing = AlertAction(@"Stop Crashing"){ StopCrashBot(); }];
        UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
        
        [alertController addAction:StopCrashing];
        [alertController addAction:Cancel];
        [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Start Crashing Server"
                                                                                         message:NULL
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* StartCrashing = AlertAction(@"Start Crashing"){ ActivateCrashBot(); }];
        UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
        
        [alertController addAction:StartCrashing];
        [alertController addAction:Cancel];
        [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
}
void CrashBot::ActivateCrashBot(){
    ServerName = gameUtils.GetServerName();
    ServerIP = gameUtils.GetServerIP();
    isActive = true;
}
void CrashBot::StopCrashBot(){
    isActive = NO;
    ServerName = "None";
    ServerIP = "None";
}
void CrashBot::HandleCrashBot(){
    if(isActive){
        string DisplayString = "Crashing \nServer Name: " + ServerName + "\nServer IP: " + ServerIP;
        
        //Outline
        ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), 20, ImVec2(40+1, SCREEN_HEIGHT * 4/5 +1), Black.toU32(), DisplayString.c_str());
        ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), 20, ImVec2(40+1, SCREEN_HEIGHT * 4/5 -1), Black.toU32(), DisplayString.c_str());
        ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), 20, ImVec2(40-1, SCREEN_HEIGHT * 4/5 +1), Black.toU32(), DisplayString.c_str());
        ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), 20, ImVec2(40-1, SCREEN_HEIGHT * 4/5 -1), Black.toU32(), DisplayString.c_str());
        
        ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), 20, ImVec2(40, SCREEN_HEIGHT * 4/5), utils.GetRainbowLinearColor(10, 1).toU32(), DisplayString.c_str());
        
        
        //10 Second Timer
        static bool CrashTimer = true;
        if(!CrashTimer) return;
        CrashTimer = false;
        timer(10){
            CrashTimer = true;
        });
        
        if(gameUtils.isInGame()){
            functions.CrashTheServer();
        } else {
            JoinServer();
        }
    }
}
void CrashBot::JoinServer(){
    if(isActive){
        UObject* GWorld = gameUtils.GetGWorld();
        UObject* GEngine = gameUtils.GetGEngine();
        
        if(utils.isValidAdress(GWorld) && utils.isValidAdress(GEngine)){
            std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(ServerIP);
            FString RelogFString = FString(wstr.c_str());
            ClientTravel(GEngine, GWorld, RelogFString.Data, 0);
        }
    }
}
