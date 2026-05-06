//
//  Functions.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"

static long BaseAdress = gameUtils.GetBaseAdress();

namespace InternalGameFunctions{
    static void (*ConstructFServerText)(FServerText* FServerTextPointer) = (void(*)(FServerText*))utils.getOffset(0x131ca30);
    static void (*ClientNotifyAdmin)(UObject* AShooterPlayerController, bool withAdmin, bool ShowAdminManager) = (void(*)(UObject*, bool, bool))utils.getOffset(0x010c2b2c);
    static UObject* (*GetPlayerCharacter)(UObject* ShooterPlayerCharacter) = (UObject*(*)(UObject*))utils.getOffset(0x00b38f04);
    static UObject* (*GetMountedDino)(UObject* Pointer) = (UObject*(*)(UObject*))utils.getOffset(0x00a2b148);
    static UObject* (*GetPointer)(UObject* WeakPtr) = (UObject*(*)(UObject*))utils.getOffset(0x157d62c);
    static bool (*isShootButtonQuickPressed)(long PlayerHudUI) = (bool(*)(long))utils.getOffset(0x007730d0);
    static bool (*isShootButtonHeld)(long PlayerHudUI) = (bool(*)(long))utils.getOffset(0x77303c);
    static bool (*AreTribesAllied)(long tribedata, int tribeid) = (bool (*) (long, int))utils.getOffset(0x0085d728);
    static bool (*getLineOfSight)(long t1, long t2, Vector3, bool) = (bool(*)(long, long, Vector3, bool))utils.getOffset(0x026e3638);
    static void (*Ghost)(long pointer) = (void(*)(long))utils.getOffset(0x026057b0);
    static void (*Walk)(long pointer) = (void(*)(long ))utils.getOffset(0x026056f8);
    static void (*AppearancePointer)(long Color) = (void(*)(long))utils.getOffset(0x00a1f0a4);
    static void (*ClientRemoveDungeonLoadingScreen)(long AShooterPlayerController) = (void(*)(long))utils.getOffset(0x10c43e0);
    static void (*ServerWatchedAd)(long AShooterPlayerController) = (void(*)(long))utils.getOffset(0x10c6c54);
    static void (*ServerRequestDropAllItems)(UObject* AShooterPlayerController, FString* CurrentCustomFolderFilter, FString* CurrentNameFilter, FInventoryFilter CurrentFilter) = (void(*)(UObject*, FString*, FString*, FInventoryFilter))utils.getOffset(0x10c9ab8);
    static void (*ServerTransferAllFromRemoteInventory)(UObject* AShooterPlayerController, UObject* PrimalInventoryComponent, FString* FstrCurrentCustomFolderFilter, FString* FstrCurrentNameFilter, FInventoryFilter CurrentFilter) = (void(*)(UObject*,UObject*,FString*,FString*,FInventoryFilter))utils.getOffset(0x10cb524);
    static void (*ServerTransferAllToRemoteInventory)(UObject* AShooterPlayerController, UObject* PrimalInventoryComponent, FString* FstrCurrentCustomFolderFilter, FString* FstrCurrentNameFilter, FInventoryFilter CurrentFilter) = (void(*)(UObject*,UObject*,FString*,FString*,FInventoryFilter))utils.getOffset(0x10cb6e8);
    static void (*StrucPlacePtr)(UObject* AShooterPlayerController, int StructureIndex, Vector3 BuildLocation, FRotator BuildRotation, FRotator PlayerViewRotation, long AttachToPawn, long dinoCharacter, long BoneName, long PlaceUsingItemID, FPreferredSnapData snapData, bool bSnapped, bool bIsCheat, bool bIsFlipped, int InSnapPointCycle, bool isWeaponPlacement) = (void(*)(UObject*, int, Vector3,FRotator,FRotator,long,long,long,long,FPreferredSnapData,bool,bool,bool,int,bool))utils.getOffset(0x010ca1f8);
    static Vector3 (*GetRocketTurretMuzzleLocation)(UObject* APrimalStructureTurretBallista) = (Vector3(*)(UObject*))utils.getOffset(0x9bd54c);
    static Vector3 (*FRotatorToVector)(FRotator* RotatorPointer) = (Vector3(*)(FRotator*))utils.getOffset(0x139bc30);
    static void (*SetLighting)(UObject* AShooterCharacter, long LightingArea) = (void(*)(UObject*,long))utils.getOffset(0xa21da8);
    static UObject* (*GetSelectedDataObject)(UObject* UDataListPanel) = (UObject*(*)(UObject*))utils.getOffset(0x6ed0e0);
    static void (*ClientTravel)(UObject* Engine, UObject* World, wchar_t* ServerIP, int TravelType) = (void(*)(UObject*,UObject*,wchar_t*,int))utils.getOffset(0x2b9dc88);
};
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
void FunctionCall::ProcessEventCall(UObject* Object, wchar_t* FunctionName, void* params){
    const auto FNameFunction = reinterpret_cast<void*>(BaseAdress + 0x0140e0ec);
    const auto FindFunctionCheckedFunction = reinterpret_cast<long*>(BaseAdress + 0x0154a6a4);
    const auto ProcessEventFunction = reinterpret_cast<void*>(BaseAdress + 0x024b57ec);
    if(FNameFunction && FindFunctionCheckedFunction && ProcessEventFunction){
        long FuncFName;
        
        reinterpret_cast<void(__fastcall*)(long, wchar_t*, int)>(FNameFunction)((long)&FuncFName, FunctionName, 1);
        
        long FunctionAdress = reinterpret_cast<long(__fastcall*)(UObject*, long)>(FindFunctionCheckedFunction)(Object, FuncFName);

        reinterpret_cast<void(__fastcall*)(UObject*, long, long)>(ProcessEventFunction)(Object, FunctionAdress, (long)params);
    }
    return;
}

