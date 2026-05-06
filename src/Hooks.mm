//
//  Hooks.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"
/*
 TEMPORARY:
 */

/* END TESTING */
static long (*AShooterWeapon)() = (long(*)())utils.getOffset(0x1184628);
static UObject* (*GetPointer)(UObject* WeakPtr) = (UObject*(*)(UObject*))utils.getOffset(0x157d62c);
static void (*origProcessEvent)(UObject* Object, UObject* FunctionAdress, void* Params) = (void(*)(UObject*,UObject*,void*))utils.getOffset(0x024b57ec);
static void (*MoveRight_orig)(UObject* Character, float val) = (void(*)(UObject*,float))utils.getOffset(0x818e00);
static void (*MoveForward_orig)(UObject* Character, float val) = (void(*)(UObject*,float))utils.getOffset(0x818c84);
static void (*AddMovementInput)(UObject* Pawn, Vector3 WorldDirection, float ScaleValue, bool bForce) = (void(*)(UObject*, Vector3, float, bool))utils.getOffset(0x29a5fa0);

static float (*GetUseItemAddCharacterStatusValue)(UObject* PrimalItem, EPrimalCharacterStatusValue ValueType) = (float(*)(UObject*, EPrimalCharacterStatusValue))utils.getOffset(0x8afaa0);
//008afaa0
//float GetUseItemAddCharacterStatusValue(enum class EPrimalCharacterStatusValue ValueType);
static void MoveRightHook(UObject* Pawn, float Val){
    if(PVPDinoSpin && utils.isValidAdress(gameUtils.GetPlayerCameraManager())){
        Vector3 CameraRotation = utils.Read<Vector3>(gameUtils.GetPlayerCameraManager() + 0xBEC);
        
        CameraRotation.Y = CameraRotation.Y + 90; CameraRotation.X = 0;
    
        Vector3 RotationRadians = {CameraRotation.X * Deg_To_Rad, CameraRotation.Y * Deg_To_Rad, CameraRotation.Z * Deg_To_Rad};
        Vector3 DirectionVector = {cos(RotationRadians.X) * cos(RotationRadians.Y), cos(RotationRadians.X) * sin(RotationRadians.Y), sin(RotationRadians.X)};
         
        return AddMovementInput(Pawn, DirectionVector, Val, true);
    } else{
        return MoveRight_orig(Pawn, Val);
    }
}
static void MoveForwardHook(UObject* Pawn, float Val){
    if(PVPDinoSpin && utils.isValidAdress(gameUtils.GetPlayerCameraManager())){
        Vector3 CameraRotation = utils.Read<Vector3>(gameUtils.GetPlayerCameraManager() + 0xBEC);
        
        if(gameUtils.isDinoFlying(Pawn))
            CameraRotation.X = 0;
    
        Vector3 RotationRadians = {CameraRotation.X * Deg_To_Rad, CameraRotation.Y * Deg_To_Rad, CameraRotation.Z * Deg_To_Rad};
        Vector3 DirectionVector = {cos(RotationRadians.X) * cos(RotationRadians.Y), cos(RotationRadians.X) * sin(RotationRadians.Y), sin(RotationRadians.X)};
         
        return AddMovementInput(Pawn, DirectionVector, Val, true);
    } else{
        return MoveForward_orig(Pawn, Val);
    }
}

//Normal Hooks
static void ShooterPlayerStateHook(UObject* Object, UObject* FunctionAdress, void* Params){
    string FunctionName = gameUtils.SGetObjectName(FunctionAdress);
    if(FunctionName == "ClientGetAlivePlayerConnectedData"){
        playerList.HandleReceivePlayerInfo(Object, (ClientGetAlivePlayerConnectedData_Params*)Params);
        return;
    }
    if(FunctionName == "ServerRequestApplyEngramPoints"){
        menu.ConsoleLog("Player State", gameUtils.SGetObjectName((UObject*)Params), Red);
    }
    
    origProcessEvent(Object, FunctionAdress, Params);
}
static void WeaponHook(UObject* Object, UObject* FunctionAdress, void* Params){
    string FunctionName = gameUtils.SGetObjectName(FunctionAdress);
    //menu.ConsoleLog(FunctionName, "Weapon", Blue);
    //SimualteInstantHit, ServerStopFire, ServerStartFire, ServerNotifyShot
    
    
    if(FunctionName == "ServerNotifyShot" && PVPMagicBullet){
        if(aimbot.FireWeapon())
            return;
    }
    
    if(FunctionName == "ServerFireProjectile"){
        if(PVPProjectileSpam && aimbot.isProjectileWeapon(Object)){
            return;
        }
    }
    
    origProcessEvent(Object, FunctionAdress, Params);
}
static Vector3 RotatorToVector(FRotator Rotator){
    float radPitch = Rotator.Pitch * PI/180;
    float radYaw = Rotator.Yaw * PI/180;
    float SP = sin(radPitch);
    float CP = cos(radPitch);
    float SY = sin(radYaw);
    float CY = cos(radYaw);
    return {CP*CY, CP*SY, SP};
}


