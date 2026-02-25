//
//  GameUtils.m
//  BaseMenu
//
//  Created by Carson Mobile on 4/10/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"





namespace GameFunctions{
    static UObject* (*GetPlayerCharacter)(UObject* ShooterPlayerCharacter) = (UObject*(*)(UObject*))utils.getOffset(0x00b38f04);
    static UObject* (*GetMountedDino)(UObject* Pointer) = (UObject*(*)(UObject*))utils.getOffset(0x00a2b148);
    static UObject* (*GetPointer)(long WeakPtr) = (UObject*(*)(long))utils.getOffset(0x157d62c);
    static bool (*isShootButtonQuickPressed)(UObject* PlayerHudUI) = (bool(*)(UObject*))utils.getOffset(0x007730d0);
    static bool (*isShootButtonHeld)(UObject* PlayerHudUI) = (bool(*)(UObject*))utils.getOffset(0x77303c);
    static bool (*AreTribesAllied)(long tribedata, int tribeid) = (bool (*) (long, int))utils.getOffset(0x0085d728);
    static bool (*getLineOfSight)(long t1, long t2, Vector3, bool) = (bool(*)(long, long, Vector3, bool))utils.getOffset(0x026e3638);
    static void (*Ghost)(long pointer) = (void(*)(long))utils.getOffset(0x026057b0);
    static void (*Walk)(long pointer) = (void(*)(long ))utils.getOffset(0x026056f8);
    static void (*AppearancePointer)(long Color) = (void(*)(long))utils.getOffset(0x00a1f0a4);
    static void (*ClientRemoveDungeonLoadingScreen)(long AShooterPlayerController) = (void(*)(long))utils.getOffset(0x10c43e0);
    static void(*ClientNotifyAdmin)(long AShooterPlayerController,bool withAdmin,bool ShowAdminManager) = (void(*)(long,bool,bool))utils.getOffset(0x010c2b2c);
    static void (*ServerWatchedAd)(long AShooterPlayerController) = (void(*)(long))utils.getOffset(0x10c6c54);
    static void (*ServerTransferAllFromRemoteInventory)(long AShooterPlayerController, long PrimalInventoryComponent, long FstrCurrentCustomFolderFilter, long FstrCurrentNameFilter, FInventoryFilter CurrentFilter) = (void(*)(long,long,long,long,FInventoryFilter))utils.getOffset(0x10cb524);
    static void (*ServerTransferAllToRemoteInventory)(long AShooterPlayerController, long PrimalInventoryComponent, long FstrCurrentCustomFolderFilter, long FstrCurrentNameFilter, FInventoryFilter CurrentFilter) = (void(*)(long,long,long,long,FInventoryFilter))utils.getOffset(0x10cb6e8);
    static void (*StrucPlacePtr)(long AShooterPlayerController, int StructureIndex, Vector3 BuildLocation, FRotator BuildRotation, FRotator PlayerViewRotation, long AttachToPawn, long dinoCharacter, long BoneName, long PlaceUsingItemID, FPreferredSnapData snapData, bool bSnapped, bool bIsCheat, bool bIsFlipped, int InSnapPointCycle, bool isWeaponPlacement) = (void(*)(long, int, Vector3,FRotator,FRotator,long,long,long,long,FPreferredSnapData,bool,bool,bool,int,bool))utils.getOffset(0x010ca1f8);
};
UObject* GameUtils::ReadWeakPointer(UObject *WeakPointer)
{
    int IntegerTwo = utils.Read<int>(WeakPointer + 0x4);
    int ArrayIndex = (int)utils.Read<long>(WeakPointer + 0x0);
    
    if(IntegerTwo == 0) return 0;
    
    
    int GUObjectArrayCount = utils.Read<int>(gameUtils.GetBaseAdress() + 0x440908c);
    UObject* GUObjectArray = utils.Read<UObject*>(gameUtils.GetBaseAdress() + 0x04409080);
    
    if(-1 < ArrayIndex && GUObjectArray != 0 && ArrayIndex < GUObjectArrayCount)
    {
        if(utils.Read<int>(GUObjectArray + ArrayIndex * 0x18 + 0x10)  != IntegerTwo){
            return 0;
        }
        if((utils.Read<uint8_t>(GUObjectArray + ArrayIndex * 0x18 + 0xb) & 0x30) != 0){
            return 0;
        }
        
        return utils.Read<UObject*>(GUObjectArray + ArrayIndex * 0x18);
    }
    
    return 0;
}