static void InternalStealItems(UObject* FromInventory){
    UObject* MyController = gameUtils.GetMyController();
    if(MyController != nullptr && FromInventory != nullptr){
        
        MFStr nullString = {0};
        FInventoryFilter InventoryFilter = {0};
        
        InventoryFilter.ItemTypeFilter = 9;
        InventoryFilter.EquipmentTypeFilter = 10;
        InventoryFilter.ConsumableTypeFilter = 4;
        InternalGameFunctions::ServerTransferAllFromRemoteInventory(MyController, FromInventory, (FString*)&nullString, (FString*)&nullString, InventoryFilter);
    }
}
void FunctionCall::StealItems(UObject* FromInventory){
    funcqueue.AddFunction(std::bind(&InternalStealItems, FromInventory));
}


static void InternalTransferItems(UObject* ToInventory){
    UObject* MyController = gameUtils.GetMyController();
    if(MyController != nullptr && ToInventory != nullptr){
        
        MFStr nullString = {0};
        FInventoryFilter InventoryFilter = {0};
        
        InventoryFilter.ItemTypeFilter = 9;
        InventoryFilter.EquipmentTypeFilter = 10;
        InventoryFilter.ConsumableTypeFilter = 4;
        
        InternalGameFunctions::ServerTransferAllToRemoteInventory(MyController, ToInventory, (FString*)&nullString, (FString*)&nullString, InventoryFilter);
    }
}
void FunctionCall::TransferItems(UObject* ToInventory){
    funcqueue.AddFunction(std::bind(&InternalTransferItems, ToInventory));
}

static void ServerRequestRespawnAtPoint(int spawnPointID, int spawnRegionIndex, bool bForArena){
    
    if(!utils.isValidAdress((long)gameUtils.GetMyController())) return;
    
    struct ServerRequestRespawnAtPoint_params{
        int spawnPointID;
        int spawnRegionIndex;
        bool bForArena;
    };
    
    ServerRequestRespawnAtPoint_params params;
    params.spawnPointID = spawnPointID; params.spawnRegionIndex = spawnRegionIndex; params.bForArena = bForArena;
    
    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestRespawnAtPoint", &params);
}
void FunctionCall::BedTeleport(int SpawnpointID){
    funcqueue.AddFunction(std::bind(&ServerRequestRespawnAtPoint, SpawnpointID, 0, 1));
}

static void InternalForcePlaceStructureAtLocation(int StructureIndex, Vector3 Location){
    if(!utils.isValidAdress((long)gameUtils.GetMyController()))
        return;

    static FPreferredSnapData snapZero = {0};
    
    InternalGameFunctions::StrucPlacePtr(gameUtils.GetMyController(), StructureIndex, Location, {0}, {0,0,0}, 0, 0, 0, 0, snapZero, 0,0,0,0,1);
}
void FunctionCall::ForcePlaceStructureAtLocation(int StructureIndex, Vector3 Location){
    funcqueue.AddFunction(std::bind(&InternalForcePlaceStructureAtLocation, StructureIndex, Location));
}

static void InternalForcePlaceStructure(int StructureIndex){
    long CurrentPlacingStructure = utils.Read<long>(gameUtils.GetStructurePlacer() + 0x658);
    long StructureSceneComponent = utils.Read<long>(CurrentPlacingStructure + 0x2c8);
    
    if(!utils.isValidAdress(CurrentPlacingStructure) || !utils.isValidAdress(StructureSceneComponent) || !utils.isValidAdress((long)gameUtils.GetMyController()))
        return;

    Vector3 PlacementLocation = utils.Read<Vector3>(StructureSceneComponent + 0x290);
    FRotator PlacementRotation = utils.Read<FRotator>(StructureSceneComponent + 0x2c0);
    long FItemNetID = utils.Read<long>(gameUtils.GetStructurePlacer() + 0x684);
    FPreferredSnapData snapZero = {0};
    InternalGameFunctions::StrucPlacePtr(gameUtils.GetMyController() , StructureIndex, PlacementLocation, PlacementRotation, {0,0,0}, 0, 0, 0, FItemNetID, snapZero, 0,0,0,0,1);
}
void FunctionCall::ForcePlaceCurrentStructure(){
    UObject* StructurePlacer = gameUtils.GetStructurePlacer();
    if(utils.isValidAdress(StructurePlacer)){
        int StructureIndex = utils.Read<int>(StructurePlacer + 0x654);
        InternalForcePlaceStructure(StructureIndex);
    }
    
}
void FunctionCall::ForcePlaceStructure(int StructureIndex){
    funcqueue.AddFunction(std::bind(&InternalForcePlaceStructure, StructureIndex));
}