static void EnableButton(UObject* Button){
    long Smth = *(long*)(Button + 0x158);
    if(utils.isValidAdress(Smth)) {
        *(int*)(Smth + 0x210) = 25;
    }
}

static bool isFoodHealthy(UObject* Food){
    float TorporValue = GetUseItemAddCharacterStatusValue(Food, PrimalCharacterStatusValue_Torpidity);
    float WaterValue = GetUseItemAddCharacterStatusValue(Food, PrimalCharacterStatusValue_Water);
    float FoodValue = GetUseItemAddCharacterStatusValue(Food, PrimalCharacterStatusValue_Food);
    float HealthValue = GetUseItemAddCharacterStatusValue(Food, PrimalCharacterStatusValue_Health);
    
    if(FoodValue < -0.1 || WaterValue < -0.1 || TorporValue > 0.5 || HealthValue < -0.1)
        return false;
    
    return true;
}
static void RequestPlayerInfoTimer(){
    
    static bool RequestInfoTimer = true;
    
    if(!RequestInfoTimer) return;
    RequestInfoTimer = false;
    
    timer(5){
        RequestInfoTimer = true;
    });
    
    
    playerList.RequestPlayerInfo();
}
static void InventoryBrewTimer(){
    
    static bool AutoBrewTimer = true;
    
    if(!AutoBrewTimer) return;
    AutoBrewTimer = false;
    
    timer(3){
        AutoBrewTimer = true;
    });
    
    if(!gameUtils.isInGame()) return;
    
    UObject* MyCharacter = gameUtils.GetMyShooterCharacter();
    UObject* MyInventory = utils.Read<UObject*>(MyCharacter + 0x1070);
    UObject* PrimalCharacterStatusComponent = utils.Read<UObject*>(MyCharacter + 0x1068);
    TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(MyInventory + 0x228);
    
    
    if(!utils.isValidAdress(MyCharacter) || !utils.isValidAdress(MyInventory) || !utils.isValidAdress(PrimalCharacterStatusComponent)) return;
    
    float CurrentHealth = utils.Read<float>(MyCharacter + 0xc44);
    float MaxHealth = utils.Read<float>(MyCharacter + 0xc48);
    
    float CurrentStamina = utils.Read<float>(PrimalCharacterStatusComponent + 0x960 + 4);
    float MaxStamina = utils.Read<float>(PrimalCharacterStatusComponent + 0x1e8 + 4);
    
    float CurrentFood = utils.Read<float>(PrimalCharacterStatusComponent + 0x960 + 4 * PrimalCharacterStatusValue_Food);
    float MaxFood = utils.Read<float>(PrimalCharacterStatusComponent + 0x1e8 + 4 * PrimalCharacterStatusValue_Food);
    
    float CurrentWater = utils.Read<float>(PrimalCharacterStatusComponent + 0x960 + 4 * PrimalCharacterStatusValue_Water);
    float MaxWater = utils.Read<float>(PrimalCharacterStatusComponent + 0x1e8 + 4 * PrimalCharacterStatusValue_Water);

    //bool needsToEat
    float FoodDeficit = MaxFood - CurrentFood;
    float WaterDeficit = MaxWater - CurrentWater;
    bool hasEaten = false;
    bool hasUsedMedBrew = MaxHealth - CurrentHealth > 30 ? false : true;
    bool hasUsedStamBrew = MaxStamina - CurrentStamina > 30 ? false : true;
    
    
    if(!InventoryItems.IsValidArray()) return;
    for(int i = 0; i<InventoryItems.Count; ++i){
        UObject* CurrentItem = InventoryItems.Data[i];
        EPrimalItemType ItemType = utils.Read<EPrimalItemType>(CurrentItem + 0x138);
        if(CurrentItem && ItemType == ItemType_MiscConsumable){
            string ItemName = gameUtils.SGetObjectName(CurrentItem);
            if(PVPAutoStam && !hasUsedStamBrew){
                if(ItemName == "PrimalItemConsumable_StaminaSoup_C"){
                    ServerRequestInventoryUseItem_Params params = {MyInventory, utils.Read<long>(CurrentItem + 0x1e0)};
                    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestInventoryUseItem", &params);
                    hasUsedStamBrew = true;
                }
            }
            if(PVPAutoMed && !hasUsedMedBrew){
                if(ItemName == "PrimalItemConsumable_HealSoup_C"){
                    ServerRequestInventoryUseItem_Params params = {MyInventory, utils.Read<long>(CurrentItem + 0x1e0)};
                    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestInventoryUseItem", &params);
                    hasUsedMedBrew = true;
                }
            }
            if(PVPAutoEat && !hasEaten){
                
                float FoodValue = GetUseItemAddCharacterStatusValue(CurrentItem, PrimalCharacterStatusValue_Food);
                float WaterValue = GetUseItemAddCharacterStatusValue(CurrentItem, PrimalCharacterStatusValue_Water);
                FItemNetID ItemNetID = utils.Read<FItemNetID>(CurrentItem + 0x1e0);
                
                if(FoodValue > 1 && FoodValue < FoodDeficit){
                    if(isFoodHealthy(CurrentItem)){
                        ServerRequestInventoryUseItem_Params params = {MyInventory, ItemNetID};
                        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestInventoryUseItem", &params);
                        hasEaten = true;
                    }
                }
                if(WaterValue > 1 && WaterValue < WaterDeficit){
                    if(isFoodHealthy(CurrentItem)){
                        ServerRequestInventoryUseItem_Params params = {MyInventory, ItemNetID};
                        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestInventoryUseItem", &params);
                        hasEaten = true;
                    }
                }
                //GetUseItemAddCharacterStatusValue
            }
        }
    }
}
static bool isItemBlueprint(UObject* PrimalItem){
    bool bIsBlueprint = utils.Read<uint8_t>(PrimalItem + 0x52) >> 6 & 1;
    bool bIsEngram = utils.Read<uint8_t>(PrimalItem + 0x53) & 1;
    
    return bIsBlueprint || bIsEngram;
}
static void InventoryAutoFlak(){
    static bool AutoFlakTimer = true;
    
    if(!AutoFlakTimer) return;
    AutoFlakTimer = false;
    
    timer(0.2){
        AutoFlakTimer = true;
    });
    
    if(!gameUtils.isInGame()) return;
    
    UObject* MyCharacter = gameUtils.GetMyShooterCharacter();
    UObject* MyInventory = utils.Read<UObject*>(MyCharacter + 0x1070);
    UObject* PrimalCharacterStatusComponent = utils.Read<UObject*>(MyCharacter + 0x1068);
    TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(MyInventory + 0x228);
    TArray<UObject*> EquippedItems = utils.Read<TArray<UObject*>>(MyInventory + 0x238);
    
    if(!utils.isValidAdress(MyCharacter) || !utils.isValidAdress(MyInventory) || !utils.isValidAdress(PrimalCharacterStatusComponent)) return;
    

    float CurrentOxygen = utils.Read<float>(PrimalCharacterStatusComponent + 0x960 + 4 * PrimalCharacterStatusValue_Oxygen);
    float MaxOxygen = utils.Read<float>(PrimalCharacterStatusComponent + 0x1e8 + 4 * PrimalCharacterStatusValue_Oxygen);
    
    float ItemDurabilities[EquippedType_Max] = {0};
    long EquipArmorIDs[EquippedType_Max] = {0};
    
    if(EquippedItems.IsValidArray()){
        for(int i = 0; i<EquippedItems.Count; ++i){
            UObject* EquippedArmor = EquippedItems.Data[i];
            if(utils.isValidAdress(EquippedArmor)){
                EPrimalEquipmentType ArmorType = utils.Read<EPrimalEquipmentType>(EquippedArmor + 0x13a);
                ItemDurabilities[ArmorType] = utils.Read<float>(EquippedArmor + 0x5b4);
            }
        }
    }
    
    if(!InventoryItems.IsValidArray()) return;
    for(int i = 0; i<InventoryItems.Count; ++i){
        UObject* InventoryArmor = InventoryItems.Data[i];
        if(utils.isValidAdress(InventoryArmor)){
            EPrimalEquipmentType ArmorType = utils.Read<EPrimalEquipmentType>(InventoryArmor + 0x13a);
            EPrimalItemType ItemType = utils.Read<EPrimalItemType>(InventoryArmor + 0x138);
            
            if(ItemType == ItemType_Equipment){
                
                if(isItemBlueprint(InventoryArmor)) continue;
                
                float ArmorDura = utils.Read<float>(InventoryArmor + 0x5b4);
                long ArmorNetID = utils.Read<long>(InventoryArmor + 0x1e0);
                
                if(ArmorDura > ItemDurabilities[ArmorType]){
                    ItemDurabilities[ArmorType] = ArmorDura;
                    EquipArmorIDs[ArmorType] = ArmorNetID;
                }
            }
        }
    }
    
    if(CurrentOxygen <  MaxOxygen - 10){
        
        bool HasScubaChestOn = false;
        for(int i = 0; i<EquippedItems.Count; ++i){
            UObject* EquippedArmor = EquippedItems.Data[i];
            if(utils.isValidAdress(EquippedArmor)){
                EPrimalEquipmentType ArmorType = utils.Read<EPrimalEquipmentType>(EquippedArmor + 0x13a);
                if(ArmorType == EquippedType_Chestplate){
                    if(gameUtils.SGetObjectName(EquippedArmor) == "PrimalItemArmor_ScubaShirt_SuitWithTank_C"){
                        HasScubaChestOn = true;
                    }
                }
            }
        }
        if(HasScubaChestOn){
            EquipArmorIDs[EquippedType_Chestplate] = 0;
        }
        if(!HasScubaChestOn && CurrentOxygen < 10){
            for(int i = 0; i<InventoryItems.Count; ++i){
                UObject* InventoryArmor = InventoryItems.Data[i];
                if(utils.isValidAdress(InventoryArmor)){
                    EPrimalEquipmentType ArmorType = utils.Read<EPrimalEquipmentType>(InventoryArmor + 0x13a);
                    EPrimalItemType ItemType = utils.Read<EPrimalItemType>(InventoryArmor + 0x138);
                    
                    if(ItemType == ItemType_Equipment && ArmorType == EquippedType_Chestplate){
                        
                        long ArmorNetID = utils.Read<long>(InventoryArmor + 0x1e0);
                        if(isItemBlueprint(InventoryArmor)) continue;
                        if(gameUtils.SGetObjectName(InventoryArmor) == "PrimalItemArmor_ScubaShirt_SuitWithTank_C"){
                            EquipArmorIDs[ArmorType] = ArmorNetID;
                        }
                    }
                }
            }
        }
    }
    
    for(int i = 0; i<EquippedType_Max; ++i){
        FItemNetID ItemNetID = EquipArmorIDs[i];
        if(ItemNetID != 0){
            functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerEquipPawnItem", &ItemNetID);
        }
    }
}
static void CheckRidingDinoInventory(){
    
    static bool ForceFeedTimer = true;
    
    if(!ForceFeedTimer) return;
    ForceFeedTimer = false;
    
    timer(1){
        ForceFeedTimer = true;
    });
    
    
    
    
    if(gameUtils.isRidingDino()){
        
        UObject* MountedDino = gameUtils.GetMountedDino();
        
        
        float CurrentHealth = utils.Read<float>(MountedDino + 0xc44);
        float MaxHealth = utils.Read<float>(MountedDino + 0xc48);
        if(CurrentHealth + 30 > MaxHealth) return;
        
        UObject* DinoInventory = utils.Read<UObject*>(gameUtils.GetMountedDino() + 0x1070);
        
        TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(DinoInventory + 0x228);
        if(InventoryItems.IsValidArray()){
            for(int i = 0; i<InventoryItems.Count; ++i){
                UObject* CurrentItem = InventoryItems.Data[i];
                if(utils.isValidAdress(CurrentItem)){
                    string CurrentItemString = gameUtils.SGetObjectName(CurrentItem);
                    if(CurrentItemString == "PrimalItemConsumable_RawMeat_C" || CurrentItemString == "PrimalItemConsumable_RawMeat_Fish_C" || CurrentItemString == "PrimalItemConsumable_RawPrimeMeat_C"){
                        ServerRequestInventoryUseItem_Params params = {DinoInventory, utils.Read<long>(CurrentItem + 0x1e0)};
                        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestInventoryUseItem", &params);
                    }
                }
            }
        }
    }
}
//These are for automatic crate place / drop
static Vector3 CrateLocation;
static int CrateIndex = 0;

