//
//  Includes.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//
//  Building CFlags -mllvm -enable-bcfobf  -mllvm -enable-indibran -mllvm -enable-strcry -mllvm -enable-subobf


#include "time.h"
#import <math.h>
#include <sys/time.h>
#include <cstdio>
#include <cmath>
#include <cstdint>
#include <map>
#include <unordered_map>
#include <vector>
#include <string>
#include <queue>
#include <random>
#include <functional>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#include <iostream>
#include <queue>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import "objc/runtime.h"
#include <sys/mount.h>
#include <dirent.h>

#include "RunInBg/RunInBackground.h"
#include "../Utils/Structures.h"
#include "Menu.h"
#include "EncryptedPreferences.h"
#include "ESP.h"
#include "BaseUtils.h"
#include "GameUtils.h"
#include "BedIcon.h"
#include "Prefs.h"
#include "FunctionQueue.h"
#include "Functions.h"
#include "Hooks.h"
#include "Misc.h"
#include "Aimbot.h"
#include "Testing.h"
#include "CrashBot.h"
#include "PlayerIcons.h"
#include "IconSwitcher.h"
#include "PVEDestruction.h"

#include "AdminMenu/ItemSpawn.h"
#include "AdminMenu/DinoSpawn.h"
#include "AdminMenu/QuickCommands.h"
#include "AdminMenu/OtherCommands.h"
#include "AdminMenu/Waypoints.h"
#include "AdminMenu/MatSpawn.h"

#include "OtherWindows/DinoSteal.h"
#include "OtherWindows/Minimap.h"
#include "OtherWindows/ChatMessages.h"
#include "OtherWindows/PlayerList.h"
#include "OtherWindows/DinoColors.h"
#include "OtherWindows/Crosshair.h"
#include "OtherWindows/WeaponColor.h"
#include "OtherWindows/BedList.h"
#include "OtherWindows/AimAssist.h"

#include "Customize/MenuStyle.h"
#include "Customize/PlayerColors.h"

#include "CodeRegistration/CodeManagment.h"


#include "Translations/MenuText.h"

static ChatMessages& chatMessages = ChatMessages::getInstance();
static AimAssist& aimAssist = AimAssist::getInstance();
static MenuStyle& menuStyle = MenuStyle::getInstance();
static PlayerColors& playerColors = PlayerColors::getInstance();

static BedList& bedList = BedList::getInstance();
static CrashBot& crashBot = CrashBot::getInstance();
static Testing& tests = Testing::getInstance();
static EncryptedPreferences& preferences = EncryptedPreferences::getInstance();
static Menu& menu = Menu::getInstance();
static ESP& esp = ESP::getInstance();
static BaseUtils& utils = BaseUtils::getInstance();
static GameUtils& gameUtils = GameUtils::getInstance();
static FunctionQueue& funcqueue = FunctionQueue::getInstance();
static FunctionCall& functions = FunctionCall::getInstance();
static Pref& prefs = Pref::getInstance();
static Hooks& hooks = Hooks::getInstance();
static Miscellaneous& misc = Miscellaneous::getInstance();
static Aimbot& aimbot = Aimbot::getInstance();
static PlayerList& playerList = PlayerList::getInstance();

static Crosshair& crosshair = Crosshair::getInstance();
static DinoColors& dinoColors = DinoColors::getInstance();
static WeaponColor& weaponColor = WeaponColor::getInstance();

static ItemSpawn& itemSpawn = ItemSpawn::getInstance();
static DinoSpawn& dinoSpawn = DinoSpawn::getInstance();
static QuickCommands& adminCommands = QuickCommands::getInstance();
static OtherCommands& otherCommands = OtherCommands::getInstance();

static CodeManagment& userCode = CodeManagment::getInstance();


static ImGuiColorEditFlags ColorFlags = ImGuiColorEditFlags_NoInputs;

extern UIImage* InvisibleImage;
extern UIButton* InvisibleMenuButton;
extern UIButton* VisibleMenuButton;
extern UITextField *hideRecordTextfield;
extern UIView* hideRecordView;
extern UISwitch* SpeedZeroSwitch;
extern UISwitch* AutoShootSwitch;

extern bool PVPBoomBoom;
extern bool PVPAutoLauncher;

