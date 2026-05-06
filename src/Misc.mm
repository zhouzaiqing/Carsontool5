//
//  Misc.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/12/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"


static FQuat UE4EulerToQuaternion(FRotator View){
    float Pitch = View.Pitch;
    float Yaw = View.Yaw;
    float Roll = View.Roll;
    static float DEG_TO_RAD = PI/(180.f);
    static float DIVIDE_BY_2 = DEG_TO_RAD/2.f;

    float CR = cos(Roll*DIVIDE_BY_2);
    float CP = cos(Pitch*DIVIDE_BY_2);
    float CY = cos(Yaw*DIVIDE_BY_2);
    float SR = sin(Roll*DIVIDE_BY_2);
    float SP = sin(Pitch*DIVIDE_BY_2);
    float SY = sin(Yaw*DIVIDE_BY_2);

    FQuat RotationQuat;
    RotationQuat.w = CR*CP*CY + SR*SP*SY;
    RotationQuat.x = CR*SP*SY - SR*CP*CY;
    RotationQuat.y = -CR*SP*CY - SR*CP*SY;
    RotationQuat.z = CR*CP*SY - SR*SP*CY;
    return RotationQuat;
}

static UObject* (*GetPointer)(UObject* WeakPtr) = (UObject*(*)(UObject*))utils.getOffset(0x157d62c);
static void (*Ghost)(UObject* pointer) = (void(*)(UObject* ))utils.getOffset(0x026057b0);
static void (*Walk)(UObject* pointer) = (void(*)(UObject* ))utils.getOffset(0x026056f8);


