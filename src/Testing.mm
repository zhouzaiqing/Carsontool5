//
//  Testing.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/24/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"
#include <pthread.h>

//SetVector 028946a8
//SetScalar 02894924
//MaterialPrivate 02fbb6b0
static void (*SetVectorParameterValue)(UObject* MaterialInstance, long FNameBodyPart, FLinearColor Color) = (void(*)(UObject*, long, FLinearColor))utils.getOffset(0x28946a8);
static void (*SetScalarParameterValue)(UObject* MaterialInstance, long FNameBodyPart, float Scalar) = (void(*)(UObject*, long, float))utils.getOffset(0x28946a8);
static long (*MaterialInstanceDynamic)() = (long(*)())utils.getOffset(0x2fbb6b0);
static long (*MaterialInstanceConstant)() = (long(*)())utils.getOffset(0x2fb9764);

static UObject* (*GetBaseMaterial)(UObject* UMaterialInterface) = (UObject*(*)(UObject*))utils.getOffset(0x028a887c);

/*
 
 Look at SkeletalMeshActor
 
 long __thiscall USkinnedMeshComponent::GetMaterial(USkinnedMeshComponent *this,int param_1)

 {
   long lVar1;
   long lVar2;
   
   if (param_1 < 0) {
     return 0;
   }
   if ((OverrideMaterials.Count <= param_1) ||
      (lVar1 = *(long *)(*(long *)(this + 0x868) + (long)param_1 * 8), lVar1 == 0)) {
     lVar2 = *(long *)(this + 0x970);
     lVar1 = 0;
     if ((lVar2 != 0) && (-1 < param_1)) {
       if (*(int *)(lVar2 + 0xa8) <= param_1) {
         return 0;
       }
       lVar1 = *(long *)(*(long *)(lVar2 + 0xa0) + (long)param_1 * 0x30);
     }
   }
   return lVar1;
 }
 */


 /*
 long GetMaterial(long SkinnedMeshComponent,uint ElementIndex)

 {
   long lVar1;
   
   if (-1 < (int)ElementIndex) {

     USkeletalMesh = *(long *)(param_1 + 0x970);
     if ((USkeletalMesh != 0) && ((int)param_2 < *(int *)(USkeletalMesh + 0xa8))) {
       return *(long *)(*(long *)(USkeletalMesh + 0xa0) + (ulong)param_2 * 0x30);
     }
   }
   return 0;
 }

 
 
 
 
 long CharacterMeshZFunctionOne = utils.Read<long>(CharacterMeshVTable + 0x728) - BaseAdress; //0x26b2ce8
 int GetNumMaterials(USkinnedMeshComponent* this)
 
 
 long CharacterMeshZFunctionTwo = utils.Read<long>(CharacterMeshVTable + 0x5d8) - BaseAdress; //0x26b2d00
 GetMaterial(USkinnedMeshComponent* this, int ElementIndex);
 
 
 //struct UMaterialInterface* GetMaterial(int ElementIndex);
 
 undefined4 FUN_026b2ce8(long param_1)

 {
   if (*(long *)(param_1 + 0x970) != 0) {
     return *(undefined4 *)(*(long *)(param_1 + 0x970) + 0xa8);
   }
   return 0;
 
 struct TArray<struct FSkeletalMaterial> Materials; // Offset: 0xa0 // Size: 0x10
 SkeletalMesh + Materials.Count;
 }
 
 26b4274
  
  
  
  
SetVectorParamValue
  
  
  struct TArray<struct FVectorParameterValue> VectorParameterValues; // Offset: 0xb8 // Size: 0x10
 
 */
static void (*ApplyBodyColors)(UObject* ShooterCharacter) = (void(*)(UObject*))utils.getOffset(0x00a1f0a4);
/*
 void FunctionCall::ProcessEventCall(UObject* Object, wchar_t* FunctionName, void* params){
     const auto FNameFunction = reinterpret_cast<void*>(BaseAdress + 0x0140e0ec);
     const auto FindFunctionCheckedFunction = reinterpret_cast<long*>(BaseAdress + 0x0154a6a4);
     const auto ProcessEventFunction = reinterpret_cast<void*>(BaseAdress + 0x024b57ec);
     if(FNameFunction && FindFunctionCheckedFunction && ProcessEventFunction){
         long FuncFName;
         
         reinterpret_cast<void(__fastcall*)(long, wchar_t*, int)>(FNameFunction)((long)&FuncFName, FunctionName, 1);
 */
static int GetNumMaterials(UObject* SkinnedMeshComponent){
    UObject* USkeletalMesh = utils.Read<UObject*>(SkinnedMeshComponent + 0x970);
    if(utils.isValidAdress(USkeletalMesh)){
        return utils.Read<int>(USkeletalMesh + 0xa8);
    }
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



static void FNameCreate(long* Object, wchar_t* ObjectName){
    long BaseAdress = gameUtils.GetBaseAdress();
    const auto FNameFunction = reinterpret_cast<void*>(BaseAdress + 0x0140e0ec);
    if(FNameFunction){
        reinterpret_cast<void(__fastcall*)(long*, wchar_t*, int)>(FNameFunction)(Object, ObjectName, 1);
    }
}

/*
 struct TArray<struct FFontParameterValue> FontParameterValues; // Offset: 0x88 // Size: 0x10
     struct TArray<struct FScalarParameterValue> ScalarParameterValues; // Offset: 0x98 // Size: 0x10
     struct TArray<struct FTextureParameterValue> TextureParameterValues; // Offset: 0xa8 // Size: 0x10
     struct TArray<struct FVectorParameterValue> VectorParameterValues; // Offset: 0xb8 // Size: 0x10
 */
static void PrintDynamicMaterialParameters(UObject* UMaterialInstance){
    if(utils.isValidAdress(UMaterialInstance)){
        TArray<FFontParameterValue> FontParameterValues = utils.Read<TArray<FFontParameterValue>>(UMaterialInstance + 0x88);
        TArray<FScalarParameterValue> ScalarParameterValues = utils.Read<TArray<FScalarParameterValue>>(UMaterialInstance + 0x98);
        TArray<FTextureParameterValue> TextureParameterValues = utils.Read<TArray<FTextureParameterValue>>(UMaterialInstance + 0xa8);
        TArray<FVectorParameterValue> VectorParameterValues = utils.Read<TArray<FVectorParameterValue>>(UMaterialInstance + 0xb8);
        
        if(FontParameterValues.IsValidArray()){
            for(int i = 0; i<FontParameterValues.Count; i++){
                string ParameterName = gameUtils.GetFName((int)FontParameterValues[i].FNameParameterName);
                menu.ConsoleLog("Font Parameter", ParameterName, Red);
            }
        }
        
        if(ScalarParameterValues.IsValidArray()){
            for(int i = 0; i<ScalarParameterValues.Count; i++){
                string ParameterName = gameUtils.GetFName((int)ScalarParameterValues[i].FNameParameterName);
                ParameterName += " " + to_string(ScalarParameterValues[i].ParameterValue);
                menu.ConsoleLog("Scalar Parameter", ParameterName, Red);
            }
        }
        
        if(TextureParameterValues.IsValidArray()){
            for(int i = 0; i<TextureParameterValues.Count; i++){
                string ParameterName = gameUtils.GetFName((int)TextureParameterValues[i].FNameParameterName);
                menu.ConsoleLog("Texture Parameter", ParameterName, Red);
            }
        }
        
        if(VectorParameterValues.IsValidArray()){
            for(int i = 0; i<VectorParameterValues.Count; i++){
                string ParameterName = gameUtils.GetFName((int)VectorParameterValues[i].FNameParameterName);
                ParameterName += " R " + to_string(VectorParameterValues[i].ParameterValue.r) +  " G " + to_string(VectorParameterValues[i].ParameterValue.g) + " B " + to_string(VectorParameterValues[i].ParameterValue.b) + " A " + to_string(VectorParameterValues[i].ParameterValue.a);
                menu.ConsoleLog("Vector Parameter", ParameterName, Red);
            }
        }
        
        string SummaryString = utils.string_format("Font Parameters: %d \n Scalar Parameters %d \n Texture Parameters %d \n Vector Parameters %d", FontParameterValues.Count, ScalarParameterValues.Count, TextureParameterValues.Count, VectorParameterValues.Count);
        
        menu.ConsoleLog(SummaryString, gameUtils.SGetObjectName(UMaterialInstance), Blue);
    } 
}


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
}


