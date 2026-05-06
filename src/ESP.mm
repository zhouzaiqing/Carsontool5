//
//  ESP.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"

static FRotator UE4QuaternionToEuler(const FQuat& Quat)
{
    FRotator Rotator;

    // Roll (x-axis rotation)
    float sinRoll = 2.f * (Quat.w * Quat.x + Quat.y * Quat.z);
    float cosRoll = 1.f - 2.f * (Quat.x * Quat.x + Quat.y * Quat.y);
    Rotator.Roll = atan2f(sinRoll, cosRoll);

    // Pitch (y-axis rotation)
    float sinPitch = 2.f * (Quat.w * Quat.y - Quat.z * Quat.x);
    if (fabsf(sinPitch) >= 1.f)
    {
        Rotator.Pitch = copysignf(M_PI / 2.f, sinPitch); // Use 90 degrees if out of range
    }
    else
    {
        Rotator.Pitch = asinf(sinPitch);
    }

    // Yaw (z-axis rotation)
    float sinYaw = 2.f * (Quat.w * Quat.z + Quat.x * Quat.y);
    float cosYaw = 1.f - 2.f * (Quat.y * Quat.y + Quat.z * Quat.z);
    Rotator.Yaw = atan2f(sinYaw, cosYaw);

    // Convert from radians to degrees
    Rotator.Roll *= (180.f / M_PI);
    Rotator.Pitch *= (180.f / M_PI);
    Rotator.Yaw *= (180.f / M_PI);

    return Rotator;
}




namespace StaticClassFunctions{
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

    static void (*ServerCheat)(UObject* PlayerController, FString* CheatString) = (void(*)(UObject*,FString*))utils.getOffset(0xd048c0);
    static bool (*AreTribesAllied)(long tribedata, int tribeid) = (bool (*) (long, int))utils.getOffset(0x0085d728);

}

struct ESPObject{
    UObject* Object;
    ESPTeam Team;
    float Distance;
    ImU32 DrawColor;
    string ObjectName;
};

vector<ESPObject> DinoList;
vector<UObject*> PlayerList;
vector<ESPObject> StructureList;
vector<ESPObject> ContainerList;
vector<ESPObject> BedList;
vector<ESPObject> TurretList;

static bool isA(UObject* Object, long Class){
    
    if(!utils.isObject((long)Object)) return false;
       
    if ( (*(int*)(Class + 0x90) <= *(int*)(((long*)Object)[2] + 0x90))
        && (*(long*)(*(long*)(((long*)Object)[2] + 0x88) + *(int*)(Class + 0x90) * 8) == Class + 0x88)) {
        return true;
    }

    return false;
    
}
static bool isA_Fast(UObject* Object, long Class){
    if ( (*(int*)(Class + 0x90) <= *(int*)(((long*)Object)[2] + 0x90))
        && (*(long*)(*(long*)(((long*)Object)[2] + 0x88) + *(int*)(Class + 0x90) * 8) == Class + 0x88)) {
        return true;
    }

    return false;
}

static Vector3 GetWorldLocation(UObject* Pawn){
    UObject* SceneComponent = utils.Read<UObject*>(Pawn + 0x2c8);
    return utils.Read<Vector3>(SceneComponent + 0x290);
}


static FString* (*FTextToString)(void* FTextPtr) = (FString*(*)(void*))utils.getOffset(0x0131010c);

 
static std::map<int,string> StructureNameMap;
static std::map<int,string> DinoNameMap;

static string GetStructureName(UObject* Structure){
    int Key = utils.Read<int>(Structure + 0x18);
    if(StructureNameMap.find(Key) == StructureNameMap.end()){
        FString* StructureFString = FTextToString(Structure + 0x668);
        if(!utils.isValidAdress((long)StructureFString)) return "NULL";
       
        std::wstring WStructureString = StructureFString->ToWString();
        NSString * objstr = [[NSString alloc] initWithBytes:WStructureString.data() length:WStructureString.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
        std::string StructureName = std::string([objstr UTF8String]);
        StructureNameMap[Key] = StructureName;
    }
    return StructureNameMap[Key];
}
static string GetDinoName(UObject* Dino){
    int Key = utils.Read<int>(Dino + 0x18);
    if(DinoNameMap.find(Key) == DinoNameMap.end()){
        
        FString* DinoFString = FTextToString(Dino + 0xf90);
        if(!utils.isValidAdress((long)DinoFString)) return "NULL";
        
        std::wstring WDinoString = DinoFString->ToWString();
        NSString * objstr = [[NSString alloc] initWithBytes:WDinoString.data() length:WDinoString.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
        std::string DinoName = std::string([objstr UTF8String]);
        DinoNameMap[Key] = DinoName;
    }
    return DinoNameMap[Key];
}


static void DrawHighlightedText(string Text, Vector2 Position, ImU32 color, float FontSize = ESPSize){
    if(Text.length() < 1) return;
    
    if(Position.X < -100 || Position.Y < -100 || Position.X > SCREEN_WIDTH + 100 || Position.Y > SCREEN_HEIGHT + 100) return;
    
    const char *str = Text.c_str();
    static ImU32 BlackColor = Black.toU32();
    ImVec2 vec2 = ImVec2(Position.X, Position.Y);

    ImVec2 textSize = ImGui::GetFont()->CalcTextSizeA(FontSize, MAXFLOAT, 0.0f, str);
    vec2.x -= textSize.x * 0.5f;
     
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), FontSize, ImVec2(vec2.x + 1, vec2.y + 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), FontSize, ImVec2(vec2.x + 1, vec2.y - 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), FontSize, ImVec2(vec2.x - 1, vec2.y + 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), FontSize, ImVec2(vec2.x - 1, vec2.y - 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), FontSize, vec2, color, str);
}

