//
//  AimAssist.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 8/19/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static Vector2 ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
/*
 float MagicCircleSize

 bool showMagicCircle


bool AutoFire
 bool MagicBullet
 bool Aimlock
 bool bSlowDinos
 
 bool CustomMagicBulletSettings
    bool showMagicCircle
    float MagicCircleSize
 
 bool CustomAimlockSettings
     float AimlockSpeed
     bool AimlockToggleSwitch
     bool showAimlockCircle
     float AimlockCircleSize
 
 
 Get distance from midddle of screen to location of other player, have that has a float, and the ammount per tick is Speed / MenuFPS and the Speed Slider is
 
 
 */



void AimAssist::DrawAimlockCircles(){
    AimlockCircleColor[3] = 1; MagicCircleColor[3] = 1;
    ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if(CustomAimlockSettings && showAimlockCircle && Aimlock)
    {
        ImGui::GetForegroundDrawList()->AddCircle(ScreenCenter.toVec2(), AimlockCircleSize, utils.FloatColorsToImU32(AimlockCircleColor), 50, 1);
    }
    if(CustomMagicBulletSettings && showMagicCircle && PVPMagicBullet)
    {
        
        ImGui::GetForegroundDrawList()->AddCircle(ScreenCenter.toVec2(), MagicCircleSize, utils.FloatColorsToImU32(MagicCircleColor), 50, 1);
    }
}
void AimAssist::DrawAimAssistMenu(){
    ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    ImGui::Columns(2, NULL, false);

    ImGui::Checkbox(GetMenuText("Magic Bullet"), &PVPMagicBullet); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Auto Fire"), &PVPAutoFire); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Aimlock"), &Aimlock); ImGui::NextColumn();
    ImGui::Checkbox(GetMenuText("Slow Dinos"), &SlowDinos); ImGui::NextColumn();
    ImGui::Columns();
    
    
    ImGui::Separator();
    ImGui::Text("Custom Aimlock Settings");
    ImGui::Checkbox(GetMenuText("Enable Aimlock Settings"), &CustomAimlockSettings);
    
    if(CustomAimlockSettings)
    {
        ImGui::Columns(3, NULL, false);
        
        ImGui::Checkbox(GetMenuText("Aimlock Toggle Switch"), &AimlockToggleSwitch); ImGui::NextColumn();
        ImGui::Checkbox(GetMenuText("Aimlock Circle"), &showAimlockCircle); ImGui::NextColumn();
        ImGui::ColorEdit3(GetMenuText("Aimlock Circle Color"), AimlockCircleColor, ColorFlags);
        
        ImGui::Columns();
        
        ImGui::SliderFloat(GetMenuText("Aimlock Speed"), &AimlockSpeed, 1, 2000);
        ImGui::SliderFloat(GetMenuText("Aimlock Circle Size"), &AimlockCircleSize, 10, 1000);
    }
    
    ImGui::Separator();
    ImGui::Text("Custom Magic Bullet Settings");
    ImGui::Checkbox(GetMenuText("Enable Magic Bullet Settings"), &CustomMagicBulletSettings);
    
    if(CustomMagicBulletSettings)
    {
        ImGui::Columns(2, NULL, false);
        ImGui::Checkbox(GetMenuText("Magic Circle"), &showMagicCircle); ImGui::NextColumn();
        ImGui::ColorEdit3(GetMenuText("Magic Circle Color"), MagicCircleColor, ColorFlags);
        
        ImGui::Columns();
        
        ImGui::SliderFloat(GetMenuText("Magic Circle Size"), &MagicCircleSize, 10, 500);
    }
    
    if(CustomAimlockSettings || CustomMagicBulletSettings)
    {
        ImGui::Separator();
        ImGui::Text("Bone Aim Settings");
        const char* AimbotTargets[]{ GetMenuText("Weakest"), GetMenuText("Head"), GetMenuText("Chest"), GetMenuText("Leggings"), GetMenuText("Gauntlets"), GetMenuText("Boots"), GetMenuText("All")};
        ImGui::Combo("Aimbot Target", &TargettingIndex, AimbotTargets, IM_ARRAYSIZE(AimbotTargets));
        ImGui::SliderFloat(GetMenuText("Target Bone Hit Chance"), &TargetBoneHitChance, 0, 100, "%.0f%%", 1);
        
        
    }
}
//need to draw a line from the targeted location to screen center
int MaleBones[] = {0, 21, 4, 90, 40, 85, 0};
int FemaleBones[] = {0, 21, 4, 90, 40, 85, 0};
void AimAssist::HandleAimAssist(UObject* TargettedPlayer){
    ScreenCenter = Vector2([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    /*int MaleBones[] = {0, 49, 95, 29, 87, 62, 0};
    int FemaleBones[] = {0, 49, 97, 30, 89, 63, 0};
                            
     */
    
    
    
    UObject* MyController = gameUtils.GetMyController();
    if(utils.isObject((long)TargettedPlayer) && Aimlock && utils.isValidAdress(MyController) && utils.isObject((long)MyController) && utils.isValidAdress(gameUtils.GetPlayerCameraManager()) && utils.isValidAdress(gameUtils.GetShooterWeapon()) && gameUtils.isInGame() &&  utils.isValidAdress(gameUtils.GetMyShooterCharacter()))
    {
        
        if(AimlockToggleSwitch && !AutoShootSwitch.isOn) return;
        
        bool isFemale = gameUtils.SGetObjectName(TargettedPlayer) == "PlayerPawnTest_Female_C";
        
        int BoneToAimAt = isFemale ? FemaleBones[TargettingIndex] : MaleBones[TargettingIndex];
        
        Vector3 EnemyLocation = gameUtils.GetBoneLocation(TargettedPlayer, BoneToAimAt);
        Vector3 MyLocation = gameUtils.GetMyLocation();
        
        
        Vector2 EnemyScreenLocation = gameUtils.World2Screen(EnemyLocation, gameUtils.GetViewMatrix());
        Vector2 DeltaScreenLocation = ScreenCenter - EnemyScreenLocation;
        float ScreenDistance = DeltaScreenLocation.GetMagnitude();
        
        if(ScreenDistance > AimlockCircleSize) return;
        //if(ScreenDistance < 12) return;
        
        if(EnemyScreenLocation.X < 0 || EnemyScreenLocation.Y < 0 || EnemyScreenLocation.X > SCREEN_WIDTH || EnemyScreenLocation.Y > SCREEN_HEIGHT) return;
        
        Vector3 DeltaLocation = EnemyLocation - MyLocation;
        float aimYaw = atan2(DeltaLocation.Y, DeltaLocation.X) * RadiansToDegree;
        float aimPitch = asin(DeltaLocation.Z / DeltaLocation.GetMagnitude()) * RadiansToDegree;
        
        if(showAimlockCircle){
            ImGui::GetForegroundDrawList()->AddLine(EnemyScreenLocation.toVec2(), ScreenCenter.toVec2(), utils.FloatColorsToImU32(AimlockCircleColor), 0.3);
        }
        
        if(AimlockSpeed != 2000)
        {
            
            float MaxScreenMovement = 2 * AimlockSpeed / MenuFPS;
            
            float ScreenMovementPercentage = MaxScreenMovement / ScreenDistance;
            if(ScreenMovementPercentage > 1.f) ScreenMovementPercentage = 1.f;
            
            
            FRotator AimRotation = utils.Read<FRotator>(gameUtils.GetMyController() + 0x600);

            float DeltaCameraRotationPitch = AimRotation.Pitch - aimPitch;
            float DeltaCameraRotationYaw = AimRotation.Yaw - aimYaw;
            
            if(DeltaCameraRotationYaw > 180){
                DeltaCameraRotationYaw-=360;
            }
            if(DeltaCameraRotationYaw < -180){
                DeltaCameraRotationYaw+=360;
            }
            
            if(DeltaCameraRotationPitch > 180){
                DeltaCameraRotationPitch-=360;
            }
            if(DeltaCameraRotationPitch < -180){
                DeltaCameraRotationPitch+=360;
            }

            float NewCamerRotationPitch = AimRotation.Pitch - DeltaCameraRotationPitch * ScreenMovementPercentage;
            float NewCamerRotationYaw = AimRotation.Yaw - DeltaCameraRotationYaw * ScreenMovementPercentage;
            
            utils.Write<float>(MyController + 0x600, NewCamerRotationPitch);
            utils.Write<float>(MyController + 0x604, NewCamerRotationYaw);
        } else {
            
            utils.Write<float>(MyController + 0x600, aimPitch);
            utils.Write<float>(MyController + 0x604, aimYaw);
        }
        
        
    }
}