static void SetDinoColor(UObject* Dino){
    if(utils.isValidAdress(Dino)){
        static long Color5FName = 0;
        static long Color4FName = 0;
        static long Color3FName = 0;
        static long Color2FName = 0;
        static long Color1FName = 0;
        static long Color0FName = 0;
        static long EeryParamsFName = 0;
        static long Wind_FeatherParamsFName = 0;
        static long TilingFName = 0;
        
        if(Color5FName == 0){
            FNameCreate(&Color5FName, (wchar_t*)L"Color5");
            FNameCreate(&Color4FName, (wchar_t*)L"Color4");
            FNameCreate(&Color3FName, (wchar_t*)L"Color3");
            FNameCreate(&Color2FName, (wchar_t*)L"Color2");
            FNameCreate(&Color1FName, (wchar_t*)L"Color1");
            FNameCreate(&Color0FName, (wchar_t*)L"Color0");
            FNameCreate(&EeryParamsFName, (wchar_t*)L"EeryParams");
            FNameCreate(&Wind_FeatherParamsFName, (wchar_t*)L"Wind_FeatherParams");
            FNameCreate(&TilingFName, (wchar_t*)L"Tiling");
        }
        
        
        UObject* Mesh = utils.Read<UObject*>(Dino + 0x638);
        if(utils.isValidAdress(Mesh)){
            int NumMaterials = GetNumMaterials(Mesh);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(Mesh, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        SetVectorParameterValue(CurrentMaterial, Color5FName, Green);
                        SetVectorParameterValue(CurrentMaterial, Color4FName, Green);
                        SetVectorParameterValue(CurrentMaterial, Color3FName, Green);
                        SetVectorParameterValue(CurrentMaterial, Color2FName, Green);
                        SetVectorParameterValue(CurrentMaterial, Color1FName, Green);
                        SetVectorParameterValue(CurrentMaterial, Color0FName, Green);
                    }
                }
            }
            //menu.ConsoleLog("Dino Saddle Mesh 0x1db8", "kkkk", Blue);
        }
        
        
    }
}
/*
 PrimalDinoCharacter + 0x638
 
 Vector:
    Color5
    Color4
    Color3
    EeryParams
    Wind_FeatherParams
    Color2
    Color1
    Color0
    Tiling
 
 Scalar:
    DiffuseMult
    Metallic
    Roughness
    Specular
    
 */
//0x1db8
//0x638
static void MyBodyColors(UObject* ShooterCharacter){
    long BaseAdress = gameUtils.GetBaseAdress();
   
    long BodyFName = 0;
    FNameCreate(&BodyFName, (wchar_t*)L"Body"); //Works I Think
    
    UObject* CharacterMeshZ = utils.Read<UObject*>(ShooterCharacter + 0x638); //CharacterMesh0
    if(utils.isValidAdress(CharacterMeshZ)){
        int NumMaterials = GetNumMaterials(CharacterMeshZ);
        for(int i = 0; i<NumMaterials; ++i){
            UObject* CurrentMaterial = GetMaterial(CharacterMeshZ, i);
            if(utils.isValidAdress(CurrentMaterial)){
                if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                    SetVectorParameterValue(CurrentMaterial, BodyFName, Green);
                    
                    UObject* BaseMaterial = GetBaseMaterial(CurrentMaterial);
                    if(utils.isValidAdress(BaseMaterial)){
                        // Wireframe
                        uint8_t* WireframeByte = (uint8_t*)(BaseMaterial + 0x828);
                        *WireframeByte = (*WireframeByte & ~1) | 1;
                        
                    }
                    
                    PrintDynamicMaterialParameters(CurrentMaterial);
                }
            }
        }
    }
}


void Testing::ShooterWeaponTest(){
    
    UObject* GameState = gameUtils.GetGameStateBase();
    if(utils.isValidAdress(GameState)){
        FString* ServerName  = (FString*)(GameState + 0x9b8);
        menu.ConsoleLog(gameUtils.FStringToString(*ServerName), "Kkkkkk", Blue);
    }
    /*
    long PaintColorName = 0;
    FNameCreate(&PaintColorName, (wchar_t*)L"PaintColor"); //Works I Think
    
    UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
    if(utils.isValidAdress(ShooterWeapon)){
        UObject* MeshFirstPerson = utils.Read<UObject*>(ShooterWeapon + 0xaa0);
        if(utils.isValidAdress(MeshFirstPerson)){
            int NumMaterials = GetNumMaterials(MeshFirstPerson);
            for(int i = 0; i<NumMaterials; ++i){
                UObject* CurrentMaterial = GetMaterial(MeshFirstPerson, i);
                if(utils.isValidAdress(CurrentMaterial)){
                    if(gameUtils.isA_Fast(CurrentMaterial, MaterialInstanceDynamic())){
                        SetVectorParameterValue(CurrentMaterial, PaintColorName, utils.GetRainbowLinearColor(10, 1));
                    }
                }
            }
        }
    } */
}
void Testing::PlacerColorTest(){
    UObject* StructurePlacer = gameUtils.GetStructurePlacer();
    if(utils.isValidAdress(StructurePlacer)){
        long ColorParamFName = 0;
        FNameCreate(&ColorParamFName, (wchar_t*)L"ColorParam");
        
        TArray<UObject*> PreviewMaterialInstances = utils.Read<TArray<UObject*>>(StructurePlacer + 0x6b0);
        if(PreviewMaterialInstances.IsValidArray()){
            for(int i = 0; i<PreviewMaterialInstances.Count; ++i){
                UObject* MaterialInstanceDynamic = PreviewMaterialInstances[i];
                if(utils.isValidAdress(MaterialInstanceDynamic)){
                    SetVectorParameterValue(MaterialInstanceDynamic, ColorParamFName, Red);
                    PrintDynamicMaterialParameters(MaterialInstanceDynamic);
                }
            }
        }
    }
}
static FLinearColor (*GetColorForID)(int ID) = (FLinearColor(*)(int))utils.getOffset(0x008c2404);
void DumpItemIDs(){
    UObject* PrimalGameData = gameUtils.GetPrimalGameData();
    if(utils.isValidAdress(PrimalGameData)){
        TArray<UClassPointer> MasterItemList = utils.Read<TArray<UClassPointer>>(PrimalGameData + 0xef8);
        
        for(int i = 0; i<MasterItemList.Count; ++i){
            UClassPointer CurrentItemClass = MasterItemList[i];
            string CurrentItem = gameUtils.FStringToString(CurrentItemClass.AssetName);
            
            std::size_t DyePos = CurrentItem.find("PrimalItemDye");
            if (DyePos!=std::string::npos){
                //menu.ConsoleLog(CurrentItem, to_string(i), White);
                FLinearColor ItemColor = GetColorForID(i + 1);
                string ItemColorString = utils.string_format("ID: %d r: %f g: %f b: %f", i + 1, ItemColor.r, ItemColor.g, ItemColor.b);
                menu.ConsoleLog(CurrentItem, ItemColorString, ItemColor);
            }
        }
    }
}
void Testing::PlayerBodyTest(){
    static FLinearColor CurrentColor;
    static bool ColorSwitch = false;
    
    CurrentColor = ColorSwitch ? Red : Blue;
    ColorSwitch = !ColorSwitch;
    
    UObject* ShooterCharacter = gameUtils.GetMyShooterCharacter();
    if(utils.isValidAdress(ShooterCharacter)){
        utils.Write<FLinearColor>(ShooterCharacter + 0x1abc, CurrentColor);
        ApplyBodyColors(ShooterCharacter);
        MyBodyColors(ShooterCharacter);
    }
}


