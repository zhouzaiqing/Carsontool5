//
//  PlayerColors.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/26/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static void (*SetVectorParameterValue)(UObject* MaterialInstance, long FNameBodyPart, FLinearColor Color) = (void(*)(UObject*, long, FLinearColor))utils.getOffset(0x28946a8);
static void (*SetScalarParameterValue)(UObject* MaterialInstance, long FNameBodyPart, float Scalar) = (void(*)(UObject*, long, float))utils.getOffset(0x28946a8);
static void (*ApplyBodyColors)(UObject* ShooterCharacter) = (void(*)(UObject*))utils.getOffset(0x00a1f0a4);
static long (*MaterialInstanceDynamic)() = (long(*)())utils.getOffset(0x2fbb6b0);
static UObject* (*GetBaseMaterial)(UObject* UMaterialInterface) = (UObject*(*)(UObject*))utils.getOffset(0x028a887c);



static void FNameCreate(long* Object, wchar_t* ObjectName){
    long BaseAdress = gameUtils.GetBaseAdress();
    const auto FNameFunction = reinterpret_cast<void*>(BaseAdress + 0x0140e0ec);
    if(FNameFunction){
        reinterpret_cast<void(__fastcall*)(long*, wchar_t*, int)>(FNameFunction)(Object, ObjectName, 1);
    }
}

static int GetNumMaterials(UObject* SkinnedMeshComponent){
    UObject* USkeletalMesh = utils.Read<UObject*>(SkinnedMeshComponent + 0x970);
    if(utils.isValidAdress(USkeletalMesh)){
        return utils.Read<int>(USkeletalMesh + 0xa8);
    }
    return 0;
}
static UObject* GetMaterial(UObject* SkinnedMeshComponent, int ElementIndex){
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
/*
static void PrintMyCharacterMeshes(){
    UObject* MyShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(MyShooterCharacter)){
        UObject* Mesh = utils.Read<UObject*>(MyShooterCharacter + 0x638);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        PrintDynamicMaterialParameters(CurrentMaterial);
                    }
                }
            }
            menu.ConsoleLog("Player Mesh 0x638", "kkkk", Blue);
        }
        
        Mesh = utils.Read<UObject*>(MyShooterCharacter + 0x15e8);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        PrintDynamicMaterialParameters(CurrentMaterial);
                    }
                }
            }
            menu.ConsoleLog("Player Mesh 0x15e8", "kkkk", Blue);
        }
    }
    menu.ConsoleLog("Shooter Character", "kkk", Green);
    UObject* PrimalDinoCharacter = gameUtils.GetMountedDino();
    if(utils.isValidAdress(PrimalDinoCharacter)){
        UObject* Mesh = utils.Read<UObject*>(PrimalDinoCharacter + 0x638);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        PrintDynamicMaterialParameters(CurrentMaterial);
                    }
                }
            }
            menu.ConsoleLog("Dino Mesh 0x638", "kkkk", Blue);
        }
        Mesh = utils.Read<UObject*>(PrimalDinoCharacter + 0x1db8);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        PrintDynamicMaterialParameters(CurrentMaterial);
                    }
                }
            }
            menu.ConsoleLog("Dino Saddle Mesh 0x1db8", "kkkk", Blue);
        }
    }
    menu.ConsoleLog("Dino Character", "kkk", Green);
} */



void PlayerColors::HandlePlayerWireframe(){
    UObject* MyShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(MyShooterCharacter)){
        
        FLinearColor BodyColorMult = FLinearColor(BodyColor.r * PlayerColorIntensity, BodyColor.g * PlayerColorIntensity,BodyColor.b * PlayerColorIntensity,BodyColor.a * PlayerColorIntensity);
        FLinearColor HairColorMult = FLinearColor(HairColor.r * PlayerColorIntensity, HairColor.g * PlayerColorIntensity,HairColor.b * PlayerColorIntensity,HairColor.a * PlayerColorIntensity);
        
        /*
         FName::FName((FName *)&BodyFName,"Body",1);
         FName::FName((FName *)&HairFName,"Hair",1);
         */
        bool canChangeBodyColor = false;
        
        
        UObject* Mesh = utils.Read<UObject*>(MyShooterCharacter + 0x638);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        UObject* BaseMaterial = GetBaseMaterial(CurrentMaterial);
                        if(utils.isValidAdress(BaseMaterial)){
                            
                            canChangeBodyColor = true;
                            
                            uint8_t* WireframeByte = (uint8_t*)(BaseMaterial + 0x828);
                            
                            if(PlayerWireframe)
                                *WireframeByte = (*WireframeByte & ~1) | 1;
                            else
                                *WireframeByte = (*WireframeByte & ~1);
                        }
                    }
                }
            }
        }
        
        if(gameUtils.isInGame() && canChangeBodyColor){
            
            if(ChangeBodyColor)
                *(FLinearColor*)(MyShooterCharacter + 0x1abc) = BodyColorMult;
            
            if(ChangeHairColor)
                *(FLinearColor*)(MyShooterCharacter + 0x1acc) = HairColorMult;
            
            ApplyBodyColors(MyShooterCharacter);
        }
    }
}
void PlayerColors::ChangePlayerColors(){
    HandlePlayerRainbow();
    UObject* MyCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(MyCharacter)){
        HandlePlayerWireframe();
    }
}
void PlayerColors::HandlePlayerRainbow(){
    if(RainbowHair)
        HairColor = utils.GetRainbowLinearColor(PlayerRainbowCycleTime, 1);
    
    if(RainbowBody)
        BodyColor = utils.GetRainbowLinearColor(PlayerRainbowCycleTime, 1);
    
    HairColor.a = 1;
    BodyColor.a = 1;
    
}
void PlayerColors::DrawMenu(){
    
    ImGui::Columns(3, NULL, false);
    
    ImGui::Checkbox(GetMenuText("Change Hair Color"), &ChangeHairColor); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Change Body Color"), &ChangeBodyColor); ImGui::NextColumn();
    
    ImGui::Checkbox(GetMenuText("Rainbow Hair"), &RainbowHair); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Rainbow Body"), &RainbowBody); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Player Wireframe"), &PlayerWireframe); ImGui::NextColumn();
    
    ImGui::ColorEdit3(GetMenuText("Body Color"), &BodyColor.r, ColorFlags); ImGui::NextColumn();
    ImGui::ColorEdit3(GetMenuText("Hair Color"), &HairColor.r, ColorFlags); ImGui::NextColumn();
    
    ImGui::Columns();
    
    ImGui::SliderInt(GetMenuText("Rainbow Cycle Time"), &PlayerRainbowCycleTime, 1, 20);
    ImGui::SliderFloat("Player Color Intensity", &PlayerColorIntensity, 0, 20);
    
    
    
    
}

