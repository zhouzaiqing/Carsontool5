//
//  PVEDestruction.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 1/23/24.
//

#import <Foundation/Foundation.h>
#include "Includes.h"


/*
 Pickup Bottom Up
    - Item Caches
    - Foundations
    - Turrets
    - Structures
 Demolish Target / Pickup Target
    - Automatic (Enemy)
    - When Punching
 
Claim Enemy Dino
    - All in Render Distance Automatically
    - All in Render Distance Once
    - When Punching
    
 */

/*
static bool MultiUsePickupItemCache;
static bool MultiUsePickupFoundation;
static bool MultiUsePickupTurrets;
static bool MultiUsePickupStructures;

static bool ClaimAllDinos;
static bool ClaimTargetDino;
 */

namespace FunctionsStaticClassFunctions{
    static long (*AShooterWeapon)() = (long(*)())utils.getOffset(0x1184628);
    static long (*AShooterWeapon_Instant)() = (long(*)())utils.getOffset(0x0118a13c);
    static long (*AShooterWeapon_Projectile)() = (long(*)())utils.getOffset(0x118f768);

    static long (*PrimalTargetableActor)() = (long(*)())utils.getOffset(0xfc7ac4);
    static long (*PrimalStructureItemContainer)() = (long(*)())utils.getOffset(0x00f9b03c);
    static long (*PrimalStructure)() = (long(*)())utils.getOffset(0x00f76cd4);
    static long (*PrimalStructureBearTrap)() = (long(*)())utils.getOffset(0x00f80078);
    static long (*PrimalStructureBed)() = (long(*)())utils.getOffset(0xf89518);
    static long (*PrimalStructureExplosive)() = (long(*)())utils.getOffset(0x00f95bf0);
    static long (*PrimalStructureTurret)() = (long(*)())utils.getOffset(0xfbbf7c);
    static long (*PrimalStructureTurretPlant)() = (long(*)())utils.getOffset(0xfbf93c);

    static long (*PrimalCharacter)() = (long(*)())utils.getOffset(0x0df3ab0);
    static long (*PrimalDinoCharacter)() = (long(*)())utils.getOffset(0xe685c0);
    static long (*ShooterCharacter)() = (long(*)())utils.getOffset(0x102be00);

    static long (*ADroppedItem)() = (long(*)())utils.getOffset(0xd52868);
    static long (*DroppedItemEgg)() = (long(*)())utils.getOffset(0xd53280);
    static long (*DroppedItemFeather)() = (long(*)())utils.getOffset(0xd5379c);
    static long (*ADroppedItemLowQuality)() = (long(*)())utils.getOffset(0x0d53970);

    static long (*APrimalStructureDoor)() = (long(*)())utils.getOffset(0xf8c018);

    static bool (*AreTribesAllied)(long tribedata, int tribeid) = (bool (*) (long, int))utils.getOffset(0x0085d728);
};


static void PVEUnclaimDino(UObject* Dino){
    if(!utils.isObject((long)Dino)) return;
    if(utils.isValidAdress(gameUtils.GetMyController()) && gameUtils.isA_Fast(Dino, FunctionsStaticClassFunctions::PrimalDinoCharacter())){
        uint32_t DinoID = utils.Read<uint32_t>(Dino + 0x1a08);
        
        ServerMultiUse_Params newMultUseParams;
        newMultUseParams.bAllowSpam = 1;
        newMultUseParams.ComponentIndex = -1;
        newMultUseParams.UseIndex = 122;
        newMultUseParams.ForObject = Dino;
        newMultUseParams.ignoreDisableUse = 1;

        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
    }
}
static void PVEPickupStructure(UObject* Structure){
    UObject* Controller = gameUtils.GetMyController();
    if(!utils.isObject((long)Structure)) return;
    
    if(utils.isValidAdress(Controller) && gameUtils.isA_Fast(Structure, FunctionsStaticClassFunctions::PrimalStructure())){
        ServerMultiUse_Params params = {Structure, 204,0,1,1};
        functions.ProcessEventCall(Controller, (wchar_t*)L"ServerMultiUse", &params);
    }
}
static void PVEDemolishStructure(UObject* Structure){
    UObject* Controller = gameUtils.GetMyController();
    if(!utils.isObject((long)Structure)) return;
    
    if(utils.isValidAdress(Controller) && gameUtils.isA_Fast(Structure, FunctionsStaticClassFunctions::PrimalStructure())){
        ServerMultiUse_Params params = {Structure, 201,0,1,1};
        functions.ProcessEventCall(Controller, (wchar_t*)L"ServerMultiUse", &params);
    }
}