/*
 
 void UMaterialInstanceDynamic::SetVectorParameterValue(FName param_1,FLinearColor param_2)
 
 SetVectorParameterValue(Material, FName, FLinearColor);
 
 
 
 void __thiscall AShooterCharacter::ApplyBodyColors(AShooterCharacter *this)

 {
   FName FVar1;
   int iVar2;
   UMaterialInstanceDynamic *pUVar3;
   long lVar4;
   long lVar5;
   long *plVar6;
   int iVar7;
   int local_44;
   
   if ((((byte)this[0x318] & 6) == 4) || (((byte)this[0x318] & 6) == 2)) {
     if (((DAT_0745f7f8 & 1) == 0) && (iVar2 = __cxa_guard_acquire(), iVar2 != 0)) {
       FName::FName((FName *)&BodyFName,"Body",1);
       FName::FName((FName *)&HairFName,"Hair",1);
       FName::FName((FName *)&EyesFName,"Eyes",1);
     }
    //char pad_0x638[0x8]; // Offset: 0x638 // Size: 0x08
     USkinnedMeshComponent* BodyMesh0 = *(long*)(this + 0x638);
     int NumMaterials = GetNumMaterials(BodyMesh0);
     if (0 < NumMaterials) {
       CurrentMaterialIndex = 0;
       do {
        UMaterialInstanceDynamic* CurrentMaterial = (UMaterialInstanceDynamic *)GetMaterial(BodyMesh0,CurrentMaterialIndex);
         if (CurrentMaterial != (UMaterialInstanceDynamic *)0x0) {
           UMaterialInstanceDynamic* MaterialClass = UMaterialInstanceDynamic::GetPrivateStaticClass();
           if(isA(CurrentMaterial, MaterialClass){
             FVar1 = SUB81(CurrentMaterial,0);
             SetVectorParameterValue(CurrentMaterial, BodyFName, BodyColor);
             SetVectorParameterValue(CurrentMaterial, HairFName, HairColor);
             SetVectorParameterValue(CurrentMaterial, EyesFName, EyeColor);
             SetScalarParameterValue(CurrentMaterial, HairFName, *(float*)(this + 0x1aec);
            //float HairLength; // Offset: 0x1aec // Size: 0x04
           }
         }
        CurrentMaterialIndex = CurrentMaterialIndex + 1;
       } while (NumMaterials != CurrentMaterialIndex);
     }
    NumMaterials = (**(code **)(**(long **)(this + 0x15e8) + 0x728))();
     if (0 < NumMaterials) {
       iVar7 = 0;
       do {
         lVar4 = (**(code **)(**(long **)(this + 0x15e8) + 0x5d8))(*(long **)(this + 0x15e8),iVar7);
         if (lVar4 != 0) {
           lVar5 = UMaterialInstanceDynamic::GetPrivateStaticClass();
           if ((*(int *)(lVar5 + 0x90) <= *(int *)(*(long *)(lVar4 + 0x10) + 0x90)) &&
              (*(long *)(*(long *)(*(long *)(lVar4 + 0x10) + 0x88) + (long)*(int *)(lVar5 + 0x90) * 8
                        ) == lVar5 + 0x88)) {
             FVar1 = SUB81(lVar4,0);
             UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(BodyFName,0));
             UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(HairFName,0));
             UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(EyesFName,0));
           }
         }
         iVar7 = iVar7 + 1;
       } while (NumMaterials != iVar7);
     }
     local_44 = 0;
     plVar6 = (long *)GetHairComponent(this,&local_44);
     if (plVar6 != (long *)0x0) {
       iVar2 = (**(code **)(*plVar6 + 0x728))(plVar6);
       if (0 < iVar2) {
         iVar7 = 0;
         do {
           lVar4 = (**(code **)(*plVar6 + 0x5d8))(plVar6,iVar7);
           if (lVar4 != 0) {
             lVar5 = UMaterialInstanceDynamic::GetPrivateStaticClass();
             if ((*(int *)(lVar5 + 0x90) <= *(int *)(*(long *)(lVar4 + 0x10) + 0x90)) &&
                (*(long *)(*(long *)(*(long *)(lVar4 + 0x10) + 0x88) +
                          (long)*(int *)(lVar5 + 0x90) * 8) == lVar5 + 0x88)) {
               FVar1 = SUB81(lVar4,0);
               UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(BodyFName,0));
               UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(HairFName,0));
               UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(EyesFName,0));
             }
           }
           iVar7 = iVar7 + 1;
         } while (iVar2 != iVar7);
       }
       plVar6 = (long *)GetFacialHairComponent(this,&local_44);
       if (plVar6 != (long *)0x0) {
         iVar2 = (**(code **)(*plVar6 + 0x728))(plVar6);
         if (0 < iVar2) {
           iVar7 = 0;
           do {
             pUVar3 = (UMaterialInstanceDynamic *)(**(code **)(*plVar6 + 0x5d8))(plVar6,iVar7);
             if (pUVar3 != (UMaterialInstanceDynamic *)0x0) {
               lVar4 = UMaterialInstanceDynamic::GetPrivateStaticClass();
               if ((*(int *)(lVar4 + 0x90) <= *(int *)(*(long *)(pUVar3 + 0x10) + 0x90)) &&
                  (*(long *)(*(long *)(*(long *)(pUVar3 + 0x10) + 0x88) +
                            (long)*(int *)(lVar4 + 0x90) * 8) == lVar4 + 0x88)) {
                 FVar1 = SUB81(pUVar3,0);
                 UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(BodyFName,0));
                 UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(HairFName,0));
                 UMaterialInstanceDynamic::SetVectorParameterValue(FVar1,SUB81(EyesFName,0));
                 UMaterialInstanceDynamic::SetScalarParameterValue
                           (pUVar3,SUB81(HairFName,0),*(float *)(this + 0x1af4));
               }
             }
             iVar7 = iVar7 + 1;
           } while (iVar2 != iVar7);
         }
       }
     }
   }
   return;
 }
 */


/* 62
 
 
 undefined4 UPrimalItem::StaticGetColorForItemColorID(int param_1)

 {
   FWeakObjectPtr *pFVar1;
   long *plVar2;
   long *plVar3;
   UObject *pUVar4;
   long lVar5;
   long *plVar6;
   long lVar7;
   long lVar8;
   long *plVar9;
   undefined1 *puVar10;
   
   puVar10 = FLinearColor::White;
   if (param_1 == 0) goto LAB_02ba04b8;
   lVar7 = *(long *)(GEngine + 0x1e0);
   lVar5 = *(long *)(lVar7 + 0x40);
   lVar8 = lVar5;
   if (lVar5 == 0) {
     lVar8 = *(long *)(lVar7 + 0x28);
   }

   lVar8 = (long)param_1 + -1;
   if (lVar5 == 0) {
     lVar5 = *(long *)(lVar7 + 0x28);
   }
   lVar7 = *(long *)(lVar5 + 0xef8);
   pFVar1 = (FWeakObjectPtr *)(lVar7 + lVar8 * 0x20);
   lVar5 = FWeakObjectPtr::Get(pFVar1);
   if (lVar5 == 0) {
     if (FStringAssetReference::CurrentTag != *(int *)(pFVar1 + 8)) {
       if (*(int *)(pFVar1 + 0x18) < 2) goto LAB_02ba04b8;
       pUVar4 = (UObject *)
                FStringAssetReference::ResolveObject
                          ((FStringAssetReference *)(lVar7 + lVar8 * 0x20 + 0x10));
       FWeakObjectPtr::operator=(pFVar1,pUVar4);
       if ((pUVar4 != (UObject *)0x0) || (GIsSavingPackage == '\0')) {
         *(int *)(pFVar1 + 8) = FStringAssetReference::CurrentTag;
       }
       lVar5 = FWeakObjectPtr::Get(pFVar1);
       if (lVar5 != 0) goto LAB_02ba02ac;
     }
     if (*(int *)(pFVar1 + 0x18) < 2) goto LAB_02ba04b8;
   }
 LAB_02ba02ac:
   lVar5 = *(long *)(GEngine + 0x1e0);
   lVar7 = *(long *)(lVar5 + 0x40);
   if (lVar7 == 0) {
     lVar7 = *(long *)(lVar5 + 0x28);
   }
   UPrimalAssets::Resolve<UPrimalItem>
             (*(UPrimalAssets **)(lVar5 + 0x38),
              (TAssetSubclassOf *)(*(long *)(lVar7 + 0xef8) + lVar8 * 0x20));
   lVar5 = *(long *)(*(long *)(GEngine + 0x1e0) + 0x40);
   if (lVar5 == 0) {
     lVar5 = *(long *)(*(long *)(GEngine + 0x1e0) + 0x28);
   }
   lVar5 = *(long *)(lVar5 + 0xef8);
   pFVar1 = (FWeakObjectPtr *)(lVar5 + lVar8 * 0x20);
   plVar2 = (long *)FWeakObjectPtr::Get(pFVar1);
   if (plVar2 == (long *)0x0) {
     if ((FStringAssetReference::CurrentTag != *(int *)(pFVar1 + 8)) &&
        (lVar5 = lVar5 + lVar8 * 0x20, 1 < *(int *)(lVar5 + 0x18))) {
       pUVar4 = (UObject *)
                FStringAssetReference::ResolveObject((FStringAssetReference *)(lVar5 + 0x10));
       FWeakObjectPtr::operator=(pFVar1,pUVar4);
       if ((pUVar4 != (UObject *)0x0) || (GIsSavingPackage == '\0')) {
         *(int *)(pFVar1 + 8) = FStringAssetReference::CurrentTag;
       }
       plVar2 = (long *)FWeakObjectPtr::Get(pFVar1);
       if (plVar2 != (long *)0x0) goto LAB_02ba02f8;
     }
   }
   else {
 LAB_02ba02f8:
     lVar8 = UClass::GetPrivateStaticClass();
     if ((*(int *)(lVar8 + 0x90) <= *(int *)(plVar2[2] + 0x90)) &&
        (*(long *)(*(long *)(plVar2[2] + 0x88) + (long)*(int *)(lVar8 + 0x90) * 8) == lVar8 + 0x88))
     {
       plVar3 = (long *)GetPrivateStaticClass();
       plVar6 = plVar2;
       do {
         if (plVar6 == plVar3) {
           if (plVar2 != (long *)0x0) {
             plVar3 = (long *)GetPrivateStaticClass();
             plVar6 = plVar2;
             goto LAB_02ba045c;
           }
           break;
         }
         plVar6 = (long *)plVar6[6];
       } while (plVar6 != (long *)0x0);
     }
   }
   plVar9 = (long *)0x0;
   lVar8 = _DAT_00000108;
   goto joined_r0x02ba048c;
   while( true ) {
     plVar6 = (long *)plVar6[6];
     plVar9 = (long *)0x0;
     if (plVar6 == (long *)0x0) break;
 LAB_02ba045c:
     plVar9 = plVar2;
     if (plVar6 == plVar3) break;
   }
   lVar8 = plVar9[0x21];
 joined_r0x02ba048c:
   if (lVar8 == 0) {
     (**(code **)(*plVar9 + 0x358))(plVar9);
     lVar8 = plVar9[0x21];
     if (lVar8 == 0) goto LAB_02ba04b8;
   }
   puVar10 = (undefined1 *)(lVar8 + 0xa54);
 LAB_02ba04b8:
   return *(undefined4 *)puVar10;
 }

 */