static void InternalForcePlaceStructureWithRoll(int StructureIndex, float Roll){
    long CurrentPlacingStructure = utils.Read<long>(gameUtils.GetStructurePlacer() + 0x658);
    long StructureSceneComponent = utils.Read<long>(CurrentPlacingStructure + 0x2c8);
    
    if(!utils.isValidAdress(CurrentPlacingStructure) || !utils.isValidAdress(StructureSceneComponent) || !utils.isValidAdress((long)gameUtils.GetMyController()))
        return;

    Vector3 PlacementLocation = utils.Read<Vector3>(StructureSceneComponent + 0x290);
    FRotator PlacementRotation = utils.Read<FRotator>(StructureSceneComponent + 0x2c0);
    long FItemNetID = utils.Read<long>(gameUtils.GetStructurePlacer() + 0x684);
    FPreferredSnapData snapZero = {0};
    PlacementRotation.Roll = Roll;
    InternalGameFunctions::StrucPlacePtr(gameUtils.GetMyController() , StructureIndex, PlacementLocation, PlacementRotation, {0,0,0}, 0, 0, 0, FItemNetID, snapZero, 0,0,0,0,1);
}

void FunctionCall::ForcePlaceStructureWithRoll(int StructureIndex, float Roll){
    funcqueue.AddFunction(std::bind(&InternalForcePlaceStructureWithRoll, StructureIndex, Roll));
}

static void InternalCrashServer(){
    UObject* MyController = gameUtils.GetMyController();
    Vector3 MyLocation = gameUtils.GetRootLocation();
    
    if(utils.isValidAdress(MyController)){
        FPreferredSnapData snapZero = {0};
        InternalGameFunctions::StrucPlacePtr(MyController , 290, MyLocation, {0,0,0}, {0,0,0}, 0, 0, 0, 69696969, snapZero, 0,0,0,0,1);
    }
}
void FunctionCall::CrashTheServer(){
    funcqueue.AddFunction(std::bind(&InternalCrashServer));
}


/*
 struct ServerRequestActorItemsParams{
     long PrimalInventory;
     bool bInventoryItems;
     bool bFirstSpawn;
 };
 ServerRequestActorItemsParams params;
 params.PrimalInventory = PrimalInventory;
 params.bInventoryItems = true;
 params.bFirstSpawn = false;

 StaticProcessEvent(MyController, L"ServerRequestActorItems", &params);
 */
static void InternalRequestItems(bool bFirstSpawn){
    if(!utils.isValidAdress(gameUtils.GetMyController())) return;
    if(!utils.isValidAdress(gameUtils.GetMyInventory()))  return;
    
    struct ServerRequestActorItemsParams{
        UObject* PrimalInventory; bool bInventoryItems; bool bFirstSpawn;
    };
    ServerRequestActorItemsParams params;
    params.PrimalInventory = gameUtils.GetMyInventory();
    params.bInventoryItems = true;
    params.bFirstSpawn = false;
    
    functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestActorItems", &params);
}
 
void FunctionCall::RequestItems(){
    funcqueue.AddFunction(std::bind(&InternalRequestItems, false));
}
/*
 ServerMultiUse_Params* MultiUseParams = (ServerMultiUse_Params*)Params;
 
 if(MultiUseParams->UseIndex == 100){
     UObject* CurrentWeapon = gameUtils.GetShooterWeapon();
     UObject* AssociatedPrimalItem = utils.Read<UObject*>(CurrentWeapon + 0x7f8);
     if(utils.isValidAdress(AssociatedPrimalItem)){
         long FItemNetID = utils.Read<long>(AssociatedPrimalItem + 0x1e0);
         ServerRequestInventoryUseItem_Params newParams = {gameUtils.GetMyInventory(), FItemNetID};
         functions.ProcessEventCall(Object, L"ServerRequestInventoryUseItem", &newParams);
     }
 */
static void InternalEquipWeapon(UObject* Weapon, ServerMultiUse_Params params){
    UObject* Controller = gameUtils.GetMyController();
    UObject* AssociatedPrimalItem = Weapon;//utils.Read<UObject*>(Weapon + 0x7f8);
    if(utils.isValidAdress(AssociatedPrimalItem)){
        FItemNetID ItemNetID = utils.Read<FItemNetID>(AssociatedPrimalItem + 0x1e0);
        ServerRequestInventoryUseItem_Params newParams = {gameUtils.GetMyInventory(), ItemNetID};
        functions.ProcessEventCall(Controller, L"ServerRequestInventoryUseItem", &newParams);
    }
    
    timer(0.1){
        ServerMultiUse_Params MultiUseParamaters = params;
        MultiUseParamaters.bAllowSpam = 1;
        
        functions.ProcessEventCall(Controller, L"ServerMultiUse", &MultiUseParamaters);
        
    });
    //functions.ProcessEventCall(Object, L"ServerRequestInventoryUseItem", &newParams);
}
void FunctionCall::EquipWeapon(UObject* Weapon, ServerMultiUse_Params params){
    timer(0.5){
        funcqueue.AddFunction(std::bind(&InternalEquipWeapon, Weapon, params));
    });
}

