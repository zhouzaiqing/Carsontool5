//
//  Aimbot.mm
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/20/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"
 //0118f768 projectile
namespace AimbotStaticClassFunctions{
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
namespace AimbotUtilityFunctions{
    static bool (*AreTribesAllied)(long tribedata, int tribeid) = (bool (*) (long, int))utils.getOffset(0x0085d728);
    static void (*MakeWeakObjectPtrTest)(long* Target, UObject* Object) = (void(*)(long*,UObject*))utils.getOffset(0x157d474);
    static bool (*getLineOfSight)(UObject* t1, UObject* t2, Vector3, bool) = (bool(*)(UObject*, UObject*, Vector3, bool))utils.getOffset(0x026e3638);
    static UObject* (*GetMountedDino)(UObject* ShooterCharacter) = (UObject*(*)(UObject*))utils.getOffset(0x00a2b148);
};

static int getRandomIntInRange(int min, int max) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(min, max);

    return dis(gen);
}
static bool getRandomBoolWithProbability(double probability) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0.0, 1.0);

    return dis(gen) < probability;
}

bool Aimbot::isInstantWeapon(UObject* Weapon){
    if(utils.isObject((long)Weapon)){
        if(gameUtils.isA_Fast(Weapon, AimbotStaticClassFunctions::AShooterWeapon_Instant())){
            return true;
        }
    }
    return false;
}
bool Aimbot::isProjectileWeapon(UObject* Weapon){
    if(utils.isObject((long)Weapon)){
        if(gameUtils.isA_Fast(Weapon, AimbotStaticClassFunctions::AShooterWeapon_Projectile())){
            return true;
        }
    }
    return false;
}
bool Aimbot::isRidingDino(UObject* Player){
    if(utils.isValidAdress(Player)){
        return (uint8_t)(utils.Read<uint8_t>(Player + 0x1584)) >> 2 & 1;
    }
    return false;
}
bool Aimbot::ShouldSlowDino(UObject* Dino){
    if(utils.isValidAdress(Dino)){
        bool isFlying = utils.Read<uint8_t>(Dino + 0x16d0) >> 7 & 1;
        if(isFlying){
            TArray<UObject*> EnemyDinoBuffs = utils.Read<TArray<UObject*>>(Dino + 0xac0);
            if(EnemyDinoBuffs.IsValidArray()){
                for(int i = 0; i<EnemyDinoBuffs.Count; ++i){
                    UObject* CurrentBuff = EnemyDinoBuffs.Data[i];
                    if(utils.isValidAdress(CurrentBuff)){
                        if(gameUtils.SGetObjectName(CurrentBuff) == "Buff_FlyerSlowdown_C") return false;
                    }
                }
            }
            return true;
        }
    }
    return false;
}
UObject* Aimbot::GetRidingDino(UObject* Player){
    if(isRidingDino(Player)){
        return AimbotUtilityFunctions::GetMountedDino(Player);
    }
    return nullptr;
}
UObject* Aimbot::FindBestAimbotTarget(){
    if(!gameUtils.isInGame()) return nullptr;
    
    int MyTeamID = gameUtils.GetMyTeam();
    float* ViewMatrix = gameUtils.GetViewMatrix();
    long MyTribeData = gameUtils.GetMyTribeData();
    
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    UObject* MyCharacter = gameUtils.GetMyShooterCharacter();
    UObject* MyController = gameUtils.GetMyController();
    
    float ScreenDistance = MAXFLOAT;
    
    UObject* CurrentTarget = nullptr;
    
    if(!utils.isValidAdress(WorldSettings) || !utils.isValidAdress(MyCharacter) || !utils.isValidAdress(MyController) || !utils.isValidAdress(MyTribeData))
        return nullptr;
    
    if(!TActorsArray.IsValidArray()) return nullptr;
    for(int i = 0; i<TActorsArray.Count; ++i){
        UObject* CurrentActor = TActorsArray.Data[i];
        if(utils.isValidAdress(CurrentActor)){
            if(gameUtils.isA_Fast(CurrentActor, AimbotStaticClassFunctions::ShooterCharacter())){
                
                int TeamID = utils.Read<int>(CurrentActor + 0x29c);
                
                //ignore teamates
                if(gameUtils.IsTribeAlliedWith((FTribeData*)MyTribeData, TeamID)) continue;
                if(TeamID == MyTeamID) continue;
                
                //ignore "wild" players
                if(TeamID < 1000) continue;
                
                bool isDead = utils.Read<uint8_t>(CurrentActor + 0xba0) >> 5 & 1;
                bool isSleeping = utils.Read<uint8_t>(CurrentActor + 0xb90) & 1;
                
                //Ignore Dead and Sleeping Players
                if(isDead || isSleeping) continue;
                
                //ignore Dungeon/PVE Players
                TArray<UObject*> BuffsArray = utils.Read<TArray<UObject*>>(CurrentActor + 0xac0);
                if(BuffsArray.IsValidArray()){
                    for(int j = 0; j<BuffsArray.Count; ++j){
                        UObject* CurrentBuff = BuffsArray.Data[j];
                        if(gameUtils.SGetObjectName(CurrentBuff) == "Buff_DungeonExplore_C")
                            continue;
                    }
                }
                
                UObject* EnemyPlayerSceneComponent = utils.Read<UObject*>(CurrentActor + 0x2c8);
                Vector3 EnemyPlayerWorldRootLocation = utils.Read<Vector3>(EnemyPlayerSceneComponent + 0x290);
                Vector3 EnemyHeadBoneLocation = gameUtils.GetBoneLocation(CurrentActor, 21);
                Vector2 EnemyPlayerScreenLocation = gameUtils.World2Screen(EnemyPlayerWorldRootLocation, ViewMatrix);
                
                float XDistance = abs(EnemyPlayerScreenLocation.X - SCREEN_WIDTH/2);
                float YDistance = abs(EnemyPlayerScreenLocation.Y - SCREEN_HEIGHT/2);
                float DistanceFromCrossheir = sqrt(XDistance*XDistance + YDistance*YDistance);
                
                bool isVisible = AimbotUtilityFunctions::getLineOfSight(MyController, MyCharacter, EnemyPlayerWorldRootLocation, false) || AimbotUtilityFunctions::getLineOfSight(MyController, MyCharacter, EnemyHeadBoneLocation, false);
                
                if(isVisible && DistanceFromCrossheir < ScreenDistance){
                    ScreenDistance = DistanceFromCrossheir;
                    CurrentTarget = CurrentActor;
                }
            }
        }
    }
    
    return  CurrentTarget;
}


