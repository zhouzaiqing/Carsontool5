//
//  Structures.h
//  BaseMenu
//
//  Created by Carson Mobile on 6/26/23.
//
#include <cstdio>
#include <cstdint>
#include <map>
#include <unordered_map>
#include <vector>
#include <string>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <UIKit/UIKit.h>
#include <string>
#include <codecvt>
#include <locale>
#import "../KittyMemory/imgui.h"

using namespace std;

#pragma once

#define RadiansToDegree  180 /3.141592654f;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE [UIScreen mainScreen].scale
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
#define PI 3.14159265
#define AlertAction(string) [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
static float Deg_To_Rad = 0.01745;
typedef signed char UObject;
typedef long FItemNetID;

struct FontRenderInfo{
        int FontRenderBasic; //2 0000000000000010
        int DepthFieldBasic; //1071710207 00111111111111111 //test : 3219193855
        float GlowColorR; // 0
        float GlowColorG; // 0
        float GlowColorB; // 0
        float GlowColorA; // 1
        float GlowOuterRadiusX; // .42
        float GlowOuterRadiusY; // .48
        float GlowInnerRadiusX; // .48
        float GlowInnerRadiusY; // .54
    FontRenderInfo(){
        FontRenderBasic = 2;
        DepthFieldBasic = 1071710207;
        GlowColorR = 0;
        GlowColorG = 1;
        GlowColorB = 0;
        GlowColorA = 1;
        GlowOuterRadiusX = .5;
        GlowOuterRadiusY = .51;
        GlowInnerRadiusX = .79;
        GlowInnerRadiusY = .8;
    }
};

struct FLinearColor{
    float r;
    float g;
    float b;
    float a;
    
    FLinearColor() {
        r = 0;
        g = 0;
        b = 0;
        a = 1;
    }
    FLinearColor(float red, float green, float blue, float alpha){
        r = red; g = green; b = blue; a = alpha;
    }
    FLinearColor(int red, int green, int blue, int alpha){
        r = (float)(red)/255; g = (float)(green)/255; b = (float)(blue)/255; a = (float)(alpha)/255;
    }
    FLinearColor(int red, int green, int blue){
        r = (float)(red)/255; g = (float)(green)/255; b = (float)(blue)/255; a = 1;
    }
    FLinearColor(float red, float green, float blue){
        r = red; g = green; b = blue; a = 1;
    }
    FLinearColor(float red, float green, float blue, bool kms){
        r = red; g = green; b = blue; a = 1;
    }
    FLinearColor(float* Colors){
        r = Colors[0];
        g = Colors[1];
        b = Colors[2];
        a = 1;
    }

    FLinearColor(float* Colors, float alpha){
        r = Colors[0];
        g = Colors[1];
        b = Colors[2];
        a = alpha;
    }
    FLinearColor(float* Colors, float alpha, float intensity){
        r = Colors[0] * intensity;
        g = Colors[1] * intensity;
        b = Colors[2] * intensity;
        a = alpha;
    }
    void print(){
        NSLog(@"Red %f \n Green %f Blue %f Alpha %f",r,g,b,a);
    }
    ImU32 toU32(){
        ImVec4 color = ImVec4(r,g,b,a);
        return ImGui::ColorConvertFloat4ToU32(color);
    }
}; 

static FLinearColor Red = FLinearColor(255,0,0);
static FLinearColor Green = FLinearColor(0,0xff,0);
static FLinearColor Blue = FLinearColor(0,0,0xff);
static FLinearColor Yellow = FLinearColor(0xff,0xff,0);
static FLinearColor Cyan = FLinearColor(0,0xff,0xff);
static FLinearColor Purple = FLinearColor(0xcc,0x88,0x99);
static FLinearColor Pink = FLinearColor(255,192,203);
static FLinearColor Black = FLinearColor(0,0,0);
static FLinearColor White = FLinearColor(255,255,255);
static FLinearColor Orange = FLinearColor(255,165,0);
static FLinearColor Brown = FLinearColor(150, 75,0);
static FLinearColor Lime = FLinearColor(0xbf, 0xff, 0);
static FLinearColor Grey = FLinearColor(0xC0, 0xC0, 0xC0);
static FLinearColor DarkBlue = FLinearColor(0,0,0x8B);