static void InternalRequestDino(UObject* Dino){
    //void ServerRequestDino(uint32_t DinoID); // Offset: 0x1010deb68 // Return & Params: Num(1) Size(0x4)
    if(utils.isValidAdress(gameUtils.GetMyController())){
        uint32_t DinoID = utils.Read<uint32_t>(Dino + 0x1a08);
        
        if(DinoID != 0)
            functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerRequestDino", &DinoID);
    }
}

static void InternalRequestImplant(UObject* Dino){
    //void FlagDinoForImplantReturn(struct APrimalDinoCharacter* aDino, bool Request);
    if(utils.isValidAdress(gameUtils.GetMyController())){
        FlagDinoForImplantReturn_Params Params = {Dino, true};
        functions.ProcessEventCall(gameUtils.GetMyController(), L"FlagDinoForImplantReturn", &Params);
    }
}

void FunctionCall::RequestDino(UObject* Dino){
    funcqueue.AddFunction(std::bind(&InternalRequestDino, Dino));
}
void FunctionCall::RequestImplant(UObject* Dino){
    funcqueue.AddFunction(std::bind(&InternalRequestImplant, Dino));
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
void FunctionCall::UnclaimDino(UObject* Dino){
    funcqueue.AddFunction(std::bind(&InternalUnclaimDino, Dino));
}

static void InternalDropItems(){
    UObject* MyController = gameUtils.GetMyController();
    if(MyController != nullptr){
        
        MFStr nullString = {0};
        FInventoryFilter InventoryFilter = {0};
        
        InventoryFilter.ItemTypeFilter = 9;
        InventoryFilter.EquipmentTypeFilter = 10;
        InventoryFilter.ConsumableTypeFilter = 4;
        InternalGameFunctions::ServerRequestDropAllItems(MyController, (FString*)&nullString, (FString*)&nullString, InventoryFilter);
    }
}
void FunctionCall::DropItems(){
    funcqueue.AddFunction(std::bind(&InternalDropItems));
}


static void InternalServerTransferToRemoteInventory(ServerTransferToRemoveInventory_Params params){
    if(utils.isValidAdress(gameUtils.GetMyController())){
        ServerTransferToRemoveInventory_Params newParams = params;
        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerTransferToRemoteInventory", &newParams);
    }
}
void FunctionCall::ServerTransferToRemoteInventory(ServerTransferToRemoveInventory_Params params){
    funcqueue.AddFunction(std::bind(&InternalServerTransferToRemoteInventory, params));
}

static void InternalChangeTurretName(UObject* Box, float Latitude, float Longitude){
    string TurretName = utils.string_format("LAT %.1f LONG %.1f", Latitude, Longitude);
    std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(TurretName);
    FString NameString = FString(wstr.c_str());
    
    
    if(utils.isValidAdress(Box)){
        functions.ProcessEventCall(Box, L"NetUpdateBoxName", &NameString);
    }
}
void FunctionCall::ChangeTurretName(UObject* Box, float Latitude, float Longitude){
    funcqueue.AddFunction(std::bind(&InternalChangeTurretName, Box, Latitude, Longitude));
}

static void InternalServerMultiUse(ServerMultiUse_Params params){
    if(utils.isValidAdress(gameUtils.GetMyController())){
        ServerMultiUse_Params newParams = params;
        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &newParams);
    }
}
void FunctionCall::ServerMultiUse(ServerMultiUse_Params params){
    funcqueue.AddFunction(std::bind(&InternalServerMultiUse, params));
}

void FunctionCall::ActivateFakeAdmin(){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        InternalGameFunctions::ClientNotifyAdmin(MyController, true, true);
    }
}

static void InternalGiveRaptorSkin(){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        functions.ProcessEventCall(MyController, L"OnPromoWatched", nullptr);
    }
    //OnPromoWatched
}
void FunctionCall::GiveRaptorSkin(){
    funcqueue.AddFunction(std::bind(&InternalGiveRaptorSkin));
}

static void InternalUnlockAllNotes(){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        for(int i = 0; i<150; ++i){
            functions.ProcessEventCall(MyController, L"ServerUnlockPerMapExplorerNote", &i);
        }
    }
}
void FunctionCall::UnlockAllNotes(){
    funcqueue.AddFunction(std::bind(&InternalUnlockAllNotes));
}

static void InternalShowDungeonMenu(){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        functions.ProcessEventCall(MyController, L"ServerRequestDungeonAccess", nullptr);
    }
}
void FunctionCall::ShowDungeonMenu(){
    funcqueue.AddFunction(std::bind(&InternalShowDungeonMenu));
}

static void SetLighting(long LightingIndex){
    UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        InternalGameFunctions::SetLighting(ShooterCharacter, LightingIndex);
    }
}
void FunctionCall::ShowLightingMenu(){
 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Visibility"
                                                                                     message:@"Choose A Lighting"
                                                                              preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = AlertAction(@"Cancel"){}];
    UIAlertAction *worldAction = AlertAction(@"World"){SetLighting(1);}];
    UIAlertAction *dungeonAction = AlertAction(@"Dungeon"){SetLighting(2);}];
    UIAlertAction *arenaAction = AlertAction(@"Arena"){SetLighting(3);}];

    // Add the actions to the alert controller
    [alertController addAction:cancelAction];
    [alertController addAction:worldAction];
    [alertController addAction:dungeonAction];
    [alertController addAction:arenaAction];

    // Present the alert controller
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}