/*
 SkyMaterial:
    Scalars
        Alpha .0000005
        DesaturateAmt - .15
        FinalModulate - 1.0
        TargetModulate - 1.4
        BaseModulate - 1.5
        StarAmt - .005179
        Cloud opacity - 1.00000
 
 WaterMaterial:
    Vector
        SimpleSkyTop
        SimpleSkyBottom
 
    Scalar
        Alpha
        FinalModulate
        SimpleSkyBend
        TargetModulate
        BaseModulate
 
 
 
 
 
 struct UMaterialInstanceDynamic* Sky material; // Offset: 0x628 // Size: 0x08
 struct UMaterialInstanceDynamic* WaterMaterial; // Offset: 0x728 // Size: 0x08
 */

//Works
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
                SetVectorParameterValue(WaterMaterial, SimpleSkyBottomFName, Blue); */

                
            }
        }
    }
}
/*
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

    }
}


 struct UMaterialInterface* TopMaterial; // Offset: 0x610 // Size: 0x08
 struct UMaterialInterface* UndersideMaterial; // Offset: 0x618 // Size: 0x08
 
 
 */
void Testing::RemoveScopeTest(){
    
    //RemoveScopeTexture();
}

//static void (*SetVectorParameterValue)(UObject* MaterialInstance, long FNameBodyPart, FLinearColor Color) = (void(*)(UObject*, long, FLinearColor))utils.getOffset(0x28946a8);
//static void (*SetScalarParameterValue)(UObject* MaterialInstance, long FNameBodyPart, float Scalar) = (void(*)(UObject*, long, float))utils.getOffset(0x28946a8);

/*
 TArray<FFontParameterValue> FontParameterValues = utils.Read<TArray<FFontParameterValue>>(UMaterialInstance + 0x88);
 TArray<FScalarParameterValue> ScalarParameterValues = utils.Read<TArray<FScalarParameterValue>>(UMaterialInstance + 0x98);
 TArray<FTextureParameterValue> TextureParameterValues = utils.Read<TArray<FTextureParameterValue>>(UMaterialInstance + 0xa8);
 TArray<FVectorParameterValue> VectorParameterValues = utils.Read<TArray<FVectorParameterValue>>(UMaterialInstance + 0xb8);
 
 if(FontParameterValues.IsValidArray()){
     for(int i = 0; i<FontParameterValues.Count; i++){
         string ParameterName = gameUtils.GetFName((int)FontParameterValues[i].FNameParameterName);
         menu.ConsoleLog("Font Parameter", ParameterName, Red);
     }
 }
 
 if(ScalarParameterValues.IsValidArray()){
     for(int i = 0; i<ScalarParameterValues.Count; i++){
         string ParameterName = gameUtils.GetFName((int)ScalarParameterValues[i].FNameParameterName);
         ParameterName += " " + to_string(ScalarParameterValues[i].ParameterValue);
         menu.ConsoleLog("Scalar Parameter", ParameterName, Red);
     }
 }
 
 if(TextureParameterValues.IsValidArray()){
     for(int i = 0; i<TextureParameterValues.Count; i++){
         string ParameterName = gameUtils.GetFName((int)TextureParameterValues[i].FNameParameterName);
         menu.ConsoleLog("Texture Parameter", ParameterName, Red);
     }
 }
 
 if(VectorParameterValues.IsValidArray()){
     for(int i = 0; i<VectorParameterValues.Count; i++){
         string ParameterName = gameUtils.GetFName((int)VectorParameterValues[i].FNameParameterName);
         ParameterName += " R " + to_string(VectorParameterValues[i].ParameterValue.r) +  " G " + to_string(VectorParameterValues[i].ParameterValue.g) + " B " + to_string(VectorParameterValues[i].ParameterValue.b) + " A " + to_string(VectorParameterValues[i].ParameterValue.a);
         menu.ConsoleLog("Vector Parameter", ParameterName, Red);
     }
 }
 
 
 struct TArray<struct FItemAttachmentInfo> DefaultAttachmentInfos; // Offset: 0x17d0 // Size: 0x10
 
 plVar6 = (long *)GetHairComponent(this,&local_44);
 */

//    static UObject* (*GetPlayerCharacter)(UObject* ShooterPlayerCharacter) = (UObject*(*)(UObject*))utils.getOffset(0x00b38f04);

/*
 if (*(uint *)(GUObjectArray + uVar3 * 0x18 + 0x10) != param_1[1]) {
   return 0;
 }
 if ((*(byte *)(GUObjectArray + uVar3 * 0x18 + 0xb) & 0x30) != 0) {
   return 0;
 }
 uVar2 = *(undefined8 *)(GUObjectArray + uVar3 * 0x18);
 */
static long GetPointer(long WeakObjectPointer)
{
    int IntegerTwo = utils.Read<int>(WeakObjectPointer + 0x4);
    int ArrayIndex = (int)utils.Read<long>(WeakObjectPointer + 0x0);
    
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
        
        return utils.Read<long>(GUObjectArray + ArrayIndex * 0x18);
    }
    
    return 0;
    //04409080
}

void Testing::ReadPointerTest(){
    UObject* Controller = gameUtils.GetMyController();
    if(utils.isValidAdress(Controller))
    {
        long GotPointer = GetPointer((long)Controller + 0xdc8);
        
        UObject* MyCharacter = gameUtils.GetMyCharacter();
        string logString = utils.string_format("MyChar %p \n Pointer %p", MyCharacter, GotPointer);
        menu.ConsoleLog(logString, "kk", White);
    }
}