static FLinearColor ArkCol_Slate = FLinearColor(0.15f, 0.15f, 0.17f, false);
static FLinearColor ArkCol_Olive = FLinearColor(0.4f, 0.4f, 0.05f, false);
static FLinearColor ArkCol_Navy = FLinearColor(0.03f, 0.03f, 0.15f, false);
static FLinearColor ArkCol_Mud = FLinearColor(0.06f, 0.04f, 0.02f, false);
static FLinearColor ArkCol_Cantaloupe = FLinearColor(1.f, 0.33f, 0.0f, false);
static FLinearColor ArkCol_Brick = FLinearColor(0.3f, 0.03f, 0.01f, false);
static FLinearColor ArkCol_ActuallyMagenta = FLinearColor(0.8f, 0.01f, 0.07f, false);
static FLinearColor ArkCol_Tangerine = FLinearColor(0.425f, 0.13f, 0.021f, false);
static FLinearColor ArkCol_Tan = FLinearColor(0.765f, 0.62f, 0.387f, false);
static FLinearColor ArkCol_Sky = FLinearColor(0.5f, 0.667f, 1.0f, false);
static FLinearColor ArkCol_Silver = FLinearColor(0.9f, 0.9f, 0.9f, false);
static FLinearColor ArkCol_Royal = FLinearColor(0.2f, 0.0f, 0.4f, false);
static FLinearColor ArkCol_Pink = FLinearColor(1.0f, 0.2f, 0.76f, false);
static FLinearColor ArkCol_Parchment = FLinearColor(1.0f, 1.0f, 0.5f, false);
static FLinearColor ArkCol_Forest = FLinearColor(0.0f, 0.15f, 0.0f, false);
static FLinearColor ArkCol_Magenta = FLinearColor(0.15f, 0.0f, 0.5f, false);
static FLinearColor ArkCol_Cyan = FLinearColor(0.0f, 1.0f, 1.0f, false);
static FLinearColor ArkCol_Brown = FLinearColor(0.18f, 0.12f, 0.06f, false);
static FLinearColor ArkCol_White = FLinearColor(0.99f, 0.99f, 0.99f, false);
static FLinearColor ArkCol_Black = FLinearColor(0.05f, 0.05f, 0.05f, false);
static FLinearColor ArkCol_Orange = FLinearColor(1.0f, 0.25f, 0.0f, false);
static FLinearColor ArkCol_Purple = FLinearColor(0.2f, 0.0f, 0.75f, false);
static FLinearColor ArkCol_Yellow = FLinearColor(0.687f, 0.636f, 0.018f, false);
static FLinearColor ArkCol_Blue = FLinearColor(0.0f, 0.0f, 1.0f, false);
static FLinearColor ArkCol_Green = FLinearColor(0.0f, 0.6f, 0.0f, false);
static FLinearColor ArkCol_Red = FLinearColor(1.0f, 0.0f, 0.0f, false);


struct ThreeColor{
    float r;
    float g;
    float b;
    
    ThreeColor(){
        r = 0; g = 0; b = 0;
    }
    ThreeColor(float R, float G, float B){
        r = R; g = G; b = B;
    }
    ThreeColor(FLinearColor fromColor){
        r = fromColor.r;
        g = fromColor.g;
        b = fromColor.b;
    }
    FLinearColor toLinearColor(){
        return FLinearColor(r,g,b,1.f);
    }
    bool equals(ThreeColor other){
        return other.r == r && other.g == g && other.b == b;
    }
};