void Miscellaneous::SlidersMain(){
    if(!gameUtils.isInGame()) return;
    
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    UObject* Character = gameUtils.GetMyCharacter();
    UObject* MatineeActor = gameUtils.GetMatineeActor();
    UObject* ShooterGameUserSettings = gameUtils.GetShooterGameUserSettings();
    UObject* PlayerCameraManager = gameUtils.GetPlayerCameraManager();
    UObject* MountedDino = gameUtils.GetMountedDino();
    UObject* FPSBase = utils.Read<UObject*>(gameUtils.GetBaseAdress() + 0x44e7ab8);
    UObject* StructurePlacer = gameUtils.GetStructurePlacer();
    

    
    
    if(!(utils.isValidAdress(WorldSettings) && utils.isValidAdress(Character) && utils.isValidAdress(MatineeActor) && utils.isValidAdress(ShooterGameUserSettings) && utils.isValidAdress(PlayerCameraManager) && utils.isValidAdress(FPSBase)))
        return;
    
    
    static bool once = false;
    if(!once){ once = true; Speed = Speed > 50 ? 50 : Speed;}
    
    /* Testing
     AShooterGameMode
     */
    //UObject* baseAddr = (UObject*)gameUtils.GetBaseAdress();
    //*(float*)(baseAddr + 0x042A9604) = .24;
    
    /* Testing */
    utils.Write<float>(WorldSettings + 0x934, Speed);
    utils.Write<float>(ShooterGameUserSettings + 0x1e0, FOV);
    utils.Write<float>(PlayerCameraManager + 0x2268, FarView);
    utils.Write<float>(FPSBase + 0x65c, GameFPS);
    
    if(TimeOfDay != 0)
        utils.Write<float>(MatineeActor + 0x644, TimeOfDay);
    
    UObject* GameStateBase = gameUtils.GetGameStateBase();
    if(utils.isValidAdress(GameStateBase)){
        utils.Write<bool>(GameStateBase + 0x6e2, !EnableCustomCrosshair);
    }
    
    static bool GhostSwitch = true;
    if(PVPGhost) {
        GhostSwitch = false;
        Ghost(Character);
    }
    else {
        if(!GhostSwitch) {
            Walk(Character);
            GhostSwitch = true;
        }
    }
    
    if(gameUtils.isRidingDino()){
        
        if(PVPStrafing && utils.isValidAdress(gameUtils.GetMountedDino()))
            utils.Write<uint8_t>(MountedDino + 0x20d9, 0xd);
            //*(uint8_t*)(gameUtils.GetMountedDino() + 0x20d9) = 0xd;
        
        if(PVPInstantTurn || PVPDinoSpin){
            UObject* DinoSceneComponent = utils.Read<UObject*>(MountedDino + 0x2c8);
            FRotator MyAim = utils.Read<FRotator>(PlayerCameraManager + 0xBEC);
            if(!gameUtils.isDinoFlying(MountedDino)){
                MyAim.Pitch = 0; MyAim.Roll = 0;
            }
            
            static float SavedYaw = 0;
            if(PVPDinoSpin){
                SavedYaw += 5;
                if(SavedYaw >= 180) SavedYaw = -180;
                MyAim.Yaw = SavedYaw;
            }
            
            utils.Write<FQuat>(DinoSceneComponent + 0x280, UE4EulerToQuaternion(MyAim));
        }
    }
    
    if(utils.isValidAdress(gameUtils.GetShooterWeapon())){
        UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
        NSString* WeaponName = gameUtils.GetObjectName(ShooterWeapon);
        if(PVPInfiniteC4){
            if([WeaponName isEqualToString:@"WeapC4_C"]){
                utils.Write<int>(ShooterWeapon + 0xfb8, 30);
                utils.Write<int>(ShooterWeapon + 0xfb4, 10);
                UObject* AssociatedPrimalItem = utils.Read<UObject*>(ShooterWeapon + 0x7f8);
                if(utils.isValidAdress(AssociatedPrimalItem)) {
                    utils.Write<int>(AssociatedPrimalItem + 0x628, 10);
                }
                utils.Write<long>(ShooterWeapon + 0xa10, (long)AssociatedPrimalItem);
                UObject* AmmoTemplatePrimalItem = utils.Read<UObject*>(ShooterWeapon + 0xa10);
                if(utils.isValidAdress(AmmoTemplatePrimalItem)) {
                    utils.Write<int>(AmmoTemplatePrimalItem + 0x628, 10);
                }
            }
        }
        if(![WeaponName containsString:@"WeapFists"] && PVPUWShoot)
            utils.Write<uint8_t>(ShooterWeapon + 0xf50, 129);
        
        if(PVPInfinitePistol && [WeaponName containsString:@"WeapMachinedPistol"]){
            utils.Write<uint8_t>(ShooterWeapon + 0x140, 0x3);
            utils.Write<int>(ShooterWeapon + 0xfb8, 9999);
            utils.Write<int>(ShooterWeapon + 0xfb4, 9999);
        }
        if(PVPProjectileSpam && aimbot.isProjectileWeapon(ShooterWeapon)){
            if([WeaponName containsString:@"Rocket"]){
                utils.Write<int>(ShooterWeapon + 0xfb4, 10);
                utils.Write<int>(ShooterWeapon + 0xfb8, 10);
                
                UObject* AssociatedPrimalItem = utils.Read<UObject*>(ShooterWeapon + 0X7f8);
                if(utils.isValidAdress(AssociatedPrimalItem))
                    utils.Write<int>(AssociatedPrimalItem + 0x59c, 10);
            }
            
            //Infinite Ammo + No Overheat Tek Rifle
            if([WeaponName isEqualToString:@"WeapTekRifle_C"]){
                utils.Write<int>(ShooterWeapon + 0xfb4, 1000);
                utils.Write<int>(ShooterWeapon + 0xfb8, 1000);
                
                
                utils.Write<float>(ShooterWeapon + 0x12d8, 0);
                utils.Write<float>(ShooterWeapon + 0x12dc, 0);

                UObject* AssociatedPrimalItem = utils.Read<UObject*>(ShooterWeapon + 0X7f8);
                if(utils.isValidAdress(AssociatedPrimalItem))
                    utils.Write<int>(AssociatedPrimalItem + 0x59c, 1000);
            }
        }
    }
    
    if(utils.isValidAdress(StructurePlacer))
    {
        UObject* CurrentPlacingStructure = utils.Read<UObject*>(StructurePlacer + 0x658);
        UObject* StructureSceneComponent = utils.Read<UObject*>(CurrentPlacingStructure + 0x2c8);
        if(utils.isValidAdress(StructureSceneComponent))
        {
            if(EnablePitch)
                utils.Write<float>(StructureSceneComponent + 0x2C0, StructurePitch);
            if(EnableYaw)
                utils.Write<float>(StructureSceneComponent + 0x2C4, StructureYaw);
            if(EnableRoll)
                utils.Write<float>(StructureSceneComponent + 0x2C8, StructureRoll);
        }
        if(PVPBoomBoom){
            utils.Write<int>(StructurePlacer + 0x654, 36);
        }
    }
    
    
    //Remove store primal pass timer
    UObject* CurrentOpenedInventory = utils.Read<UObject*>(gameUtils.GetShooterHUD() + 0xf38);
    if(utils.isValidAdress(CurrentOpenedInventory))
    {
        UObject* inGameStore = utils.Read<UObject*>(CurrentOpenedInventory + 0x19c8);
        TArray<UObject*> StoreEntries = utils.Read<TArray<UObject*>>(inGameStore + 0x5e0);
        if(StoreEntries.IsValidArray())
        {
            for(int i = 0; i<StoreEntries.Count; ++i)
            {
                UObject* CurrentStoreEntry = StoreEntries[i];
                if(utils.isValidAdress(CurrentStoreEntry))
                {
                    string CurrentEntryName = gameUtils.SGetObjectName(CurrentStoreEntry);
                    if(CurrentEntryName == "StoreEntry_PromoCode")
                    {
                        utils.Write<uint8_t>(CurrentStoreEntry + 0x140, 0x0);
                        utils.Write<int>(CurrentStoreEntry + 0x160, 0x0);
                        utils.Write<bool>(CurrentStoreEntry + 0x11d, false);
                    }
                }
            }
        }
    }
}
void Miscellaneous::CheckboxesMain(){
    
}
void Miscellaneous::OtherMain(){
    
}
void Miscellaneous::WorldLoop(){
    
}
void Miscellaneous::InventoryLoop(){
    
}
