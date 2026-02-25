//
//  WeaponColor.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/24/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static void (*SetVectorParameterValue)(UObject* MaterialInstance, long FNameBodyPart, FLinearColor Color) = (void(*)(UObject*, long, FLinearColor))utils.getOffset(0x28946a8);
static void (*SetScalarParameterValue)(UObject* MaterialInstance, long FNameBodyPart, float Scalar) = (void(*)(UObject*, long, float))utils.getOffset(0x28946a8);
static long (*MaterialInstanceDynamic)() = (long(*)())utils.getOffset(0x2fbb6b0);
static UObject* (*GetBaseMaterial)(UObject* UMaterialInterface) = (UObject*(*)(UObject*))utils.getOffset(0x028a887c);
static void FNameCreate(long* Object, wchar_t* ObjectName){
    long BaseAdress = gameUtils.GetBaseAdress();
    const auto FNameFunction = reinterpret_cast<void*>(BaseAdress + 0x0140e0ec);
    if(FNameFunction){
        reinterpret_cast<void(__fastcall*)(long*, wchar_t*, int)>(FNameFunction)(Object, ObjectName, 1);
    }
}


vector<DyeEntry> DyeList;

static void CreateDyeList(){
    static bool once = true;
    if(!once) return;
    
    once = false;
    
    DyeList.push_back({"Slate", 412, ArkCol_Slate});
    DyeList.push_back({"Olive", 411, ArkCol_Olive});
    DyeList.push_back({"Navy", 410, ArkCol_Navy});
    DyeList.push_back({"Mud", 409, ArkCol_Mud});
    DyeList.push_back({"Cantaloupe", 408, ArkCol_Cantaloupe});
    DyeList.push_back({"Brick", 407, ArkCol_Brick});
    DyeList.push_back({"Actually Magenta", 406, ArkCol_ActuallyMagenta});
    DyeList.push_back({"Tangerine", 370, ArkCol_Tangerine});
    DyeList.push_back({"Tan", 369, ArkCol_Tan});
    DyeList.push_back({"Sky", 368, ArkCol_Sky});
    DyeList.push_back({"Silver", 367, ArkCol_Silver});
    DyeList.push_back({"Royal", 366, ArkCol_Royal});
    DyeList.push_back({"Pink", 365, ArkCol_Pink});
    DyeList.push_back({"Parchment", 364, ArkCol_Parchment});
    DyeList.push_back({"Forest", 363, ArkCol_Forest});
    DyeList.push_back({"Magenta", 69, ArkCol_Magenta});
    DyeList.push_back({"Cyan", 68, ArkCol_Cyan});
    DyeList.push_back({"Brown", 67, ArkCol_Brown});
    DyeList.push_back({"White", 66, ArkCol_White});
    DyeList.push_back({"Black", 65, ArkCol_Black});
    DyeList.push_back({"Orange", 64, ArkCol_Orange});
    DyeList.push_back({"Purple", 63, ArkCol_Purple});
    DyeList.push_back({"Yellow", 62, ArkCol_Yellow});
    DyeList.push_back({"Blue", 61, ArkCol_Blue});
    DyeList.push_back({"Green", 60, ArkCol_Green});
    DyeList.push_back({"Red", 59, ArkCol_Red});
}
int WeaponColor::GetColorIndex(int ListIndex){
    CreateDyeList();
    
    if(ListIndex > DyeList.size()) return 0;
    
    return DyeList[ListIndex].ColorID;
}
void WeaponColor::ModifyWorldColors(){
    if(RainbowWater)
        WaterColor = utils.GetRainbowLinearColor(10, 1);
    
    if(ChangeWorld){
        
        if(!gameUtils.isInGame()) return;
        
        UObject* LevelScriptActor = gameUtils.GetLevelScriptActor();
        UObject* PrimalGameData = gameUtils.GetPrimalGameData();
        UObject* PostProcess_KnockoutBlur = utils.Read<UObject*>(PrimalGameData + 0x1130);
        UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
        if(RemoveKnockoutBlur){
            if(utils.isValidAdress(PostProcess_KnockoutBlur)){
                utils.Write<long>(PrimalGameData + 0x1130, 0);
            }
        }
        if(utils.isValidAdress(ShooterWeapon)){
            if(RemoveScopeTexture){
                utils.Write<long>(ShooterWeapon + 0x1058, 0);
                utils.Write<float>(ShooterWeapon + 0x1090, 0);
                utils.Write<float>(ShooterWeapon + 0x1094, 0);
                utils.Write<float>(ShooterWeapon + 0x1098, 0);
                utils.Write<float>(ShooterWeapon + 0x109c, 0);
            }
        }
        
        if(utils.isValidAdress(LevelScriptActor))
        {
            static long SimpleSkyTopFName = 0;
            static long SimpleSkyBottomFName = 0;
            
            if(SimpleSkyTopFName == 0 || SimpleSkyBottomFName == 0)
            {
                FNameCreate(&SimpleSkyTopFName, (wchar_t*)L"SimpleSkyTop");
                FNameCreate(&SimpleSkyBottomFName, (wchar_t*)L"SimpleSkyBottom");
            }
            UObject* ArkSkySphere = utils.Read<UObject*>(LevelScriptActor + 0x6e0);
            if(utils.isValidAdress(ArkSkySphere))
            {
                UObject* SkyMaterial = utils.Read<UObject*>(ArkSkySphere + 0x628);
                UObject* WaterMaterial = utils.Read<UObject*>(ArkSkySphere + 0x728);
                if(utils.isValidAdress(SkyMaterial))
                {
                    UObject* SkyBaseMaterial = GetBaseMaterial(SkyMaterial);
                    if(utils.isValidAdress(SkyBaseMaterial)){
                       // Wireframe Sky
                        uint8_t* WireframeByte = (uint8_t*)(SkyBaseMaterial + 0x828);
                        if(SkyWireframe)
                            *WireframeByte = (*WireframeByte & ~1) | 1;
                        else
                            *WireframeByte = (*WireframeByte & ~1);
                    }
                }
                if(utils.isValidAdress(SkyMaterial))
                {
                    UObject* WaterBaseMaterial = GetBaseMaterial(WaterMaterial);
                    if(utils.isValidAdress(WaterBaseMaterial))
                    {
                        uint8_t* WireframeByte = (uint8_t*)(WaterBaseMaterial + 0x828);
                        if(WaterWireframe)
                            *WireframeByte = (*WireframeByte & ~1) | 1;
                        else
                            *WireframeByte = (*WireframeByte & ~1);
                    }
                    
                    if(ChangeWaterColor)
                    {
                        FLinearColor WaterColorMult = FLinearColor(WaterColor.r * WaterColorIntesnity, WaterColor.g * WaterColorIntesnity,WaterColor.b * WaterColorIntesnity,WaterColor.a * WaterColorIntesnity);
                        SetVectorParameterValue(WaterMaterial, SimpleSkyTopFName, WaterColorMult);
                        SetVectorParameterValue(WaterMaterial, SimpleSkyBottomFName, WaterColorMult);
                    }
                }
            }
        }
    }
    
}
/*
 
 void ModifyTheSky(){
     long SimpleSkyTopFName = 0;
     long SimpleSkyBottomFName = 0;
     

     FNameCreate(&SimpleSkyTopFName, L"SimpleSkyTop");
     FNameCreate(&SimpleSkyBottomFName, L"SimpleSkyBottom");
  
     UObject* LevelScriptActor = gameUtils.GetLevelScriptActor();
     if(utils.isValidAdress(LevelScriptActor)){
         UObject* ArkSkySphere = utils.Read<UObject*>(LevelScriptActor + 0x6e0);
         if(utils.isValidAdress(ArkSkySphere)){
             
             UObject* SkyMaterial = utils.Read<UObject*>(ArkSkySphere + 0x628);
             UObject* WaterMaterial = utils.Read<UObject*>(ArkSkySphere + 0x728);
             
             if(utils.isValidAdress(SkyMaterial)){
                 UObject* SkyBaseMaterial = GetBaseMaterial(SkyMaterial);
                 
                 if(utils.isValidAdress(SkyBaseMaterial)){
                    // Wireframe Sky
                    // uint8_t* WireframeByte = (uint8_t*)(SkyBaseMaterial + 0x828);
                    // *WireframeByte = (*WireframeByte & ~1) | 1;
                 }
             }
             if(utils.isValidAdress(WaterMaterial)){
                 UObject* WaterBaseMaterial = GetBaseMaterial(WaterMaterial);
                 if(utils.isValidAdress(WaterBaseMaterial)){
                    // Wireframe Water
                    // uint8_t* WireframeByte = (uint8_t*)(WaterBaseMaterial + 0x828);
                    // *WireframeByte = (*WireframeByte & ~1) | 1;
                 }
                 
                 
                 /*Modify Water Color
                 SetVectorParameterValue(WaterMaterial, SimpleSkyTopFName, White);
                 SetVectorParameterValue(WaterMaterial, SimpleSkyBottomFName, Blue);

                 
             }
         }
     }
 }
 //Works
 void RemoveKnockoutBlur(){
     UObject* PrimalGameData = gameUtils.GetPrimalGameData();
     UObject* PostProcess_KnockoutBlur = utils.Read<UObject*>(PrimalGameData + 0x1130);
     
     if(utils.isValidAdress(PostProcess_KnockoutBlur)){
         utils.Write<long>(PrimalGameData + 0x1130, 0);
     }
 }
 void RemoveScopeTexture(){
     UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
     if(utils.isValidAdress(ShooterWeapon)){
         utils.Write<long>(ShooterWeapon + 0x1058, 0);
         
         uint8_t* bUseScopeOverlay = (uint8_t*)(ShooterWeapon + 0x1078);
         *bUseScopeOverlay = (*bUseScopeOverlay & ~(1 << 4));
         
         
         utils.Write<float>(ShooterWeapon + 0x1090, 0);
         utils.Write<float>(ShooterWeapon + 0x1094, 0);
         utils.Write<float>(ShooterWeapon + 0x1098, 0);
         utils.Write<float>(ShooterWeapon + 0x109c, 0);
         /*
          float AimDriftYawAngle; // Offset: 0x1090 // Size: 0x04
          float AimDriftPitchAngle; // Offset: 0x1094 // Size: 0x04
          float AimDriftYawFrequency; // Offset: 0x1098 // Size: 0x04
          float AimDriftPitchFrequency; // Offset: 0x109c // Size: 0x04
          
     }
 }
 */