enum ESPTeam : uint8_t {
    Team_Tribe = 0,
    Team_Ally = 1,
    Team_Enemy = 2,
    Team_Wild = 3
};
enum CurrentLanguage : uint8_t {
    LNone = 0,
    LEnglish = 1,
    LKorean = 2,
    LJapenese = 3,
    LChinese = 4
};
enum EChatMessageSource : uint8_t {
    Normal = 0,
    TribeMate = 1,
    TribeAdmin = 2,
    Admin = 3,
    ARK = 4
};
enum EChatMessageType : uint8_t {
    Text = 0,
    Emote = 1,
    LogIn = 2,
    Notification = 3,
    Announcement = 4
};
enum EChatChannel : uint8_t {
    Local = 0,
    Global = 1,
    Tribe = 2,
    TribeAndAlliance = 3,
    Radio = 4
};
enum TeamType : uint8_t {
    Enemy = 0,
    Tribemate = 1,
    Ally = 2
};
struct TextEntries{
    NSString* PlayerName;
    NSString* TextString;
    EChatMessageSource Source;
    EChatChannel Channel;
    EChatMessageType Type;
    TeamType TeamID;
    string Translated = "";
};
/*
struct FString{
    wchar_t* TextPointer;
    int Size;
    int Max;
};
 
 bool equals(ThreeColor other){
     return other.r == r && other.g == g && other.b == b;
 }
 
 */
struct Vector3{
    float X,Y,Z;
    
    Vector3 operator-(Vector3 v)
    {
        return {X - v.X, Y - v.Y, Z - v.Z};
    }
    Vector3 operator+(Vector3 v)
    {
        return {X + v.X, Y + v.Y, Z + v.Z};
    }
    Vector3 operator*(float f)
    {
        return {X*f, Y*f, Z*f};
    }
    float GetMagnitude(){
        return sqrt(X*X + Y*Y + Z*Z);
    }
    Vector3 ToNormal(){
        float Magnitude = GetMagnitude();
        return {X/Magnitude, Y/Magnitude, Z/Magnitude};
    }
    float DistanceTo(const Vector3& other){
        return sqrt(X*other.X + Y*other.Y + Z*other.Z);
    }
};
 
struct FRotator {
    float Pitch;
    float Yaw;
    float Roll;
    
    float GetMagnitude(){
        return sqrt(Pitch*Pitch + Yaw*Yaw + Roll*Roll);
    }
    
    Vector3 ToNormal(){
        float Magnitude = GetMagnitude();
        return {Pitch/Magnitude, Yaw/Magnitude, Roll/Magnitude};
    }
};
typedef struct FQuat
{
    float x;
    float y;
    float z;
    float w;
}FQuat;
struct ObjectName{
    const char data[256];
};
static struct LTMatrix{
    float a1;
    float a2;
    float a3;
    float a4;
    float b1;
    float b2;
    float b3;
    float b4;
    float c1;
    float c2;
    float c3;
    float c4;
    float d1;
    float d2;
    float d3;
    float d4;
}*LPMatrix;
struct MinimalViewInfo {
    Vector3 Location;
    Vector3 LocationLocalSpace;
    FRotator Rotation;
    float FOV;
};
struct FMatrix {
    float Matrix[4][4];

    float *operator[](int index) {
        return Matrix[index];
    }
};

struct Vector2{
    float X,Y;
    Vector2(float x, float y){
        X = x; Y = y;
    }
    Vector2(){
        X = 0; Y = 0;
    }
    
    Vector2 operator-(Vector2 v)
    {
        return {X - v.X, Y-v.Y};
    }
    Vector2 operator+(Vector2 v)
    {
        return {X + v.X, Y+v.Y};
    }
    Vector2 operator*(float f)
    {
        return {X * f, Y * f};
    }
    Vector2 operator/(float f)
    {
        return {X / f, Y / f};
    }
    
    /*
     Vector3 operator-(Vector3 v)
     {
         return {X - v.X, Y - v.Y, Z - v.Z};
     }
     Vector3 operator+(Vector3 v)
     {
         return {X + v.X, Y + v.Y, Z + v.Z};
     }
     */
    void additionX(float val){
        X = X + val;
    }
    void additionY(float val){
        Y = Y + val;
    }
    Vector2 add(float x, float y){
        return Vector2(X + x, Y + y);
    }
    ImVec2 toVec2(){
        return ImVec2(X,Y);
    }
    float GetMagnitude(){
        return sqrt(X*X + Y*Y);
    }
};

class CVector3
{
public:
    CVector3() : x(0.f), y(0.f), z(0.f)
    {
        
    }
    
    CVector3(float _x, float _y, float _z) : x(_x), y(_y), z(_z)
    {
        
    }
    ~CVector3()
    {
        
    }
    