static void InternalOneClickPVE(){
    if(DungeonName.length() > 1 && utils.isValidAdress(gameUtils.GetMyController())){
        std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(DungeonName);
        FString NameString = FString(wstr.c_str());
        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerDownloadDungeon", &NameString);
    }
    else{
        InternalShowDungeonMenu();
    }
}
void FunctionCall::OneClickPVE(){
    funcqueue.AddFunction(std::bind(&InternalOneClickPVE));
}

static void InternalGoToWhitePlatform(){
    if(DungeonName.length() > 1 && utils.isValidAdress(gameUtils.GetMyController())){
        std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(DungeonName);
        FString NameString = FString(wstr.c_str());
        functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerStartDungeonTeleport", &NameString);
        
        timer(5){
            if(utils.isValidAdress(gameUtils.GetMyController())){
                functions.ProcessEventCall(gameUtils.GetMyController(), L"ClientRemoveDungeonLoadingScreen", nullptr);
            }
        });
    }
    else{
        InternalShowDungeonMenu();
    }
}

void FunctionCall::GoToWhitePlatform(){
    funcqueue.AddFunction(std::bind(&InternalGoToWhitePlatform));
}


static void InternalReviveDinosaur(){
    UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        UObject* ShooterHUD = gameUtils.GetShooterHUD();
        UObject* CurrentOpenedInventory = utils.Read<UObject*>(ShooterHUD + 0xf38);
        
        
        UObject* Something = utils.Read<UObject*>(CurrentOpenedInventory + 0xc80);
        UObject* SomethingTwo = utils.Read<UObject*>(CurrentOpenedInventory + 0xc70);
        UObject* Selected = 0;

        if(utils.isValidAdress(Something)){
            Selected = InternalGameFunctions::GetSelectedDataObject(Something);
        }
        if(!utils.isValidAdress(Selected) && utils.isValidAdress(SomethingTwo)){
            Selected = InternalGameFunctions::GetSelectedDataObject(SomethingTwo);
        }
        
        if(!utils.isValidAdress(Selected)) return;
        
        int DinoID = utils.Read<int>(Selected + 0xae0);
        functions.ProcessEventCall(ShooterCharacter, L"ServerResurrectDino", &DinoID);
    }
}
void FunctionCall::ReviveDinosaur(){
    funcqueue.AddFunction(std::bind(&InternalReviveDinosaur));
}

static void InternalWhistleAgressive(){
    UObject* MyShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(MyShooterCharacter)){
        functions.ProcessEventCall(MyShooterCharacter, L"ServerCallAggressive", nullptr);
    }
    //ServerCallAggressive
}
void FunctionCall::WhistleAggressive(){
    funcqueue.AddFunction(std::bind(&InternalWhistleAgressive));
}

void FunctionCall::Relog(){
    UObject* GWorld = gameUtils.GetGWorld();
    UObject* GEngine = gameUtils.GetGEngine();
    
    string ServerIP = gameUtils.GetServerIP();
    std::wstring WServerIP = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(ServerIP);
    FString ServerIPFString = FString(WServerIP.c_str());
    
    if(utils.isValidAdress(GWorld) && utils.isValidAdress(GEngine))
    {
        InternalGameFunctions::ClientTravel(GEngine, GWorld, ServerIPFString.Data, 0);
    }
}

//Crashes From: 

//void ServerSendChatMessage(enum class EChatChannel ChatChannel, enum class EChatMessageType messageType, struct FString ChatMessage, struct FServerText ServerText);
 
static void InternalSendAnnouncement(string AnnouncementString, EChatMessageType messageType){
    UObject* MyController = gameUtils.GetMyController();
    UObject* GameUserSettings = gameUtils.GetShooterGameUserSettings();
    if(utils.isValidAdress(MyController) && utils.isValidAdress(GameUserSettings)){
        ServerSendChatMessage_Params MessageParamaters;
        
        std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(AnnouncementString);
        
        MessageParamaters.ChatChannel = utils.Read<EChatChannel>(GameUserSettings + 0x2ae);
        MessageParamaters.MessageType = messageType;
        MessageParamaters.ChatMessage = FString(wstr.c_str());
        InternalGameFunctions::ConstructFServerText(&MessageParamaters.ServerText);
        
        
        functions.ProcessEventCall(MyController, L"ServerSendChatMessage", &MessageParamaters);
    }
}
void InternalShowMessageTypeMenu(string AnnouncementString){
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message Type"
                                                                                     message:@"Choose A Message Type"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *TextAction = AlertAction(@"Text"){InternalSendAnnouncement(AnnouncementString, Text);}];
    UIAlertAction *EmoteAction = AlertAction(@"Emote"){InternalSendAnnouncement(AnnouncementString, Emote);}];
    UIAlertAction *LoginAction = AlertAction(@"LogIn"){InternalSendAnnouncement(AnnouncementString, LogIn);}];
    UIAlertAction *NotificationAction = AlertAction(@"Notification"){InternalSendAnnouncement(AnnouncementString, Notification);}];
    UIAlertAction *AnnouncmentAction = AlertAction(@"Announcement"){InternalSendAnnouncement(AnnouncementString, Announcement);}];
    
    [alertController addAction:NotificationAction];
    [alertController addAction:AnnouncmentAction];
    [alertController addAction:TextAction];
    [alertController addAction:EmoteAction];
    [alertController addAction:LoginAction];
    
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
    
    
    
    /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Visibility"
                                                                                     message:@"Choose A Lighting"
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = AlertAction(@"Cancel"){}];
    UIAlertAction *worldAction = AlertAction(@"World"){SetLighting(1);}];
    UIAlertAction *dungeonAction = AlertAction(@"Dungeon"){SetLighting(2);}];
    UIAlertAction *arenaAction = AlertAction(@"Arena"){SetLighting(3);}];

    // Add the actions to the alert controller
    [alertController addAction:cancelAction];
    [alertController addAction:worldAction];
    [alertController addAction:dungeonAction];
    [alertController addAction:arenaAction];

    // Present the alert controller
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil]; */
}
void FunctionCall::ShowAnnouncementMenu(){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Chat Menu"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Carsontool";}];
    
    UIAlertAction* Send = AlertAction(@"Send Message"){
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        string MessageText = [enteredText UTF8String];
        InternalShowMessageTypeMenu(MessageText);
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}