extern bool StayOnWhitePlatform;
extern string AuthString;
extern bool StreamerMode;
extern ImVec2 MenuOrigin;
extern ImVec2 MenuSize;
extern bool MoveableMenu;
extern int LanguageValue;
extern string CarsontoolCode;
extern bool UnlockEngrams;
extern bool AutoMountBallista;
extern bool EnableBallistaPlace;
extern bool AutoBallistaInvisiblity;
extern bool AutoPlaceBearTraps;
extern int AutoPlaceBearTrapInt;
extern bool PlayerViewDirection;
extern bool ItemCacheSteal;

extern float GameFPS;
extern float WeaponColorIntensity;
extern float WaterColorIntesnity;
extern bool ChangeBodyColor;
extern bool ChangeHairColor;

extern bool RainbowHair;
extern bool RainbowBody;
extern bool PlayerWireframe;


extern FLinearColor BodyColor;
extern FLinearColor HairColor;


extern int PlayerRainbowCycleTime;
extern float PlayerColorIntensity;

extern bool ChangeWorld;
extern bool RemoveKnockoutBlur;
extern bool RemoveScopeTexture;
extern bool RainbowWater;
extern bool WeaponWireframe;
extern bool WaterWireframe;
extern bool SkyWireframe;
extern bool ChangeWaterColor;
extern FLinearColor WaterColor;

extern bool ESPArmorIcons;
extern bool ESPArmorIconDura;
extern bool ESPWeaponIcon;
extern bool ESPBedIDs;

extern bool EnableWeaponColorChange;
extern bool EnableHeldWeaponDetailedChange;
extern bool HeldWeaponRainbow;
extern FLinearColor HeldWeaponColor;
extern int SelectedDye;

extern bool EnableDinoColorChange;
extern bool DinoWireframe;
extern bool DinoEery;


extern FLinearColor DustRegionOne;
extern FLinearColor DustRegionTwo;
extern FLinearColor DustRegionThree;

extern bool DustRegionOneRainbow;
extern bool DustRegionTwoRainbow;
extern bool DustRegionThreeRainbow;

extern int RainbowCycleTime;

extern float ColorizationIntensity;

extern float ColorRegionOneIntensity;
extern float ColorRegionTwoIntensity;
extern float ColorRegionThreeIntensity;
extern float ColorRegionFourIntensity;
extern float ColorRegionFiveIntensity;
extern float ColorRegionSixIntensity;

extern int ColorRegionOneColorIndex;
extern int ColorRegionTwoColorIndex;
extern int ColorRegionThreeColorIndex;
extern int ColorRegionFourColorIndex;
extern int ColorRegionFiveColorIndex;
extern int ColorRegionSixColorIndex;






extern bool FetchPlayerInfo;
extern int PlayerListFilterIndex;
extern int PlayerListDisplayIndex;

extern string DungeonName;
extern float Speed;
extern float LocalSpeed;
extern float TimeOfDay;
extern float FOV;
extern float FarView;
extern float ESPSize;
extern float ESPDistance;
extern int MenuFPS;

extern bool RapidSpin;
extern bool PlayerESP;
extern bool DinoESP;
extern bool StructureESP;
extern bool ContainerESP;

extern bool TopRightESPToggle;
extern UISwitch *ESPHideSwitch;
extern ESPColor Dinos;
extern ESPColor Players;
extern ESPColor Structures;
extern ESPColor Containers;
extern ESPColor Beds;
extern ESPColor Turrets;

extern int TargettingIndex;
extern BedIcon* BedIcons[100];
extern StealButton* StealIcons[15];
extern TransferButton* TransferIcons[15];
extern class ArmorIcons playerArmorIcons[30];

extern BedIcon* InvisibleBedIcons[100];
extern StealButton* InvisibleStealIcons[15];
extern TransferButton* InvisibleTransferIcons[15];

extern bool PVPStealAll;
extern bool PVPTameShooting;

extern bool PVPMagicBullet;
extern bool PVPAutoFire;
extern bool PVPInfinitePistol;
extern bool PVPProjectileSpam;
extern bool PVPAutoArmor;
extern bool PVPAutoMed;
extern bool PVPAutoStam;
extern bool PVPUWShoot;
extern bool PVPInfiniteC4;
extern bool PVPExplosions;
extern bool PVPAutoSteal;
extern bool PVPAutoDrop;
extern bool PVPRocketSpam;
extern bool PVPRocketSpread;
extern bool PVPDinoSpin;
extern bool PVPInstantTurn;
extern bool PVPStrafing;
extern bool PVPAutoEat;
extern bool PVPForceFeed;
extern bool PVPGhost;
extern bool PVPHideLogin;
extern bool PVPChatSpam;
extern bool PVPRequestDino;
extern bool PVPRequestImplant;
extern bool PVPSpeedZero;
extern bool EnableESP;
extern bool BedESP;
extern bool TurretESP;