static long BaseAdress = (long)_dyld_get_image_header(0);

std::string GameUtils::GetFName(int FName){
    static std::map<int32_t, std::string> namesCachedMap;
    if (namesCachedMap.count(FName) > 0)
        return namesCachedMap[FName];
    
    
    static long GName = *(long*)(BaseAdress + 0x420fc48);
    string ObjName = "null";
    
    
    
    
    long fNamePtr = utils.Read<long>(GName + int(FName / 0x4000) * 0x8);
    long fName = utils.Read<long>(fNamePtr + int(FName % 0x4000) * 0x8);
    if(!isValidAdress(fName)) return ObjName;
    
    ObjectName pBuffer = *(ObjectName*)(fName + 0x10);
    ObjName = pBuffer.data;
    
    return ObjName;
}
std::string GameUtils::SGetObjectName(UObject* Object){
    int32_t nameid = utils.Read<uint32_t>(Object + 0x18);
    return GetFName(nameid);
}
NSString* GameUtils::GetObjectName(UObject* Object){
    
    string ObjName = SGetObjectName(Object);
    NSString *objname= [NSString stringWithCString:ObjName.c_str() encoding:[NSString defaultCStringEncoding]];
    return objname;
}

Vector2 GameUtils::World2Screen(Vector3 WorldLocation, float* ViewMatrix){

    static float w2sWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    static float w2sHeight = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    static float w2sScale = [UIScreen mainScreen].scale;
    struct Vector2 outVec = {3100, 3100};
    float view = ViewMatrix[3] * WorldLocation.X + ViewMatrix[7] * WorldLocation.Y + ViewMatrix[11] * WorldLocation.Z + ViewMatrix[15];
    float x,y,z;
    if (view < 0.001) {
        z = ViewMatrix[8] * WorldLocation.X + ViewMatrix[9] * WorldLocation.Y + ViewMatrix[10] * WorldLocation.Z + ViewMatrix[11];
        x = w2sWidth + (ViewMatrix[0] * WorldLocation.X + ViewMatrix[4] * WorldLocation.Y + ViewMatrix[8] * WorldLocation.Z + ViewMatrix[12]) / 1 * w2sWidth;
        y = w2sHeight - (ViewMatrix[1] * WorldLocation.X + ViewMatrix[5] * WorldLocation.Y + ViewMatrix[9] * WorldLocation.Z + ViewMatrix[13]) / 1 * w2sHeight;
    }else {
        z = ViewMatrix[3] * WorldLocation.X + ViewMatrix[7] * WorldLocation.Y + ViewMatrix[11] * WorldLocation.Z + ViewMatrix[15];
        x = w2sWidth + (ViewMatrix[0] * WorldLocation.X + ViewMatrix[4] * WorldLocation.Y + ViewMatrix[8] * WorldLocation.Z + ViewMatrix[12]) / z * w2sWidth;
        y = w2sHeight - (ViewMatrix[1] * WorldLocation.X + ViewMatrix[5] * WorldLocation.Y + ViewMatrix[9] * WorldLocation.Z + ViewMatrix[13]) / z * w2sHeight;
    }
    outVec.X = x/2/w2sScale;
    outVec.Y = y/2/w2sScale;
    return outVec;
}