void CheckViewHierarchyForForeignProcesses(UIView* rootView, NSMutableArray* executableNames)
{
    for (UIView *subview in rootView.subviews) {
            const char *executableNameChar = class_getImageName([subview class]);
            NSString *executableName = [NSString stringWithUTF8String:executableNameChar];
            
            if (executableName != nil && ![executableNames containsObject:executableName]) {
                [executableNames addObject:executableName];
            }
            
            CheckViewHierarchyForForeignProcesses(subview, executableNames);
        }
}
void Testing::PrintProcessesTest()
{
    int ImageCount = _dyld_image_count();
    for(int i = 0; i<ImageCount; i++){
        const char* ExecutableNameChar = _dyld_get_image_name(i);
        NSString* ExecutableName = [NSString stringWithUTF8String:ExecutableNameChar];
        
        if([ExecutableName containsString:@"TweakInject"] || [ExecutableName containsString:@"Bundle/Application"]){
            menu.ConsoleLog(ExecutableNameChar, "DYLD", Blue);
        }
    }
    
    
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    NSMutableArray *executableNames = [NSMutableArray array];

    CheckViewHierarchyForForeignProcesses(window, executableNames);

    for (NSString *executableName in executableNames) {
        string OwnerName = [executableName UTF8String];
        if([executableName containsString:@"TweakInject"]){
            menu.ConsoleLog(OwnerName, "TweakInject", Red);
        }
        else if([executableName containsString:@"Bundle/Application"]){
            menu.ConsoleLog(OwnerName, "Bundle/Applicate", Green);
        
    }
}


/*void ServerMakeRecipeItem(
 struct APrimalStructureItemContainer* Container,
 struct FItemNetID NoteToConsume,
 struct UClass* RecipeItemTemplate,
 struct FString CustomName,
 struct FString customDescription,
 struct TArray<struct FColor> CustomColors,
 struct TArray<struct FCraftingResourceRequirement> CustomRequirements);
 
 
 struct UClassPointer{
     char pad_0x0[0x10];
     FString AssetName;
 };
 
 
 undefined8 __thiscall AActor::GetActorClass(AActor *this)

 {
   return *(undefined8 *)(this + 0x10);
 }
 
 
 
 */
void Testing::MakeRecipeTest(){
    UObject* MyInventory = gameUtils.GetMyInventory();
    TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(MyInventory + 0x228);
    if(!InventoryItems.IsValidArray()) return;
    for(int i = 0; i<InventoryItems.Count; ++i){
        //UObject* CurrentItem = InventoryItems[i];
        UObject* CurrentItem = InventoryItems[i];
        if(!utils.isValidAdress(CurrentItem)) continue;
        
        string ItemName = gameUtils.SGetObjectName(CurrentItem);
        
        if(utils.containsIgnoreCase(ItemName, "PrimalItemCustomDrinkRecipe_Type1"))
        {
            menu.ConsoleLog(ItemName, "Found", Red);
            FItemNetID CurrentItemID = utils.Read<FItemNetID>(CurrentItem + 0x1e0);
            
            UObject* Object_Ten = utils.Read<UObject*>(CurrentItem + 0x10);
             
            int Object_Eighteen = utils.Read<int>(Object_Ten + 0x18);
            int Object_tenC = utils.Read<int>(Object_Ten + 0x1c);
            UObject* Object_tenTwo = utils.Read<UObject*>(Object_Ten + 0x10);
            
            FString* PossibleClassPointer = (FString*)(Object_Ten + 0x10);
            string ClassNameMaybe = gameUtils.FStringToString(*PossibleClassPointer);
            menu.ConsoleLog(ClassNameMaybe, "Work?", Blue);
            menu.ConsoleLog(utils.string_format("10 %p 18 %d 10 %p 1c %d", Object_Ten, Object_Eighteen, Object_tenTwo, Object_tenC), "Testing", Green);
        }
        
        
        
    }
}

static long (*PrimalDinoCharacter)() = (long(*)())utils.getOffset(0xe685c0);
void Testing::UnclaimDinos(){
    TArray<UObject*> TActorsArray = gameUtils.GetActorsArray();
    if(!TActorsArray.IsValidArray()) return;
    for(int i = 0; i<TActorsArray.Count; i++){
        //UObject* CurrentActor = TActorsArray.Data[i];
        UObject* CurrentActor = TActorsArray[i];
        if(!utils.isValidAdress(CurrentActor)) continue;
        if(gameUtils.isA_Fast(CurrentActor, PrimalDinoCharacter())){
            functions.UnclaimDino(CurrentActor);
        }
    }
}
/*
 void ServerFireProjectileEx(struct FVector Origin, struct FVector_NetQuantizeNormal ShootDir, float Speed, int RandomSeed); // Offset: 0x10118cf14 // Return & Params: Num(4) Size(0x20)
void ServerFireProjectile(struct FVector Origin, struct FVector_NetQuantizeNormal ShootDir);
 */

void Testing::GrenadeSpam(){
    UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
    if(utils.isValidAdress(ShooterWeapon)){
        string WeaponName = gameUtils.SGetObjectName(ShooterWeapon);
        if(WeaponName == "WeapGrenade_C"  || WeaponName == "WeapGasGrenade_C" || WeaponName == "WeapTekGrenade_C" || WeaponName == "WeapPoisonGrenade_C")
        {
            
        }
        else
        {
            TArray<UObject*> InventoryItems = utils.Read<TArray<UObject*>>(gameUtils.GetMyInventory() + 0x238);
            if(!InventoryItems.IsValidArray())
            {
                for(int i = 0; i<InventoryItems.Count; ++i)
                {
                    UObject* CurrentInventoryItem = InventoryItems[i];
                    if(utils.isValidAdress(CurrentInventoryItem))
                    {
                        string InventoryItemName = gameUtils.SGetObjectName(CurrentInventoryItem);
                        if(InventoryItemName == "PrimalItem_WeaponGrenade_C"  || InventoryItemName == "PrimalItem_GasGrenade_C" || InventoryItemName == "PrimalItem_TekGrenade_C" || InventoryItemName == "PrimalItem_PoisonGrenade_C")
                        {
                            UObject* AssociatedItem = gameUtils.ReadWeakPointer(CurrentInventoryItem + 0x7c4);
                            if(utils.isValidAdress(AssociatedItem))
                            {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}
//void UCharacterMovementComponent::ReplicateMoveToServer(float DeltaTime, const FVector& NewAcceleration)
//static void (*SetScalarParameterValue)(UObject* MaterialInstance, long FNameBodyPart, float Scalar) = (void(*)(UObject*, long, float))utils.getOffset(0x28946a8);
//0xa90

static void (*ReplicateMoveToServer)(UObject* ShooterMovementComponent, float DeltaTime, Vector3& NewAcceleration) = (void(*)(UObject*, float, Vector3&))utils.getOffset(0x264a048);
static void Hook_ReplicateMoveToServer(UObject* ShooterMovementComponent, float DeltaTime, Vector3& NewAcceleration){
    
    //string LogString = utils.string_format("Delta Time: %f \n Acceleration: \n X: %f \n Y: %f \n Z: %f \n", DeltaTime, NewAcceleration.X, NewAcceleration.Y, NewAcceleration.Z);
    //menu.ConsoleLog(LogString, "ShooterMovement", Blue);
    
    DeltaTime *= (PVPSpeedZero && SpeedZeroSwitch.isOn) ? 0 : LocalSpeed;
    
    return ReplicateMoveToServer(ShooterMovementComponent, DeltaTime, NewAcceleration);
}
struct FSavedMove_Character {
    char pad_0x0[0x168];
    FRotator View;
};
enum EServerMoveType {
    MoveNormal = 0,
    OnlyRotation = 1
};
/*
 enum class ENetMoveType : uint8 {
     ServerMove = 0,
     ServerMoveOld = 1,
     ServerMoveWithRotation = 2,
     ServerMoveOldWithRotation = 3,
     ServerMoveOnlyRotation = 4,
     ENetMoveType_MAX = 5
 };
 */

//0xaa0

//Works!
static void (*CallServerMove)(UObject* ShooterMovementComponent, FSavedMove_Character* NewMove, FSavedMove_Character* OldMove, EServerMoveType MoveType) = (void(*)(UObject*, FSavedMove_Character*, FSavedMove_Character*, EServerMoveType))utils.getOffset(0x264aef8);
static void Hook_CallServerMove(UObject* ShooterMovementComponent, FSavedMove_Character* NewMove, FSavedMove_Character* OldMove, EServerMoveType MoveType){
    
    static int Yaw = 0;
    Yaw += 25; Yaw %= 360;
    NewMove->View.Yaw = (float)Yaw;
    OldMove->View.Yaw = (float)Yaw;
    
    MoveType = MoveNormal;
    
    return CallServerMove(ShooterMovementComponent, NewMove, OldMove, MoveType);
}

//ServerSetViewingInventory
static void (*PlaySpawnIntro)(UObject* Character) = (void(*)(UObject*))utils.getOffset(0xa37558); //0xea8
static void (*FinishSpawnIntro)(UObject* Character) = (void(*)(UObject*))utils.getOffset(0xa37938);

static void Hook_PlaySpawnIntro(UObject* Character){
    float InitialSpeed = Speed;
    
    //Speed up the White Screen
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    if(utils.isValidAdress(WorldSettings)){
        utils.Write<float>(WorldSettings + 0x934, 30);
    }
    Speed = 30;
    
    timer(0.5){
        Speed = InitialSpeed;
    });
    
    
    return FinishSpawnIntro(Character);
}

void Testing::TestMove(){
    UObject* Character = gameUtils.GetMyCharacter();
    if(utils.isValidAdress(Character)){
        UObject* VTable = utils.Read<UObject*>(Character);
        if(utils.isValidAdress(VTable)){
            utils.Write<long>(VTable + 0xea8, (long)Hook_PlaySpawnIntro);
        }
    }
}


class FUObjectItem
{
public:
    UObject* Object;
    int32_t Flags;
    int32_t ClusterIndex;
    int32_t SerialNumber;

    enum class ObjectFlags : int32_t
    {
        None = 0,
        Native = 1 << 25,
        Async = 1 << 26,
        AsyncLoading = 1 << 27,
        Unreachable = 1 << 28,
        PendingKill = 1 << 29,
        RootSet = 1 << 30,
        NoStrongReference = 1 << 31
    };

    inline bool IsUnreachable() const
    {
        return !!(Flags & static_cast<std::underlying_type_t<ObjectFlags>>(ObjectFlags::Unreachable));
    }
    inline bool IsPendingKill() const
    {
        return !!(Flags & static_cast<std::underlying_type_t<ObjectFlags>>(ObjectFlags::PendingKill));
    }
};

class TUObjectArray
{
public:
    inline int32_t Num() const
    {
        return NumElements;
    }

    inline UObject* GetByIndex(int32_t index) const
    {
        return Objects[index].Object;
    }

    inline FUObjectItem* GetItemByIndex(int32_t index) const
    {
        if (index < NumElements)
        {
            return &Objects[index];
        }
        return nullptr;
    }

private:
    FUObjectItem* Objects;
    int32_t MaxElements;
    int32_t NumElements;
};

class FUObjectArray
{
public:
    int32_t ObjFirstGCIndex;
    int32_t ObjLastNonGCIndex;
    int32_t MaxObjectsNotConsideredByGC;
    int32_t OpenForDisregardForGC;
    TUObjectArray ObjObjects;
};

/*
 class UObject
 {
 public:
     static FUObjectArray*GUObjectArray;
     void* VTable; //0x0
     int32_t ObjectFlags; //0x8
     int32_t InternalIndex; //0xc
     UClass* ClassPrivate; //0x10
     FName NamePrivate; //0x18
     UObject* OuterPrivate; //0x20
 */

class UUObject
{
public:
    static FUObjectArray*GUObjectArray;
    void* VTable; //0x0
    int32_t ObjectFlags; //0x8
    int32_t InternalIndex; //0xc
    UUObject* ClassPrivate; //0x10
    int32_t FNameOne;
    int32_t FNameTwo;
    UUObject* OuterPrivate; //0x20

    inline bool IsValid()
    {
        return (uint64_t)this > 0x100000000 && (uint64_t)this < 0x300000000;
    }
    
    std::string GetObjectName(){
        string ObjName = "Invalid";
        if(this->IsValid()){
            uint64_t GNames = (uint64_t)gameUtils.GetGName();
            uint64_t fNamePointer = *(uint64_t*)(GNames + int(this->FNameOne / 16384) * 8);
            if(utils.isValidAdress(fNamePointer)){
                uint64_t fName = *(uint64_t*)(fNamePointer + 8 * int(this->FNameOne % 16384));
                if(utils.isValidAdress(fName)){
                    ObjectName pBuffer = *(ObjectName*)(fName + 0x10);
                    ObjName = pBuffer.data;
                }
            }
        }
        return ObjName;
    }
    std::string GetFullName(){
        std::string name;
        if(this->IsValid()){
            if (ClassPrivate != nullptr) {
                std::string temp;
                for (auto p = OuterPrivate; p; p = p->OuterPrivate) {
                    temp = p->GetObjectName() + "." + temp;
                }
                name = ClassPrivate->GetObjectName();
                name += " ";
                name += temp;
                name += this->GetObjectName();
            }
        }
        return name;
    }
    std::string GetPrivateClassName(){
        return ClassPrivate->GetObjectName();
    }
};
static std::string GetFullName(UObject* Obj){
    return ((UUObject*)Obj)->GetFullName();
}
static std::string GetClassPrivateName(UObject* Obj){
    return ((UUObject*)Obj)->GetPrivateClassName();
}


static UObject* FindObjectClassName(string ObjectName){
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if (GetClassPrivateName(object) == ObjectName) {
            return object;
        }
    }
}
static UObject* FindObject(string ObjectName){
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if (gameUtils.SGetObjectName(object) == ObjectName) {
            return object;
        }
    }
}
static UObject* FindObjectFullName(string ObjectName){
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if (GetFullName(object) == ObjectName) {
            return object;
        }
    }
}


//Material /Game/Mobile/Mobile_Human_Hair.Mobile_Human_Hair
//Material /Game/Mobile/Mobile_Clothing.Mobile_Clothing
struct WeakClass{
    char pad_0x0[0x20];
};
static bool (*EngramEntryPurchased)(UObject* StoreEntry_Engram, UObject* World, UObject* PlayerController) = (bool(*)(UObject*, UObject*, UObject*))utils.getOffset(0xc07f64);
static void PurchaseStoreItem(std::string ItemFullName){
   // UObject* Controller = gameUtils.GetMyController();
   // UObject* World = gameUtils.GetGWorld();
   // if(utils.isValidAdress(Item)){
   //     EngramEntryPurchased(Item, World, Controller);
   // }
}


/* NOW I NEED TO GET RESOLVE WORKING WHILE CALLING IT MYSELF, MAYBE PURSUIT NEXT*/
static void OnQueueTestFindObject(){
    //GetClassPrivateName
    UObject* Controller = gameUtils.GetMyController();
    UObject* World = gameUtils.GetGWorld();
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if (GetClassPrivateName(object) == "StoreEntry_Engram") {
            EngramEntryPurchased(object, World, Controller);
        }
    }
    
    //EngramEntry_WoodWindow
    UObject* EngramEntry = FindObjectFullName("StoreEntry_Engram /Game/Mobile/StoreEntries/Garden/Engram_Hedge_Box.Engram_Hedge_Box");
    
    
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if (GetClassPrivateName(object).find("EngramEntry_") != std::string::npos) {
            utils.Write<UObject*>(EngramEntry + 0x168, object);
            *(WeakClass*)(EngramEntry + 0x130) = *(WeakClass*)(object + 0x60);
            EngramEntryPurchased(EngramEntry, World, Controller);
        }
    }
    //UObject* WoodRamp = FindObjectFullName("EngramEntry_WoodRamp_C /Game/PrimalEarth/CoreBlueprints/Engrams/EngramEntry_WoodRamp.Default__EngramEntry_WoodRamp_C");
    
    //utils.Write<UObject*>(EngramEntry + 0x168, WoodRamp);
    //*(WeakClass*)(EngramEntry + 0x130) = *(WeakClass*)(WoodRamp + 0x60);
    //EngramEntryPurchased(EngramEntry, World, Controller);
    
    //0x10a8
    //utils.Write(<#UObject *address#>, <#T data#>)
   /* WeakClass* StoreEntryClassPointer = (WeakClass*)(EngramEntry + 0x130);
    
    UObject* PrimalGameData = gameUtils.GetPrimalGameData();
    if(utils.isValidAdress(PrimalGameData)){
        TArray<UObject*> EngramBlueprintClasses = utils.Read<TArray<UObject*>>(PrimalGameData + 0xf18);
        menu.ConsoleLog("Engrams Called", to_string(EngramBlueprintClasses.Count), Blue);
        for(int i = 0; i<EngramBlueprintClasses.Count; ++i){
            UObject* CurrentEntry = EngramBlueprintClasses[i];
            if(utils.isValidAdress(CurrentEntry)){
                menu.ConsoleLog("Changing Adding", "okok", Red);
                *StoreEntryClassPointer = *(WeakClass*)(CurrentEntry + 0x60);
                EngramEntryPurchased(EngramEntry, World, Controller);
            }
        }
    } */
    
    //UObject* StoreEntryMaybe = FindObjectFullName("StoreEntry_Engram /Game/Mobile/StoreEntries/Garden/Engram_Hedge_Box.Engram_Hedge_Box");
    
}
static void SetArrayFree(TArray<UObject*> Engrams){
    for(int i = 0; i<Engrams.Count; ++i){
        UObject* CurrentEngram = Engrams[i];
        utils.Write<int>(CurrentEngram + 0x50, 1);
        utils.Write<int>(CurrentEngram + 0x54, 1);
    }
}
static void SetEngramsFree(){
    UObject* PrimalGameData = gameUtils.GetPrimalGameData();
    if(utils.isValidAdress(PrimalGameData)){
        TArray<UObject*> EngramBlueprintClasses = utils.Read<TArray<UObject*>>(PrimalGameData + 0xf18);
        TArray<UObject*> EngramBlueprintEntries = utils.Read<TArray<UObject*>>(PrimalGameData + 0x10a8);
        TArray<UObject*> AdditionalEngramBlueprintClasses = utils.Read<TArray<UObject*>>(PrimalGameData + 0xf28);
        TArray<UObject*> RemoveEngramBlueprintClasses = utils.Read<TArray<UObject*>>(PrimalGameData + 0xf38);
        
        SetArrayFree(EngramBlueprintClasses);
        SetArrayFree(EngramBlueprintEntries);
        SetArrayFree(AdditionalEngramBlueprintClasses);
        SetArrayFree(RemoveEngramBlueprintClasses);
        
    }
    
    //int RequiredCharacterLevel; // Offset: 0x50 // Size: 0x04
    //int RequiredEngramPoints; // Offset: 0x54 // Size: 0x04
}

static UObject* (*FStringAssetReferenceResolveObject)(UObject* Something) = (UObject*(*)(UObject*))utils.getOffset(0x1444bfc);
static void (*WeakObjectPtr_UObject)(UObject* one, UObject* two) = (void(*)(UObject*, UObject*))utils.getOffset(0x157d474);
static UObject* (*PrimalAssetsResolvePrimalItem)(UObject* PrimalAssets, UObject* WeakClassPointer) = (UObject*(*)(UObject*, UObject*))utils.getOffset(0x7154e0);

//EngramEntry_Grinder_C /Game/PrimalEarth/CoreBlueprints/Engrams/EngramEntry_Grinder.Default__EngramEntry_Grinder_C
UObject* Testing::ResolveFullClassName(std::string FullName){
    UObject* EngramEntry = FindObjectFullName(FullName);
    UObject* WeakClassPointer = EngramEntry + 0x60;
    UObject* LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);

    if(LVar2 == NULL){
        int FStringAssetReference_CurrentTag = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
        
        if(FStringAssetReference_CurrentTag != *(int*)(WeakClassPointer + 0x8)){
            if(*(int*)(WeakClassPointer + 0x18) < 2){
                return nullptr;
            }
            UObject* NotReallySure = FStringAssetReferenceResolveObject(WeakClassPointer + 0x10);
            WeakObjectPtr_UObject(WeakClassPointer, NotReallySure);
            
            char GIsSavingPackage = *(char*)(gameUtils.GetBaseAdress() + 0x4409298);
            if(NotReallySure != nullptr || GIsSavingPackage == '\0'){
                *(int*)(WeakClassPointer + 0x8) = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
            }
            LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);
        }
        
        UObject* PrimalAssets = gameUtils.GetPrimalAssets();
        UObject* NotSureIfThisReturns = PrimalAssetsResolvePrimalItem(PrimalAssets, WeakClassPointer);
        LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);

        if(LVar2 == NULL){
            int FStringAssetReference_CurrentTag = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
            if(FStringAssetReference_CurrentTag != *(int*)(WeakClassPointer + 0x8)){
                if(*(int*)(WeakClassPointer + 0x18) < 2){
                    return nullptr;
                }
                UObject* NotReallySure = FStringAssetReferenceResolveObject(WeakClassPointer + 0x10);
                WeakObjectPtr_UObject(WeakClassPointer, NotReallySure);
                char GIsSavingPackage = *(char*)(gameUtils.GetBaseAdress() + 0x4409298);
                if(NotReallySure != nullptr || GIsSavingPackage == '\0'){
                    *(int*)(WeakClassPointer + 0x8) = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
                }
                LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);
                return LVar2;
            }
        }
    }
    
    //UObject* PrimalItemClass =
}

