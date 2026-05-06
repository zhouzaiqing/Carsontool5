//
//  Functions.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

class FunctionCall {
    
public:
    static FunctionCall& getInstance() {
        static FunctionCall instance; // The single instance
        return instance;
    }
    
    void ProcessEventCall(UObject* Object, wchar_t* FunctionName, void* params);
    void StealItems(UObject* FromInventory);
    void TransferItems(UObject* ToInventory);
    void BedTeleport(int SpawnpointID);
    void ForcePlaceStructureAtLocation(int StructureIndex, Vector3 Location);
    void ForcePlaceStructure(int StructureIndex);
    void ForcePlaceStructureWithRoll(int StructureIndex, float Roll);
    void CrashTheServer();
    void RequestItems();
    void EquipWeapon(UObject* Weapon, ServerMultiUse_Params params);
    void RequestDino(UObject* Dino);
    void RequestImplant(UObject* Dino);
    void UnclaimDino(UObject* Dino);
    void DropItems();
    void ServerTransferToRemoteInventory(ServerTransferToRemoveInventory_Params params);
    void ChangeTurretName(UObject* Box, float Latitude, float Longitude);
    void ServerMultiUse(ServerMultiUse_Params params);
    void ActivateFakeAdmin();
    
    void GiveRaptorSkin();
    void UnlockAllNotes();
    void ShowDungeonMenu();
    void ShowLightingMenu();
    void OneClickPVE();
    void GoToWhitePlatform();
    void ReviveDinosaur();
    void WhistleAggressive();
    void Relog();
    void ShowAnnouncementMenu();
    
    
    void ExecuteConsoleCommand(string CommandToExecute);
    void ExecuteConsoleCommand(wstring CommandToExecute);
    void TeleportToPlayerLocation(long PlayerID);
    void BanTribe(long TribeID, bool bDestroyStructures, bool bDestroyDinos);
    void TribeRequestNewAlliance(int TribeID);
    void BedIDTP();
    
    void Suicide();
    
    void MountClosestBallista();
    void UnclaimEnemyMultiseatDinos();
    
    void ForceEquipWeapon(UObject* Weapon);
    void ForceUnequipWeapon(UObject* Weapon);
    void SpawnMaterial(int Material, int Ammount);
    void ServerSaveData();
    void ChangeAppImage();
    void OpenInventory(UObject* Inventory);
    void ForcePlaceCurrentStructure();
    void StealAimedDino();
    void PickupStructure(UObject* PrimalStructure);
    void DestroyStructure(UObject* PrimalStructure);
    void PickupAimedStructure();
    void DestroyAimedStructure();
    void PickupEnemyBase();
    void DestroyEnemyBase();
    void ForeverCrash();

    void ServerTeleportToPlayerLocation(int64_t ForLinkedPlayerID);
    void ServerBanTribe(uint64_t TribeTeamID, int NumDays, FString BanReason, bool bDestroyStructures, bool bDestroyDinos);
    void ServerTribeRequestNewAlliance(uint32_t TribeID);
};