/*
 
 thinking... how do i want to do this
 
 
 seperate
containers, turrets, players, structures, dinos, beds

 one switch for wild
 
 Friendly Containers
 Friendly Turrets
 Friendly Players
 Friendly Structures
 Friendly Dinos
 Friendly Beds

 */
extern bool ESPFriendlyContainers;
extern bool ESPFriendlyTurrets;
extern bool ESPFriendlyPlayers;
extern bool ESPFriendlyStructures;
extern bool ESPFriendlyDinos;
extern bool ESPFriendlyBeds;

extern bool ESPShowEnemy;
extern bool ESPShowWild;
extern bool ESPContainerSteal;
extern bool ESPBedTeleport;
extern bool ESPTurretRange;
extern bool ESPTurretBullets;
extern bool ESPPlayerNumber;
extern bool ESPPlayerName;
extern bool ESPTribeName;
extern bool ESPHealthBar;
extern bool ESPTopLine;
extern bool ESPBottomLine;
extern bool ESPSleepingPlayers;
extern bool ESPGPS;

extern float StructurePitch;
extern float StructureYaw;
extern float StructureRoll;
extern bool EnablePitch;
extern bool EnableYaw;
extern bool EnableRoll;

extern int PlaceOptionsInt;
extern float PlacementRange;
extern bool EnablePlacement;

extern bool ChangeRange;
extern bool ChangeSettings;
extern bool ChangeName;

extern bool EerieFill;
extern bool AutoFill;
extern bool TekGeneratorFill;
extern bool GeneratorFill;

extern int AutoAmmoFillAmmount;
extern int TekGeneratorFillAmmount;
extern int GeneratorFillAmmount;

extern int TurretRangeInt;
extern int TurretSettingsInt;

extern bool EnableDupe;
extern bool Floaters;
extern bool PlaceBlueprints;

extern bool StationPurchase;
extern bool AmberPurhcase;
extern int StationPurchaseAmmount;
extern int AmberPurchaseAmmount;


extern int CrosshairTypeInt;


extern bool EnableCustomCrosshair;
extern float CircleRadius;
extern float CircleWidth;
extern float CircleColor[4];

extern float PlusMiddleSpacing;
extern float PlusLength;
extern float PlusWidth;
extern float PlusColor[4];

extern bool PlusMiddleDot;
extern float PlusMiddleDotRadius;
extern float PlusMiddleDotColor[4];

extern float XWidth;
extern float XLength;
extern float XColor[4];

extern float CarrotWidth;
extern float CarrotLength;
extern float CarrotColor[4];


extern bool Aimlock;
extern bool CustomAimlockSettings;
extern bool CustomMagicBulletSettings;
extern float TargetBoneHitChance;

extern bool SlowDinos;

extern bool showMagicCircle;
extern float MagicCircleSize;

extern float AimlockSpeed;
extern bool AimlockToggleSwitch;
extern bool showAimlockCircle;
extern float AimlockCircleSize;

extern float AimlockCircleColor[4];
extern float MagicCircleColor[4];

extern bool EnableMinimap;
extern bool MoveMinimap;
extern bool PlayersMinimap;
extern bool DinosMinimap;
extern bool TurretsMinimap;
extern Vector2 MapOrigin;
extern float MapTransformScale;

extern bool PVPDropNearby;

extern bool IgnoreShots;
extern bool PickupNearbyStructures;
extern bool DestroyNearbyStructures;

extern bool MultiUsePickupItemCache;
extern bool MultiUsePickupFoundation;
extern bool MultiUsePickupTurrets;
extern bool MultiUsePickupStructures;

extern bool DemolishTargetAutmoatically;
extern bool PickupTargetAutomatically;
extern bool DemolishTargetPunching;
extern bool PickupTargetPunching;

extern bool ClaimAllDinos;
extern bool ClaimTargetDino;
extern bool KillAllDinos;