static void DrawNameText(string Text, Vector2 Position, ImU32 color){
    if(Text.length() < 1) return;
    
    const char *str = Text.c_str();
    static ImU32 BlackColor = Black.toU32();
    ImVec2 vec2 = ImVec2(Position.X, Position.Y);

    ImVec2 textSize = ImGui::GetFont()->CalcTextSizeA(ESPSize, MAXFLOAT, 0.0f, str);
    vec2.x -= textSize.x * 0.5f;
    vec2.y -= textSize.y;
     
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), ESPSize, ImVec2(vec2.x + 1, vec2.y + 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), ESPSize, ImVec2(vec2.x + 1, vec2.y - 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), ESPSize, ImVec2(vec2.x - 1, vec2.y + 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), ESPSize, ImVec2(vec2.x - 1, vec2.y - 1), BlackColor, str);
    ImGui::GetBackgroundDrawList()->AddText(ImGui::GetFont(), ESPSize, vec2, color, str);
}

static bool FilterContainersTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyContainers && TeamType == Team_Ally) return true;
    else if(ESPFriendlyContainers && TeamType == Team_Tribe) return true;
    return false;
}
static bool FilterTurretsTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyTurrets && TeamType == Team_Ally) return true;
    else if(ESPFriendlyTurrets && TeamType == Team_Tribe) return true;
    return false;
}
static bool FilterPlayersTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyPlayers && TeamType == Team_Ally) return true;
    else if(ESPFriendlyPlayers && TeamType == Team_Tribe) return true;
    return false;
}
static bool FilterStructuresTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyStructures && TeamType == Team_Ally) return true;
    else if(ESPFriendlyStructures && TeamType == Team_Tribe) return true;
    return false;
}
static bool FilterDinosTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyDinos && TeamType == Team_Ally) return true;
    else if(ESPFriendlyDinos && TeamType == Team_Tribe) return true;
    return false;
}
static bool FilterBedsTeam(ESPTeam TeamType){
    if(ESPShowWild && TeamType == Team_Wild) return true;
    else if(ESPShowEnemy && TeamType == Team_Enemy) return true;
    else if(ESPFriendlyBeds && TeamType == Team_Ally) return true;
    else if(ESPFriendlyBeds && TeamType == Team_Tribe) return true;
    return false;
}


static vector<int> AlliedTeamIDs;
static void UpdateAlliedTeamIDs(){
    AlliedTeamIDs.clear();
    
    FTribeData* TribeData = (FTribeData*)gameUtils.GetMyTribeData();
    if(utils.isValidAdress((long)TribeData)){
        TArray<FTribeAlliance> TribeAlliances = TribeData->TribeAlliances;
        if(TribeAlliances.IsValidArray()){
            for(int i = 0; i<TribeAlliances.Count; ++i){
                FTribeAlliance CurrentAlliance = TribeAlliances[i];
                if(CurrentAlliance.MemmbersTribeID.IsValidArray()){
                    for(int j = 0; j<CurrentAlliance.MemmbersTribeID.Count; ++j){
                        AlliedTeamIDs.push_back(CurrentAlliance.MemmbersTribeID[j]);
                    }
                }
            }
        }
    }
}
static bool isTribeAlliedToMe(int TeamID){
    std::vector<int>::iterator it;

    it = find (AlliedTeamIDs.begin(), AlliedTeamIDs.end(), TeamID);
    if (it != AlliedTeamIDs.end())
        return true;
    else
        return false;

    return 0;
}