void WeaponColor::DrawWeaponColorMenu(){
    CreateDyeList();
    
    if(ImGui::BeginCombo("Dye List", DyeList[SelectedDye].DyeName.c_str()))
    {
        for(int i = 0; i<DyeList.size(); ++i)
        {
            string DisplayString = DyeList[i].DyeName;
            
            ImGui::PushStyleColor(ImGuiCol_Text, DyeList[i].Color.toU32());
            
            if(ImGui::Selectable(DisplayString.c_str(), i == SelectedDye)){
                SelectedDye = i;
            } 
            
            ImGui::PopStyleColor(1);
        }
        ImGui::EndCombo();
    }
    
    ImGui::Columns(3, NULL, false);
    
    /*
     static float WeaponColorIntensity = 1;
     static float WaterColorIntesnity = 1;
     */
    ImGui::Checkbox(GetMenuText("Inventory Color Change"), &EnableWeaponColorChange); ImGui::NextColumn();
    if(EnableWeaponColorChange){
        ImGui::Checkbox(GetMenuText("Held Wep Color Change"), &EnableHeldWeaponDetailedChange); ImGui::NextColumn();
        if(EnableHeldWeaponDetailedChange){
            ImGui::Checkbox(GetMenuText("Held Wep Rainbow"), &HeldWeaponRainbow); ImGui::NextColumn();
            ImGui::ColorEdit3(GetMenuText("Held Wep Color"), &HeldWeaponColor.r, ColorFlags); ImGui::NextColumn();
            ImGui::Checkbox(GetMenuText("Weapon Wireframe"), &WeaponWireframe); ImGui::NextColumn();
            ImGui::Columns();
            
            ImGui::SliderFloat(GetMenuText("Weapon Color Intensity"), &WeaponColorIntensity, 0, 20);
        }
    }
    
    ImGui::Columns();
    
    ImGui::Separator();
    
    ImGui::Checkbox(GetMenuText("Change World"), &ChangeWorld);
    
    ImGui::Columns(3, NULL, false);
    
    if(ChangeWorld){
        ImGui::Checkbox(GetMenuText("Remove Scope"), &RemoveScopeTexture); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("No Knockout Blur"), &RemoveKnockoutBlur); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Sky Wireframe"), &SkyWireframe); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Water Wireframe"), &WaterWireframe); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Change Water Color"), &ChangeWaterColor); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Rainbow Water"), &RainbowWater); ImGui::NextColumn();
        ImGui::ColorEdit3(GetMenuText("Water Color"), &WaterColor.r, ColorFlags); ImGui::NextColumn();
        
        ImGui::Columns();
        ImGui::SliderFloat(GetMenuText("Water Color Intensity"), &WaterColorIntesnity, 0, 20);
    }
    
    ImGui::Columns();
    
}
void WeaponColor::ChangeWeaponColor(){
    ModifyWorldColors();
    if(EnableWeaponColorChange && EnableHeldWeaponDetailedChange)
    {
        UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
        if(utils.isValidAdress(ShooterWeapon))
        {
            if(HeldWeaponRainbow) HeldWeaponColor = utils.GetRainbowLinearColor(10, 1);
            
            static long PaintColorName = 0;
            
            if(PaintColorName == 0)
                FNameCreate(&PaintColorName, (wchar_t*)L"PaintColor");
            
            UObject* FirstPersonMesh = utils.Read<UObject*>(ShooterWeapon + 0xaa0);
            if(utils.isValidAdress(FirstPersonMesh))
            {
                int NumMaterials = GetNumMaterials(FirstPersonMesh);
                for(int i = 0; i<NumMaterials; ++i)
                {
                    UObject* CurrentMaterial = GetMaterial(FirstPersonMesh, i);
                    if(utils.isValidAdress(CurrentMaterial))
                    {
                        if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic()))
                        {
                            FLinearColor WeaponColorMult = FLinearColor(HeldWeaponColor.r * WeaponColorIntensity, HeldWeaponColor.g * WeaponColorIntensity,HeldWeaponColor.b * WeaponColorIntensity,HeldWeaponColor.a * WeaponColorIntensity);
                            SetVectorParameterValue(CurrentMaterial, PaintColorName, WeaponColorMult);
                            if(ChangeWorld)
                            {
                                UObject* BaseMateral = GetBaseMaterial(CurrentMaterial);
                                if(utils.isValidAdress(BaseMateral))
                                {
                                    uint8_t* WireframeByte = (uint8_t*)(BaseMateral + 0x828);
                                    if(WeaponWireframe)
                                        *WireframeByte = (*WireframeByte & ~1) | 1;
                                    else
                                        *WireframeByte = (*WireframeByte & ~1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
int WeaponColor::GetNumMaterials(UObject *SkinnedMeshComponent){
    UObject* USkeletalMesh = utils.Read<UObject*>(SkinnedMeshComponent + 0x970);
    if(utils.isValidAdress(USkeletalMesh)){
        return utils.Read<int>(USkeletalMesh + 0xa8);
    }
    
    return 0;
}
UObject* WeaponColor::GetMaterial(UObject *SkinnedMeshComponent, int ElementIndex){
    if(ElementIndex < 0)
        return nullptr;
    
    TArray<UObject*> UMaterialInterface_OverrideMaterials = utils.Read<TArray<UObject*>>(SkinnedMeshComponent + 0x868);
    if(ElementIndex < UMaterialInterface_OverrideMaterials.Count){
        UObject* MaterialInterface = UMaterialInterface_OverrideMaterials[ElementIndex];
        if(utils.isValidAdress(MaterialInterface)) return MaterialInterface;
    }
    
    UObject* USkeletalMesh = utils.Read<UObject*>(SkinnedMeshComponent + 0x970);
    if(utils.isValidAdress(USkeletalMesh)){
        TArray<FSkeletalMaterial> SkeletalMaterials = utils.Read<TArray<FSkeletalMaterial>>(USkeletalMesh + 0xa0);
        if(ElementIndex < SkeletalMaterials.Count){
            return SkeletalMaterials[ElementIndex].MaterialInterface;
        }
    }
    
    return nullptr;
}