//Main Controller Hook
static void ControllerHook(UObject* Object, UObject* FunctionAdress, void* Params){
    
    if(!userCode.isNormalCode()) return;
    
    string FunctionName = gameUtils.SGetObjectName(FunctionAdress);
    
    
    
    if(FunctionName == "ClientStartReceivingActorItems" && PVPDropNearby){
        functions.ProcessEventCall(Object, (wchar_t*)L"ServerActorCloseRemoteInventory", Params);
    }
    
    if(FunctionName == "ReceiveTick"){
        
        PVEDestruction::getInstance().Handle();
        
        if(PickupNearbyStructures){
            functions.PickupEnemyBase();
        }
        if(DestroyNearbyStructures){
            functions.DestroyEnemyBase();
        }
        
        funcqueue.ExecuteQueue();
        playerColors.ChangePlayerColors();
        
        static bool ShouldRefreshInventory = PlaceBlueprints;
        if(EnableBallistaPlace){
            if(utils.isValidAdress(gameUtils.GetStructurePlacer()))
            {
                functions.ForcePlaceStructureWithRoll(48, -180);
            }

            static bool MountTimer = true;
            if(MountTimer){
                MountTimer = false;
                timer(0.66){
                    MountTimer = true;
                    functions.MountClosestBallista();
                });
            }
        }
        if(AutoPlaceBearTraps){
            static int BearTrapIndexes[3] = {219, 220, 67};
            
            Vector3 PlayerRootLocation = gameUtils.GetRootLocation();
            FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetPlayerCameraManager() + 0xBEC);
            Vector3 AimRotNormal = RotatorToVector(AimRotation);
            
            Vector3 BearTrapLocation = {PlayerRootLocation.X + AimRotNormal.X * -100, PlayerRootLocation.Y + AimRotNormal.Y * -100, PlayerRootLocation.Z};
            
            functions.ForcePlaceStructureAtLocation(BearTrapIndexes[AutoPlaceBearTrapInt], BearTrapLocation);
        }
        if(FetchPlayerInfo){
            RequestPlayerInfoTimer();
        }
        if(PlaceBlueprints != ShouldRefreshInventory){
            ShouldRefreshInventory = PlaceBlueprints;
            functions.RequestItems();
        }
        if(PVPChatSpam){
            functions.ProcessEventCall(Object, (wchar_t*)L"ServerChatLogin", NULL);
        }
        if(PVPExplosions){
            functions.ForcePlaceStructureAtLocation(36, gameUtils.GetRootLocation());
        }
        if(PVPRocketSpam){
            UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
            if(utils.isValidAdress(ShooterCharacter) && gameUtils.isShootButtonPressed()){
                UObject* MountedStructure = GetPointer(ShooterCharacter + 0x1c2c);
                if(utils.isValidAdress(MountedStructure)){
                    FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetPlayerCameraManager() + 0xBEC);
                    Vector3 AimRotNormal = RotatorToVector(AimRotation);
                    
                    Vector3 FireLocation = {gameUtils.GetMyLocation().X + AimRotNormal.X*150, gameUtils.GetMyLocation().Y + AimRotNormal.Y*150, gameUtils.GetMyLocation().Z-30+AimRotNormal.Z*150};
                    FireBallistaProjectile_Params params = {gameUtils.GetMyLocation(), AimRotNormal};
                    functions.ProcessEventCall(ShooterCharacter, L"ServerFireBallistaProjectile", &params);
//
                    if(PVPRocketSpread){
                        float AimOffset = -30;
                        while(AimOffset <= 30){
                            FRotator SpreadRotation = {AimRotation.Pitch, AimRotation.Yaw + AimOffset, AimRotation.Roll};
                            FireBallistaProjectile_Params SpreadParams = {FireLocation, RotatorToVector(SpreadRotation)};
                            functions.ProcessEventCall(ShooterCharacter, L"ServerFireBallistaProjectile", &SpreadParams);
                            AimOffset+=6;
                        }
                    }
                }
            }
            
        }
        if(PVPProjectileSpam || PVPAutoLauncher){
            UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
            UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
            if(utils.isValidAdress(ShooterWeapon) && utils.isValidAdress(ShooterCharacter) && (gameUtils.isShootButtonPressed() || PVPAutoLauncher)){
                if(aimbot.isProjectileWeapon(ShooterWeapon)){
                    FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetPlayerCameraManager() + 0xBEC);
                    Vector3 AimRotNormal = RotatorToVector(AimRotation);
                    
                    ServerFireProjectileEx_Params ProjectileFireParams;
                    ProjectileFireParams.Origin = gameUtils.GetMyLocation();
                    ProjectileFireParams.Rotation = AimRotNormal;
                    ProjectileFireParams.Speed = 10000;
                    ProjectileFireParams.RandomSeed = 0;
                    
                    functions.ProcessEventCall(ShooterWeapon, L"ServerFireProjectileEx", &ProjectileFireParams);
                }
                
                
              //  FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetPlayerCameraManager() + 0xBEC);
              //  Vector3 AimRotNormal = RotatorToVector(AimRotation);
                
                
            }
        }
        if(PVPAutoMed || PVPAutoStam){
            InventoryBrewTimer();
        }
        if(PVPAutoArmor){
            InventoryAutoFlak();
        }
        if(PVPForceFeed){
            CheckRidingDinoInventory();
        }
        if(PVPAutoFire && AutoShootSwitch.isOn){
            aimbot.HandleAutoFiring();
        }
        if(gameUtils.isRidingDino() && gameUtils.isShootButtonPressed() && PVPMagicBullet){
            aimbot.HandleAutoFiring();
        }
        if(PVPAutoDrop){
            functions.DropItems();
            
        }
        if(PVPDropNearby) {
            if(CrateIndex != 0)
                functions.ForcePlaceStructureAtLocation(CrateIndex, CrateLocation);
        }
        else {
            CrateIndex = 0;
            CrateLocation = {0,0,0};
        }
        if(EnableDupe && gameUtils.isShootButtonPressed()){
            functions.ForcePlaceCurrentStructure();
        }
        //Need a loop for Request Dino, Request Implant, Auto Steal, Auto Drop, Auto Fire Targetting
        
        
        UObject* CurrentOpenedAdminManager = utils.Read<UObject*>(gameUtils.GetShooterHUD() + 0xf58);
        if(utils.isValidAdress(CurrentOpenedAdminManager)){
            UObject* MultiCommand = utils.Read<UObject*>(CurrentOpenedAdminManager + 0xbe0);
            UObject* BanTribeButton = utils.Read<UObject*>(CurrentOpenedAdminManager + 0xa88);
            UObject* CommandLine = utils.Read<UObject*>(CurrentOpenedAdminManager + 0xae0);
            EnableButton(MultiCommand);
            EnableButton(BanTribeButton);
            EnableButton(CommandLine);
        }
    }
    else if(FunctionName == "ServerRequestPlaceStructure"){
        
        if(PVPDropNearby){
            if(*(int*)(Params) > 330 && *(int*)(Params) < 350){
                CrateLocation = *(Vector3*)((long)Params + 0x4);
                CrateIndex = *(int*)(Params);
            }
        }
        
        long ServerRequestPlaceStructureParams = (long)Params;
        
        if(Floaters && !*(bool*)(ServerRequestPlaceStructureParams + 0x68)){
            functions.ForcePlaceStructure(*(int*)(ServerRequestPlaceStructureParams));
            return;
        }
        *(bool*)(ServerRequestPlaceStructureParams + 0x68) = EnableDupe;
        
        if(EnablePitch) *(float*)(ServerRequestPlaceStructureParams + 0x10) = StructurePitch;
        if(EnableYaw) *(float*)(ServerRequestPlaceStructureParams + 0x14) = StructureYaw;
        if(EnableRoll) *(float*)(ServerRequestPlaceStructureParams + 0x18) = StructureRoll;
        
        //Auto Mount Ballista
    }
    else if(FunctionName == "ServerSendBadPlayer"){
        return;
    }
    else if(FunctionName == "ClientAddActorItem"){
        
        ClientAddActorItemParams* NewItemParams = (ClientAddActorItemParams*)Params;
        
        if((UObject*)NewItemParams->PrimalInventoryComponentForInventory == gameUtils.GetMyInventory()){
            if(EnableWeaponColorChange){
                NewItemParams->ItemInfo.ItemColorID = weaponColor.GetColorIndex(SelectedDye);
            }
            if(PlaceBlueprints){
                ClientAddActorItemParams* AddItemParams = (ClientAddActorItemParams*)Params;
                if(AddItemParams->ItemInfo.bIsEngram || AddItemParams->ItemInfo.bIsBlueprint){
                    AddItemParams->ItemInfo.bIsEngram = false;
                    AddItemParams->ItemInfo.bIsBlueprint = false;
                    AddItemParams->ItemInfo.Ammount = 999;
                } 
            }
        }
        else {
            if(UnlockEngrams){
                if(NewItemParams->ItemInfo.bIsEngram){
                //if(NewItemParams->ItemInfo.Ammount < 10){
                //    NewItemParams->ItemInfo.bIsCustomRecipe = true;
                    NewItemParams->ItemInfo.bIsEngram = false;
                    NewItemParams->ItemInfo.bHideFromInventoryDisplay = false;
                    NewItemParams->ItemInfo.bIsBlueprint = true;
                //}
                }
            }
            if(PVPDropNearby){
                if(!NewItemParams->ItemInfo.bIsEngram && !NewItemParams->ItemInfo.bIsBlueprint){
                    struct ServerDropFromRemoteInventory_Params {
                        UObject* inventoryComp;
                        FItemNetID itemID;
                    };
                    ServerDropFromRemoteInventory_Params params = {
                        (UObject*)NewItemParams->PrimalInventoryComponentForInventory,
                        NewItemParams->ItemInfo.ItemID
                    };
                    //ServerDropFromRemoteInventory
                    functions.ProcessEventCall(Object, (wchar_t*)L"ServerDropFromRemoteInventory", &params);
                }
            }
        }
    }
    else if(FunctionName == "PerformAmberPurchase"){
        if(AmberPurhcase){
            for(int i = 0; i < AmberPurchaseAmmount; ++i) origProcessEvent(Object, FunctionAdress, Params);
        }
    }
    else if(FunctionName == "ServerCreatePremiumItem"){
        if(StationPurchase){
            for(int i = 0; i < StationPurchaseAmmount; ++i) origProcessEvent(Object, FunctionAdress, Params);
        }
    }
    else if(FunctionName == "NotifyClientPurchaseSuccess"){
        if(AmberPurhcase && AmberPurchaseAmmount > 2) return;
    }
    else if(FunctionName == "ServerChatLogin"){
        if(PVPHideLogin && !PVPChatSpam) return;
    }
    else if(FunctionName == "ServerDownloadDungeon"){
        if(StayOnWhitePlatform){
            return;
        }
    }
            
    else if(FunctionName == "ServerStartDungeonTeleport"){
        FString* FDungeonName = (FString*)Params;
        DungeonName = FDungeonName->ToString();
        if(!StayOnWhitePlatform){
            functions.ProcessEventCall(Object, L"ServerDownloadDungeon", Params);
            return;
        }
    }
    else if(FunctionName == "ServerAdminManConsoleCommand"){
        functions.ProcessEventCall(Object, L"ServerCheat", Params);
        return;
    }
    else if(FunctionName == "ClientDoTeleportFadeEffect"){
        return;
    }
    else if(FunctionName == "ServerMultiUse"){
        
        ServerMultiUse_Params* MultiUseParams = (ServerMultiUse_Params*)Params;
        if(MultiUseParams->UseIndex == 100 && MultiUseParams->bAllowSpam == 0 && PVPTameShooting){
            UObject* MyShooterWeapon = gameUtils.GetShooterWeapon();
            if(!(gameUtils.SGetObjectName(MyShooterWeapon) == "WeapFists_C" || gameUtils.SGetObjectName(MyShooterWeapon) == "WeapFists_Female_C")){
                functions.ProcessEventCall(gameUtils.GetMyShooterCharacter(), L"ServerGiveFists", nullptr);
                UObject* PrimalItem = utils.Read<UObject*>(gameUtils.GetShooterWeapon() + 0x7f8);
                functions.EquipWeapon(PrimalItem, *MultiUseParams);
                return;
            }
        }
        menu.ConsoleLog(utils.string_format("Use Index %d \n Component Index %d \n bAllowSpam %d", MultiUseParams->UseIndex, MultiUseParams->ComponentIndex, MultiUseParams->bAllowSpam), "hi", Blue);
    }
    /*else if(FunctionName == "ServerEnterPromoCode"){
        FString* PromoCode = (FString*)Params;
        std::string promostring = gameUtils.FStringToString(*PromoCode);
        menu.ConsoleLog(promostring, promostring, Red);
        //void ServerEnterPromoCode(struct FString promoCode, bool forSinglePlayer, uint32_t deviceToken);
    } */

    
    
    //ClientSetCinematicMode - Didn't do anything
    //ClientRestart - This is Necessary (to get inventory and shit) - White appeared anyways
    //SetBeaconState
    //BroadcastBeaconSpawn
    //K2_OnBecomeViewTarget - Didn't do anything
    //ClientNotifyPlayerDeath
    //ClientPlayCameraShake - Didn't do anything
    
    //ClientNotifyTorpidityIncrease
    
    origProcessEvent(Object, FunctionAdress, Params);
}