static ImU32 GetColor(ESPTeam Team, ESPColor ColorCategory){
    if(Team == Team_Tribe){
        return ((FLinearColor)ColorCategory.Tribe).toU32();
    } else if(Team == Team_Ally){
        return ((FLinearColor)ColorCategory.Ally).toU32();
    } else if(Team == Team_Enemy){
        return ((FLinearColor)ColorCategory.Enemy).toU32();
    } else {
        return ((FLinearColor)ColorCategory.Wild).toU32();
    }
}
//IsTribeAlliedWith
static ESPTeam GetTeam(int MyTeam, int ObjectTeam, long TribeData){
    if(ObjectTeam == MyTeam){
        return Team_Tribe;
    } else if(ObjectTeam < 1000){
        return Team_Wild;
    } else if(isTribeAlliedToMe(ObjectTeam)){
         return Team_Ally;
    }
    return Team_Enemy;
}
void ESP::FilterESP(){
    static bool FilterTimer = true;
    
    if(!FilterTimer) return;
    FilterTimer = false;
    
    timer(0.4){
        FilterTimer = true;
    });
    
    
    static bool RequestShit = true;

    // ----------------------------------------------------------------------
    // VALIDATE FIRST, THEN CLEAR.
    //
    // Previously the ESP lists were cleared at the top of this function and
    // then a series of validations would early-return on transient null /
    // invalid game state (respawn, level transition, briefly null inventory,
    // etc.). Combined with the 0.4s throttle, that meant a single bad tick
    // wiped the lists and left ESP blank for at least 0.4s — sometimes much
    // longer if successive ticks also hit a bad state.
    //
    // We now gather every required pointer up front and bail out *without*
    // touching the live lists if anything is invalid. ESPMain's own isA() /
    // isObject() checks filter out any actors that have since been freed,
    // so reusing the previous frame's lists for one extra cycle is safe and
    // makes ESP visibly stable across transient invalidations.
    // ----------------------------------------------------------------------

    if(!EnableESP){
        DinoList.clear();
        PlayerList.clear();
        StructureList.clear();
        ContainerList.clear();
        BedList.clear();
        TurretList.clear();
        for(int i = 0; i<30; i++) playerArmorIcons[i].Reset();
        for(int i = 0; i<100; i++){
            BedIcons[i].frame = CGRectMake(-100, -100, 50, 50);
            InvisibleBedIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        }
        for(int i = 0; i<15; i++){
            TransferIcons[i].frame = CGRectMake(-100, -100, 50, 50);
            StealIcons[i].frame = CGRectMake(-100, -100, 50, 50);
            InvisibleTransferIcons[i].frame = CGRectMake(-100, -100, 50, 50);
            InvisibleStealIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        }
        return;
    }

    if(gameUtils.GetMyShooterCharacter() == nullptr || gameUtils.GetMyController() == nullptr){
        return;
    }

    UpdateAlliedTeamIDs();

    int MyTeamID = gameUtils.GetMyTeam();
    Vector3 MyLocation = gameUtils.GetRootLocation();
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    long MyTribeData = gameUtils.GetMyTribeData();
    float* ViewMatrix = gameUtils.GetViewMatrix();
    UObject* MyInventory = gameUtils.GetMyInventory();
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    UObject* MyCharacter = gameUtils.GetMyShooterCharacter();
    UObject* Character = gameUtils.GetMyCharacter();

    UObject* StructurePlacer = gameUtils.GetStructurePlacer();
    UObject* CurrentPlacingStructure = utils.isValidAdress(StructurePlacer)
                                          ? utils.Read<UObject*>(StructurePlacer + 0x658)
                                          : nullptr;

    if(!utils.isValidAdress(MyTribeData)) return;
    if(!utils.isValidAdress(MyInventory)) return;
    if(!TActorsArray.IsValidArray()) return;

    TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(MyInventory + 0x228);
    if(!InventoryItems.IsValidArray()) return;

    // All preconditions OK — safe to throw away the previous frame's data.
    DinoList.clear();
    PlayerList.clear();
    StructureList.clear();
    ContainerList.clear();
    BedList.clear();
    TurretList.clear();

    int BedCount = 0;

    for(int i = 0; i<30; i++){
        playerArmorIcons[i].Reset();
    }
    for(int i = 0; i<100; i++){
        BedIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        InvisibleBedIcons[i].frame = CGRectMake(-100, -100, 50, 50);
    }
    for(int i = 0; i<15; i++){
        TransferIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        StealIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        InvisibleTransferIcons[i].frame = CGRectMake(-100, -100, 50, 50);
        InvisibleStealIcons[i].frame = CGRectMake(-100, -100, 50, 50);
    }

    FItemNetID ElementNetID = 0, GasolineNetID = 0, AmmoNetID = 0;

    //Search inventory for element, gas and bullets
    for(int i = 0; i<InventoryItems.Count; ++i){
        //UObject* CurrentItem = InventoryItems[i];
        UObject* CurrentItem = InventoryItems[i];
        if(!utils.isValidAdress(CurrentItem)) continue;
        
        FItemNetID CurrentItemID = utils.Read<FItemNetID>(CurrentItem + 0x1e0);
        EPrimalItemType ItemType = utils.Read<EPrimalItemType>(CurrentItem + 0x138);
        
        if(ItemType == ItemType_Ammo && (EerieFill || AutoFill)){
            string ItemName = gameUtils.SGetObjectName(CurrentItem);
            if(ItemName == "PrimalItemAmmo_AdvancedRifleBullet_C"){
                AmmoNetID = CurrentItemID;
            }
            
        } else if (ItemType == ItemType_Resource && (TekGeneratorFill || GeneratorFill)){
            string ItemName = gameUtils.SGetObjectName(CurrentItem);
            
            if(ItemName == "PrimalItemResource_EeryElement_C" || ItemName == "PrimalItemResource_Element_C"){
                ElementNetID = CurrentItemID;
            }
            else if(ItemName == "PrimalItemResource_Gasoline_C"){
                GasolineNetID = CurrentItemID;
            }
        }
    }
    
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        //UObject* CurrentActor = TActorsArray.Data[i];
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
    
        if(isA(CurrentActor, StaticClassFunctions::ShooterCharacter())){
            if(PlayerESP){
                if(CurrentActor == MyCharacter) continue;
                PlayerList.push_back(CurrentActor);
            }
            continue;
        }

        if(!ESPHideSwitch.isOn){
            
            
            
            int ObjectTeamID = utils.Read<int>(CurrentActor + 0x29c);
            
            ESPObject newObject;
            newObject.Object = CurrentActor;
            
            ESPObject* Entity = &newObject;
             
            Vector3 ObjectLocation = GetWorldLocation(Entity->Object);
            Entity->Distance = utils.GetDistance(ObjectLocation, MyLocation);
            
            if(Entity->Distance >= ESPDistance)
                continue;
            
            Vector2 ScreenLocation = gameUtils.World2Screen(ObjectLocation, ViewMatrix);
            
            //TurretsMinimap DinosMinimap
            if((!TurretsMinimap && !DinosMinimap) || !EnableMinimap){
                if(ScreenLocation.X < -100 || ScreenLocation.Y < -100 || ScreenLocation.X > SCREEN_WIDTH + 100 || ScreenLocation.Y > SCREEN_HEIGHT + 100)
                     continue;
            }
            
            if(CurrentActor == CurrentPlacingStructure) continue;
            
            
            if(isA_Fast(CurrentActor, StaticClassFunctions::PrimalStructureTurret())){
                if(TurretESP){
                    string StructureName = GetStructureName(CurrentActor);
                    string StructureObjectName = gameUtils.SGetObjectName(CurrentActor);
                    
                    if(!(StructureObjectName == "StructureTurretPlant_C") && ESPTurretBullets)
                        StructureName = StructureName + " [" + to_string(utils.Read<int>(CurrentActor + 0x1004)) + "]";
                    
                    
                    Entity->ObjectName = StructureName;
                    Entity->Team = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
                    Entity->DrawColor = GetColor(Entity->Team, Turrets); //Colors[Entity->Team];
                    
                    
                    //Steal Ammo From Enemy Turrets
                    if(PVPAutoSteal && Entity->Distance < 12 && Entity->Team == Team_Enemy){
                        UObject* MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0xbe8);
                        if(!utils.isValidAdress(MyPrimalInventoryComponent)){
                            MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0x1de8);
                        }
                        
                        if(utils.isValidAdress(MyPrimalInventoryComponent))
                            functions.StealItems((UObject*)MyPrimalInventoryComponent);
                    }
                    
                    if(!FilterTurretsTeam(Entity->Team))
                        continue;
                    
                    TurretList.push_back(newObject);
                    
                    
                    //Turret Auto Fill
                    if(Entity->Distance < 15 && Entity->Team == Team_Tribe){
                        if(EerieFill && AmmoNetID != 0){
                            if(StructureObjectName == "StructureTurretEerie_BP_C"){
                                int AmmoAmmount = utils.Read<int>(CurrentActor + 0x1004);
                                UObject* ObjectInventory = utils.Read<UObject*>(CurrentActor + 0xbe8);
                                if(AmmoAmmount < 1 && utils.isValidAdress(ObjectInventory)){
                                    ServerTransferToRemoveInventory_Params paramaters;
                                    paramaters.InventoryComponent = ObjectInventory;
                                    paramaters.ItemID = AmmoNetID;
                                    paramaters.tryEquip = false;
                                    paramaters.RequestedQuantity = 1;
                                    paramaters.bAlsoTryUse = false;
                                    paramaters.bShowHudNotification = true;
                                    paramaters.ForceDisableSound = false;
                                    
                                    functions.ServerTransferToRemoteInventory(paramaters);
                                }
                            }
                        }
                        if(AutoFill && AmmoNetID != 0){
                            if(StructureObjectName == "StructureTurretBaseBP_C"){
                                int AmmoAmmount = utils.Read<int>(CurrentActor + 0x1004);
                                UObject* ObjectInventory = utils.Read<UObject*>(CurrentActor + 0xbe8);
                                if(AmmoAmmount < AutoAmmoFillAmmount && utils.isValidAdress(ObjectInventory)){
                                    ServerTransferToRemoveInventory_Params paramaters;
                                    paramaters.InventoryComponent = ObjectInventory;
                                    paramaters.ItemID = AmmoNetID;
                                    paramaters.tryEquip = false;
                                    paramaters.RequestedQuantity = AutoAmmoFillAmmount;
                                    paramaters.bAlsoTryUse = false;
                                    paramaters.bShowHudNotification = true;
                                    paramaters.ForceDisableSound = false;
                                    
                                    functions.ServerTransferToRemoteInventory(paramaters);
                                }
                            }
                        }
                    }
                    if(Entity->Distance < 30 && Entity->Team == Team_Tribe){
                        
                        ServerMultiUse_Params SettingParamaters;
                        SettingParamaters.ForObject =  Entity->Object;
                        SettingParamaters.ComponentIndex = 0;
                        SettingParamaters.bAllowSpam = YES;
                        SettingParamaters.ignoreDisableUse = NO;
                        
                        if(ChangeSettings){
                            //Check if turret is online
                            if(!(utils.Read<uint8_t>(Entity->Object + 0xc08) >> 4 & 1)){
                                SettingParamaters.UseIndex = 600;
                                functions.ServerMultiUse(SettingParamaters);
                            }
                            
                            SettingParamaters.UseIndex = 10016 + TurretSettingsInt;
                            functions.ServerMultiUse(SettingParamaters);
                        }
                        if(ChangeRange){
                            SettingParamaters.UseIndex = 10013 + TurretRangeInt;
                            functions.ServerMultiUse(SettingParamaters);
                        }
                        if(ChangeName){
                            float OriginY = ObjectLocation.Y - utils.Read<float>(WorldSettings + 0xa58);
                            float OriginX = ObjectLocation.X - utils.Read<float>(WorldSettings + 0xa54);
                            float Latitude = OriginY / (10 * utils.Read<float>(WorldSettings + 0xa50));
                            float Longitude = OriginX / (10 * utils.Read<float>(WorldSettings + 0xa4c));
                            functions.ChangeTurretName(Entity->Object, Latitude, Longitude);
                            
                        }
                    }
                }
    
            }
            else if(isA_Fast(CurrentActor, StaticClassFunctions::PrimalStructureItemContainer())){
                if(ContainerESP){
                    
                    Entity->ObjectName = GetStructureName(CurrentActor);
                    Entity->Team = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
                    Entity->DrawColor = GetColor(Entity->Team, Containers);
                    
                    //Generator Auto Fill, Auto Steal
                    if(Entity->Distance < 12){
                        NSString* ObjectName = gameUtils.GetObjectName(Entity->Object);
                        //Auto Open Nearby Crate Inventory
                        if(PVPDropNearby && Entity->Team == Team_Tribe && [ObjectName containsString:@"LootCrate"]){
                            UObject* ObjectInventory = utils.Read<UObject*>(CurrentActor + 0xbe8);
                            functions.OpenInventory(ObjectInventory);
                            functions.OpenInventory(CurrentActor);
                        }
                        if([ObjectName containsString:@"Generator"] || PVPStealAll){
                            if((PVPAutoSteal || PVPStealAll) && (Entity->Team == Team_Enemy || Entity->Team == Team_Wild)){
                                UObject* MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0xbe8);
                                if(!utils.isValidAdress(MyPrimalInventoryComponent)){
                                    MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0x1de8);
                                }
                                
                                if(utils.isValidAdress(MyPrimalInventoryComponent))
                                    functions.StealItems((UObject*)MyPrimalInventoryComponent);
                            }
                            if(Entity->Team == Team_Tribe && GeneratorFill && [ObjectName isEqualToString:@"ElectricGenerator_C"] && GasolineNetID != 0){
                                int FuelCounter = utils.Read<int>(CurrentActor + 0xf14);
                                UObject* ObjectInventory = utils.Read<UObject*>(CurrentActor + 0xbe8);
                                if(FuelCounter < GeneratorFillAmmount && utils.isValidAdress(ObjectInventory)){
                                    int AmmountToFill = GeneratorFillAmmount - FuelCounter;
                                    
                                    ServerTransferToRemoveInventory_Params paramaters;
                                    paramaters.InventoryComponent = ObjectInventory;
                                    paramaters.ItemID = GasolineNetID;
                                    paramaters.tryEquip = false;
                                    paramaters.RequestedQuantity = AmmountToFill;
                                    paramaters.bAlsoTryUse = false;
                                    paramaters.bShowHudNotification = true;
                                    paramaters.ForceDisableSound = false;
                                    
                                    functions.ServerTransferToRemoteInventory(paramaters);
                                }
                            }
                            if(Entity->Team == Team_Tribe && TekGeneratorFill && [ObjectName isEqualToString:@"StorageBox_TekGenerator_C"] && ElementNetID != 0){
                                int FuelCounter = utils.Read<int>(CurrentActor + 0xf14);
                                UObject* ObjectInventory = utils.Read<UObject*>(CurrentActor + 0xbe8);
                                if(FuelCounter < TekGeneratorFillAmmount && utils.isValidAdress(ObjectInventory)){
                                    int AmmountToFill = TekGeneratorFillAmmount - FuelCounter;
                                    
                                    ServerTransferToRemoveInventory_Params paramaters;
                                    paramaters.InventoryComponent = ObjectInventory;
                                    paramaters.ItemID = ElementNetID;
                                    paramaters.tryEquip = false;
                                    paramaters.RequestedQuantity = AmmountToFill;
                                    paramaters.bAlsoTryUse = false;
                                    paramaters.bShowHudNotification = true;
                                    paramaters.ForceDisableSound = false;
                                    
                                    functions.ServerTransferToRemoteInventory(paramaters);
                                }
                            }
                        }
                        else if([ObjectName isEqualToString:@"DeathItemCache_C"] && ItemCacheSteal){
                            UObject* MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0xbe8);
                            if(!utils.isValidAdress(MyPrimalInventoryComponent)){
                                MyPrimalInventoryComponent = utils.Read<UObject*>(Entity->Object + 0x1de8);
                            }
                            
                            if(utils.isValidAdress(MyPrimalInventoryComponent))
                                functions.StealItems((UObject*)MyPrimalInventoryComponent);
                        }
                    }
                    
                    if(!FilterContainersTeam(Entity->Team))
                        continue;
                    
                    ContainerList.push_back(newObject);
                    
                    
                    
                }
            }
            else if(isA_Fast(CurrentActor, StaticClassFunctions::PrimalStructureBed())){
                if(BedESP){
                    
                    string StructureName = GetStructureName(CurrentActor);
                    
                    if(ESPBedIDs)
                        StructureName = StructureName + "[" + to_string(utils.Read<int>(CurrentActor + 0xc68)) + "]";
                    
                    Entity->ObjectName = StructureName;
                    Entity->Team = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
                    Entity->DrawColor = GetColor(Entity->Team, Beds);
                    
                    if(!FilterBedsTeam(Entity->Team))
                        continue;
                    
                    BedList.push_back(newObject);
                    
                    //Bed Icons for Teleportation
                    if(BedCount < 100 && ESPBedTeleport){
                        BedIcons[BedCount].BedID = utils.Read<int>(CurrentActor + 0xc68);
                        InvisibleBedIcons[BedCount].BedID = utils.Read<int>(CurrentActor + 0xc68);
                        
                        NSString* BedName = gameUtils.GetObjectName(CurrentActor);
                        if([BedName isEqualToString:@"SleepingBag_C"]){
                            [BedIcons[BedCount] SetSleepingBag];
                        }
                        if([BedName isEqualToString:@"SimpleBed_C"]){
                            [BedIcons[BedCount] SetSimpleBed];
                        }
                        if([BedName isEqualToString:@"TekBed_C"]){
                            [BedIcons[BedCount] SetSleepingPod];
                        }
                        if([BedName isEqualToString:@"ElegantBed_C"]){
                            [BedIcons[BedCount] SetElegantBed];
                        }
                        if([BedName isEqualToString:@"ModernBed_C"]){
                            [BedIcons[BedCount] SetBunkBed];
                        }
                        
                        BedCount++;
                    }
                }
            }
            else if(isA_Fast(CurrentActor, StaticClassFunctions::PrimalStructure())){
                if(StructureESP || EnablePlacement){
                    
                    Entity->ObjectName = GetStructureName(CurrentActor);
                    Entity->Team = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
                    Entity->DrawColor = GetColor(Entity->Team, Structures);
                    
                    
                    //Auto Turret Place
                    if(EnablePlacement && Entity->Distance < PlacementRange && Entity->Team == Team_Tribe){
                        string StructureObjectName = gameUtils.SGetObjectName(CurrentActor);
                        
                        if(StructureObjectName == "SM_MetalCeilingDoorWay_Giant_BP_C" && CurrentActor != CurrentPlacingStructure){
                            
                            TArray<UObject*> LinkedStructures = utils.Read<TArray<UObject*>>(CurrentActor + 0x998);
                            Vector3 SnappedLocation;
                            
                            //Check if hatchframe is connected to a ceiling or hatchframe
                            if(LinkedStructures.IsValidArray()){
                                for(int j = 0; j<LinkedStructures.Count; ++j){
                                    UObject* CurrentLinkedStructure = LinkedStructures.Data[j];
                                    
                                    if(utils.isValidAdress(CurrentLinkedStructure)){
                                        NSString* LinkedStructureObjectName = gameUtils.GetObjectName(CurrentLinkedStructure);
                                        if([LinkedStructureObjectName containsString:@"Floor_"] || [LinkedStructureObjectName containsString:@"Ceiling_"]){
                                            UObject* LinkedSceneComponent = utils.Read<UObject*>(CurrentLinkedStructure + 0x2c8);
                                            SnappedLocation = utils.Read<Vector3>(LinkedSceneComponent + 0x290);
                                        }
                                    }
                                }
                            }
                            
                            //Calculate Placement Location
                            Vector3 DeltaDistance = ObjectLocation - SnappedLocation;
                            Vector3 NormalDistance = DeltaDistance.ToNormal();
                            Vector3 PlacementLocation = SnappedLocation + NormalDistance*770;
                            
                            //Place auto, eerie, or plant x
                            static int PlaceIndexes[] = {102,292,67};
                            functions.ForcePlaceStructureAtLocation(PlaceIndexes[PlaceOptionsInt], PlacementLocation);
                            
                        }
                    }
                    
                    
                    if(!FilterStructuresTeam(Entity->Team))
                        continue;
                    
                    if(StructureESP)
                        StructureList.push_back(newObject);
                }
            }
            else if(isA_Fast(CurrentActor, StaticClassFunctions::PrimalDinoCharacter())){
                if(DinoESP){
                    
                    if((long)CurrentActor == (long)Character) continue;
                    
                    Entity->ObjectName = GetDinoName(CurrentActor);
                    Entity->Team = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
                    Entity->DrawColor = GetColor(Entity->Team, Dinos);
                    
                    if(!FilterDinosTeam(Entity->Team))
                        continue;
                    
                    DinoList.push_back(newObject);
                    
                    // Auto Request Implant & Bed
                    if(RequestShit && Entity->Team == Team_Enemy){
                        if(PVPRequestDino)
                            functions.RequestDino(Entity->Object);
                        if(PVPRequestImplant)
                            functions.RequestImplant(Entity->Object);
                    }
                }
            }
        }
        
    }
    
    if(RequestShit){
        RequestShit = false;
        timer(10){
            RequestShit = true;
        });
    }
    
    if(PVPMagicBullet || PVPAutoFire || Aimlock){
        TargettedPlayer = aimbot.FindBestAimbotTarget();
    }
}