    float x;
    float y;
    float z;
    
    CVector3 operator+(CVector3 v)
    {
        return CVector3(x + v.x, y + v.y, z + v.z);
    }
    
    CVector3 operator-(CVector3 v)
    {
        return CVector3(x - v.x, y - v.y, z - v.z);
    }
};

struct FTransform
{
    FQuat rot;
    CVector3 translation;
    CVector3 scale;
    LTMatrix ToMatrixWithScale()
    {
        LTMatrix m;
        m.d1 = translation.x;
        m.d2 = translation.y;
        m.d3 = translation.z;
        
        float x2 = rot.x + rot.x;
        float y2 = rot.y + rot.y;
        float z2 = rot.z + rot.z;
        
        float xx2 = rot.x * x2;
        float yy2 = rot.y * y2;
        float zz2 = rot.z * z2;
        m.a1 = (1.0f - (yy2 + zz2)) * scale.x;
        m.b2 = (1.0f - (xx2 + zz2)) * scale.y;
        m.c3 = (1.0f - (xx2 + yy2)) * scale.z;
        
        float yz2 = rot.y * z2;
        float wx2 = rot.w * x2;
        m.c2 = (yz2 - wx2) * scale.z;
        m.b3 = (yz2 + wx2) * scale.y;
        
        float xy2 = rot.x * y2;
        float wz2 = rot.w * z2;
        m.b1 = (xy2 - wz2) * scale.y;
        m.a2 = (xy2 + wz2) * scale.x;
        
        float xz2 = rot.x * z2;
        float wy2 = rot.w * y2;
        m.c1 = (xz2 + wy2) * scale.z;
        m.a3 = (xz2 - wy2) * scale.x;
        
        m.a4 = 0.0f;
        m.b4 = 0.0f;
        m.c4 = 0.0f;
        m.d4 = 1.0f;
        
        return m;
    }
};
struct MFStr{
    long Data;
    int Count;
    int Max;
};
template <class T>
struct TArrayTwo
{
    T*      Data;
    int32_t Num;
    int32_t Max;
};

struct FStringTwo
{
    TArrayTwo<wchar_t> DataType;
};

struct FName;

struct FName
{
    int32_t Index;
    int32_t Number;

};

template<class T>
struct TArray
{
private:

    friend struct FString;

public:
    
    T* Data;
    int32_t Count;
    int32_t Max;
    
    TArray()
    {
        Data = nullptr;
        Max = 0;
        Count = 0;
    }

    int Num() const
    {
        return Count;
    }

    T& operator[](int i)
    {
        return Data[i];
    }

    const T& operator[](int i) const
    {
        return Data[i];
    }

    bool IsValidIndex(int i) const
    {
        return i < Num();
    }
    
    bool IsValidArray()
    {
        return Max >= Count && Count < 50000 && IsValidPointer();
    }
    
    bool IsValidPointer()
    {
        return (long)Data > 0x100000000 && (long)Data < 0x300000000;
    }
}; 
struct FString : public TArray<wchar_t>
{
    FString() = default;

    explicit FString(const wchar_t* other)
    {
        Max = Count = *other ? std::wcslen(other) + 1 : 0;

        if (Count)
        {
            Data = const_cast<wchar_t*>(other);
        }
    };

    inline bool IsValid() const
    {
        return Data != nullptr;
    }

    inline const wchar_t* cw_str() const
    {
        return Data;
    }

    inline const char* c_str() const
    {
        return (const char*)Data;
    }

    std::string ToString() const
    {
        size_t length = std::wcslen(Data);
        std::string str(length, '\0');
        std::use_facet<std::ctype<wchar_t>>(std::locale()).narrow(Data, Data + length, '?', &str[0]);

        return str;
    }

    std::wstring ToWString() const
    {
        std::wstring str(Data);
        return str;
    }
};

struct FInventoryFilter {
    MFStr FilterString; // Offset: 0x00 // Size: 0x10
    uint8_t ItemTypeFilter; // Offset: 0x10 // Size: 0x01
    uint8_t EquipmentTypeFilter; // Offset: 0x11 // Size: 0x01
    uint8_t ConsumableTypeFilter; // Offset: 0x12 // Size: 0x01
    char pad_0x13[0x5]; // Offset: 0x13 // Size: 0x05
};