bool GameUtils::isInGame(){
    return utils.isValidAdress(GetPlayerHUDUI()) && utils.isValidAdress(GetShooterHUD()) && utils.isValidAdress(GetMyController()) && utils.isValidAdress(GetMyCharacter()) && utils.isValidAdress(GetMyTribeData());
}
bool GameUtils::isDinoFlying(UObject* Dino){
    if(utils.isValidAdress(Dino)){
        return !(utils.Read<uint8_t>(Dino + 0x16d0) < 128);
    }
    return false;
}
long GameUtils::GetBaseAdress(){
    return (long)_dyld_get_image_header(0);
}
UObject* GameUtils::GetGWorld(){
    return utils.Read<UObject*>(GetBaseAdress() + 0x44e9648);
}
UObject* GameUtils::GetGEngine(){
    return utils.Read<UObject*>(GetBaseAdress() + 0x44e7ab8);
}
UObject* GameUtils::GetGName(){
    return utils.Read<UObject*>(GetBaseAdress() + 0x420fc48);
}
UObject* GameUtils::GetOwningGameInstance(){
    return utils.Read<UObject*>(GetGWorld() + 0x1a8);
}
UObject* GameUtils::GetPLevel(){
    return utils.Read<UObject*>(GetGWorld() + 0x58);
}
TArray<UObject*> GameUtils::GetActorsArray(){
    return utils.Read<TArray<UObject*>>(GetPLevel() + 0xA0);
}
UObject* GameUtils::GetLocalPlayers(){
    return utils.Read<UObject*>(GetOwningGameInstance() + 0x38);
}
UObject* GameUtils::GetLocalPlayer(){
    return utils.Read<UObject*>(GetLocalPlayers() + 0x0);
}
UObject* GameUtils::GetMyController(){
    return utils.Read<UObject*>(GetLocalPlayer() + 0x30);
}
UObject* GameUtils::GetPlayerCameraManager(){
    return utils.Read<UObject*>(GetMyController() + 0x660);
}
UObject* GameUtils::GetMyCharacter(){
    return utils.Read<UObject*>(GetMyController() + 0x5e8);
}
UObject* GameUtils::GetShooterHUD(){
    return utils.Read<UObject*>(GetMyController() + 0x658);
}
UObject* GameUtils::GetPlayerHUDUI(){
    return utils.Read<UObject*>(GetShooterHUD() + 0x718);
}
long GameUtils::GetMatrixOffset(){
    return utils.Read<long>(GetLocalPlayer() + 0x1C8);
}
Vector3 GameUtils::GetMyLocation(){
    return utils.Read<Vector3>(GetMatrixOffset() + 0x290);
}
int GameUtils::GetMyTeam(){
    return utils.Read<int>(GetMyCharacter() + 0x29c);
}
UObject* GameUtils::GetPrimalGlobals(){
    return utils.Read<UObject*>(GetGEngine() + 0x1e0);
}
UObject* GameUtils::GetPrimalGameData(){
    return utils.Read<UObject*>(GetPrimalGlobals() + 0x28);
}
UObject* GameUtils::GetLevelScriptActor(){
    return utils.Read<UObject*>(GetPLevel() + 0x100);
}
UObject* GameUtils::GetDayCycleManager(){
    return utils.Read<UObject*>(GetLevelScriptActor() + 0x678);
}
UObject* GameUtils::GetMatineeActor(){
    return utils.Read<UObject*>(GetDayCycleManager() + 0x718);
}
UObject* GameUtils::GetWorldSettings(){
    return utils.Read<UObject*>(GetPLevel() + 0x300);
}
UObject* GameUtils::GetShooterGameUserSettings(){
    return utils.Read<UObject*>(GetGEngine() + 0x1A0);
}
UObject* GameUtils::GetGameStateBase(){
    return utils.Read<UObject*>(GetGWorld() + 0x160);
}
UObject* GameUtils::GetStructurePlacer(){
    return utils.Read<UObject*>(GetMyController() + 0xC50);
}
UObject* GameUtils::GetPrimalAssets(){
    return utils.Read<UObject*>(GetPrimalGlobals() + 0x38);
}
UObject* GameUtils::GetMyShooterCharacter(){
    if(GetMyController() != nullptr)
        return ReadWeakPointer(GetMyController() + 0xdc8);
        //return GameFunctions::GetPlayerCharacter(GetMyController());
    return nullptr;
}
UObject* GameUtils::GetShooterWeapon(){
    return utils.Read<UObject*>(GetMyShooterCharacter() + 0x1828);
}
UObject* GameUtils::GetMyInventory(){
    return utils.Read<UObject*>(GetMyShooterCharacter() + 0x1070);
}