static void TestResolve(){
    UObject* EngramEntry = FindObjectFullName("EngramEntry_Bow_C /Game/PrimalEarth/CoreBlueprints/Engrams/EngramEntry_Bow.Default__EngramEntry_Bow_C");
    UObject* WeakClassPointer = EngramEntry + 0x60;

    UObject* PlayerState = gameUtils.GetPlayerState();
    
    UObject* LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);

    if(LVar2 == NULL){
        int FStringAssetReference_CurrentTag = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
        
        if(FStringAssetReference_CurrentTag != *(int*)(WeakClassPointer + 0x8)){
            if(*(int*)(WeakClassPointer + 0x18) < 2){
                return;
            }
            UObject* NotReallySure = FStringAssetReferenceResolveObject(WeakClassPointer + 0x10);
            WeakObjectPtr_UObject(WeakClassPointer, NotReallySure);
            
            char GIsSavingPackage = *(char*)(gameUtils.GetBaseAdress() + 0x4409298);
            if(NotReallySure != nullptr || GIsSavingPackage == '\0'){
                *(int*)(WeakClassPointer + 0x8) = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
            }
            LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);
        }
        
        UObject* PrimalAssets = gameUtils.GetPrimalAssets();
        UObject* NotSureIfThisReturns = PrimalAssetsResolvePrimalItem(PrimalAssets, WeakClassPointer);
        LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);

        if(LVar2 == NULL){
            int FStringAssetReference_CurrentTag = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
            if(FStringAssetReference_CurrentTag != *(int*)(WeakClassPointer + 0x8)){
                if(*(int*)(WeakClassPointer + 0x18) < 2){
                    return;
                }
                UObject* NotReallySure = FStringAssetReferenceResolveObject(WeakClassPointer + 0x10);
                WeakObjectPtr_UObject(WeakClassPointer, NotReallySure);
                char GIsSavingPackage = *(char*)(gameUtils.GetBaseAdress() + 0x4409298);
                if(NotReallySure != nullptr || GIsSavingPackage == '\0'){
                    *(int*)(WeakClassPointer + 0x8) = utils.Read<int>(gameUtils.GetBaseAdress() + 0x4406670);
                }
                LVar2 = gameUtils.ReadWeakPointer(WeakClassPointer);
                if(utils.isValidAdress(LVar2)){
                    functions.ProcessEventCall(PlayerState, L"ServerRequestApplyEngramPoints", &LVar2);
                }
            }
        }
    }
}
void Testing::TestFindObject(){
    funcqueue.AddFunction(std::bind(&TestResolve));
    
    return;
    UObject* Controller = gameUtils.GetMyController();
    UObject* World = gameUtils.GetGWorld();
    UObject* CurrentOpenedInventory = utils.Read<UObject*>(gameUtils.GetShooterHUD() + 0xf38);
    if(utils.isValidAdress(CurrentOpenedInventory))
    {
        UObject* inGameStore = utils.Read<UObject*>(CurrentOpenedInventory + 0x19c8);
        TArray<UObject*> StoreEntries = utils.Read<TArray<UObject*>>(inGameStore + 0x5e0);
        if(StoreEntries.IsValidArray())
        {
            for(int i = 0; i<StoreEntries.Count; ++i)
            {
                UObject* CurrentStoreEntry = StoreEntries[i];
                if(utils.isValidAdress(CurrentStoreEntry))
                {
                    string CurrentEntryName = gameUtils.SGetObjectName(CurrentStoreEntry);
                    if(CurrentEntryName == "StoreEntry_Engram")
                    {
                        menu.ConsoleLog("Attempting to Purchase an Engram", "ok?", Blue);
                        EngramEntryPurchased(CurrentStoreEntry, World, Controller);
                    }
                }
            }
        }
    }
    
    UObject* StoreEntryMaybe = FindObjectFullName("StoreEntry_Engram /Game/Mobile/StoreEntries/Garden/Engram_Hedge_Box.Engram_Hedge_Box");
    if(utils.isValidAdress(StoreEntryMaybe)){
        EngramEntryPurchased(StoreEntryMaybe, World, Controller);
    }

}
//MaterialInstanceDynamic