struct Vector{
    float X;
    float Y;
    float Z;
    
    Vector(){
        X = 0; Y = 0; Z = 0;
    }
    Vector(Vector3 Other){
        X = Other.X;
        Y = Other.Y;
        Z = Other.Z;
    }
    Vector(float x, float y, float z){
        X = x; Y = y; Z = z;
    }
    
};


struct FHitResult {
    // Fields
    int Buff;
    float Time; // Offset: 0x04 // Size: 0x04
    float Distance; // Offset: 0x08 // Size: 0x04
    Vector Location; // Offset: 0x0c // Size: 0x0c
    Vector ImpactPoint; // Offset: 0x18 // Size: 0x0c
    Vector Normal; // Offset: 0x24 // Size: 0x0c
    Vector ImpactNormal; // Offset: 0x30 // Size: 0x0c
    Vector TraceStart; // Offset: 0x3c // Size: 0x0c
    Vector TraceEnd; // Offset: 0x48 // Size: 0x0c
    float PenetrationDepth; // Offset: 0x54 // Size: 0x04
    char pad_0x58[0x4];//int32_t Item; // Offset: 0x58 // Size: 0x04
    long PhysMaterial; // Offset: 0x5c // Size: 0x08
    long Actor; // Offset: 0x64 // Size: 0x08
    long Component; // Offset: 0x6c // Size: 0x08
    long BuffTwo;
    int32_t BuffThree;
    long BoneName; // Offset: 0x80 // Size: 0x08
    int32_t FaceIndex; // Offset: 0x88 // Size: 0x04
    int32_t BuffFour;
};

struct FPreferredSnapData {
  bool bUsedPreferredSnap; // Offset: 0x00 // Size: 0x01
  char pad_0x1[0x3]; // Offset: 0x01 // Size: 0x03
  int MySnapIndex; // Offset: 0x04 // Size: 0x04
  int TheirSnapIndex; // Offset: 0x08 // Size: 0x04
  char pad_0xC[0x4]; // Offset: 0x0c // Size: 0x04
  long SnapToActor; // Offset: 0x10 // Size: 0x08
};

struct ColorEntry{
    FLinearColor Color;
};
struct ESPColor{
    float Tribe[4];
    float Ally[4];
    float Enemy[4];
    float Wild[4];
};
struct FColor{
    uint8_t B;
    uint8_t G;
    uint8_t R;
    uint8_t A;
};


struct FItemNetInfo {
    // Fields
    long UPrimalItem_ItemArchetype; // Offset: 0x00 // Size: 0x08
    FItemNetID ItemID;
    int Ammount;
    char pad_0x14[0x3c];
    char bIsBlueprint : 1; // Offset: 0x50 // Size: 0x01
    char bIsEngram : 1; // Offset: 0x50 // Size: 0x01
    char bIsCustomRecipe : 1; // Offset: 0x50 // Size: 0x01
    char bIsFoodRecipe : 1; // Offset: 0x50 // Size: 0x01
    char bIsRepairing : 1; // Offset: 0x50 // Size: 0x01
    char bAllowRemovalFromInventory : 1; // Offset: 0x50 // Size: 0x01
    char bHideFromInventoryDisplay : 1; // Offset: 0x50 // Size: 0x01
    char bUsesImplantProps : 1; // Offset: 0x50 // Size: 0x01
    char bSuperFertileEgg : 1; // Offset: 0x51 // Size: 0x01
    char bPremiumBlueprint : 1; // Offset: 0x51 // Size: 0x01
    char bDungeonItem : 1; // Offset: 0x51 // Size: 0x01
    char bIsEquipped : 1; // Offset: 0x51 // Size: 0x01
    char bIsSlot : 1; // Offset: 0x51 // Size: 0x01
    char bIsInitialItem : 1; // Offset: 0x51 // Size: 0x01
    char bIsEeryEgg : 1; // Offset: 0x51 // Size: 0x01
    char pad_0x58[0x30];
    UObject* PrimalItem_ItemCustomClass;
    uint16_t ItemColorID;
    UObject* ItemSkinTemplate;
    uint16_t PreSkinItemColorID;
    char pad_0xA2[0x6];
    TArray<FColor> CustomItemColors;
    
};