static void CharacterHook(UObject* Object, UObject* FunctionAdress, void* Params){
    if(IgnoreShots){
        string FunctionName = gameUtils.SGetObjectName(FunctionAdress);
            
        if(FunctionName == "PlayHitEffectPoint"){
            return;
        }
    }
    origProcessEvent(Object, FunctionAdress, Params);
}
//menu.ConsoleLog(FunctionName, "Controller", Blue);

/*
 When u get shot ->
 ClientPlayCameraShake
 ClientPlayForceFeedback
 ClientUpdateItemDurability
 
 Characger->
 PlayHitEffectPoint
 
 */

static void (*ReplicateMoveToServer)(UObject* ShooterMovementComponent, float DeltaTime, Vector3& NewAcceleration) = (void(*)(UObject*, float, Vector3&))utils.getOffset(0x264a048);
static void Hook_ReplicateMoveToServer(UObject* ShooterMovementComponent, float DeltaTime, Vector3& NewAcceleration){
    DeltaTime *= (PVPSpeedZero && SpeedZeroSwitch.isOn) ? 0 : LocalSpeed;
    return ReplicateMoveToServer(ShooterMovementComponent, DeltaTime, NewAcceleration);
}


static void (*PlaySpawnIntro)(UObject* Character) = (void(*)(UObject*))utils.getOffset(0xa37558); //0xea8
static void (*FinishSpawnIntro)(UObject* Character) = (void(*)(UObject*))utils.getOffset(0xa37938);

