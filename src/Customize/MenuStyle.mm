//
//  MenuStyle.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/26/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

void MenuStyle::DrawMenu(){
    if(ImGui::Button("Reset Settings", ImVec2(ImGui::GetContentRegionAvailWidth()-20, 20))){
        ImGui::GetStyle() = ImGuiStyle();
    }
    ImGui::ShowStyleEditor();
}

void MenuStyle::SaveStyle(){
    @autoreleasepool {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* filePath = [documentsDirectory stringByAppendingString:@"/ShooterGame/Saved/MenuSettings.txt"];
        if(![fileManager fileExistsAtPath:filePath]){
            [fileManager createFileAtPath:filePath contents:[NSData data] attributes:nil];
        } else {
            ImGuiStyle MenuStyle = ImGui::GetStyle();
            NSData *data = [NSData dataWithBytes:&MenuStyle length:sizeof(ImGuiStyle)];
            [data writeToFile:filePath options:NSDataWritingAtomic error:nil];
        }
    }
}
void MenuStyle::LoadStyle(){
    @autoreleasepool {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* filePath = [documentsDirectory stringByAppendingString:@"/ShooterGame/Saved/MenuSettings.txt"];
        if(![fileManager fileExistsAtPath:filePath]){
            return;
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            
            ImGuiStyle MenuStyle;
            [data getBytes:&MenuStyle length:sizeof(ImGuiStyle)];
            ImGui::GetStyle() = MenuStyle;
        }
    }
}

/*
ImGuiStyle MenuStyle;
[data getBytes:&MenuStyle length:sizeof(ImGuiStyle)];
ImGui::GetStyle() = MenuStyle;
 */