//Size 88

struct ServerMultiUse_Params{
    UObject* ForObject;
    int UseIndex;
    int ComponentIndex;
    bool bAllowSpam;
    bool ignoreDisableUse;
};
struct ClientAddActorItemParams{
    long PrimalInventoryComponentForInventory;
    FItemNetInfo ItemInfo;
    bool bEquipItem;
    bool bShowHudNotification;
};

struct FireBallistaProjectile_Params{
    Vector3 Origin;
    Vector3 Rotation;
};
struct ServerRequestInventoryUseItem_Params{
    UObject* TargetInventory;
    FItemNetID ID;
};

enum EPrimalEquipmentType : uint8_t {
    EquippedType_Helmet = 0,
    EquippedType_Chestplate = 1,
    EquippedType_Pants = 2,
    EquippedType_Boots = 3,
    EquippedType_Gloves = 4,
    EquippedType_Saddle = 5,
    EquippedType_Trophy = 6,
    EquippedType_Costume = 7,
    EquippedType_Shield = 8,
    EquippedType_Collar = 9,
    EquippedType_Max = 10
};

enum EPrimalItemType : uint8_t {
    ItemType_MiscConsumable = 0,
    ItemType_Equipment = 1,
    ItemType_Weapon = 2,
    ItemType_Ammo = 3,
    ItemType_Structure = 4,
    ItemType_Resource = 5,
    ItemType_Skin = 6,
    ItemType_WeaponAttachment = 7,
    ItemType_Artifact = 8,
    ItemType_MAX = 9
};

