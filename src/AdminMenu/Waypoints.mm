//
//  Waypoints.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 8/22/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static UITextField *WaypointFilterField;
static char WaypointFilterBuffer[256];

static Vector2 GetCoordinatesFromLocation(Vector3 WorldLocation)
{
    UObject* WorldSettings = gameUtils.GetWorldSettings();
    Vector2 Coordinates = {0,0};
    if(utils.isValidAdress(WorldSettings))
    {
        float OriginY = WorldLocation.Y - utils.Read<float>(WorldSettings + 0xa58);
        float OriginX = WorldLocation.X - utils.Read<float>(WorldSettings + 0xa54);
        float Latitude = OriginY / (10 * utils.Read<float>(WorldSettings + 0xa50));
        float Longitude = OriginX / (10 * utils.Read<float>(WorldSettings + 0xa4c));
        Coordinates.X = Latitude;
        Coordinates.Y = Longitude;
    }
    return Coordinates;
}

void Waypoints::Initialize(){
    WaypointFilterField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    WaypointFilterField.backgroundColor = [UIColor lightGrayColor];
    WaypointFilterField.autocorrectionType = UITextAutocorrectionTypeNo;
    WaypointFilterField.secureTextEntry = true;
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:WaypointFilterField];
    
    LoadWaypoints();
}
void Waypoints::SaveWaypoints(){
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (const auto& waypoint : LoadedWaypoints) {
        NSDictionary *jsonDict = @{
            @"waypointName": [NSString stringWithUTF8String:waypoint.WaypointName.c_str()],
            @"x": @(waypoint.x),
            @"y": @(waypoint.y),
            @"z": @(waypoint.z)
        };
        [jsonArray addObject:jsonDict];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:0 error:&error];
    if (!jsonData) {
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Write the JSON string to a file
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"waypoints.json"];
    
    if (![jsonString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        return;
    }
}
void Waypoints::LoadWaypoints(){
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"waypoints.json"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!fileContents) {
        return;
    }
    
    if(fileContents.length < 10){
        return;
    }
    
    // Deserialize the JSON string into a vector of waypoints
    NSMutableArray *parsedArray = [NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (!parsedArray) {
        return;
    }
    
    for (NSDictionary *jsonDict in parsedArray) {
        Waypoint waypoint;

        waypoint.WaypointName = [[jsonDict objectForKey:@"waypointName"] UTF8String];
        waypoint.x = [jsonDict[@"x"] floatValue];
        waypoint.y = [jsonDict[@"y"] floatValue];
        waypoint.z = [jsonDict[@"z"] floatValue];
        LoadedWaypoints.push_back(waypoint);
    } 
}
void Waypoints::AddWaypoint(string name, float x, float y, float z){
    for(int i = 0; i<LoadedWaypoints.size(); i++){
        Waypoint CurrentWaypoint = LoadedWaypoints[i];
        if(name == CurrentWaypoint.WaypointName) return;
    }
    LoadedWaypoints.push_back({name, x, y, z});
}
void Waypoints::DrawMenu(){
    
    if(ImGui::Button(GetMenuText("Add Waypoint At Current Position"), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
        UIAlertController *WaypointAlert = [UIAlertController alertControllerWithTitle:@"Enter Waypoint Information" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [WaypointAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Name";
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray *textFields = WaypointAlert.textFields;
            UITextField *WaypointNameField = textFields[0];
            Vector3 MyLocation = gameUtils.GetMyLocation();
            AddWaypoint(WaypointNameField.text.UTF8String, MyLocation.X, MyLocation.Y, MyLocation.Z);
            SaveWaypoints();
        }];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];

        [WaypointAlert addAction:okAction]; [WaypointAlert addAction:Cancel];
        [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:WaypointAlert animated:YES completion:nil];
    }
    
    
    
    
    strcpy(WaypointFilterBuffer, WaypointFilterField.text.UTF8String);
    string CustomWaypointString = string(GetMenuText("Searched Waypoint:")) + WaypointFilterBuffer;
    ImGui::Button(CustomWaypointString.c_str(), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20));
    if(ImGui::IsItemHovered()){
        [WaypointFilterField becomeFirstResponder];
    } else{
        [WaypointFilterField resignFirstResponder];
    }
    
    int CurrentWaypointIndex = 0;
    for(const Waypoint& CurrentWaypoint : LoadedWaypoints)
    {
        ++CurrentWaypointIndex;
        if(utils.containsIgnoreCase(CurrentWaypoint.WaypointName, string(WaypointFilterBuffer)))
        {
            ImGui::PushItemWidth(200);
            if(utils.isValidAdress(gameUtils.GetWorldSettings()))
            {
                Vector2 Coordinates = GetCoordinatesFromLocation({CurrentWaypoint.x, CurrentWaypoint.y, CurrentWaypoint.z});
                ImGui::Text("%s", utils.string_format("%s %.1f %.1f", CurrentWaypoint.WaypointName.c_str(), Coordinates.Y, Coordinates.X).c_str());
            }
            else
            {
                ImGui::Text("%s", utils.string_format("%s %.1f %.1f %.1f", CurrentWaypoint.WaypointName.c_str(), CurrentWaypoint.x, CurrentWaypoint.y, CurrentWaypoint.z).c_str());
            }
            ImGui::PopItemWidth();
            
            ImGui::SameLine();
            
            ImGui::PushID(CurrentWaypointIndex);
            if(ImGui::Button(GetMenuText("Teleport"), ImVec2(70, ImGui::GetFrameHeight()))){
                functions.ExecuteConsoleCommand(utils.string_format("SPI %.0f %.0f %.0f 0", CurrentWaypoint.x, CurrentWaypoint.y, CurrentWaypoint.z));
            }
            ImGui::SameLine();
            ImGui::PopID();
            ImGui::PushID(CurrentWaypointIndex + (int)LoadedWaypoints.size());
            if(ImGui::Button(GetMenuText("Delete"), ImVec2(70, ImGui::GetFrameHeight()))){
                LoadedWaypoints.erase(LoadedWaypoints.begin() + CurrentWaypointIndex);
            }
            ImGui::PopID();
        }
    }
}
