//
//  prefs.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/8/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"

#define AddDefault(name, pointer, type) preferences.AddEntry(name, pointer, type)

bool StayOnWhitePlatform = false;
static bool hasLaunchedBefore = false;
bool StreamerMode = false;
bool MoveableMenu = false;
int LanguageValue = 0;
string CarsontoolCode = "None";
string AuthString = "Not Logged In";
bool UnlockEngrams = false;
bool AutoMountBallista = false;
bool EnableBallistaPlace = false;
bool AutoPlaceBearTraps = false;
int AutoPlaceBearTrapInt = 0;

bool ItemCacheSteal = false;
bool PlayerViewDirection = false;

float GameFPS = 120;
float WeaponColorIntensity = 1;
float WaterColorIntesnity = 1;
float PlayerColorIntensity = 5;

int PlayerRainbowCycleTime = 10;

bool ChangeBodyColor = false;
bool ChangeHairColor = false;
bool RainbowHair = false;
bool RainbowBody;
bool PlayerWireframe = false;

FLinearColor BodyColor = Red;
FLinearColor HairColor = Red;


bool AutoBallistaInvisiblity = false;


bool ChangeWorld = false;
bool RemoveKnockoutBlur = false;
bool RemoveScopeTexture = false;
bool RainbowWater = false;
bool WeaponWireframe = false;
bool WaterWireframe = false;
bool SkyWireframe = false;
bool ChangeWaterColor = false;
FLinearColor WaterColor = Blue;

bool ESPBedIDs = false;
bool ESPArmorIcons = false;
bool ESPArmorIconDura = false;
bool ESPWeaponIcon = false;

bool EnableWeaponColorChange = false;
bool EnableHeldWeaponDetailedChange = false;
bool HeldWeaponRainbow = false;
FLinearColor HeldWeaponColor = Red;
int SelectedDye = 0;

bool EnableDinoColorChange = false;
bool DinoWireframe = false;
bool DinoEery = false;


FLinearColor DustRegionOne = FLinearColor(0,0,0,1);
FLinearColor DustRegionTwo = FLinearColor(0,0,0,1);
FLinearColor DustRegionThree = FLinearColor(0,0,0,1);

bool DustRegionOneRainbow = false;
bool DustRegionTwoRainbow = false;
bool DustRegionThreeRainbow = false;

int RainbowCycleTime = 10;

float ColorizationIntensity = 1;

float ColorRegionOneIntensity = 1.f;
float ColorRegionTwoIntensity = 1.f;
float ColorRegionThreeIntensity = 1.f;
float ColorRegionFourIntensity = 1.f;
float ColorRegionFiveIntensity = 1.f;
float ColorRegionSixIntensity = 1.f;

int ColorRegionOneColorIndex = 1;
int ColorRegionTwoColorIndex = 1;
int ColorRegionThreeColorIndex = 1;
int ColorRegionFourColorIndex = 1;
int ColorRegionFiveColorIndex = 1;
int ColorRegionSixColorIndex = 1;

 
ESPColor Dinos = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};
ESPColor Players = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};
ESPColor Structures = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};
ESPColor Containers = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};
ESPColor Beds = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};
ESPColor Turrets = {{0,1,0,1},{0,0,1,1},{1,0,0,1},{1,0,1,1}};

bool FetchPlayerInfo = false;
int PlayerListFilterIndex = 0;
int PlayerListDisplayIndex = 0;


bool RapidSpin = false;
bool PlayerESP;
bool DinoESP;
bool StructureESP;
bool ContainerESP;

float Speed = 1;
float LocalSpeed = 1;
float TimeOfDay = 5;
float FOV = 1.25;
float FarView = 300;
float ESPSize = 15;
int MenuFPS = 30;
float ESPDistance = 500;

BedIcon* InvisibleBedIcons[100];
StealButton* InvisibleStealIcons[15];
TransferButton* InvisibleTransferIcons[15];

BedIcon* BedIcons[100];
StealButton* StealIcons[15];
TransferButton* TransferIcons[15];
class ArmorIcons playerArmorIcons[30];


bool TopRightESPToggle = false;

