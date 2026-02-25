//
//  Crosshair.mm
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/24/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"


static Vector2 ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);



void Crosshair::DrawCircleCrosshair(){
    ImGui::GetForegroundDrawList()->AddCircle(ScreenCenter.toVec2(), CircleRadius, utils.FloatColorsToImU32(CircleColor), 50, CircleWidth);
    //ImGui::GetForegroundDrawList()->AddCircle(ScreenCenter.toVec2(), CircleRadius, utils.FloatColorsToImU32(CircleColor), 50, CircleWidth);
}
void Crosshair::DrawPlusCrosshair(){

    ImU32 PlusDrawColor = utils.FloatColorsToImU32(PlusColor);
    float Distance = PlusMiddleSpacing + PlusLength;
    ImVec2 VerticalSize = ImVec2(PlusWidth, PlusLength);
    ImVec2 HorizontalSize = ImVec2(PlusLength, PlusWidth);
    
    ImVec2 TopStart = ImVec2(ScreenCenter.X - PlusWidth/2, ScreenCenter.Y - Distance);
    ImVec2 BottomStart = ImVec2(ScreenCenter.X - PlusWidth/2, ScreenCenter.Y + PlusMiddleSpacing);
    ImVec2 LeftStart = ImVec2(ScreenCenter.X - Distance, ScreenCenter.Y - PlusWidth/2);
    ImVec2 RightStart = ImVec2(ScreenCenter.X + PlusMiddleSpacing, ScreenCenter.Y - PlusWidth/2);
    
    ImGui::GetForegroundDrawList()->AddRectFilled(TopStart, ImVec2(TopStart.x + VerticalSize.x, TopStart.y + VerticalSize.y), PlusDrawColor, 0, 0);
    ImGui::GetForegroundDrawList()->AddRectFilled(BottomStart, ImVec2(BottomStart.x + VerticalSize.x, BottomStart.y + VerticalSize.y), PlusDrawColor, 0, 0);
    ImGui::GetForegroundDrawList()->AddRectFilled(LeftStart, ImVec2(LeftStart.x + HorizontalSize.x, LeftStart.y + HorizontalSize.y), PlusDrawColor, 0, 0);
    ImGui::GetForegroundDrawList()->AddRectFilled(RightStart, ImVec2(RightStart.x + HorizontalSize.x, RightStart.y + HorizontalSize.y), PlusDrawColor, 0, 0);
    
    if(PlusMiddleDot){
        ImU32 PlusMiddleDotDrawColor = utils.FloatColorsToImU32(PlusMiddleDotColor);
        ImGui::GetForegroundDrawList()->AddCircleFilled(ScreenCenter.toVec2(), PlusMiddleDotRadius, PlusMiddleDotDrawColor, 20);
    }
}
void Crosshair::DrawXCrosshair(){
    float FFRatio = sqrt(2)/2;
    ImU32 XDrawColor = utils.FloatColorsToImU32(XColor);
    
    Vector2 NorthWest = ScreenCenter - Vector2(XLength * FFRatio, XLength * FFRatio);
    Vector2 SouthEast = ScreenCenter - Vector2(-XLength * FFRatio, -XLength * FFRatio);
    Vector2 NorthEast = ScreenCenter - Vector2(-XLength * FFRatio, XLength * FFRatio);
    Vector2 SouthWest = ScreenCenter - Vector2(XLength * FFRatio, -XLength * FFRatio);
    
    ImGui::GetForegroundDrawList()->AddLine(NorthWest.toVec2(), SouthEast.toVec2(), XDrawColor, XWidth);
    ImGui::GetForegroundDrawList()->AddLine(NorthEast.toVec2(), SouthWest.toVec2(), XDrawColor, XWidth);
    
}
void Crosshair::DrawCarrotCrosshair(){
    float FFRatio = sqrt(2)/2;
    ImU32 CarrotDrawColor = utils.FloatColorsToImU32(CarrotColor);
    
    Vector2 SouthWest = ScreenCenter - Vector2(CarrotLength * FFRatio, -CarrotLength * FFRatio);
    Vector2 SouthEast = ScreenCenter - Vector2(-CarrotLength * FFRatio, -CarrotLength * FFRatio);
    
    ImGui::GetForegroundDrawList()->AddLine(SouthWest.toVec2(), ScreenCenter.toVec2(), CarrotDrawColor, CarrotWidth);
    ImGui::GetForegroundDrawList()->AddLine(SouthEast.toVec2(), ScreenCenter.toVec2(), CarrotDrawColor, CarrotWidth);
}
void Crosshair::DrawCrosshairMenu(){
    const char* CrosshairTypes[] = {GetMenuText("Circle"), GetMenuText("Plus"), GetMenuText("X"), GetMenuText("Carrot")};
    ImGui::Checkbox(GetMenuText("Enable Custom Crosshair"), &EnableCustomCrosshair);
    ImGui::Combo(GetMenuText("Crosshair Type"), &CrosshairTypeInt, CrosshairTypes, IM_ARRAYSIZE(CrosshairTypes));
    if(CrosshairTypeInt == 0){
        
        ImGui::ColorEdit4("Circle Color", CircleColor, ColorFlags);
        ImGui::SliderFloat("Circle Radius", &CircleRadius, 0, 40);
        ImGui::SliderFloat("Circle Width", &CircleWidth, 0, 5);
    } else if(CrosshairTypeInt == 1){
        ImGui::SliderFloat("Plus Middle Spacing", &PlusMiddleSpacing, 0, 10);
        ImGui::SliderFloat("Plus Length", &PlusLength, 0, 30);
        ImGui::SliderFloat("Plus Width", &PlusWidth, 0, 5);
        ImGui::ColorEdit4("Plus Color", PlusColor, ColorFlags);
        ImGui::Checkbox("Enable Middle Dot", &PlusMiddleDot);
        
        if(PlusMiddleDot){
            ImGui::ColorEdit4("Plus Dot Color", PlusMiddleDotColor, ColorFlags);
            ImGui::SliderFloat("Middle Dot Radius", &PlusMiddleDotRadius, 0, 5);
        }
    } else if(CrosshairTypeInt == 2){
        ImGui::ColorEdit4("X Color", XColor, ColorFlags);
        ImGui::SliderFloat("X Length", &XLength, 0, 40);
        ImGui::SliderFloat("X Width", &XWidth, 0, 5);
    } else if(CrosshairTypeInt == 3){
        ImGui::ColorEdit4("Carrot Color", CarrotColor, ColorFlags);
        ImGui::SliderFloat("Carrot Length", &CarrotLength, 0, 40);
        ImGui::SliderFloat("Carrot Width", &CarrotWidth, 0, 5);
    }
}

void Crosshair::DrawCrosshairOnScreen(){
    if(!EnableCustomCrosshair) return;
    
    ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    if(CrosshairTypeInt == 0){
        DrawCircleCrosshair();
    } else if(CrosshairTypeInt == 1){
        DrawPlusCrosshair();
    } else if(CrosshairTypeInt == 2){
        DrawXCrosshair();
    } else if(CrosshairTypeInt == 3){
        DrawCarrotCrosshair();
    }
}

