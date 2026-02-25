//
//  MatSpawn.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 10/9/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"
static int SpawnIndex = 0;
static int SpawnAmmount = 1;


void MatSpawn::DrawMenu(){
    
    const char* SpawnMaterials[] =
    {
        GetMenuText("SilicaPearls"),
        GetMenuText("Thatch"),
        GetMenuText("Fiber"),
        GetMenuText("LeechBlood"),
        GetMenuText("Sap"),
        GetMenuText("Metal"),
        GetMenuText("Charcoal"),
        GetMenuText("AnglerGel"),
        GetMenuText("Sparkpowder"),
        GetMenuText("Oil"),
        GetMenuText("Pelt"),
        GetMenuText("Obsidian"),
        GetMenuText("MetalIngot"),
        GetMenuText("Stone"),
        GetMenuText("Wood"),
        GetMenuText("Hide"),
        GetMenuText("Crystal"),
        GetMenuText("Gasoline"),
        GetMenuText("CementingPaste"),
        GetMenuText("Chitin"),
        GetMenuText("Electronics"),
        GetMenuText("Flint"),
        GetMenuText("Polymer"),
        GetMenuText("Biotoxin"),
        GetMenuText("BlackPearl")
    };
    
    ImGui::Combo("Materials", &SpawnIndex, SpawnMaterials, IM_ARRAYSIZE(SpawnMaterials));
    ImGui::SliderInt("Item Spawn Ammount", &SpawnAmmount, 1, 5000, "%d", ImGuiSliderFlags_Logarithmic);
    if(ImGui::Button("Spawn", ImVec2(150, ImGui::GetFrameHeight()))){
        SpawnMaterial((EGiveItem)SpawnIndex, SpawnAmmount);
    }
}
void MatSpawn::SpawnMaterial(EGiveItem ItemToGive, int Ammount){
    functions.SpawnMaterial(ItemToGive, Ammount);
}