int TargettingIndex = 0;
bool PVPMagicBullet;
bool PVPAutoFire;
bool PVPInfinitePistol;
bool PVPProjectileSpam;
bool PVPAutoArmor;
bool PVPAutoMed;
bool PVPAutoStam;
bool PVPUWShoot;
bool PVPInfiniteC4;
bool PVPExplosions;
bool PVPAutoSteal;
bool PVPAutoDrop;
bool PVPRocketSpam;
bool PVPRocketSpread;
bool PVPDinoSpin;
bool PVPInstantTurn;
bool PVPStrafing;
bool PVPAutoEat;
bool PVPForceFeed;
bool PVPGhost;
bool PVPHideLogin;
bool PVPChatSpam;
bool PVPRequestDino;
bool PVPRequestImplant;
bool PVPSpeedZero;
bool PVPStealAll;
bool PVPTameShooting;


bool EnableESP;
bool BedESP;
bool TurretESP;
bool ESPShowTribe;
bool ESPShowAlly;
bool ESPShowEnemy;
bool ESPShowWild;
bool ESPContainerSteal;
bool ESPBedTeleport;
bool ESPTurretRange;
bool ESPTurretBullets;
bool ESPPlayerNumber;
bool ESPPlayerName;
bool ESPTribeName;
bool ESPHealthBar;
bool ESPTopLine;
bool ESPBottomLine;
bool ESPSleepingPlayers;
bool ESPGPS;
bool ESPFriendlyContainers;
bool ESPFriendlyTurrets;
bool ESPFriendlyPlayers;
bool ESPFriendlyStructures;
bool ESPFriendlyDinos;
bool ESPFriendlyBeds;

float StructurePitch;
float StructureYaw;
float StructureRoll;
bool EnablePitch;
bool EnableYaw;
bool EnableRoll;

int PlaceOptionsInt = 1;
float PlacementRange = 1;
bool EnablePlacement = false;

bool ChangeRange = false;
bool ChangeSettings = false;
bool ChangeName = false;

bool EerieFill = false;
bool AutoFill = false;
bool TekGeneratorFill = false;
bool GeneratorFill = false;

int AutoAmmoFillAmmount = 1;
int TekGeneratorFillAmmount = 1;
int GeneratorFillAmmount = 1;

int TurretRangeInt = 1;
int TurretSettingsInt = 1;

bool EnableDupe;
bool Floaters;
bool PlaceBlueprints;

bool StationPurchase;
bool AmberPurhcase;
int StationPurchaseAmmount;
int AmberPurchaseAmmount;

string DungeonName = "null";
int CrosshairTypeInt = 0;


bool EnableCustomCrosshair = false;
float CircleRadius = 0;
float CircleWidth = 0;
float CircleColor[4] = {1,0,0,1};

float PlusMiddleSpacing = 0;
float PlusLength = 0;
float PlusWidth = 0;
float PlusColor[4] = {1,0,0,1};

bool PlusMiddleDot = false;
float PlusMiddleDotRadius = 0;
float PlusMiddleDotColor[4] = {1,0,0,1};

float XWidth = 0;
float XLength = 0;
float XColor[4] = {1,0,0,1};

float CarrotWidth = 0;
float CarrotLength = 0;
float CarrotColor[4] = {1,0,0,1};

bool Aimlock = false;
bool CustomAimlockSettings = false;
bool CustomMagicBulletSettings = false;
float TargetBoneHitChance = 100;

bool SlowDinos = true;

bool showMagicCircle = false;
float MagicCircleSize = 50;

float AimlockSpeed = 100;
bool AimlockToggleSwitch = false;
bool showAimlockCircle = false;
float AimlockCircleSize = 200;

float AimlockCircleColor[4] = {1,1,1,1};
float MagicCircleColor[4] = {1,1,1,1};

bool PVPBoomBoom = false;
bool PVPAutoLauncher = false;

bool EnableMinimap = false;
bool MoveMinimap = false;
bool PlayersMinimap = false;
bool DinosMinimap = false;
bool TurretsMinimap = false;
Vector2 MapOrigin = Vector2(0,0);
float MapTransformScale = 1;

bool PVPDropNearby = false;
bool IgnoreShots = true;

bool PickupNearbyStructures = false;
bool DestroyNearbyStructures = false;

bool MultiUsePickupItemCache = false;
bool MultiUsePickupFoundation = false;
bool MultiUsePickupTurrets = false;
bool MultiUsePickupStructures = false;

bool DemolishTargetAutmoatically = false;
bool PickupTargetAutomatically = false;
bool DemolishTargetPunching = false;
bool PickupTargetPunching = false;

bool ClaimAllDinos = false;
bool ClaimTargetDino = false;
bool KillAllDinos = false;