static void ExecuteStringConsoleCommandInternal(string CommandToExecute){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        std::wstring wstr = std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>>().from_bytes(CommandToExecute);
        FString AdminCommand = FString(wstr.c_str());
        functions.ProcessEventCall(MyController, L"ServerCheat", &AdminCommand);
    }
}
static void ExecuteWStringConsoleCommandInternal(wstring CommandToExecute){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        FString AdminCommand = FString(CommandToExecute.c_str());
        functions.ProcessEventCall(MyController, L"ServerCheat", &AdminCommand);
    }
}
void FunctionCall::ExecuteConsoleCommand(string CommandToExecute){
    funcqueue.AddFunction(std::bind(&ExecuteStringConsoleCommandInternal, CommandToExecute));
}
void FunctionCall::ExecuteConsoleCommand(wstring CommandToExecute){
    funcqueue.AddFunction(std::bind(&ExecuteWStringConsoleCommandInternal, CommandToExecute));
}

static void InternalTeleportToPlayerLocation(long PlayerID){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        long PlayerIDForCall = PlayerID;
        functions.ProcessEventCall(MyController, L"ServerTeleportToPlayerLocation", &PlayerIDForCall);
    }
}
static void InternalBanTribe(long TribeID, bool bDestroyStructures, bool bDestroyDinos){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        ServerBanTribe_Params BanParamaters;
        BanParamaters.TribeTeamID = TribeID;
        BanParamaters.NumDays = 9999999;
        BanParamaters.BanReason = FString(L"Noob");
        BanParamaters.bDestroyStructures = bDestroyStructures;
        BanParamaters.bDestroyDinos = bDestroyDinos;
        
        functions.ProcessEventCall(MyController, L"ServerBanTribe", &BanParamaters);
    }
}
static void InternalTribeRequestNewAlliance(int TribeID){
    UObject* PlayerState = gameUtils.GetPlayerState();
    if(utils.isValidAdress(PlayerState)){
        int TribeIDForCall = TribeID;
        functions.ProcessEventCall(PlayerState, L"ServerTribeRequestNewAlliance", &TribeIDForCall);
    }
}

void FunctionCall::TeleportToPlayerLocation(long PlayerID){
    funcqueue.AddFunction(std::bind(&InternalTeleportToPlayerLocation, PlayerID));
}
void FunctionCall::BanTribe(long TribeID, bool bDestroyStructures, bool bDestroyDinos){
    funcqueue.AddFunction(std::bind(&InternalBanTribe, TribeID, bDestroyStructures, bDestroyDinos));
}
void FunctionCall::TribeRequestNewAlliance(int TribeID){
    funcqueue.AddFunction(std::bind(&InternalTribeRequestNewAlliance, TribeID));
}

static void InternalServerTeleportToPlayerLocation(int64_t ForLinkedPlayerID){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        int64_t PlayerIDForCall = ForLinkedPlayerID;
        functions.ProcessEventCall(MyController, L"ServerTeleportToPlayerLocation", &PlayerIDForCall);
    }
}
static void InternalServerBanTribe(uint64_t TribeTeamID, int NumDays, FString BanReason, bool bDestroyStructures, bool bDestroyDinos){
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isValidAdress(MyController)){
        ServerBanTribe_Params BanParamaters;
        BanParamaters.TribeTeamID = TribeTeamID;
        BanParamaters.NumDays = NumDays;
        BanParamaters.BanReason = BanReason;
        BanParamaters.bDestroyStructures = bDestroyStructures;
        BanParamaters.bDestroyDinos = bDestroyDinos;

        functions.ProcessEventCall(MyController, L"ServerBanTribe", &BanParamaters);
    }
}
static void InternalServerTribeRequestNewAlliance(uint32_t TribeID){
    UObject* PlayerState = gameUtils.GetPlayerState();
    if(utils.isValidAdress(PlayerState)){
        uint32_t TribeIDForCall = TribeID;
        functions.ProcessEventCall(PlayerState, L"ServerTribeRequestNewAlliance", &TribeIDForCall);
    }
}