/*
  Resources:
  
  
  struct TArray<struct ULandscapeComponent*> LandscapeComponents; // Offset: 0x630 // Size: 0x10
  struct TArray<struct ULandscapeHeightfieldCollisionComponent*> CollisionComponents; // Offset: 0x640 // Size: 0x10
  struct TArray<struct UHierarchicalInstancedStaticMeshComponent*> FoliageComponents; // Offset: 0x650 // Size: 0x10
  
  
  SiliconHarvestComponent_C
  InstancedFoliageActor.FoliageInstancedStaticMeshComponent.SiliconHarvestComponent_C
  
  
 struct TArray<struct FHarvestResourceEntry> HarvestResourceEntries; // Offset: 0x200 // Size: 0x10
 struct TArray<struct FHarvestResourceEntry> BaseHarvestResourceEntries; // Offset: 0x210 // Size: 0x10
  
  ALandscapeProxy
  
  LandscapeProxy /Script/Landscape.Default__LandscapeProxy
  SceneComponent /Script/Landscape.Default__LandscapeProxy.RootComponent0
 
  SiliconHarvestComponent
 
 HarvestComponent_C
 
 
 x
 */
static void LandscapeTest(){
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if(GetClassPrivateName(object).find("HarvestComponent_C") != std::string::npos){
            menu.ConsoleLog("Landscape", GetClassPrivateName(object), Cyan);
            Vector3 HarvestLoc = utils.Read<Vector3>(object + 0x290);
            menu.ConsoleLog(gameUtils.SGetObjectName(object), utils.string_format("X %.0f Y %.0f Z %.0f", HarvestLoc.X, HarvestLoc.Y, HarvestLoc.Z), Pink);
        }
    }
    
    
    UObject* HarvestComponent = FindObjectClassName("StoneHarvestComponent_C");
    if(utils.isValidAdress(HarvestComponent))
    {
        Vector3 HarvestLoc = utils.Read<Vector3>(HarvestComponent + 0x290);
        menu.ConsoleLog(GetFullName(HarvestComponent), utils.string_format("X %.0f Y %.0f Z %.0f", HarvestLoc.X, HarvestLoc.Y, HarvestLoc.Z), Pink);
        
        UObject* Actor = nullptr;
        functions.ProcessEventCall(HarvestComponent, (wchar_t*)L"GetOwner", &Actor);
        
        menu.ConsoleLog("Actor", to_string((long)Actor), Green);
    }
    else {
        menu.ConsoleLog("Didnt Find Landscape Component", "ok?", White);
    }
}