bool GameUtils::isShootButtonPressed(){
    UObject* HUD = GetPlayerHUDUI();
    if(utils.isValidAdress(HUD)){
        return GameFunctions::isShootButtonHeld(HUD) || GameFunctions::isShootButtonQuickPressed(HUD);
    }
    return false;
}
bool GameUtils::isRidingDino(){ //0x15d8
    if(utils.isValidAdress(GetMyShooterCharacter())){
        return (uint8_t)(utils.Read<uint8_t>(GetMyShooterCharacter() + 0x1584)) >> 2 & 1;
    }
    return false;
}
UObject* GameUtils::GetMountedDino(){
    UObject* ShooterCharacter = GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        return ReadWeakPointer(ShooterCharacter + 0x15d8);
    }
    return nullptr;
   // if(utils.isValidAdress(GetMyShooterCharacter()) && utils.isValidAdress(GetMyCharacter()) && isRidingDino()){
   //     return GetMyCharacter();
   // }
   // return nullptr;
}
UObject* GameUtils::GetPlayerState(){
    return utils.Read<UObject*>(GetMyController() + 0x5f0);
}
long GameUtils::GetMyTribeData(){
    return (long)GetPlayerState() + 0xbe8;
}
float* GameUtils::GetViewMatrix(){
    return (float*)(GetMatrixOffset() + 0x2A0);
}
UObject* GameUtils::GetSceneComponent(){
    return utils.Read<UObject*>(GetMyCharacter() + 0x2c8);
}
Vector3 GameUtils::GetRootLocation(){
    return utils.Read<Vector3>(GetSceneComponent() + 0x290);
}


/*
 
 
 
 (long*)Object)[2]
 
 long TestTheBanCheckForAutoAimDistance = *(long*)(MyShooterWeapon + 0x10); -> Class Private
             if(IsValidAddress(TestTheBanCheckForAutoAimDistance)){
                   long TestTwoAutoAimDistance = *(long*)(TestTheBanCheckForAutoAimDistance + 0x108);
                   if(IsValidAddress(TestTwoAutoAimDistance)){
                     *(float*)(TestTwoAutoAimDistance + 0x10a4) = CurrentServer.CustomAimAssistValue;
                     *(float*)(MyShooterWeapon + 0x10a4) = CurrentServer.CustomAimAssistValue;
                 }
             }
 */
bool GameUtils::isA_Fast(UObject* Object, long Class){
    if ( (*(int*)(Class + 0x90) <= *(int*)(((long*)Object)[2] + 0x90))
        && (*(long*)(*(long*)(((long*)Object)[2] + 0x88) + *(int*)(Class + 0x90) * 8) == Class + 0x88)) {
        return true;
    }

    return false;
}


