//
//  GameUtils.h
//  BaseMenu
//
//  Created by Carson Mobile on 4/10/23.
//
//Finish all the Utils / Start aimbot functions
#include "BaseUtils.h"
class GameUtils : BaseUtils {
public:
    
    static GameUtils& getInstance() {
        static GameUtils instance; // The single instance
        return instance;
    }
    
    NSString* GetObjectName(UObject* Object);
    std::string SGetObjectName(UObject* Object);
    std::string GetFName(int FName);
    Vector2 World2Screen(Vector3 WorldLocation, float* ViewMatrix);
    
    long GetPointer(long WeakPointer);
    Vector3 GetWorldLocation(long Pawn); //Done
    
    bool isInGame();
    bool isDinoFlying(UObject* Dino);
    UObject* ReadWeakPointer(UObject* WeakPointer);
    UObject* GetGWorld();
    UObject* GetGEngine();
    UObject* GetGName();
    UObject* GetOwningGameInstance();
    UObject* GetLocalPlayers();
    UObject* GetLocalPlayer();
    long GetMatrixOffset();
    UObject* GetPlayerState();
    long GetMyTribeData();
    float* GetViewMatrix();
    int GetMyTeam();
    int GetActorsCount();
    TArray<UObject*> GetActorsArray();
    UObject* GetPlayerCameraManager();
    UObject* GetMyCharacter();
    UObject* GetShooterHUD();
    Vector3 GetMyLocation();
    UObject* GetPlayerHUDUI();
    UObject* GetPrimalGlobals();
    UObject* GetPrimalGameData();
    UObject* GetWorldSettings();
    UObject* GetShooterGameUserSettings();
    UObject* GetGameStateBase();
    UObject* GetLevelScriptActor();
    UObject* GetDayCycleManager();
    UObject* GetMatineeActor();
    UObject* GetStructurePlacer();
    UObject* GetPrimalAssets();
    UObject* GetMyController();
    UObject* GetMyInventory();
    UObject* GetMountedDino();
    UObject* GetMyShooterCharacter();
    UObject* GetPLevel();
    UObject* GetSceneComponent();
    Vector3 GetRootLocation();
    long GetBaseAdress();
    UObject* GetShooterWeapon();
    bool isRidingDino();
    
    bool isShootButtonPressed();
    bool isA_Fast(UObject* Object, long Class);
    Vector3 GetBoneLocation(UObject* Pawn, int BoneIndex);
    bool IsTribeAlliedWith(FTribeData* TribeData, int EnemyTeamID);
    string FStringToString(FString FStr);
    
    string GetServerName();
    string GetServerIP();
    bool StringContainsString(string MainString, string Check);
    int GetPlayerID();
    
    LTMatrix GetBoneMatrix(UObject* Pawn, int BoneIndex);
};

