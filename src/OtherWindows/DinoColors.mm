//
//  DinoColors.mm
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/24/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"


static void (*OnRepDustedColors)(UObject* PrimalDinoCharacter) = (void(*)(UObject*))utils.getOffset(0x80f370);

uint8_t DinoColors::IndexRegionColor(int Index){
    if(Index > 200) return Index - 100;
    else if(Index > 100 && Index < 154) return Index + 100;
    return Index;
}
void DinoColors::CopyDinoColors(){
    UObject* MountedDino = gameUtils.GetMountedDino();
    if(utils.isValidAdress(MountedDino)){
        ColorRegionOneIntensity = utils.Read<float>(MountedDino + 0x180c);
        ColorRegionTwoIntensity = utils.Read<float>(MountedDino + 0x1810);
        ColorRegionThreeIntensity = utils.Read<float>(MountedDino + 0x1814);
        ColorRegionFourIntensity = utils.Read<float>(MountedDino + 0x1818);
        ColorRegionFiveIntensity = utils.Read<float>(MountedDino + 0x181c);
        ColorRegionSixIntensity = utils.Read<float>(MountedDino + 0x1820);
        
        ColorRegionOneColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d2));
        ColorRegionTwoColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d3));
        ColorRegionThreeColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d4));
        ColorRegionFourColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d5));
        ColorRegionFiveColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d6));
        ColorRegionSixColorIndex = IndexRegionColor(utils.Read<uint8_t>(MountedDino + 0x17d7));
        
        DinoEery = utils.Read<uint8_t>(MountedDino + 0x16d2) >> 7 & 1;
        
        ColorizationIntensity = utils.Read<float>(MountedDino + 0x145c);
        
        DustRegionOne = utils.Read<FLinearColor>(MountedDino + 0x17dc);
        DustRegionTwo = utils.Read<FLinearColor>(MountedDino + 0x17ec);
        DustRegionThree = utils.Read<FLinearColor>(MountedDino + 0x17fc);
        
        
    }
}
void DinoColors::HandleDinoRainbow(){
    if(DustRegionOneRainbow){
        DustRegionOne = utils.GetRainbowLinearColor(RainbowCycleTime, 1);
    }
    if(DustRegionTwoRainbow){
        DustRegionTwo = utils.GetRainbowLinearColor(RainbowCycleTime, 1);
    }
    if(DustRegionThreeRainbow){
        DustRegionThree = utils.GetRainbowLinearColor(RainbowCycleTime, 1);
    }
}
void DinoColors::HandleDinoWireframe(){
    UObject* PrimalGlobals = gameUtils.GetPrimalGlobals();
    if(utils.isValidAdress(PrimalGlobals)){
        UObject* MaterialOne = utils.Read<UObject*>(PrimalGlobals + 0x228);
        UObject* MaterialTwo = utils.Read<UObject*>(PrimalGlobals + 0x230);
        UObject* MaterialThree = utils.Read<UObject*>(PrimalGlobals + 0x238);
        UObject* MaterialFour = utils.Read<UObject*>(PrimalGlobals + 0x240);
        
        utils.Write<bool>(MaterialOne + 0x828, DinoWireframe);
        utils.Write<bool>(MaterialTwo + 0x828, DinoWireframe);
        utils.Write<bool>(MaterialThree + 0x828, DinoWireframe);
        utils.Write<bool>(MaterialFour + 0x828, DinoWireframe);
    }
}
void DinoColors::HandleDustRegions(UObject* Dino){
    utils.Write<FLinearColor>(Dino + 0x17dc, DustRegionOne);
    utils.Write<FLinearColor>(Dino + 0x17ec, DustRegionTwo);
    utils.Write<FLinearColor>(Dino + 0x17fc, DustRegionThree);
}
void DinoColors::HandleColorRegions(UObject* Dino){
    utils.Write<float>(Dino + 0x145c, ColorizationIntensity);
    
    utils.Write<float>(Dino + 0x180c, ColorRegionOneIntensity);
    utils.Write<float>(Dino + 0x1810, ColorRegionTwoIntensity);
    utils.Write<float>(Dino + 0x1814, ColorRegionThreeIntensity);
    utils.Write<float>(Dino + 0x1818, ColorRegionFourIntensity);
    utils.Write<float>(Dino + 0x181c, ColorRegionFiveIntensity);
    utils.Write<float>(Dino + 0x1820, ColorRegionSixIntensity);
    
    utils.Write<uint8_t>(Dino + 0x17d2, IndexRegionColor(ColorRegionOneColorIndex));
    utils.Write<uint8_t>(Dino + 0x17d3, IndexRegionColor(ColorRegionTwoColorIndex));
    utils.Write<uint8_t>(Dino + 0x17d4, IndexRegionColor(ColorRegionThreeColorIndex));
    utils.Write<uint8_t>(Dino + 0x17d5, IndexRegionColor(ColorRegionFourColorIndex));
    utils.Write<uint8_t>(Dino + 0x17d6, IndexRegionColor(ColorRegionFiveColorIndex));
    utils.Write<uint8_t>(Dino + 0x17d7, IndexRegionColor(ColorRegionSixColorIndex));
    
}
void DinoColors::HandleDinoEery(UObject *Dino){
    uint8_t* EeryByte = (uint8_t*)(Dino + 0x16d2);
    if(DinoEery)
        *EeryByte = (*EeryByte & ~(1 << 7)) | (1 << 7);
    else
        *EeryByte = (*EeryByte & ~(1 << 7));
}
void DinoColors::ChangeDinoColor(){
    HandleDinoRainbow();
    
    UObject* MountedDino = gameUtils.GetMountedDino();
    if(utils.isValidAdress(MountedDino) && EnableDinoColorChange){
        HandleDinoWireframe();
        HandleColorRegions(MountedDino);
        HandleDustRegions(MountedDino);
        HandleDinoEery(MountedDino);
        OnRepDustedColors(MountedDino);
    }
}
void DinoColors::DrawDinoColorMenu(){
    if(ImGui::Button(GetMenuText("Copy Dino Colors"), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        CopyDinoColors();
    }
    
    ImGui::Columns(3, NULL, false);
    ImGui::Checkbox(GetMenuText("Enable Color Change"), &EnableDinoColorChange); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Wireframe Dinos"), &DinoWireframe); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Eery Dinos"), &DinoEery);
    ImGui::Columns();
    
    if(ImGui::BeginTabBar("Color Change Types")){
        
        if(ImGui::BeginTabItem("Dust Colors")){
            
            ImGui::Columns(2, NULL, false);
            
            ImGui::ColorEdit4(GetMenuText("Region One"), (float*)&DustRegionOne, ColorFlags);
            ImGui::ColorEdit4(GetMenuText("Region Two"), (float*)&DustRegionTwo, ColorFlags);
            ImGui::ColorEdit4(GetMenuText("Region Three"), (float*)&DustRegionThree, ColorFlags);
            
            ImGui::NextColumn();
            
            ImGui::Checkbox(GetMenuText("Region One Rainbow"), &DustRegionOneRainbow);
            ImGui::Checkbox(GetMenuText("Region Two Rainbow"), &DustRegionTwoRainbow);
            ImGui::Checkbox(GetMenuText("Region Three Rainbow"), &DustRegionThreeRainbow);
            
            ImGui::Columns();
            
            ImGui::SliderInt(GetMenuText("Rainbow Cycle Time"), &RainbowCycleTime, 1, 20);
            ImGui::SliderFloat(GetMenuText("Colorization Intensity"), &ColorizationIntensity, 0, 3);
            
            ImGui::EndTabItem();
        }
        if(ImGui::BeginTabItem("Natural Colors")){
            
            ImGui::Combo("Region One", &ColorRegionOneColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo("Region Two", &ColorRegionTwoColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo("Region Three", &ColorRegionThreeColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo("Region Four", &ColorRegionFourColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo("Region Five", &ColorRegionFiveColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo("Region Six", &ColorRegionSixColorIndex, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            
            ImGui::SliderFloat("One Intensity", &ColorRegionOneIntensity, 0, 3);
            ImGui::SliderFloat("Two Intensity", &ColorRegionTwoIntensity, 0, 3);
            ImGui::SliderFloat("Three Intensity", &ColorRegionThreeIntensity, 0, 3);
            ImGui::SliderFloat("Four Intensity", &ColorRegionFourIntensity, 0, 3);
            ImGui::SliderFloat("Five Intensity", &ColorRegionFiveIntensity, 0, 3);
            ImGui::SliderFloat("Six Intensity", &ColorRegionSixIntensity, 0, 3);
            
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }
}