void ESP::ESPMain(){
    FilterESP();
    
    if(!EnableESP) return;
    
    
    int TransferCount = 0;
    
    float* ViewMatrix = gameUtils.GetViewMatrix();
    if(gameUtils.GetMyShooterCharacter() == nullptr || gameUtils.GetMyController() == nullptr || gameUtils.GetShooterHUD() == nullptr || gameUtils.GetPlayerHUDUI() == nullptr || !utils.isValidAdress(gameUtils.GetMyTribeData())){
        return;
    }
    
    for(int i = 0; i<ContainerList.size(); i++){
        ESPObject Container = ContainerList[i];
        
        if(!isA(Container.Object, StaticClassFunctions::PrimalStructureItemContainer())) continue;
        
        Vector3 WorldLocation = GetWorldLocation(Container.Object);
        Vector2 ScreenLocation = gameUtils.World2Screen(WorldLocation, ViewMatrix);
        
        DrawHighlightedText(Container.ObjectName, Vector2(ScreenLocation.X, ScreenLocation.Y), Container.DrawColor);
        
        if(Container.Distance < 15 && TransferCount < 14 && ESPContainerSteal){
            StealIcons[TransferCount].Pointer = Container.Object;
            TransferIcons[TransferCount].Pointer = Container.Object;
            [StealIcons[TransferCount] move:ScreenLocation.X y:ScreenLocation.Y];
            [TransferIcons[TransferCount] move:ScreenLocation.X y:ScreenLocation.Y];
            
            InvisibleStealIcons[TransferCount].Pointer = Container.Object;
            InvisibleTransferIcons[TransferCount].Pointer = Container.Object;
            [InvisibleStealIcons[TransferCount] move:ScreenLocation.X y:ScreenLocation.Y];
            [InvisibleTransferIcons[TransferCount] move:ScreenLocation.X y:ScreenLocation.Y];
            
            
            TransferCount++;
        }
    }
    for(int i = 0; i<BedList.size(); i++){
        ESPObject Container = BedList[i];
        
        if(!isA(Container.Object, StaticClassFunctions::PrimalStructureBed())) continue;
        
        Vector3 WorldLocation = GetWorldLocation(Container.Object);
        Vector2 ScreenLocation = gameUtils.World2Screen(WorldLocation, ViewMatrix);
        
        
        DrawHighlightedText(Container.ObjectName, Vector2(ScreenLocation.X, ScreenLocation.Y), Container.DrawColor);
        
        if(ESPBedTeleport && i < 49){
            [BedIcons[i] move:ScreenLocation.X y:ScreenLocation.Y];
            [InvisibleBedIcons[i] move:ScreenLocation.X y:ScreenLocation.Y];
        }
    }
    for(int i = 0; i<TurretList.size(); i++){
        ESPObject Turret = TurretList[i];
        
        if(!isA(Turret.Object, StaticClassFunctions::PrimalStructureTurret())) continue;
        
        Vector3 WorldLocation = GetWorldLocation(Turret.Object);
        Vector2 ScreenLocation = gameUtils.World2Screen(WorldLocation, ViewMatrix);
        
        DrawHighlightedText(Turret.ObjectName, Vector2(ScreenLocation.X, ScreenLocation.Y), Turret.DrawColor);
        Minimap::getInstance().DrawTurret(WorldLocation, Turret.DrawColor);
    }
    
    for(int i = 0; i<StructureList.size(); i++){
        ESPObject Structure = StructureList[i];
        
        if(!isA(Structure.Object, StaticClassFunctions::PrimalStructure())) continue;
        
        Vector3 WorldLocation = GetWorldLocation(Structure.Object);
        Vector2 ScreenLocation = gameUtils.World2Screen(WorldLocation, ViewMatrix);
        
        DrawHighlightedText(Structure.ObjectName, Vector2(ScreenLocation.X, ScreenLocation.Y), Structure.DrawColor);
    }
    
    for(int i = 0; i<DinoList.size(); i++){
        ESPObject Dino = DinoList[i];
        
        if(!isA(Dino.Object, StaticClassFunctions::PrimalDinoCharacter())) continue;
        
        Vector3 WorldLocation = GetWorldLocation(Dino.Object);
        Vector2 ScreenLocation = gameUtils.World2Screen(WorldLocation, ViewMatrix);
        
        DrawHighlightedText(Dino.ObjectName, Vector2(ScreenLocation.X, ScreenLocation.Y), Dino.DrawColor);
        Minimap::getInstance().DrawDinosaur(WorldLocation, Dino.DrawColor);
    }
    
    /*
     for(int i = 0; i<30; i++){
         playerArmorIcons[i].Initialize();
     }
     */
    
    int playerIconCount = 0;
    int PlayerNumber = 0;
    for(int i = 0; i<PlayerList.size(); i++){
        UObject* CurrentPlayer = PlayerList[i];
        
        if(!isA(CurrentPlayer, StaticClassFunctions::ShooterCharacter())) continue;
        
        Vector3 ObjectLocation = GetWorldLocation(CurrentPlayer);
        UObject* PrimalCharacterStatusComponent = utils.Read<UObject*>(CurrentPlayer + 0x1068);
        
        int ObjectTeamID = utils.Read<int>(CurrentPlayer + 0x29c);
        int PlayerLevel = utils.Read<int>(PrimalCharacterStatusComponent + 0x824) + utils.Read<int>(PrimalCharacterStatusComponent + 0x828);
        float Health = utils.Read<float>(CurrentPlayer + 0xc44);
        float MaxHealth = utils.Read<float>(CurrentPlayer + 0xc48);
        bool isSleeping = ((uint8_t)utils.Read<uint8_t>(CurrentPlayer + 0xb90)) & 1;
        bool isDead = Health < 0.01;//utils.Read<uint8_t>(CurrentPlayer + 0xba0) >> 6 & 1;//0xba0
        bool isAdmin = utils.Read<bool>(CurrentPlayer + 0x1c28);
        bool isAwake = !isSleeping && !isDead;
        bool isPVE = false;
        
        TArray<UObject*> BuffsArray = utils.Read<TArray<UObject*>>(CurrentPlayer + 0xac0);
        if(BuffsArray.IsValidArray()){
            for(int j = 0; j<BuffsArray.Count; ++j){
                UObject* CurrentBuff = BuffsArray.Data[j];
                if(utils.isValidAdress(CurrentBuff)){
                    if(gameUtils.SGetObjectName(CurrentBuff) == "Buff_DungeonExplore_C")
                        isPVE = true;
                }
            }
        }
        
        if(!ESPSleepingPlayers && !isAwake) continue;
        
        string PlayerName;
        
        if(isDead) PlayerName = utils.string_format("[Dead]");
        else if(isSleeping) PlayerName = utils.string_format("[Sleep]");
        else if(isAdmin)  PlayerName = utils.string_format("[Admin]");
        else if(isPVE)  PlayerName = utils.string_format("[PVE]");
        else PlayerName = utils.string_format("Lvl %d-", PlayerLevel);
        
        FString* FPlayerName = (FString*)(CurrentPlayer + 0x15c8);
        FString* FTribeName = (FString*)(CurrentPlayer + 0xad0);
        
        Vector3 DrawBottomMiddleLocation = {ObjectLocation.X, ObjectLocation.Y, ObjectLocation.Z + 80};
        Vector2 DrawBottomMiddleScreenLocation = gameUtils.World2Screen(DrawBottomMiddleLocation, ViewMatrix);
        Vector2 NameTextPosition = DrawBottomMiddleScreenLocation;
        
        if(ESPPlayerName && FPlayerName->Count > 1){
            std::wstring wPlayerName = FPlayerName->ToWString();
            NSString * objPlayerName = [[NSString alloc] initWithBytes:wPlayerName.data()  length:wPlayerName.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
            PlayerName = PlayerName + std::string([objPlayerName UTF8String]);
        }
        if(ESPTribeName && FTribeName->Count > 1){
            std::wstring wTribeName = FTribeName->ToWString();
            NSString * objTribeName = [[NSString alloc] initWithBytes:wTribeName.data()  length:wTribeName.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
            PlayerName = PlayerName + "\n" + std::string([objTribeName UTF8String]);
        }
        
        
        
        if(ESPHealthBar && isAwake){
            float HealthBarWidth = 90;
            float HealthBarHeight = 10;
            float HealthPercent = Health/MaxHealth;
            
            ImVec2 HealthBarStartLocation = ImVec2(DrawBottomMiddleScreenLocation.X - HealthBarWidth/2, DrawBottomMiddleScreenLocation.Y - HealthBarHeight);
            ImGui::GetBackgroundDrawList()->AddRectFilled(HealthBarStartLocation, ImVec2(HealthBarStartLocation.x + HealthBarWidth, HealthBarStartLocation.y + HealthBarHeight), Black.toU32(), 0, 0);
            
            ImVec2 HealthRedStartLocation = ImVec2(HealthBarStartLocation.x + 0.5, HealthBarStartLocation.y + 0.5);
            ImGui::GetBackgroundDrawList()->AddRectFilled(HealthRedStartLocation, ImVec2(HealthBarStartLocation.x + HealthPercent * HealthBarWidth - 1, HealthBarStartLocation.y + HealthBarHeight - 1), Red.toU32(), 0, 0);
            
            NameTextPosition.Y -= 15;
        }
        
        int MyTeamID = gameUtils.GetMyTeam();
        long MyTribeData = gameUtils.GetMyTribeData();
        
        
        ESPTeam PlayerTeam = GetTeam(MyTeamID, ObjectTeamID, MyTribeData);
        ImU32 DrawColor = GetColor(PlayerTeam, Players);
        
        if(ESPTopLine && isAwake && PlayerTeam == Team_Enemy){
            ImVec2 ScreenTop = ImVec2(SCREEN_WIDTH/2, 40);
            ImGui::GetBackgroundDrawList()->AddLine(ScreenTop, ImVec2(NameTextPosition.X, NameTextPosition.Y), DrawColor, 0.75f);
            
            
            
        }
        
        if(isAwake){
            if(playerIconCount < 30){
                playerArmorIcons[playerIconCount].DrawForPlayer(DrawBottomMiddleScreenLocation, CurrentPlayer);
                playerIconCount++;
            }
            //playerArmorIcons
        }
        
        if(isAwake && PlayerTeam == Team_Enemy) PlayerNumber++;
        
        if(ESPPlayerName || ESPTribeName){
            DrawNameText(PlayerName, NameTextPosition, DrawColor);
        }
        
        if(isAwake){
            Minimap::getInstance().DrawPlayer(ObjectLocation, PlayerTeam);
        }
        
        if(((isDead || (!isAwake && PlayerTeam == Team_Enemy)) && PVPStealAll) || (isDead && PlayerTeam == Team_Enemy && ItemCacheSteal))
        {
            float PlayerDistance = utils.GetDistance(ObjectLocation, gameUtils.GetRootLocation());
            if(PlayerDistance < 12)
            {
                UObject* StealComponent = utils.Read<UObject*>(CurrentPlayer + 0x1de8);
                
                if(utils.isValidAdress(StealComponent))
                    functions.StealItems(StealComponent);
            }
        }
        
        if((PVPAutoFire && AutoShootSwitch.isOn) || PVPMagicBullet){
            if(CurrentPlayer == TargettedPlayer){
                /*
                 //Begin Calculations
                 UObject* EnemySceneComponent = utils.Read<UObject*>(Target + 0x2c8);
                 Vector3 EnemyLocation = utils.Read<Vector3>(EnemySceneComponent + 0x290);
                 
                 //struct UCharacterMovementComponent* CharacterMovement; // Offset: 0x640 // Size: 0x08
                
                
                UObject* EnemyMovementComponent = utils.Read<UObject*>(CurrentPlayer + 0x640);
                Vector3 EnemyVelocity = utils.Read<Vector3>(EnemyMovementComponent + 0x1fc);
                ObjectLocation = {ObjectLocation.X + EnemyVelocity.X * 1/20.f, ObjectLocation.Y + EnemyVelocity.Y * 1/20.f, ObjectLocation.Z + EnemyVelocity.Z * 1/20.f};
                
                Vector2 ObjetMagicBulletWorldLocation = gameUtils.World2Screen(ObjectLocation, ViewMatrix);
                ImVec2 CircleLocation = ImVec2(ObjetMagicBulletWorldLocation.X, ObjetMagicBulletWorldLocation.Y);
                
                */
                ImVec2 CircleLocation = ImVec2(DrawBottomMiddleScreenLocation.X, DrawBottomMiddleScreenLocation.Y);
                ImGui::GetBackgroundDrawList()->AddCircleFilled(CircleLocation, 5, Yellow.toU32(), 15);
            }
        }
    }
    
    if(ESPPlayerNumber){
        string PlayerNumberString = utils.string_format("%d", PlayerNumber);
        DrawHighlightedText(PlayerNumberString, Vector2(SCREEN_WIDTH/2, 20), Red.toU32(), 20);
    }
    
    if(TargettedPlayer != nullptr)
    {
        if(PVPMagicBullet || Aimlock)
        {
            aimAssist.HandleAimAssist(TargettedPlayer);
        }
    }
    
    if(ESPGPS){
        Vector3 MyLocation = gameUtils.GetMyLocation();
        UObject* WorldSettings = gameUtils.GetWorldSettings();
        
        float OriginY = MyLocation.Y - utils.Read<float>(WorldSettings + 0xa58);
        float OriginX = MyLocation.X - utils.Read<float>(WorldSettings + 0xa54);
        float Latitude = OriginY / (10 * utils.Read<float>(WorldSettings + 0xa50));
        float Longitude = OriginX / (10 * utils.Read<float>(WorldSettings + 0xa4c));
        
        string CoordinatesString = utils.string_format("LAT %.1f LONG %.1f", Latitude, Longitude);
        DrawHighlightedText(CoordinatesString, Vector2(SCREEN_WIDTH/2 , SCREEN_HEIGHT * 4/5), White.toU32(), 15);
    }
    
    
}