/*
 static bool EnableMinimap = false;
 static bool MoveMinimap = false;
 static bool PlayersMinimap = false;
 static bool DinosMinimap = false;
 static bool TurretsMinimap = false;
 static Vector2 MapOrigin;
 static float MapTransformScale = 1;
 
 
 
 
 
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
/*
static char* ColorRegions[] = {(char*)"None",
"Red - 1",
"Blue - 2",
"Green - 3",
"Yellow - 4",
"Cyan - 5",
"Magenta - 6",
"Light Green - 7",
"Light Grey - 8",
"Light Brown - 9",
"Light Orange - 10",
"Light Yellow - 11",
"Light Red - 12",
"Dark Grey - 13",
"Black - 14",
"Brown - 15",
"Dark Green - 16",
"Dark Red - 17",
"White - 18",
"Dino Light Red - 19",
"Dino Dark Red - 20",
"Dino Light Orange - 21",
"Dino Dark Orange - 22",
"Dino Light Yellow - 23",
"Dino Dark Yellow - 24",
"Dino Light Green - 25",
"Dino Medium Green - 26",
"Dino Dark Green - 27",
"Dino Light Blue - 28",
"Dino Dark Blue - 29",
"Dino Light Purple - 30",
"Dino Dark Purple - 31",
"Dino Light Brown - 32",
"Dino Medium Brown - 33",
"Dino Dark Brown - 34",
"Dino Darker Grey - 35",
"Dino Albino - 36",
"BigFoot0 - 37",
"BigFoot4 - 38",
"BigFoot5 - 39",
"WolfFur - 40",
"DarkWolfFur - 41",
"DragonBase0 - 42",
"DragonBase1 - 43",
"DragonFire - 44",
"DragonGreen0 - 45",
"DragonGreen1 - 46",
"DragonGreen2 - 47",
"DragonGreen3 - 48",
"WyvernPurple0 - 49",
"WyvernPurple1 - 50",
"WyvernBlue0 - 51",
"WyvernBlue1 - 52",
"Dino Medium Blue - 53",
"Dino Deep Blue - 54",
"NearWhite - 55",
"NearBlack - 56"};
*/

static char* ColorRegions[] = {(char*)"None",
(char*)"Red - 1",
(char*)"Blue - 2",
(char*)"Green - 3",
(char*)"Yellow - 4",
(char*)"Cyan - 5",
(char*)"Magenta - 6",
(char*)"Light Green - 7",
(char*)"Light Grey - 8",
(char*)"Light Brown - 9",
(char*)"Light Orange - 10",
(char*)"Light Yellow - 11",
(char*)"Light Red - 12",
(char*)"Dark Grey - 13",
(char*)"Black - 14",
(char*)"Brown - 15",
(char*)"Dark Green - 16",
(char*)"Dark Red - 17",
(char*)"White - 18",
(char*)"Dino Light Red - 19",
(char*)"Dino Dark Red - 20",
(char*)"Dino Light Orange - 21",
(char*)"Dino Dark Orange - 22",
(char*)"Dino Light Yellow - 23",
(char*)"Dino Dark Yellow - 24",
(char*)"Dino Light Green - 25",
(char*)"Dino Medium Green - 26",
(char*)"Dino Dark Green - 27",
(char*)"Dino Light Blue - 28",
(char*)"Dino Dark Blue - 29",
(char*)"Dino Light Purple - 30",
(char*)"Dino Dark Purple - 31",
(char*)"Dino Light Brown - 32",
(char*)"Dino Medium Brown - 33",
(char*)"Dino Dark Brown - 34",
(char*)"Dino Darker Grey - 35",
(char*)"Dino Albino - 36",
(char*)"BigFoot0 - 37",
(char*)"BigFoot4 - 38",
(char*)"BigFoot5 - 39",
(char*)"WolfFur - 40",
(char*)"DarkWolfFur - 41",
(char*)"DragonBase0 - 42",
(char*)"DragonBase1 - 43",
(char*)"DragonFire - 44",
(char*)"DragonGreen0 - 45",
(char*)"DragonGreen1 - 46",
(char*)"DragonGreen2 - 47",
(char*)"DragonGreen3 - 48",
(char*)"WyvernPurple0 - 49",
(char*)"WyvernPurple1 - 50",
(char*)"WyvernBlue0 - 51",
(char*)"WyvernBlue1 - 52",
(char*)"Dino Medium Blue - 53",
(char*)"Dino Deep Blue - 54",
(char*)"NearWhite - 55",
(char*)"NearBlack - 56"};