void Aimbot::HandleAutoFiring(){
    if(isInstantWeapon(gameUtils.GetShooterWeapon())){
        static bool Timer = true;
        if(Timer){
            Timer = false;
            timer(0.4){
                Timer=true;
            });
            
            
            FireWeapon();
            HandleReloading();
        }
    }
}


static long GetFNameForSocket(UObject* Player, int Socket){
    UObject* SkeletalMesh = utils.Read<UObject*>(Player + 0x638); //struct USkeletalMeshComponent* Mesh; // Offset: 0x638 // Size: 0x08
    UObject* SkeletalMeshOffset = utils.Read<UObject*>(SkeletalMesh + 0x970); //struct USkeletalMesh* SkeletalMesh; // Offset: 0x970 // Size: 0x08
    UObject* Skeleton = utils.Read<UObject*>(SkeletalMeshOffset + 0x48); //struct USkeleton* Skeleton; // Offset: 0x48 // Size: 0x08
    UObject* SocketPointer = utils.Read<UObject*>(Skeleton + 0x180); //struct TArray<struct USkeletalMeshSocket*> Sockets; // Offset: 0x180 // Size: 0x10
    UObject* DesiredSocket = utils.Read<UObject*>(SocketPointer + 0x8 * Socket); //USkeletalMeshSocket
    return utils.Read<long>(DesiredSocket + 0x30); //struct FName BoneName; // Offset: 0x30 // Size: 0x08
}
bool Aimbot::HandleSimulateShot(int BoneIndex, UObject* Target){
    
    UObject* MyController = gameUtils.GetMyController();
    UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
    
    if(!utils.isValidAdress(MyController)) return false;
    if(!utils.isValidAdress(ShooterWeapon)) return false;
    if(!utils.isValidAdress(Target)) return false;
    
    float HeightCheck = 0;
    Vector3 ShootDir = {0,0,0};
    
    FHitResult ShotHitResult = {0};
    UObject* HitResultPointer = (UObject*)&ShotHitResult;
    
    
    //Begin Calculations
    UObject* EnemySceneComponent = utils.Read<UObject*>(Target + 0x2c8);
    Vector3 EnemyLocation = utils.Read<Vector3>(EnemySceneComponent + 0x290);
    
    Vector3 MyLocation = gameUtils.GetRootLocation();
    Vector3 DeltaDistance = EnemyLocation - MyLocation;
    Vector3 NormalizedDistance = DeltaDistance.ToNormal();
    Vector3 EndLocation = NormalizedDistance * 12609.566 + MyLocation;
    
    long TWeakObjectPointer = 0;
    AimbotUtilityFunctions::MakeWeakObjectPtrTest(&TWeakObjectPointer, Target);
    
    long BoneFName = 0;
    if(BoneIndex != 0) BoneFName = GetFNameForSocket(Target, BoneIndex);
    
    *(Vector3*)(HitResultPointer + 0xc) = EnemyLocation;
    *(Vector3*)(HitResultPointer + 0x18) = EnemyLocation;
    *(Vector3*)(HitResultPointer + 0x48) = EndLocation;
    *(Vector3*)(HitResultPointer + 0x3c) = MyLocation;
    *(long*)(HitResultPointer + 0x64) = TWeakObjectPointer;
    *(long*)(HitResultPointer + 0x80) = BoneFName;
    

    ServerNotifyShot_Params ShotParameters;
    

    ShotParameters.ShootDirs.Data = &ShootDir;
    ShotParameters.ShootDirs.Count = 1;
    ShotParameters.ShootDirs.Max = 1;
    
    ShotParameters.ModelHeightChecks.Data = &HeightCheck;
    ShotParameters.ModelHeightChecks.Count = 1;
    ShotParameters.ModelHeightChecks.Max = 1;
    
    ShotParameters.Impacts.Data = &ShotHitResult;
    ShotParameters.Impacts.Count = 1;
    ShotParameters.Impacts.Max = 1; 
    
    functions.ProcessEventCall(ShooterWeapon, (wchar_t*)L"ServerNotifyShot", &ShotParameters);
    
    return true;
}