static void PVEDemolishTargetStructure(){
    UObject* Controller = gameUtils.GetMyController();
    UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
    if(utils.isValidAdress(TargettingObject)){
        UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
        PVEDemolishStructure(Object);
    }
}
static void PVEPickupTargetStructure(){
    UObject* Controller = gameUtils.GetMyController();
    UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
    if(utils.isValidAdress(TargettingObject)){
        UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
        PVEPickupStructure(Object);
    }
}
static void PVEClaimTargetDino(){
    UObject* Controller = gameUtils.GetMyController();
    UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
    if(utils.isValidAdress(TargettingObject)){
        UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
        PVEUnclaimDino(Object);
    }
}
static void PVEKillDinos(UObject* Dino){
    
    float Health = utils.Read<float>(Dino + 0xc44);
    
    if(Health < 0.1) return;
    
    
    ServerMultiUse_Params newMultUseParams;
    newMultUseParams.bAllowSpam = 1;
    newMultUseParams.ComponentIndex = -1;
    newMultUseParams.UseIndex = 124;
    newMultUseParams.ForObject = Dino;
    newMultUseParams.ignoreDisableUse = 1;
    
    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
    
    newMultUseParams.UseIndex = 189;
    
    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
}

/*
 
 }
 static void InternalUnclaimDino(UObject* Dino){
     if(utils.isValidAdress(gameUtils.GetMyController())){
         uint32_t DinoID = utils.Read<uint32_t>(Dino + 0x1a08);
         
         ServerMultiUse_Params newMultUseParams;
         newMultUseParams.bAllowSpam = 1;
         newMultUseParams.ComponentIndex = -1;
         newMultUseParams.UseIndex = 122;
         newMultUseParams.ForObject = Dino;
         newMultUseParams.ignoreDisableUse = 1;
         
         //functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
         if(DinoID != 0){
             functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerTryUnclaimDino", &DinoID);
             //UseIndex = 122 bAllowSpam = 1 ComponentIndex = -1
         }
         //functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
     }
 }
 //201 is Demolish
 //204 is Pickup
 void FunctionCall::StealAimedDino(){
     UObject* Controller = gameUtils.GetMyController();
     UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
     if(utils.isValidAdress(TargettingObject)){
         UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
         UnclaimDino(Object);
     }
 }
 static void InternalDestroyStructure(UObject* PrimalStructure){
     UObject* Controller = gameUtils.GetMyController();
     if(utils.isValidAdress(Controller) && gameUtils.isA_Fast(PrimalStructure, FunctionsStaticClassFunctions::PrimalStructure())){
         ServerMultiUse_Params params = {PrimalStructure, 201,0,0,1};
         functions.ProcessEventCall(Controller, (wchar_t*)L"ServerMultiUse", &params);
     }
 }
 static void InternalPickupStructure(UObject* PrimalStructure){
     UObject* Controller = gameUtils.GetMyController();
     if(utils.isValidAdress(Controller) && gameUtils.isA_Fast(PrimalStructure, FunctionsStaticClassFunctions::PrimalStructure())){
         ServerMultiUse_Params params = {PrimalStructure, 204,0,0,1};
         functions.ProcessEventCall(Controller, (wchar_t*)L"ServerMultiUse", &params);
     }
 }
 void FunctionCall::PickupStructure(UObject* PrimalStructure){
     funcqueue.AddFunction(std::bind(&InternalPickupStructure, PrimalStructure));
 }
 void FunctionCall::DestroyStructure(UObject* PrimalStructure){
     funcqueue.AddFunction(std::bind(&InternalDestroyStructure, PrimalStructure));
 }

 void FunctionCall::PickupAimedStructure(){
     UObject* Controller = gameUtils.GetMyController();
     UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
     if(utils.isValidAdress(TargettingObject)){
         UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
         PickupStructure(Object);
     }
 }
 void FunctionCall::DestroyAimedStructure(){
     UObject* Controller = gameUtils.GetMyController();
     UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
     if(utils.isValidAdress(TargettingObject)){
         UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
         DestroyStructure(Object);
     }
 }
 */