void FunctionCall::ServerTeleportToPlayerLocation(int64_t ForLinkedPlayerID){
    funcqueue.AddFunction(std::bind(&InternalServerTeleportToPlayerLocation, ForLinkedPlayerID));
}
void FunctionCall::ServerBanTribe(uint64_t TribeTeamID, int NumDays, FString BanReason, bool bDestroyStructures, bool bDestroyDinos){
    funcqueue.AddFunction(std::bind(&InternalServerBanTribe, TribeTeamID, NumDays, BanReason, bDestroyStructures, bDestroyDinos));
}
void FunctionCall::ServerTribeRequestNewAlliance(uint32_t TribeID){
    funcqueue.AddFunction(std::bind(&InternalServerTribeRequestNewAlliance, TribeID));
}


void FunctionCall::BedIDTP(){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Bed Teleport"
                                                                                     message:@"Input Bed ID"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"BedID";}];
    
    UIAlertAction* Send = AlertAction(@"Teleport"){
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        int BedID = [enteredText intValue];
        BedTeleport(BedID);
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}


static void InternalSuicide(){
    UObject* Controller = gameUtils.GetMyController();
    if(utils.isValidAdress(Controller))
    {
        functions.ProcessEventCall(Controller, (wchar_t*)L"ServerSuicide", nullptr);
    }
}
void FunctionCall::Suicide(){
    funcqueue.AddFunction(std::bind(&InternalSuicide));
}


static void InternalMountClosestBallista()
{
    
    if(gameUtils.isRidingDino()) return;
    
    UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        UObject* MountedStructure = gameUtils.ReadWeakPointer(gameUtils.GetMyShooterCharacter() + 0x1c2c);
        if(utils.isValidAdress(MountedStructure))
        {
            AutoMountBallista = false;
            EnableBallistaPlace = false;
            functions.Relog();
            return;
            //return;
        }
    }
    else {
        return;
    }
        
        
    
    Vector3 MyLocation = gameUtils.GetRootLocation();
    int MyTeamID = gameUtils.GetMyTeam();
    TArray<UObject*> ActorsArray = gameUtils.GetActorsArray();
    
    if(ActorsArray.IsValidArray())
    {
        float ClosestBallistaDistance = 9;
        UObject* ActorBallista = 0;
        for(int i = 0; i<ActorsArray.Count; ++i)
        {
            UObject* CurrentActor = ActorsArray[i];
            if(utils.isValidAdress(CurrentActor))
            {
                UObject* CurrentActorSceneComponent = utils.Read<UObject*>(CurrentActor + 0x2c8);
                if(CurrentActorSceneComponent != 0)
                {
                    Vector3 ObjectLocation = utils.Read<Vector3>(CurrentActorSceneComponent + 0x290);
                    float ObjectDistance = utils.GetDistance(ObjectLocation, MyLocation);
                    if(ObjectDistance < ClosestBallistaDistance)
                    {
                        int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
                        if(ObjectTeamID == MyTeamID)
                        {
                            string ObjectName = gameUtils.SGetObjectName(CurrentActor);
                            if(ObjectName == "StructureTurretBallistaBaseBP_C" || ObjectName == "StructureTurretRocket_C")
                            {
                                ClosestBallistaDistance = ObjectDistance;
                                ActorBallista = CurrentActor;
                            }
                        }
                    }
                }
            }
        }
        
        if(ActorBallista != 0)
        {
            ServerMultiUse_Params paramaters;
            paramaters.ignoreDisableUse = false;
            paramaters.ComponentIndex = 0;
            paramaters.UseIndex = 15003;
            paramaters.ForObject = ActorBallista;
            paramaters.bAllowSpam = false;
            
            functions.ProcessEventCall(gameUtils.GetMyController(), L"ServerMultiUse", &paramaters);
        }
    }
}
void FunctionCall::MountClosestBallista(){
    InternalMountClosestBallista();
}

static void InternalUnclaimMultiseatDinos(){
    int MyTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    
    if(!utils.isValidAdress((UObject*)MyTribeData)) return;
    if(!utils.isValidAdress(gameUtils.GetMyController())) return;
    
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalDinoCharacter())){
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            
            if(ObjectTeamID == MyTeamID){
                continue;
            }
            else if(gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID)){
                continue;
            }
            else if(ObjectTeamID < 1000){
                continue;
            }
            else{
                uint32_t DinoID = utils.Read<uint32_t>(CurrentActor + 0x1a08);
                functions.ProcessEventCall(gameUtils.GetMyController(), (wchar_t*)L"ServerTryUnclaimDino", &DinoID);
            }
        }
    }
}
void FunctionCall::UnclaimEnemyMultiseatDinos(){
    funcqueue.AddFunction(std::bind(&InternalUnclaimMultiseatDinos));
}

struct ServerGodConsoleCommandThree_Params{uint8_t ItemToGive; bool MaxStack;};
static void InternalSpawnMaterial(int Material, int Ammount){
    UObject* Controller = gameUtils.GetMyController();
    if(utils.isValidAdress(Controller)){
        ServerGodConsoleCommandThree_Params params = {(uint8_t)Material, true};
        for(int i = 0; i<Ammount; ++i){
            functions.ProcessEventCall(Controller, (wchar_t*)L"ServerGodConsoleCommandThree", &params);
        }
    }
}
void FunctionCall::SpawnMaterial(int Material, int Ammount){
    funcqueue.AddFunction(std::bind(&InternalSpawnMaterial, Material, Ammount));
}
static void InternalServerSaveData(){
    UObject* PlayerState = gameUtils.GetPlayerState();
    if(utils.isValidAdress(PlayerState)){
        functions.ProcessEventCall(PlayerState, (wchar_t*)L"ServerSaveData", nullptr);
    }
}
void FunctionCall::ServerSaveData(){
    funcqueue.AddFunction(std::bind(&InternalServerSaveData));
}