static LTMatrix MatrixMultiplication(LTMatrix pM1, LTMatrix pM2){
    LTMatrix pOut;
    pOut.a1 = pM1.a1 * pM2.a1 + pM1.a2 * pM2.b1 + pM1.a3 * pM2.c1 + pM1.a4 * pM2.d1;
    pOut.a2 = pM1.a1 * pM2.a2 + pM1.a2 * pM2.b2 + pM1.a3 * pM2.c2 + pM1.a4 * pM2.d2;
    pOut.a3 = pM1.a1 * pM2.a3 + pM1.a2 * pM2.b3 + pM1.a3 * pM2.c3 + pM1.a4 * pM2.d3;
    pOut.a4 = pM1.a1 * pM2.a4 + pM1.a2 * pM2.b4 + pM1.a3 * pM2.c4 + pM1.a4 * pM2.d4;
    pOut.b1 = pM1.b1 * pM2.a1 + pM1.b2 * pM2.b1 + pM1.b3 * pM2.c1 + pM1.b4 * pM2.d1;
    pOut.b2 = pM1.b1 * pM2.a2 + pM1.b2 * pM2.b2 + pM1.b3 * pM2.c2 + pM1.b4 * pM2.d2;
    pOut.b3 = pM1.b1 * pM2.a3 + pM1.b2 * pM2.b3 + pM1.b3 * pM2.c3 + pM1.b4 * pM2.d3;
    pOut.b4 = pM1.b1 * pM2.a4 + pM1.b2 * pM2.b4 + pM1.b3 * pM2.c4 + pM1.b4 * pM2.d4;
    pOut.c1 = pM1.c1 * pM2.a1 + pM1.c2 * pM2.b1 + pM1.c3 * pM2.c1 + pM1.c4 * pM2.d1;
    pOut.c2 = pM1.c1 * pM2.a2 + pM1.c2 * pM2.b2 + pM1.c3 * pM2.c2 + pM1.c4 * pM2.d2;
    pOut.c3 = pM1.c1 * pM2.a3 + pM1.c2 * pM2.b3 + pM1.c3 * pM2.c3 + pM1.c4 * pM2.d3;
    pOut.c4 = pM1.c1 * pM2.a4 + pM1.c2 * pM2.b4 + pM1.c3 * pM2.c4 + pM1.c4 * pM2.d4;
    pOut.d1 = pM1.d1 * pM2.a1 + pM1.d2 * pM2.b1 + pM1.d3 * pM2.c1 + pM1.d4 * pM2.d1;
    pOut.d2 = pM1.d1 * pM2.a2 + pM1.d2 * pM2.b2 + pM1.d3 * pM2.c2 + pM1.d4 * pM2.d2;
    pOut.d3 = pM1.d1 * pM2.a3 + pM1.d2 * pM2.b3 + pM1.d3 * pM2.c3 + pM1.d4 * pM2.d3;
    pOut.d4 = pM1.d1 * pM2.a4 + pM1.d2 * pM2.b4 + pM1.d3 * pM2.c4 + pM1.d4 * pM2.d4;
    
    return pOut;
}

static FTransform GetBoneIndex(UObject* mesh, int index) {
    UObject* v30 = utils.Read<UObject*>(mesh+0x980);
    UObject* boneBase = (v30 + (0x30 * index));
    FTransform result;
    if((long)boneBase>0x100000000)
    {
        result.rot.x = utils.Read<float>(boneBase + 0x0);
        result.rot.y = utils.Read<float>(boneBase + 0x4);
        result.rot.z = utils.Read<float>(boneBase + 0x8);
        result.rot.w = utils.Read<float>(boneBase + 0xC);
        CVector3 pos;
        
        pos.x = utils.Read<float>(boneBase + 0x10);
        pos.y = utils.Read<float>(boneBase + 0x14);
        pos.z = utils.Read<float>(boneBase + 0x18);
        
        result.translation.x = pos.x;
        result.translation.y = pos.y;
        result.translation.z = pos.z;
 
        
        result.scale.x = utils.Read<float>(boneBase + 0x20);
        result.scale.y = utils.Read<float>(boneBase + 0x24);
        result.scale.z = utils.Read<float>(boneBase + 0x2C);
    }
    return result;
}