/*
 // Size: 0x60 // Inherited bytes: 0x00
 struct FTamedDinoEntry {
     // Fields
     struct FString dinoName; // Offset: 0x00 // Size: 0x10
     uint32_t DinoID; // Offset: 0x10 // Size: 0x04
     int DinoLevel; // Offset: 0x14 // Size: 0x04
     struct FText DinoType; // Offset: 0x18 // Size: 0x18
     struct FString OwnerName; // Offset: 0x30 // Size: 0x10
     int OwnerID; // Offset: 0x40 // Size: 0x04
     bool CanUnclaim; // Offset: 0x44 // Size: 0x01
     bool CanBeRequested; // Offset: 0x45 // Size: 0x01
     char pad_0x46[0x2]; // Offset: 0x46 // Size: 0x02
     double DinoRequestTime; // Offset: 0x48 // Size: 0x08
     double DinoTeleportTime; // Offset: 0x50 // Size: 0x08
     bool isWaterDino; // Offset: 0x58 // Size: 0x01
     char pad_0x59[0x7]; // Offset: 0x59 // Size: 0x07
 };
 
struct FTamedDinoEntry {
    char pad_0x0[0x10];
    uint32_t DinoID;
    char pad_0x14[0x4C];
};
 
 
 static void InternalUnclaimDino(UObject* Dino){
     if(utils.isValidAdress(gameUtils.GetMyController())){
         uint32_t DinoID = utils.Read<uint32_t>(Dino + 0x1a08);
         
         ServerMultiUse_Params newMultUseParams;
         newMultUseParams.bAllowSpam = 1;
         newMultUseParams.ComponentIndex = -1;
         newMultUseParams.UseIndex = 122;
         newMultUseParams.ForObject = Dino;
         newMultUseParams.ignoreDisableUse = 1;
         
         //functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
         if(DinoID != 0){
             functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerTryUnclaimDino", &DinoID);
             //UseIndex = 122 bAllowSpam = 1 ComponentIndex = -1
         }
         //functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
     }
 }
 void FunctionCall::UnclaimDino(UObject* Dino){
     funcqueue.AddFunction(std::bind(&InternalUnclaimDino, Dino));
 }
 */

static void UnclaimAllMyDinos(){
    UObject* Controller = gameUtils.GetMyController();
    UObject* RidingDino = gameUtils.GetMountedDino();
    
    
    int myTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    
    if(utils.isValidAdress(Controller)){
        
        uint32_t DinoID = utils.Read<uint32_t>(RidingDino + 0x1a08);
        TArray<FTamedDinoEntry> LastRecievedDinoList = utils.Read<TArray<FTamedDinoEntry>>(Controller + 0x13a0);
        
        
        //Kill All Dinos In Render Distance
       /* if(!TActorsArray.IsValidArray()) return;
        for(int i = 0; i<TActorsArray.Count; i++){
            UObject* CurrentActor = TActorsArray[i];
            if(!utils.isValidAdress(CurrentActor)) continue;
            
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            
            //if(ObjectTeamID == myTeamID){
                if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalDinoCharacter())){
                    uint32_t CurrentDinoID = utils.Read<uint32_t>(CurrentActor + 0x1a08);
                    if(CurrentDinoID != DinoID){
                        
                        ServerMultiUse_Params newMultUseParams;
                        newMultUseParams.bAllowSpam = 1;
                        newMultUseParams.ComponentIndex = -1;
                        newMultUseParams.UseIndex = 124;
                        newMultUseParams.ForObject = CurrentActor;
                        newMultUseParams.ignoreDisableUse = 1;
                        
                        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
                        
                        newMultUseParams.UseIndex = 189;
                        
                        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newMultUseParams);
                        
                    }
                }
            //}
        } */
        
        
        
        //Unclaim Dino List
        for(int i = 0; i<LastRecievedDinoList.Count; ++i){
            FTamedDinoEntry CurrentEntry = LastRecievedDinoList[i];
            if(CurrentEntry.DinoID != DinoID){
                functions.ProcessEventCall(gameUtils.GetMyController(), (wchar_t*)L"ServerTryUnclaimDino", &CurrentEntry.DinoID);
            }
        }
    }
    
    //FTamedDinoEntry
    //struct TArray<struct FTamedDinoEntry> LastRecievedDinoList; // Offset: 0x13a0 // Size: 0x10
}
static void EXECUnclaimAllDinos(){
    funcqueue.AddFunction(std::bind(&UnclaimAllMyDinos));
}