static void Hook_PlaySpawnIntro(UObject* Character){
    float InitialSpeed = Speed;
    
    //Speed up the White Screen
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    if(utils.isValidAdress(WorldSettings)){
        utils.Write<float>(WorldSettings + 0x934, 30);
    }
    Speed = 1;

    timer(0.5){
        Speed = InitialSpeed;
    });

    return PlaySpawnIntro(Character);
}


void Hooks::StartHooks(){
    
    if(gameUtils.GetMyShooterCharacter() != nullptr){
        UObject* VTable = utils.Read<UObject*>(gameUtils.GetMyShooterCharacter());
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0x230, (long)CharacterHook);
        }
    }
    
    
    
    
    
    
    UObject* Character = gameUtils.GetMyCharacter();
    if(utils.isValidAdress(Character)){
        UObject* VTable = utils.Read<UObject*>(Character);
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0xea8, (long)Hook_PlaySpawnIntro);
        }
    }
    
    UObject* Movement = utils.Read<UObject*>(gameUtils.GetMyCharacter() + 0x640);
    if(utils.isValidAdress(Movement)){
        UObject* VTable = utils.Read<UObject*>(Movement);
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0xa90, (long)Hook_ReplicateMoveToServer);
        }
    }
    
    if(gameUtils.GetMyShooterCharacter() != nullptr){
        UObject* VTable = utils.Read<UObject*>(gameUtils.GetMyController());
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0x230, (long)ControllerHook);
        }
    }
    
    if(gameUtils.GetShooterWeapon() != nullptr){
        UObject* VTable = utils.Read<UObject*>(gameUtils.GetShooterWeapon());
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0x230, (long)WeaponHook);
        }
    }
    
    if(gameUtils.GetPlayerState() != nullptr){
        UObject* VTable = utils.Read<UObject*>(gameUtils.GetPlayerState());
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0x230, (long)ShooterPlayerStateHook);
        }
    }
    
    if(utils.isValidAdress(gameUtils.GetMountedDino())){
        UObject* VTable = utils.Read<UObject*>(gameUtils.GetMountedDino());
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0xe08, (long)MoveForwardHook);
            utils.Write<long>(VTable + 0xe10, (long)MoveRightHook);
        }
    }
}