LTMatrix GameUtils::GetBoneMatrix(UObject* Pawn, int BoneIndex){
    UObject* mesh = utils.Read<UObject*>(Pawn + 0x638);
    if(!utils.isValidAdress(mesh)){
        return {0};
    }
    
    FTransform bone = GetBoneIndex(mesh, BoneIndex);
    FTransform ComponentToWorld;
    ComponentToWorld.rot.x = utils.Read<float>(mesh + 0x280);
    ComponentToWorld.rot.y = utils.Read<float>(mesh + 0x284);
    ComponentToWorld.rot.z = utils.Read<float>(mesh + 0x288);
    ComponentToWorld.rot.w = utils.Read<float>(mesh + 0x28C);
    
    ComponentToWorld.translation.x = utils.Read<float>(mesh + 0x290);
    ComponentToWorld.translation.y = utils.Read<float>(mesh + 0x294);
    ComponentToWorld.translation.z = utils.Read<float>(mesh + 0x298);
    
    ComponentToWorld.scale.x = utils.Read<float>(mesh + 0x29c);
    ComponentToWorld.scale.y = utils.Read<float>(mesh + 0x2a0);
    ComponentToWorld.scale.z = utils.Read<float>(mesh + 0x2a4);
    
    LTMatrix Matrix;
    Matrix = MatrixMultiplication(bone.ToMatrixWithScale(), ComponentToWorld.ToMatrixWithScale());
    return Matrix;
}
Vector3 GameUtils::GetBoneLocation(UObject* Pawn, int BoneIndex){
    
    UObject* mesh = utils.Read<UObject*>(Pawn + 0x638);
    if(!utils.isValidAdress(mesh)){
        return {0,0,0};
    }
    Vector3 result;
    
    FTransform bone = GetBoneIndex(mesh, BoneIndex);
    FTransform ComponentToWorld;
    ComponentToWorld.rot.x = utils.Read<float>(mesh + 0x280);
    ComponentToWorld.rot.y = utils.Read<float>(mesh + 0x284);
    ComponentToWorld.rot.z = utils.Read<float>(mesh + 0x288);
    ComponentToWorld.rot.w = utils.Read<float>(mesh + 0x28C);
    
    ComponentToWorld.translation.x = utils.Read<float>(mesh + 0x290);
    ComponentToWorld.translation.y = utils.Read<float>(mesh + 0x294);
    ComponentToWorld.translation.z = utils.Read<float>(mesh + 0x298);
    
    ComponentToWorld.scale.x = utils.Read<float>(mesh + 0x29c);
    ComponentToWorld.scale.y = utils.Read<float>(mesh + 0x2a0);
    ComponentToWorld.scale.z = utils.Read<float>(mesh + 0x2a4);
    
    LTMatrix Matrix;
    Matrix = MatrixMultiplication(bone.ToMatrixWithScale(), ComponentToWorld.ToMatrixWithScale());
    
    result.X = Matrix.d1;
    result.Y = Matrix.d2;
    result.Z = Matrix.d3;
    
    return result;
}
//EActorListsBP
bool GameUtils::IsTribeAlliedWith(FTribeData* TribeData, int EnemyTeamID){
    if(0x3b9b8d50 < EnemyTeamID && utils.isValidAdress((long)TribeData)){
        TArray<FTribeAlliance> TribeAlliances = TribeData->TribeAlliances;
        if(TribeAlliances.IsValidArray()){
            for(int i = 0; i<TribeAlliances.Count; ++i){
                FTribeAlliance CurrentAlliance = TribeAlliances[i];
                if(CurrentAlliance.MemmbersTribeID.IsValidArray()){
                    for(int j = 0; j<CurrentAlliance.MemmbersTribeID.Count; ++j){
                        if(CurrentAlliance.MemmbersTribeID[j] == EnemyTeamID){
                            return true;
                        }
                    }
                }
            }
        }
    }
    return false;
}

string GameUtils::FStringToString(FString FStr){
    if(FStr.Count < 1) return "Null";
    
    std::wstring wFString = FStr.ToWString();
    NSString * objFString = [[NSString alloc] initWithBytes:wFString.data()  length:wFString.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
    return std::string([objFString UTF8String]);
}

string GameUtils::GetServerName(){
    UObject* GameState = GetGameStateBase();
    if(utils.isValidAdress(GameState)){
        FString* ServerName  = (FString*)(GameState + 0x9b8);
        return FStringToString(*ServerName);
    }
    return "None";
}

string GameUtils::GetServerIP(){
    UObject* GWorld = GetGWorld();
    if(utils.isValidAdress(GWorld)){
        FString* IP = (FString*)(GWorld + 0x940);
        int Port = utils.Read<int>(GWorld + 0x950);
        
        string ServerIP = FStringToString(*IP) + ":" + to_string(Port);
        
        string ffString = "::ffff:";
        std::size_t EndingRank = ServerIP.find(ffString);
        if (EndingRank!=std::string::npos){
            int fPos = (int)EndingRank + ffString.length();
            ServerIP = ServerIP.substr(fPos, ServerIP.length() - fPos);
        }
        
        
        return ServerIP;
    }
    return "None";
}


bool GameUtils::StringContainsString(string MainString, string Check){
    std::size_t DoesContain = MainString.find(Check);
    if (DoesContain!=std::string::npos){
        return true;
    }
    return false;
}

int GameUtils::GetPlayerID(){
    UObject* PlayerState = GetPlayerState();
    if(utils.isValidAdress(PlayerState)){
        return utils.Read<int>(PlayerState + 0x690);
    }
    return 0;
}