//make the destruction list
static void GetDestructionList(){
    if(!MultiUsePickupFoundation && !MultiUsePickupTurrets && !MultiUsePickupStructures && !MultiUsePickupItemCache && !ClaimAllDinos && !KillAllDinos)
        return;
    
    int myTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    
    bool CheckStructures = MultiUsePickupFoundation || MultiUsePickupTurrets || MultiUsePickupStructures || MultiUsePickupItemCache;

    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        
        NSString* ObjectName = gameUtils.GetObjectName(CurrentActor);
        
        int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
        if(!gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID) && ObjectTeamID != myTeamID){
            UObject* SceneComponent = utils.Read<UObject*>(CurrentActor + 0x2c8);
            Vector3 Location = utils.Read<Vector3>(SceneComponent + 0x290);
            
            
            if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalDinoCharacter())){
                if(ClaimAllDinos && ObjectTeamID > 1000)
                    PVEUnclaimDino(CurrentActor);
                else if(KillAllDinos)
                    PVEKillDinos(CurrentActor);

                continue;
            }
            if(CheckStructures){
                if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalStructureItemContainer())){
                    if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalStructureTurret())){
                        if(MultiUsePickupTurrets){
                            PVEPickupStructure(CurrentActor);
                            continue;
                        }
                    }
                    else if([ObjectName isEqualToString:@"DeathItemCache_C"]){
                        if(MultiUsePickupItemCache){
                            PVEPickupStructure(CurrentActor);
                        }
                        continue;
                    }
                }
                if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalStructure())){
                    
                    if([ObjectName containsString:@"Foundation"] || [ObjectName containsString:@"Floor"] || [ObjectName containsString:@"Pillar"]){
                        if(MultiUsePickupFoundation){
                            PVEPickupStructure(CurrentActor);
                            continue;
                        }
                    }
                    else{
                        if(MultiUsePickupStructures){
                            PVEPickupStructure(CurrentActor);
                        }
                        continue;
                    }
                }
            }
        }
        
    }
}

/* All the long range shit */
void PVEDestruction::Handle(){
    static bool shouldRefreshList = true;
    if(shouldRefreshList){
        GetDestructionList();
        shouldRefreshList = false;
        timer(1){
            shouldRefreshList = true;
        });
    }
    
    if(ClaimTargetDino){
        if(gameUtils.isShootButtonPressed()){
            PVEClaimTargetDino();
        }
    }
    if(DemolishTargetAutmoatically){
        PVEDemolishTargetStructure();
    }
    if(PickupTargetAutomatically){
        PVEPickupTargetStructure();
    }
    if(DemolishTargetPunching){
        if(gameUtils.isShootButtonPressed()){
            PVEDemolishTargetStructure();
        }
    }
    if(PickupTargetPunching){
        if(gameUtils.isShootButtonPressed()){
            PVEPickupTargetStructure();
        }
    }
}
void PVEDestruction::ShowPVEDestructionMenu(){
    ImGui::Text("%s", GetMenuText("Pickup In Range"));
    
    ImGui::Columns(2, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Item Cache"), &MultiUsePickupItemCache); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Foundation"), &MultiUsePickupFoundation); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Turrets"), &MultiUsePickupTurrets); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Structures"), &MultiUsePickupStructures); ImGui::NextColumn();
    
    ImGui::Columns();
    
    ImGui::Text("%s", GetMenuText("Demolish Target"));
    ImGui::Columns(2, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Automatically"), &DemolishTargetAutmoatically); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("When Punching"), &DemolishTargetPunching); ImGui::NextColumn();
    
    ImGui::Columns();
    ImGui::Text("%s", GetMenuText("Pickup Target"));
    ImGui::Columns(2, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Automatically "), &PickupTargetAutomatically); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("When Punching "), &PickupTargetPunching); ImGui::NextColumn();
    
    ImGui::Columns();
    ImGui::Text("%s", GetMenuText("Claim Dinos"));
    ImGui::Columns(2, NULL, false);
    
    ImGui::Checkbox(GetMenuText("All In Range"), &ClaimAllDinos); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Target"), &ClaimTargetDino); ImGui::NextColumn();
    
    ImGui::Columns();
    
    ImGui::Text("%s", GetMenuText("Kill Dinos"));
    ImGui::Columns(2, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Kill All In Range"), &KillAllDinos); ImGui::NextColumn();
    
    ImGui::Columns();
    
    ImGui::Text("Buttons");
    ImGui::Columns(4, NULL, false);
    
    if(ImGui::Button(GetMenuText("Pickup"), ImVec2(75,20))){
        PVEPickupTargetStructure();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Demolish"), ImVec2(75,20))){
        PVEDemolishTargetStructure();
    } ImGui::NextColumn();
    if(ImGui::Button(GetMenuText("Claim"), ImVec2(75,20))){
        PVEClaimTargetDino();
    } ImGui::NextColumn();
    
    if(ImGui::Button(GetMenuText("Unclaim All Dinos"), ImVec2(75,20))){
        EXECUnclaimAllDinos();
    } ImGui::NextColumn();
    
    ImGui::Columns();
}