enum EArmorQuality : uint8_t {
    ArmorQuality_Primitive = 0,
    ArmorQuality_Ramshackle = 1,
    ArmorQuality_Apprentice = 2,
    ArmorQuality_Journeyman = 3,
    ArmorQuality_Mastercraft = 4,
    ArmorQuality_Ascendent = 5,
    ArmorQuality_Count = 6
};
enum EPrimalItemStat : uint8_t {
    ItemStat_GenericQuality = 0,
    ItemStat_Armor = 1,
    ItemStat_MaxDurability = 2,
    ItemStat_WeaponDamagePercent = 3,
    ItemStat_WeaponClipAmmo = 4,
    ItemStat_HypothermalInsulation = 5,
    ItemStat_Weight = 6,
    ItemStat_HyperthermalInsulation = 7,
    ItemStat_MAX = 8,
};
enum EPrimalCharacterStatusValue : uint8_t {
    PrimalCharacterStatusValue_Health = 0,
    PrimalCharacterStatusValue_Stamina = 1,
    PrimalCharacterStatusValue_Torpidity = 2,
    PrimalCharacterStatusValue_Oxygen = 3,
    PrimalCharacterStatusValue_Food = 4,
    PrimalCharacterStatusValue_Water = 5,
    PrimalCharacterStatusValue_Temperature = 6,
    PrimalCharacterStatusValue_Weight = 7,
    PrimalCharacterStatusValue_MeleeDamageMultiplier = 8,
    PrimalCharacterStatusValue_SpeedMultiplier = 9,
    PrimalCharacterStatusValue_TemperatureFortitude = 10,
    PrimalCharacterStatusValue_CraftingSpeedMultiplier = 11,
    PrimalCharacterStatusValue_MAX = 12
};
struct FlagDinoForImplantReturn_Params{
    UObject* Dino;
    bool Request;
};
struct ServerTransferToRemoveInventory_Params{
    UObject* InventoryComponent;
    FItemNetID ItemID;
    bool tryEquip;
    int RequestedQuantity;
    bool bAlsoTryUse;
    bool bShowHudNotification;
    bool ForceDisableSound;
};
struct ServerFireProjectileEx_Params{
    Vector3 Origin;
    Vector3 Rotation;
    float Speed;
    int RandomSeed;
};
struct ServerNotifyShot_Params{
    TArray<FHitResult> Impacts;
    TArray<Vector3> ShootDirs;
    TArray<float> ModelHeightChecks;
};
struct FTribeAlliance{
    int AllianceID;
    char pad_0x4[0x4];
    TArray<FString> MembersTribeName;
    TArray<int> MemmbersTribeID;
    int PendingTribeID;
    char pad_0x2C[0x4];
    FString PendingTribeName;
    bool pendingAccept;
    char pad_0x41[0x7];
};
struct FTribeData{
    FString TribeName;
    int OwnerPlayerDataId;
    int TribeID;
    TArray<FString> MembersPlayerName;
    TArray<int> MembersPlayerDataID;
    TArray<char> MembersRankGroups;
    TArray<int> TribeAdmins;
    TArray<FTribeAlliance> TribeAlliances;
};
struct FServerText{
    long FTextOne = 0; //0x0
    long FTextTwo = 0; //0x8
    long FTextThree = 0; //0x10
    FString Paramaters;
};
struct ServerSendChatMessage_Params{
    EChatChannel ChatChannel;
    EChatMessageType MessageType;
    FString ChatMessage;
    FServerText ServerText;
};
struct MenuAlivePlayerDataInfo{
    string PlayerName;
    string TribeName;
    long PlayerID;
    long TribeID;
    ESPTeam PlayerTeam;
};
struct PlayerTribeEntry{
    string PlayerName;
    long PlayerID;
};
struct TribeListEntry{
    string TribeName;
    long TribeID;
    vector<PlayerTribeEntry> Players;
};
struct FAlivePlayerDataInfo{
    FString PlayerName;
    FString PlayerSteamName;
    long PlayerID;
    FString TribeName;
    long TargetingTeamID;
};
struct ClientGetAlivePlayerConnectedData_Params{
    TArray<FAlivePlayerDataInfo> list;
};
struct ServerBanTribe_Params{
    long TribeTeamID;
    int NumDays;
    FString BanReason;
    bool bDestroyStructures;
    bool bDestroyDinos;
};
struct FColorDefinition {
    long FNameColorName; // Offset: 0x00 // Size: 0x08
    FLinearColor ColorValue; // Offset: 0x08 // Size: 0x10
};
struct FSkeletalMaterial{
    UObject* MaterialInterface;
    char pad_0x8[0x28];
};
struct FVectorParameterValue{
    long FNameParameterName;
    FLinearColor ParameterValue;
    char pad_0x18[0x10];
};
struct FFontParameterValue{
    long FNameParameterName;
    long UFontValue;
    int FontPage;
    char pad_0x14[0x14];
};
struct FTextureParameterValue{
    long FNameParameterName;
    long UTextureParameterValue;
    char pad_0x10[0x10];
};
struct FScalarParameterValue{
    long FNameParameterName;
    float ParameterValue;
    char pad_0xc[0x14];
};
struct UClassPointer{
    char pad_0x0[0x10];
    FString AssetName;
};
struct DyeEntry{
    string DyeName;
    int ColorID;
    FLinearColor Color;
};
enum EHelmetImageType : uint8_t {
    HelmetType_Cloth = 0,
    HelmetType_Hide = 1,
    HelmetType_Chitin = 2,
    HelmetType_Ghille = 3,
    HelmetType_Flak = 4,
    HelmetType_Riot = 5,
    HelmetType_Tek = 6,
    HelmetType_TekScuba = 7,
    HelmetType_Goggles = 8,
    HelmetType_GasMask = 9,
    HelmetType_Fur = 10,
    HelmetType_Miner = 11,
    HelmetType_NVG = 12,
    HelmetType_Count = 13
};
enum EChestplateImageType : uint8_t {
    ChestplateType_Cloth = 0,
    ChestplateType_Hide = 1,
    ChestplateType_Chitin = 2,
    ChestplateType_Ghille = 3,
    ChestplateType_Flak = 4,
    ChestplateType_Riot = 5,
    ChestplateType_Tek = 6,
    ChestplateType_Scuba = 7,
    ChestplateType_Fur = 8,
    ChestplateType_Count = 9
};
enum ELeggingsImageType : uint8_t {
    LeggingsType_Cloth = 0,
    LeggingsType_Hide = 1,
    LeggingsType_Chitin = 2,
    LeggingsType_Ghille = 3,
    LeggingsType_Flak = 4,
    LeggingsType_Riot = 5,
    LeggingsType_Tek = 6,
    LeggingsType_Scuba = 7,
    LeggingsType_Fur = 8,
    LeggingsType_Count = 9
};
enum EGauntletsImageType : uint8_t {
    GauntletsType_Cloth = 0,
    GauntletsType_Hide = 1,
    GauntletsType_Chitin = 2,
    GauntletsType_Ghille = 3,
    GauntletsType_Flak = 4,
    GauntletsType_Riot = 5,
    GauntletsType_Tek = 6,
    GauntletsType_Fur = 7,
    GauntletsType_Count = 8
};
enum EBootsImageType : uint8_t {
    BootsType_Cloth = 0,
    BootsType_Hide = 1,
    BootsType_Chitin = 2,
    BootsType_Ghille = 3,
    BootsType_Flak = 4,
    BootsType_Riot = 5,
    BootsType_Tek = 6,
    BootsType_Scuba = 7,
    BootsType_FrogFeet = 8,
    BootsType_Fur = 9,
    BootsType_Count = 10
};
enum Codetype : uint8_t {
    Codetype_None = 0,
    Codetype_Normal = 1,
    Codetype_Pro = 2,
    Codetype_Max = 3,
    Codetype_Dev = 4,
    Codetype_Count = 5
};
enum EWeaponImageType : uint8_t {
    WeaponImage_Longneck = 0,
    WeaponImage_FabPistol = 1,
    WeaponImage_Club = 2,
    WeaponImage_SimplePistol = 3,
    WeaponImage_SprayPaint = 4,
    WeaponImage_AssaultRifle = 5,
    WeaponImage_C4 = 6,
    WeaponImage_Bola = 7,
    WeaponImage_MetalHatchet = 8,
    WeaponImage_MetalPickaxe = 9,
    WeaponImage_Sword = 10,
    WeaponImage_Crowbar = 11,
    WeaponImage_Cutlass = 12,
    WeaponImage_Pan = 13,
    WeaponImage_Grapples = 14,
    WeaponImage_Crossbow = 15,
    WeaponImage_Bow = 16,
    WeaponImage_CompoundBow = 17,
    WeaponImage_Map = 18,
    WeaponImage_Sickle = 19,
    WeaponImage_Pump = 20,
    WeaponImage_PrimShotgun = 21,
    WeaponImage_FabSniper = 22,
    WeaponImage_RocketLauncher = 23,
    WeaponImage_ElectricProd = 24,
    WeaponImage_StonePickaxe = 25,
    WeaponImage_StoneHatchet = 26,
    WeaponImage_Spear = 27,
    WeaponImage_Torch = 28,
    WeaponImage_Pike = 29,
    WeaponImage_PoisonGrenade = 30,
    WeaponImage_Count = 31
};
struct CreatureIDStruct{
    string DisplayName;
    string EntityName;
    string BlueprintString;
};
struct ItemIDStruct{
    string DisplayName;
    string BlueprintString;
};
struct GameFTransform {
    FQuat Rotation;
    Vector3 Translation;
    Vector3 Scale3D;
    char pad_0x28[0x8];
};
struct SavedChatMessage{
    string SenderName;
    string TextString;
    EChatMessageSource Source;
    EChatChannel Channel;
    EChatMessageType Type;
    ESPTeam Team;
};
struct FChatEntry {
    double Timestamp;
    int TargetingTeam;
    EChatChannel Channel;
    EChatMessageType Type;
    EChatMessageSource Source;
    char pad_0xF[0x1];
    int PlayerID;
    char pad_0x14[0x4];
    FString sender;
    FString message;
    char pad_0x38[0x4];
    int int0;
    char pad_0x40[0x30];
};
struct Waypoint {
    std::string WaypointName;
    float x, y, z;
};
struct FTamedDinoEntry {
    char pad_0x0[0x10];
    uint32_t DinoID;
    char pad_0x14[0x4C];
};