static int MaleBones[] = {49, 95, 29, 87, 62};
static int FemaleBones[] = {49, 97, 30, 89, 63};
bool Aimbot::FireWeapon(){
    if(isInstantWeapon(gameUtils.GetShooterWeapon())){
        UObject* Target = FindBestAimbotTarget();
        if(Target == nullptr) return false;
        
        if(CustomMagicBulletSettings)
        {
            Vector3 EnemyLocation = gameUtils.GetBoneLocation(Target, 21);
            Vector2 EnemyScreenLocation = gameUtils.World2Screen(EnemyLocation, gameUtils.GetViewMatrix());
            Vector2 ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            Vector2 DeltaScreenDistance = ScreenCenter-EnemyScreenLocation;
            if(DeltaScreenDistance.GetMagnitude() > MagicCircleSize) return false;
        }
        
        /*
         CustomMagicBulletSettings ? MagicCircleSize : 
         */
        
        //Checks if the enemy is riding a Dino, and if it should be slowed.
        if(isRidingDino(Target) && SlowDinos){
            UObject* Dino = GetRidingDino(Target);
            if(ShouldSlowDino(Dino)){
                return HandleSimulateShot(0, Dino);
            }
        }
        
        //"All" Targetting Option - Hits every armor piece
        if(TargettingIndex == 6){
            return HandleSimulateShot(0, Target);
        }
        
        int EnemyShootBone = 0;
        bool isFemale = gameUtils.SGetObjectName(Target) == "PlayerPawnTest_Female_C";
        float EnemyArmorDurabilities[EquippedType_Max] = {0};
        UObject* EnemyInventory = utils.Read<UObject*>(Target + 0x1de8);
        TArray<UObject*> EnemyArmorArray =  utils.Read<TArray<UObject*>>(EnemyInventory + 0x238);
        
        //get the enemy armor dura
        if(EnemyArmorArray.IsValidArray()){
            for(int i = 0; i<EnemyArmorArray.Count; ++i){
                UObject* CurrentArmorPiece = EnemyArmorArray[i];
                if(utils.isValidAdress(CurrentArmorPiece)){
                    EPrimalEquipmentType ArmorType = utils.Read<EPrimalEquipmentType>(CurrentArmorPiece + 0x13a);
                    
                    //Rearrange the Order of gloves and boots
                    if(ArmorType == EquippedType_Gloves) ArmorType = EquippedType_Boots;
                    else if(ArmorType == EquippedType_Boots) ArmorType = EquippedType_Gloves;
                    
                    EnemyArmorDurabilities[ArmorType] = utils.Read<float>(CurrentArmorPiece + 0x5b4);
                }
            }
        }
        
        //auto target any missing armor piece
        for(int i = 0; i<5; ++i){
            if(EnemyArmorDurabilities[i] == 0){
                EnemyShootBone = isFemale ? FemaleBones[i] : MaleBones[i];
                return HandleSimulateShot(EnemyShootBone, Target);
            }
        }
        
        //"Weakest" Targetting Option - Find and shoot the lowest dura armor piece
        if(TargettingIndex == 0){
            float SavedDura = 9999;
            
            for(int i = 0; i<5; ++i){
                if(EnemyArmorDurabilities[i] < SavedDura){
                    EnemyShootBone = isFemale ? FemaleBones[i] : MaleBones[i];
                    SavedDura = EnemyArmorDurabilities[i];
                }
            }
            
            
            return HandleSimulateShot(EnemyShootBone, Target);
        }
        
        //Handles specific armor targetting
        EnemyShootBone = isFemale ? FemaleBones[TargettingIndex - 1] : MaleBones[TargettingIndex - 1];
        
        //To Appear More Legit
        if(CustomMagicBulletSettings){
            if(!getRandomBoolWithProbability((double)TargetBoneHitChance / 100)){
                int RandomNumber = getRandomIntInRange(0,7);
                if(RandomNumber == TargettingIndex -1 || RandomNumber > 5) return false;
                EnemyShootBone = isFemale ? FemaleBones[RandomNumber] : MaleBones[RandomNumber];
            }
        }
        
        return HandleSimulateShot(EnemyShootBone, Target);
        
    }
    return false;
}

void Aimbot::HandleReloading(){
    if(isInstantWeapon(gameUtils.GetShooterWeapon())){
        UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
        UObject* AssociatedPrimalItem = utils.Read<UObject*>(ShooterWeapon + 0x7f8);
        
        int CurrentAmmoInClip = utils.Read<int>(AssociatedPrimalItem + 0x59c);
        int TotalAmmo = utils.Read<int>(ShooterWeapon + 0xfb4);
        int ExtraAmmo = TotalAmmo - CurrentAmmoInClip;
        
        int AmmoPerClip = utils.Read<int>(ShooterWeapon + 0x9a8); // Offset: 0x08 // Size: 0x04
        
        
        if(ExtraAmmo > 0 && CurrentAmmoInClip != AmmoPerClip){
            functions.ProcessEventCall(ShooterWeapon, L"ServerStartReload", nullptr);
        }
    }
}