/*
 static bool Aimlock = false;
 static bool CustomAimlockSettings = false;
 static bool CustomMagicBulletSettings = false;
 static float TargetBoneHitChance = 1;

 bool SlowDinos = true;

 bool showMagicCircle = false;
 float MagicCircleSize = 50;

 float AimlockSpeed = 100;
 bool AimlockToggleSwitch = false;
 bool showAimlockCircle = false;
 float AimlockCircleSize = 200;

 float AimlockCircleColor[4] = {1,1,1,1};
 float MagicCircleColor[4] = {1,1,1,1};
 */


static bool CheckHasLaunched(){
    AddDefault("hasLaunchedBefore", &hasLaunchedBefore, Type_Bool);
    preferences.LoadDefaults();
    return preferences.GetBool("hasLaunchedBefore");
}


void Pref::InitPref(){
    //Set Encryption Settings, enable or disable it.
    preferences.SetEncryptNames(YES);
    preferences.SetEncryptValues(YES);
    preferences.SetValueEncryptionKey(@"ValueEncry");
    preferences.SetPreferenceNameEncryptionKey(@"PrefEncry");
    
    bool hasLaunched = CheckHasLaunched();
    
    AddDefault("DungeonName", &DungeonName, Type_String);
    
    AddDefault("DinosTribeColor", &Dinos.Tribe, Type_FloatFour);
    AddDefault("DinosAllyColor", &Dinos.Ally, Type_FloatFour);
    AddDefault("DinosWildColor", &Dinos.Wild, Type_FloatFour);
    AddDefault("DinosEnemyColor", &Dinos.Enemy, Type_FloatFour);
    
    AddDefault("PlayersTribeColor", &Players.Tribe, Type_FloatFour);
    AddDefault("PlayersAllyColor", &Players.Ally, Type_FloatFour);
    AddDefault("PlayersWildColor", &Players.Wild, Type_FloatFour);
    AddDefault("PlayersEnemyColor", &Players.Enemy, Type_FloatFour);
    
    AddDefault("StructuresTribeColor", &Structures.Tribe, Type_FloatFour);
    AddDefault("StructuresAllyColor", &Structures.Ally, Type_FloatFour);
    AddDefault("StructuresWildColor", &Structures.Wild, Type_FloatFour);
    AddDefault("StructuresEnemyColor", &Structures.Enemy, Type_FloatFour);
    
    AddDefault("ContainersTribeColor", &Containers.Tribe, Type_FloatFour);
    AddDefault("ContainersAllyColor", &Containers.Ally, Type_FloatFour);
    AddDefault("ContainersWildColor", &Containers.Wild, Type_FloatFour);
    AddDefault("ContainersEnemyColor", &Containers.Enemy, Type_FloatFour);
    
    AddDefault("BedsTribeColor", &Beds.Tribe, Type_FloatFour);
    AddDefault("BedsAllyColor", &Beds.Ally, Type_FloatFour);
    AddDefault("BedsWildColor", &Beds.Wild, Type_FloatFour);
    AddDefault("BedsEnemyColor", &Beds.Enemy, Type_FloatFour);
    
    AddDefault("TurretsTribeColor", &Turrets.Tribe, Type_FloatFour);
    AddDefault("TurretsAllyColor", &Turrets.Ally, Type_FloatFour);
    AddDefault("TurretsWildColor", &Turrets.Wild, Type_FloatFour);
    AddDefault("TurretsEnemyColor", &Turrets.Enemy, Type_FloatFour);
    
    AddDefault("Speed", &Speed, Type_Float);
    AddDefault("LocalSpeed", &LocalSpeed, Type_Float);
    AddDefault("TimeOfDay", &TimeOfDay, Type_Float);
    AddDefault("FOV", &FOV, Type_Float);
    AddDefault("FarView", &FarView, Type_Float);
    AddDefault("ESPSize", &ESPSize, Type_Float);
    AddDefault("ESPDistance", &ESPDistance, Type_Float);
    AddDefault("StructurePitch", &StructurePitch, Type_Float);
    AddDefault("StructureYaw", &StructureYaw, Type_Float);
    AddDefault("StructureRoll", &StructureRoll, Type_Float);
    AddDefault("PlacementRange", &PlacementRange, Type_Float);
    
    AddDefault("MenuFPS", &MenuFPS, Type_Int);
    AddDefault("PlaceOptionsInt", &PlaceOptionsInt, Type_Int);
    AddDefault("AutoAmmoFillAmmount", &AutoAmmoFillAmmount, Type_Int);
    AddDefault("TekGeneratorFillAmmount", &TekGeneratorFillAmmount, Type_Int);
    AddDefault("GeneratorFillAmmount", &GeneratorFillAmmount, Type_Int);
    AddDefault("TurretRangeInt", &TurretRangeInt, Type_Int);
    AddDefault("TurretSettingsInt", &TurretSettingsInt, Type_Int);
    AddDefault("StationPurchaseAmmount", &StationPurchaseAmmount, Type_Int);
    AddDefault("AmberPurchaseAmmount", &AmberPurchaseAmmount, Type_Int);
    
    
    AddDefault("ESPFriendlyContainers", &ESPFriendlyContainers, Type_Bool);
    AddDefault("ESPFriendlyTurrets", &ESPFriendlyTurrets, Type_Bool);
    AddDefault("ESPFriendlyPlayers", &ESPFriendlyPlayers, Type_Bool);
    AddDefault("ESPFriendlyStructures", &ESPFriendlyStructures, Type_Bool);
    AddDefault("ESPFriendlyDinos", &ESPFriendlyDinos, Type_Bool);
    AddDefault("ESPFriendlyBeds", &ESPFriendlyBeds, Type_Bool);
    
    AddDefault("PVPStealAll", &PVPStealAll, Type_Bool);
    AddDefault("PVPTameShooting", &PVPTameShooting, Type_Bool);
    
    AddDefault("PlayerESP", &PlayerESP, Type_Bool);
    AddDefault("DinoESP", &DinoESP, Type_Bool);
    AddDefault("StructureESP", &StructureESP, Type_Bool);
    AddDefault("ContainerESP", &ContainerESP, Type_Bool);
    AddDefault("EnableESP", &EnableESP, Type_Bool);
    AddDefault("BedESP", &BedESP, Type_Bool);
    AddDefault("TurretESP", &TurretESP, Type_Bool);
    AddDefault("ESPShowTribe", &ESPShowTribe, Type_Bool);
    AddDefault("ESPShowAlly", &ESPShowAlly, Type_Bool);
    AddDefault("ESPShowEnemy", &ESPShowEnemy, Type_Bool);
    AddDefault("ESPShowWild", &ESPShowWild, Type_Bool);
    AddDefault("ESPContainerSteal", &ESPContainerSteal, Type_Bool);
    AddDefault("ESPBedTeleport", &ESPBedTeleport, Type_Bool);
    AddDefault("ESPTurretRange", &ESPTurretRange, Type_Bool);
    AddDefault("ESPTurretBullets", &ESPTurretBullets, Type_Bool);
    AddDefault("ESPPlayerNumber", &ESPPlayerNumber, Type_Bool);
    AddDefault("ESPPlayerName", &ESPPlayerName, Type_Bool);
    AddDefault("ESPTribeName", &ESPTribeName, Type_Bool);
    AddDefault("ESPHealthBar", &ESPHealthBar, Type_Bool);
    AddDefault("ESPTopLine", &ESPTopLine, Type_Bool);
    AddDefault("ESPBottomLine", &ESPBottomLine, Type_Bool);
    AddDefault("ESPSleepingPlayers", &ESPSleepingPlayers, Type_Bool);
    AddDefault("ESPGPS", &ESPGPS, Type_Bool);
    AddDefault("EnablePitch", &EnablePitch, Type_Bool);
    AddDefault("EnableYaw", &EnableYaw, Type_Bool);
    AddDefault("EnableRoll", &EnableRoll, Type_Bool);
    AddDefault("EnablePlacement", &EnablePlacement, Type_Bool);
    AddDefault("ChangeRange", &ChangeRange, Type_Bool);
    AddDefault("ChangeSettings", &ChangeSettings, Type_Bool);
    AddDefault("ChangeName", &ChangeName, Type_Bool);
    AddDefault("EerieFill", &EerieFill, Type_Bool);
    AddDefault("AutoFill", &AutoFill, Type_Bool);
    AddDefault("TekGeneratorFill", &TekGeneratorFill, Type_Bool);
    AddDefault("GeneratorFill", &GeneratorFill, Type_Bool);
    AddDefault("EnableDupe", &EnableDupe, Type_Bool);
    AddDefault("Floaters", &Floaters, Type_Bool);
    AddDefault("PlaceBlueprints", &PlaceBlueprints, Type_Bool);
    AddDefault("StationPurchase", &StationPurchase, Type_Bool);
    AddDefault("AmberPurhcase", &AmberPurhcase, Type_Bool);
    AddDefault("PVPMagicBullet", &PVPMagicBullet, Type_Bool);
    AddDefault("PVPAutoFire", &PVPAutoFire, Type_Bool);
    AddDefault("PVPInfinitePistol", &PVPInfinitePistol, Type_Bool);
    AddDefault("PVPProjectileSpam", &PVPProjectileSpam, Type_Bool);
    AddDefault("PVPAutoArmor", &PVPAutoArmor, Type_Bool);
    AddDefault("PVPAutoMed", &PVPAutoMed, Type_Bool);
    AddDefault("PVPAutoStam", &PVPAutoStam, Type_Bool);
    AddDefault("PVPUWShoot", &PVPUWShoot, Type_Bool);
    AddDefault("PVPInfiniteC4", &PVPInfiniteC4, Type_Bool);
    AddDefault("PVPExplosions", &PVPExplosions, Type_Bool);
    AddDefault("PVPAutoSteal", &PVPAutoSteal, Type_Bool);
    AddDefault("PVPAutoDrop", &PVPAutoDrop, Type_Bool);
    AddDefault("PVPRocketSpam", &PVPRocketSpam, Type_Bool);
    AddDefault("PVPRocketSpread", &PVPRocketSpread, Type_Bool);
    AddDefault("PVPDinoSpin", &PVPDinoSpin, Type_Bool);
    AddDefault("PVPInstantTurn", &PVPInstantTurn, Type_Bool);
    AddDefault("PVPStrafing", &PVPStrafing, Type_Bool);
    AddDefault("PVPAutoEat", &PVPAutoEat, Type_Bool);
    AddDefault("PVPForceFeed", &PVPForceFeed, Type_Bool);
    AddDefault("PVPGhost", &PVPGhost, Type_Bool);
    AddDefault("PVPHideLogin", &PVPHideLogin, Type_Bool);
    AddDefault("PVPChatSpam", &PVPChatSpam, Type_Bool);
    AddDefault("PVPRequestDino", &PVPRequestDino, Type_Bool);
    AddDefault("PVPRequestImplant", &PVPRequestImplant, Type_Bool);
    AddDefault("PVPSpeedZero", &PVPSpeedZero, Type_Bool);
    
    AddDefault("TargettingIndex", &TargettingIndex, Type_Int);
    
    AddDefault("FetchPlayerInfo", &FetchPlayerInfo, Type_Bool);
    AddDefault("PlayerListFilterIndex", &PlayerListFilterIndex, Type_Int);
    AddDefault("PlayerListDisplayIndex", &PlayerListDisplayIndex, Type_Int);
    
    
    
    AddDefault("CrosshairTypeInt", &CrosshairTypeInt, Type_Int);
    AddDefault("EnableCustomCrosshair", &EnableCustomCrosshair, Type_Bool);
    AddDefault("PlusMiddleDot", &PlusMiddleDot, Type_Bool);
    
    
    AddDefault("CircleRadius", &CircleRadius, Type_Float);
    AddDefault("CircleWidth", &CircleWidth, Type_Float);
    AddDefault("PlusMiddleSpacing", &PlusMiddleSpacing, Type_Float);
    AddDefault("PlusLength", &PlusLength, Type_Float);
    AddDefault("PlusWidth", &PlusWidth, Type_Float);
    AddDefault("PlusMiddleDotRadius", &PlusMiddleDotRadius, Type_Float);
    AddDefault("XWidth", &XWidth, Type_Float);
    AddDefault("XLength", &XLength, Type_Float);
    AddDefault("CarrotWidth", &CarrotWidth, Type_Float);
    AddDefault("CarrotLength", &CarrotLength, Type_Float);
    AddDefault("CircleColor", &CircleColor, Type_FloatFour);
    AddDefault("PlusColor", &PlusColor, Type_FloatFour);
    AddDefault("PlusMiddleDotColor", &PlusMiddleDotColor, Type_FloatFour);
    AddDefault("XColor", &XColor, Type_FloatFour);
    AddDefault("CarrotColor", &CarrotColor, Type_FloatFour);
    
    /*
     FLinearColor DustRegionOne = FLinearColor(0,0,0,1);
     FLinearColor DustRegionTwo = FLinearColor(0,0,0,1);
     FLinearColor DustRegionThree = FLinearColor(0,0,0,1);
     */
    AddDefault("DustRegionOne", &DustRegionOne.r, Type_FloatFour);
    AddDefault("DustRegionTwo", &DustRegionTwo.r, Type_FloatFour);
    AddDefault("DustRegionThree", &DustRegionThree.r, Type_FloatFour);
    
    
    
    
    
    
    AddDefault("RainbowCycleTime", &RainbowCycleTime, Type_Int);
    AddDefault("ColorizationIntensity", &ColorizationIntensity, Type_Float);
    AddDefault("ColorRegionOneIntensity", &ColorRegionOneIntensity, Type_Float);
    AddDefault("ColorRegionTwoIntensity", &ColorRegionTwoIntensity, Type_Float);
    AddDefault("ColorRegionThreeIntensity", &ColorRegionThreeIntensity, Type_Float);
    AddDefault("ColorRegionFourIntensity", &ColorRegionFourIntensity, Type_Float);
    AddDefault("ColorRegionFiveIntensity", &ColorRegionFiveIntensity, Type_Float);
    AddDefault("ColorRegionSixIntensity", &ColorRegionSixIntensity, Type_Float);
    
    
    AddDefault("ColorRegionOneColorIndex", &ColorRegionOneColorIndex, Type_Int);
    AddDefault("ColorRegionTwoColorIndex", &ColorRegionTwoColorIndex, Type_Int);
    AddDefault("ColorRegionThreeColorIndex", &ColorRegionThreeColorIndex, Type_Int);
    AddDefault("ColorRegionFourColorIndex", &ColorRegionFourColorIndex, Type_Int);
    AddDefault("ColorRegionFiveColorIndex", &ColorRegionFiveColorIndex, Type_Int);
    AddDefault("ColorRegionSixColorIndex", &ColorRegionSixColorIndex, Type_Int);
    
    AddDefault("EnableDinoColorChange", &EnableDinoColorChange, Type_Bool);
    AddDefault("DinoWireframe", &DinoWireframe, Type_Bool);
    AddDefault("DinoEery", &DinoEery, Type_Bool);
    AddDefault("DustRegionOneRainbow", &DustRegionOneRainbow, Type_Bool);
    AddDefault("DustRegionTwoRainbow", &DustRegionTwoRainbow, Type_Bool);
    AddDefault("DustRegionThreeRainbow", &DustRegionThreeRainbow, Type_Bool);
    
    
    AddDefault("EnableWeaponColorChange", &EnableWeaponColorChange, Type_Bool);
    AddDefault("EnableHeldWeaponDetailedChange", &EnableHeldWeaponDetailedChange, Type_Bool);
    AddDefault("HeldWeaponRainbow", &HeldWeaponRainbow, Type_Bool);
    AddDefault("HeldWeaponColorHeldWeaponColor", &DustRegionThree.r, Type_FloatFour);
    AddDefault("SelectedDye", &SelectedDye, Type_Int);
    
    AddDefault("ESPArmorIcons", &ESPArmorIcons, Type_Bool);
    AddDefault("ESPArmorIconDura", &ESPArmorIconDura, Type_Bool);
    AddDefault("ESPWeaponIcon", &ESPWeaponIcon, Type_Bool);
    
    AddDefault("ChangeWorld", &ChangeWorld, Type_Bool);
    AddDefault("RemoveKnockoutBlur", &RemoveKnockoutBlur, Type_Bool);
    AddDefault("RemoveScopeTexture", &RemoveScopeTexture, Type_Bool);
    AddDefault("RainbowWater", &RainbowWater, Type_Bool);
    AddDefault("WeaponWireframe", &WeaponWireframe, Type_Bool);
    AddDefault("WaterWireframe", &WaterWireframe, Type_Bool);
    AddDefault("SkyWireframe", &SkyWireframe, Type_Bool);
    AddDefault("ChangeWaterColor", &ChangeWaterColor, Type_Bool);
    AddDefault("WaterColor", &WaterColor.r, Type_FloatFour);
    AddDefault("ESPBedIDs", &ESPBedIDs, Type_Bool);
    
    AddDefault("ItemCacheSteal", &ItemCacheSteal, Type_Bool);
    AddDefault("PlayerViewDirection", &PlayerViewDirection, Type_Bool);
    
    
    
    AddDefault("ChangeBodyColor", &ChangeBodyColor, Type_Bool);
    AddDefault("ChangeHairColor", &ChangeHairColor, Type_Bool);
    AddDefault("RainbowHair", &RainbowHair, Type_Bool);
    AddDefault("RainbowBody", &RainbowBody, Type_Bool);
    AddDefault("PlayerWireframe", &PlayerWireframe, Type_Bool);
    
    AddDefault("WeaponColorIntensity", &WeaponColorIntensity, Type_Float);
    AddDefault("WaterColorIntesnity", &WaterColorIntesnity, Type_Float);
    AddDefault("PlayerColorIntensity", &PlayerColorIntensity, Type_Float);
    
    AddDefault("PlayerRainbowCycleTime", &PlayerRainbowCycleTime, Type_Int);
    
    AddDefault("BodyColor", &BodyColor.r, Type_FloatFour);
    AddDefault("HairColor", &HairColor.r, Type_FloatFour);
    
    
    AddDefault("GameFPS", &GameFPS, Type_Float);
    
    AddDefault("AutoPlaceBearTraps", &AutoPlaceBearTraps, Type_Bool);
    AddDefault("AutoPlaceBearTrapInt", &AutoPlaceBearTrapInt, Type_Int);
    AddDefault("UnlockEngrams", &UnlockEngrams, Type_Bool);
    
    AddDefault("CarsontoolCode", &CarsontoolCode, Type_String);
    
    AddDefault("LanguageValue", &LanguageValue, Type_Int);
    
    
    AddDefault("StreamerMode", &StreamerMode, Type_Bool);
    AddDefault("MoveableMenu", &MoveableMenu, Type_Bool);
    
    AddDefault("MenuOriginX", &MenuOrigin.x, Type_Float);
    AddDefault("MenuOriginY", &MenuOrigin.y, Type_Float);
    AddDefault("MenuSizeX", &MenuSize.x, Type_Float);
    AddDefault("MenuSizeY", &MenuSize.y, Type_Float);
    
    
    AddDefault("Aimlock", &Aimlock, Type_Bool);
    AddDefault("CustomAimlockSettings", &CustomAimlockSettings, Type_Bool);
    AddDefault("CustomMagicBulletSettings", &CustomMagicBulletSettings, Type_Bool);
    AddDefault("TargetBoneHitChance", &TargetBoneHitChance, Type_Float);
    AddDefault("SlowDinos", &SlowDinos, Type_Bool);
    AddDefault("showMagicCircle", &showMagicCircle, Type_Bool);
    AddDefault("MagicCircleSize", &MagicCircleSize, Type_Float);
    AddDefault("AimlockSpeed", &AimlockSpeed, Type_Float);
    AddDefault("AimlockToggleSwitch", &AimlockToggleSwitch, Type_Bool);
    AddDefault("showAimlockCircle", &showAimlockCircle, Type_Bool);
    AddDefault("AimlockCircleSize", &AimlockCircleSize, Type_Float);
    AddDefault("AimlockCircleColor", &AimlockCircleColor, Type_FloatFour);
    AddDefault("MagicCircleColor", &MagicCircleColor, Type_FloatFour);
    
    AddDefault("EnableMinimap", &EnableMinimap, Type_Bool);
    AddDefault("MoveMinimap", &MoveMinimap, Type_Bool);
    AddDefault("PlayersMinimap", &PlayersMinimap, Type_Bool);
    AddDefault("DinosMinimap", &DinosMinimap, Type_Bool);
    AddDefault("TurretsMinimap", &TurretsMinimap, Type_Bool);
    AddDefault("MapOriginX", &MapOrigin.X, Type_Float);
    AddDefault("MapOriginY", &MapOrigin.Y, Type_Float);
    AddDefault("MapTransformScale", &MapTransformScale, Type_Float);
    
    AddDefault("StayOnWhitePlatform", &StayOnWhitePlatform, Type_Bool);
    AddDefault("IgnoreShots", &IgnoreShots, Type_Bool);
    
    
    //ImVec2 MenuOrigin = {(float)SCREEN_WIDTH - 400, 0};
    //ImVec2 MenuSize = {400, 370};
    if(hasLaunched){
        preferences.LoadDefaults();
    }
    
    else {
        preferences.SetValue("hasLaunchedBefore", true);
        preferences.SaveDefaults();
    }
}