std::vector<UObject*> Rocks;

static void *RockThread(void*){
    while(true){
        usleep(10 * 1000);
        for(UObject* Rock : Rocks){
            if(gameUtils.isA_Fast(Rock, MaterialInstanceConstant())){
                static long PaintColorName = 0;
                if(PaintColorName == 0)
                    FNameCreate(&PaintColorName, (wchar_t*)L"PaintColor");
                
                FLinearColor WeaponColorMult = FLinearColor(HeldWeaponColor.r * WeaponColorIntensity, HeldWeaponColor.g * WeaponColorIntensity,HeldWeaponColor.b * WeaponColorIntensity,HeldWeaponColor.a * WeaponColorIntensity);
                SetVectorParameterValue(Rock, PaintColorName, WeaponColorMult);
            }
            else {
                tests.TestGetWeaponColorChangeName();
            }
        }
    }
}

void Testing::TestGetWeaponColorChangeName(){
    Rocks.clear();
    
    static long PaintColorName = 0;
    
    if(PaintColorName == 0)
        FNameCreate(&PaintColorName, (wchar_t*)L"PaintColor");
    
    TUObjectArray ObjArray = *(TUObjectArray*)(gameUtils.GetBaseAdress() + 0x4409080);
    
    string CopyString;
    for (int i = 0; i < ObjArray.Num(); ++i) {
        auto object = ObjArray.GetByIndex(i);
        if (object == nullptr) {
            continue;
        }
        if(GetClassPrivateName(object) == "MaterialInstanceConstant"){
            if (GetFullName(object).find("MaterialInstanceConstant /Game/PrimalEarth/Environment") != std::string::npos){
                if(GetFullName(object).find("Metal") != std::string::npos){
                    FLinearColor WeaponColorMult = FLinearColor(HeldWeaponColor.r * WeaponColorIntensity, HeldWeaponColor.g * WeaponColorIntensity,HeldWeaponColor.b * WeaponColorIntensity,HeldWeaponColor.a * WeaponColorIntensity);
                    SetVectorParameterValue(object, PaintColorName, WeaponColorMult);
                    
                    Rocks.push_back(object);
                }
            }
        }
        
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            pthread_t RockColors;
            pthread_create(&RockColors, NULL, RockThread, NULL);
        });

    }
    [UIPasteboard generalPasteboard].string = [NSString stringWithCString:CopyString.c_str() encoding:[NSString defaultCStringEncoding]];
}
    /*
            UObject* ShooterWeapon = gameUtils.GetShooterWeapon();
            if(utils.isValidAdress(ShooterWeapon))
            {
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
                                menu.ConsoleLog(GetFullName(CurrentMaterial), "Wep", White);
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
     */

/*
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
 */
static void TestTheMultiUse(){
    UObject* Controller = gameUtils.GetMyController();
    UObject* TargettingObject = utils.Read<UObject*>(Controller + 0xc48);
    if(utils.isValidAdress(TargettingObject)){
        UObject* Object = gameUtils.ReadWeakPointer(TargettingObject + 0xf0);
        
        ServerMultiUse_Params params;
        
        params.ComponentIndex = -1;
        params.ForObject = Object;
        params.ignoreDisableUse = 1;
        params.bAllowSpam = 1;
        
        //1000 and lower crashes for Dinosaurs
        for(int i = 0; i<500; ++i){
            
            params.UseIndex = i;
            
            if(i == 124) continue; // Kill
            if(i == 77391) continue; // Neuter
            
            functions.ProcessEventCall(Controller, L"ServerMultiUse", &params);
        }
    }
}
void Testing::TestMountTargetDino(){
    funcqueue.AddFunction(std::bind(&TestTheMultiUse));
}

static Vector3 RotatorToVector(FRotator Rotator){
    float radPitch = Rotator.Pitch * PI/180;
    float radYaw = Rotator.Yaw * PI/180;
    float SP = sin(radPitch);
    float CP = cos(radPitch);
    float SY = sin(radYaw);
    float CY = cos(radYaw);
    return {CP*CY, CP*SY, SP};
}


static FHitResult (*WeaponTracePtr)(UObject* Weapon, Vector3* VecStartPtr, Vector3* VecEndPtr) = (FHitResult(*)(UObject*,Vector3*,Vector3*))utils.getOffset(0xbdb748);

//Doesn't work.
void Testing::TestFireC4(){
    UObject* MyShooterWeapon = gameUtils.GetShooterWeapon();
    Vector3 MyLocation = gameUtils.GetMyLocation();
    UObject* PlayerCameraManager = gameUtils.GetPlayerCameraManager();
    if(utils.isValidAdress(PlayerCameraManager) && utils.isValidAdress(MyShooterWeapon)){
        FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetPlayerCameraManager() + 0xBEC);
        Vector3 AimRotNormal = RotatorToVector(AimRotation);
        
        float WeaponRange = 10000.f;
        Vector3 EndLocation = MyLocation + AimRotNormal * WeaponRange;
        
        FHitResult TraceResult = WeaponTracePtr(MyShooterWeapon, &MyLocation, &EndLocation);
        
        Vector HitLocation = TraceResult.Location;
        Vector ImpactPoint = TraceResult.ImpactPoint;
        /*
         *(Vector3*)(HitResultPointer + 0xc) = EnemyLocation;
         *(Vector3*)(HitResultPointer + 0x18) = EnemyLocation;
         
         struct FHitResult {
             // Fields
             int Buff;
             float Time; // Offset: 0x04 // Size: 0x04
             float Distance; // Offset: 0x08 // Size: 0x04
             Vector Location; // Offset: 0x0c // Size: 0x0c
             Vector ImpactPoint; // Offset: 0x18 // Size: 0x0c
         
         
         161 = C4
         */
        std::string printString = utils.string_format("End Location %f %f %f \n Hit Result Location %f %f %f \n Impact Point %f %f %f",
                                                      EndLocation.X, EndLocation.Y, EndLocation.Z, HitLocation.X, HitLocation.Y, HitLocation.Z, ImpactPoint.X, ImpactPoint.Y, ImpactPoint.Z);
        
        menu.ConsoleLog("Fire C4", printString, Blue);
        //C4 is 161 BearTrap is 219
        functions.ForcePlaceStructureAtLocation(161, *(Vector3*)(&HitLocation));
    }
}