void FunctionCall::ChangeAppImage(){
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App Icon"
                                                                                     message:@"Choose An App Icon"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ArkIconAction = AlertAction(@"ARK Icon"){
        [[UIApplication sharedApplication] setAlternateIconName:@"defaultArkIcon" completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"App icon reverted to default successfully");
            }
        }];
    }];
    UIAlertAction *CarsontoolIconAction = AlertAction(@"Carsontool Icon"){
        [[UIApplication sharedApplication] setAlternateIconName:@"CarsontoolIcon" completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"App icon changed successfully");
            }
        }];
    }];
    UIAlertAction *AdminMenuIconAction = AlertAction(@"Admin Menu Icon"){
        [[UIApplication sharedApplication] setAlternateIconName:@"AdminMenuIcon" completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"App icon changed successfully");
            }
        }];
    }];
    UIAlertAction *DefaultIconAction = AlertAction(@"Default Icon"){
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"App icon changed successfully");
            }
        }];
    }];
    [alertController addAction:DefaultIconAction];
    [alertController addAction:CarsontoolIconAction];
    [alertController addAction:ArkIconAction];
    [alertController addAction:AdminMenuIconAction];
    
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil]; */
}

//ServerActorViewRemoteInventory
//ServerRequestActorItems
//void ServerRequestActorItems(struct UPrimalInventoryComponent* forInventory, bool bInventoryItems, bool bInIsFirstSpawn);
struct ServerRequestActorItems_Params{
    UObject* forInventory;
    bool bInventoryItems;
    bool bInIsFirstSpawn;
};
/*
 struct ServerMultiUse_Params{
     UObject* ForObject;
     int UseIndex;
     int ComponentIndex;
     bool bAllowSpam;
     bool ignoreDisableUse;
 };
 */
//Works
static void InternalOpenInventory(UObject* Inventory){
    UObject* Controller = gameUtils.GetMyController();
    if(utils.isValidAdress(Controller)){
        ServerMultiUse_Params params = {Inventory, 0,0,0,1};
        functions.ProcessEventCall(Controller, (wchar_t*)L"ServerMultiUse", &params);
        //ServerRequestActorItems_Params params = {Inventory, 1, 0};
        //functions.ProcessEventCall(Controller, (wchar_t*)L"ServerRequestActorItems", &params);
    }
}
void FunctionCall::OpenInventory(UObject* Inventory){
    funcqueue.AddFunction(std::bind(&InternalOpenInventory, Inventory));
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

void FunctionCall::DestroyEnemyBase(){
    int myTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    Vector3 MyLocation = gameUtils.GetRootLocation();
    
    UObject* LowestObject = nullptr; float LowestZ = MAXFLOAT;
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalStructure())){
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            if(!gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID) && ObjectTeamID > 1000 && ObjectTeamID != myTeamID){
                UObject* SceneComponent = utils.Read<UObject*>(CurrentActor + 0x2c8);
                Vector3 Location = utils.Read<Vector3>(SceneComponent + 0x290);
                if(utils.GetDistance(Location, MyLocation) < 14){
                    if(Location.Z < LowestZ){
                        LowestZ = Location.Z;
                        LowestObject = CurrentActor;
                    }
                }
            }
        }
    }
    if(LowestObject)
        DestroyStructure(LowestObject);
}
void FunctionCall::PickupEnemyBase(){
    int myTeamID = gameUtils.GetMyTeam();
    FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalStructure())){
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            if(!gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID) && ObjectTeamID > 1000 && ObjectTeamID != myTeamID){
                PickupStructure(CurrentActor);
                return;
            }
        }
    }
}

void FunctionCall::ForeverCrash(){
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CRASH THE SERVER"
                                                                                     message:@"FOREVER"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Send = AlertAction(@"CRASSHHHHH"){
        int myTeamID = gameUtils.GetMyTeam();
        FTribeData* MyTribeData = (FTribeData*)gameUtils.GetMyTribeData();
        TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
        if(!TActorsArray.IsValidArray()) return;
        for(int i = 0; i<TActorsArray.Count; i++){
            UObject* CurrentActor = TActorsArray[i];
            if(!utils.isValidAdress(CurrentActor)) continue;
            if(gameUtils.isA_Fast(CurrentActor, FunctionsStaticClassFunctions::PrimalDinoCharacter())){
                int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
                if(!gameUtils.IsTribeAlliedWith(MyTribeData, ObjectTeamID) && ObjectTeamID != myTeamID){
                    RequestImplant(CurrentActor);
                }
            }
        }
    }];
    UIAlertAction* Cancel = AlertAction(@"NO"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}

/*
 if(!IsValidAddress(Controller)) return;
     long TargettingObject = Read<long>(Controller + 0xc48);
     if(!IsValidAddress(TargettingObject)) return;
     long Object = Functions::GetPointer(TargettingObject + 0xf0);
 */
