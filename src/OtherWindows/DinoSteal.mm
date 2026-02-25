//
//  DinoSteal.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 8/22/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static long (*PrimalDinoCharacter)() = (long(*)())utils.getOffset(0xe685c0);
void DinoSteal::StealDinos(bool StealWilds, bool StealAlly, bool StealEnemy){
    int MyTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    
    
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        if(gameUtils.isA_Fast(CurrentActor, PrimalDinoCharacter())){
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            
            if(ObjectTeamID == MyTeamID){
                continue;
            }
            else if(gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID)){
                if(StealAlly){
                    functions.UnclaimDino(CurrentActor);
                }
                continue;
            }
            else if(ObjectTeamID < 1000){
                if(StealWilds){
                    functions.UnclaimDino(CurrentActor);
                }
                continue;
            }
            else{
                if(StealEnemy){
                    functions.UnclaimDino(CurrentActor);
                }
                continue;
            }
        }
    }
}

static bool MenuStealAlly;
static bool MenuStealEnemy;
static bool MenuStealWild;
static void (*ClientRemoveDungeonLoadingScreen)(UObject* AShooterPlayerController) = (void(*)(UObject*))utils.getOffset(0x10c43e0);

//Make Claim Target Dino

void DinoSteal::DrawDinoStealMenu(){
    
    //StreamerMode = YES;
    ImGui::Text("This is the dev menu. Streamer Mode has been automatically Enabled. \n Please Don't show anything here to anyone else.");
    ImGui::Text("Menu Framerate: %.1f", ImGui::GetIO().Framerate);
    ImGui::Columns(3, NULL, false);
    ImGui::Checkbox("Steal Ally", &MenuStealAlly); ImGui::NextColumn();
    ImGui::Checkbox("Steal Enemy", &MenuStealEnemy); ImGui::NextColumn();
    ImGui::Checkbox("Steal Wild", &MenuStealWild);
    
    ImGui::Columns();
    if(ImGui::Button("Start Stealing", ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        StealDinos(MenuStealWild, MenuStealAlly, MenuStealEnemy);
    }
    
    ImGui::Separator();
    
    if(ImGui::Button("Crash Server Forever", ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        functions.ForeverCrash();
    }
    if(ImGui::Button("Claim Target Dino", ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        functions.StealAimedDino();
    }
    
    ImGui::Columns(2, NULL, false);
    ImGui::Checkbox("Pickup Nearby", &PickupNearbyStructures); ImGui::NextColumn();
    ImGui::Checkbox("Destroy Nearby", &DestroyNearbyStructures); ImGui::NextColumn();
    ImGui::Columns();
    if(ImGui::Button("Pickup Target Structure", ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        functions.PickupAimedStructure();
    }
    if(ImGui::Button("Destroy Target Structure", ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        functions.DestroyAimedStructure();
    }
}

