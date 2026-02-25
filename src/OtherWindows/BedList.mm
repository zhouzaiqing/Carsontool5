//
//  BedList.mm
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/26/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"

static long (*PrimalStructureBed)() = (long(*)())utils.getOffset(0xf89518);

enum EBedType : uint8_t {
    BedType_SleepingBag = 0,
    BedType_SimpleBed = 1,
    BedType_BunkBed = 2,
    BedType_ElegantBed = 3,
    BedType_SleepingPod = 4,
    BedType_Count = 5
};
struct BedStructure {
    string BedName;
    string BedTribeName;
    int BedID;
    EBedType BedType;
    Vector3 BedWorldLocation;
    Vector2 BedWorldCoordinates;
};
struct ServerEntry {
    string ServerIP;
    string ServerName;
    vector<BedStructure> ServerBeds;
};


ServerEntry NullEntry = {"NO IP", "NO NAME"};
vector<ServerEntry> ServerList;

static void CreateDummyServerList(){
    BedStructure bedEntryOne = {"BedNameOne", "TribeNameOne", 123, BedType_SleepingBag, {1,2,3}, Vector2(3,4)};
    BedStructure bedEntryTwo = {"BedNameTwo", "TribeNameTwo", 456, BedType_SimpleBed, {4,5,6}, Vector2(9,8)};
    ServerEntry entryOne;
    entryOne.ServerIP = "123.456.789";
    entryOne.ServerName = "A Server";
    entryOne.ServerBeds.push_back(bedEntryOne);
    entryOne.ServerBeds.push_back(bedEntryTwo);
    
    BedStructure bedEntryThree = {"BedNameThree", "TribeNameThree", 123, BedType_SleepingBag, {1,2,3}, Vector2(3,4)};
    BedStructure bedEntryFour = {"BedNameFour", "TribeNameFour", 456, BedType_SimpleBed, {4,5,6}, Vector2(9,8)};
    ServerEntry entryTwo;
    entryTwo.ServerIP = "987.654.321";
    entryTwo.ServerName = "B Server";
    entryTwo.ServerBeds.push_back(bedEntryThree);
    entryTwo.ServerBeds.push_back(bedEntryFour);
    
    ServerList.push_back(entryOne);
    ServerList.push_back(entryTwo);
}
static void SaveServersToFile(NSArray<NSDictionary*>* ServersArray, NSString* filePath){
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ServersArray options:NSJSONWritingPrettyPrinted error:&error];

    if (!error) {
        [jsonData writeToFile:filePath atomically:YES];
    } else {
    }
}
static NSString* GetServerListSavePath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *test = @"/ShooterGame/Saved";
    NSString *testdir = [documentsDirectory stringByAppendingString:test];
    NSString *WkWk = [NSString stringWithFormat:@"%@/ServerList.json", testdir];
    return WkWk;
}
static void SaveServerList(){
    NSMutableArray<NSDictionary *> *serversArray = [NSMutableArray array];
    
    for (const ServerEntry& serverEntry : ServerList) {
        NSMutableDictionary *serverDict = [NSMutableDictionary dictionary];
        serverDict[@"ServerName"] = [NSString stringWithUTF8String:serverEntry.ServerName.c_str()];
        serverDict[@"ServerIP"] = [NSString stringWithUTF8String:serverEntry.ServerIP.c_str()];

        NSMutableArray<NSDictionary *> *bedsArray = [NSMutableArray array];
        for (const BedStructure& bed : serverEntry.ServerBeds) {
            NSMutableDictionary *bedDict = [NSMutableDictionary dictionary];
            
            bedDict[@"BedName"] = [NSString stringWithUTF8String:bed.BedName.c_str()];
            bedDict[@"BedTribeName"] = [NSString stringWithUTF8String:bed.BedTribeName.c_str()];
            bedDict[@"BedID"] = @(bed.BedID);
            bedDict[@"BedType"] = @(bed.BedType);
            bedDict[@"BedWorldLocation"] = @{
                @"X": @(bed.BedWorldLocation.X),
                @"Y": @(bed.BedWorldLocation.Y),
                @"Z": @(bed.BedWorldLocation.Z)
            };
            bedDict[@"BedWorldCoordinates"] = @{
                @"X": @(bed.BedWorldCoordinates.X),
                @"Y": @(bed.BedWorldCoordinates.Y)
            };
            /*bedDict[@"BedLocation"] = @{
                @"x": @(bed.BedLocation.x),
                @"y": @(bed.BedLocation.y)
            }; */

            [bedsArray addObject:bedDict];
        }
        serverDict[@"ServerBeds"] = bedsArray;

        [serversArray addObject:serverDict];
    }
    
    NSString* filePath = GetServerListSavePath();
    SaveServersToFile(serversArray, filePath);
    /*
     NSString *filePath = @"/path/to/servers.json"; // Replace with your desired file path
     [self saveServersToFile:serversArray toFilePath:filePath];
     */
}
static NSArray<NSDictionary *>* loadServersFromFile(NSString* FilePath){
    if ([[NSFileManager defaultManager] fileExistsAtPath:FilePath]){
        NSData *jsonData = [NSData dataWithContentsOfFile:FilePath];
        NSError *error = nil;
        NSArray<NSDictionary *> *serversArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

        if (!error) {
            return serversArray;
        } else {
            return nil;
        }
    }
    else {
        CreateDummyServerList();
        SaveServerList();
        
        NSData *jsonData = [NSData dataWithContentsOfFile:FilePath];
        NSError *error = nil;
        NSArray<NSDictionary *> *serversArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

        if (!error) {
            return serversArray;
        } else {
            return nil;
        }
    }
}
static void LoadServerList(){
    NSString* FilePath = GetServerListSavePath();
    NSArray<NSDictionary*>* serversArray = loadServersFromFile(FilePath);
    if(serversArray)
    {
        ServerList.clear();
        
        for (NSDictionary *serverDict in serversArray) {
            ServerEntry serverEntry;
            serverEntry.ServerName = [serverDict[@"ServerName"] UTF8String];
            serverEntry.ServerIP = [serverDict[@"ServerIP"] UTF8String];

            NSArray<NSDictionary *> *bedsArray = serverDict[@"ServerBeds"];
            for (NSDictionary *bedDict in bedsArray) {
                BedStructure bed;
                bed.BedName = [bedDict[@"BedName"] UTF8String];
                bed.BedTribeName = [bedDict[@"BedTribeName"] UTF8String];
                bed.BedID = [bedDict[@"BedID"] intValue];
                bed.BedType = (EBedType)[bedDict[@"BedType"] intValue];
                bed.BedWorldLocation.X = [bedDict[@"BedWorldLocation"][@"X"] floatValue];
                bed.BedWorldLocation.Y = [bedDict[@"BedWorldLocation"][@"Y"] floatValue];
                bed.BedWorldLocation.Z = [bedDict[@"BedWorldLocation"][@"Z"] floatValue];
                bed.BedWorldCoordinates.X = [bedDict[@"BedWorldCoordinates"][@"X"] floatValue];
                bed.BedWorldCoordinates.Y = [bedDict[@"BedWorldCoordinates"][@"Y"] floatValue];
                

                serverEntry.ServerBeds.push_back(bed);
            }

            ServerList.push_back(serverEntry);
        }
    }
}

static bool doesServerExistInList(string ServerIP){
    for (const ServerEntry& serverEntry : ServerList)
    {
        if(serverEntry.ServerIP == ServerIP)
        {
            return true;
        }
        
    }
    return false;
}
static void CreateServerEntryForList(){
    ServerEntry newServer;
    if(gameUtils.GetServerName() != "None"){
        newServer.ServerName = gameUtils.GetServerName();
        newServer.ServerIP = gameUtils.GetServerIP();
        ServerList.push_back(newServer);
    }
}
/*
static ServerEntry* GetCurrentServerList(){
    
} */
static ServerEntry& GetCurrentBedList(string ServerIP){
    for (ServerEntry& serverEntry : ServerList)
    {
        if(serverEntry.ServerIP == ServerIP)
        {
            return serverEntry;
        }
    }
    
    return NullEntry;
}
static void ModifyTest(){
    for (ServerEntry& serverEntry : ServerList)
    {
        for(BedStructure& bedEntry : serverEntry.ServerBeds){
            bedEntry.BedID = 666;
        }
    }
}


/*
 enum EBedType : uint8_t {
     BedType_SleepingBag = 0,
     BedType_SimpleBed = 1,
     BedType_BunkBed = 2,
     BedType_ElegantBed = 3,
     BedType_SleepingPod = 4,
     BedType_Count = 5
 };
 struct BedStructure {
     string BedName;
     string BedTribeName;
     int BedID;
     EBedType BedType;
     Vector3 BedWorldLocation;
     Vector2 BedWorldCoordinates;
 };
 */
static Vector3 GetWorldLocation(UObject* Pawn){
    UObject* SceneComponent = utils.Read<UObject*>(Pawn + 0x2c8);
    return utils.Read<Vector3>(SceneComponent + 0x290);
}


vector<BedStructure> WorldBeds;
static void GetWorldBedList(){
    string BedNames[BedType_Count] = {"Sleeping Bag","Simple Bed", "Bunk Bed", "Elegant Bed", "Sleeping Pod"};
    
    WorldBeds.clear();
    
    if(!gameUtils.isInGame()) return;
    
    TArray<UObject*> EntityList = gameUtils.GetActorsArray();
    if(EntityList.IsValidArray())
    {
        for(int i = 0; i<EntityList.Count; ++i)
        {
            UObject* CurrentEntity = EntityList[i];
            if(utils.isValidAdress(CurrentEntity))
            {
                if(gameUtils.isA_Fast(CurrentEntity, PrimalStructureBed()))
                {
                    BedStructure newStructure;
                    
                    Vector3 BedWorldLocation = GetWorldLocation(CurrentEntity);
                    int BedID = utils.Read<int>(CurrentEntity + 0xc68);
                    EBedType BedType;
                    string BedName = gameUtils.SGetObjectName(CurrentEntity);
                    if(BedName == "SleepingBag_C"){
                        BedType = BedType_SleepingBag;
                    } else if(BedName == "SimpleBed_C"){
                        BedType = BedType_SimpleBed;
                    } else if(BedName == "TekBed_C"){
                        BedType = BedType_SleepingPod;
                    } else if(BedName == "ElegantBed_C"){
                        BedType = BedType_ElegantBed;
                    } else {
                        BedType = BedType_BunkBed;
                    }
                    
                    newStructure.BedType = BedType;
                    newStructure.BedName = BedNames[BedType];
                    newStructure.BedID = BedID;
                    newStructure.BedTribeName = to_string(utils.Read<int>(CurrentEntity + 0x29c));
                    newStructure.BedWorldLocation = BedWorldLocation;
                    
                    
                    UObject* WorldSettings = gameUtils.GetWorldSettings();
                    
                    float OriginY = BedWorldLocation.Y - utils.Read<float>(WorldSettings + 0xa58);
                    float OriginX = BedWorldLocation.X - utils.Read<float>(WorldSettings + 0xa54);
                    float Latitude = OriginY / (10 * utils.Read<float>(WorldSettings + 0xa50));
                    float Longitude = OriginX / (10 * utils.Read<float>(WorldSettings + 0xa4c));
                    
                    newStructure.BedWorldCoordinates = Vector2(Latitude, Longitude);
                    
                    WorldBeds.push_back(newStructure);
                }
            }
        }
    }
}

static bool isBedIDAlreadyInList(int BedID, ServerEntry ServerBedList){
    for(const BedStructure& currentBed : ServerBedList.ServerBeds){
        if(currentBed.BedID == BedID) return true;
    }
    return false;
}
static void DeleteBed(int BedID, int ServerListIndex){
    for(int i = 0; i<ServerList[ServerListIndex].ServerBeds.size(); i++){
        if(ServerList[ServerListIndex].ServerBeds[i].BedID == BedID){
            ServerList[ServerListIndex].ServerBeds.erase(ServerList[ServerListIndex].ServerBeds.begin() + i);
            return;
        }
    }
}
static void ChangeBedName(BedStructure& bed, int ServerListIndex){
    
    int BedIndex = 0;
    for(int i = 0; i<ServerList[ServerListIndex].ServerBeds.size(); i++){
        BedStructure currentBed = ServerList[ServerListIndex].ServerBeds[i];
        if(currentBed.BedID == bed.BedID){
            BedIndex = i;
        }
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Bed Name"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"New Name";}];
    
    UIAlertAction* Send = AlertAction(@"Change"){
        UITextField *textField = alertController.textFields.firstObject;
        NSString *enteredText = textField.text;
        string MessageText = [enteredText UTF8String];
        ServerList[ServerListIndex].ServerBeds[BedIndex].BedName = MessageText;
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
}
static void AddCustomBed(int ServerListIndex){
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Custom Bed"
                                                                                     message:NULL
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Bed Name";}];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"BedID";}];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Latitude";}];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Longitude";}];
    
    
    UIAlertAction* Send = AlertAction(@"Add"){
        BedStructure newBed;
        UITextField *BedNameTextField = alertController.textFields[0];
        UITextField *BedIDTextField = alertController.textFields[1];
        UITextField *LatitudeTextField = alertController.textFields[2];
        UITextField *LongitudeTextField = alertController.textFields[3];
        
        string BedName = [BedNameTextField.text UTF8String];
        int BedID = [BedIDTextField.text intValue];
        float Latitude = [LatitudeTextField.text floatValue];
        float Longitude = [LongitudeTextField.text floatValue];
        
        newBed.BedName = BedName;
        newBed.BedID = BedID;
        newBed.BedWorldCoordinates.X = Latitude;
        newBed.BedWorldCoordinates.Y = Longitude;
        
        ServerList[ServerListIndex].ServerBeds.push_back(newBed);
    }];
    UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
    
    [alertController addAction:Send];
    [alertController addAction:Cancel];
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

/*
 enum EBedType : uint8_t {
     BedType_SleepingBag = 0,
     BedType_SimpleBed = 1,
     BedType_BunkBed = 2,
     BedType_ElegantBed = 3,
     BedType_SleepingPod = 4,
     BedType_Count = 5
 };
 struct BedStructure {
     string BedName;
     string BedTribeName;
     int BedID;
     EBedType BedType;
     Vector3 BedWorldLocation;
     Vector2 BedWorldCoordinates;
 };
 */


/*
 
Get Server IP

if ServerIP is
 
 
 
 
 IDEA:
 
    Others: Ability to export a Bed List and Bed Structure as a string and also import as string
 
    https://chat.openai.com/share/0fe6da6e-4b62-46a5-91a3-9114e10ef9b7
    
    1. Show IDs on Bed ESP
    2. Have Lists that are based on server (Loads a different list for every server)
       Each List Contains Bed IDs + Location
        Display a Bed Name (Optional), Bed Type, Bed GPS Location, Tribe Name
 
    A Button 'Add Nearby Bed' which does an ESP search for beds, displays them with
    their type, location, tribe, and a butotn to add a name to them
 
    A Button to add a bed ID on the server and custom add type/location/tribe
 
    All of this save as JSON
 
 something like this
 
 vector<ServerEntry> Servers;
 struct ServerEntry{
     string ServerName;
     string ServerIP;
     vector<BedStructure> ServerBeds;
 };
 struct BedStructure{
     string BedName;
     Vector2 BedLocation;
     int BedID;
 };
 
 https://chat.openai.com/share/ca33b9e3-4222-430f-b77b-88e3cfe8be86
 */

void BedList::LoadServerBedList(){
    if(!hasLoadedBeds){
        hasLoadedBeds = true;
        LoadServerList();
    }
}
void BedList::SaveServerBedList(){
    if(hasLoadedBeds){
        SaveServerList();
    }
}
void BedList::DrawBedListMenu(){
    
    static bool ShowPickBedMenu = false;
    int ServerListIndex = 0;
    ServerEntry& currentServer = NullEntry;
    
    if(gameUtils.isInGame()){
        string ServerIP = gameUtils.GetServerIP();
        if(doesServerExistInList(ServerIP))
        {
            for(int i = 0; i<ServerList.size(); i++){
                ServerEntry& serverEntry = ServerList[i];
                if(serverEntry.ServerIP == ServerIP){
                    ServerListIndex = i;
                    currentServer = ServerList[i];
                }
            }
        }
        else
        {
            CreateServerEntryForList();
        }
       /* if(currentServer.ServerIP != ServerIP)
        {
            if(doesServerExistInList(ServerIP)){
                currentServer = GetCurrentBedList(ServerIP);
            } else {
                CreateServerEntryForList();
                return;
            }
        } */
        if(currentServer.ServerIP == ServerIP)
        {
            
            string ServerName = gameUtils.GetServerName();
            
            ImGui::Text("Server Name: %s", ServerName.c_str());
            ImGui::Text("Server IP: %s", ServerIP.c_str());
            ImGui::Text("Server Bed Count: %lu", currentServer.ServerBeds.size());

            if(ShowPickBedMenu){
                if(ImGui::Selectable("BACK")){
                    ShowPickBedMenu = false;
                }
                for(const BedStructure& currentBed : WorldBeds){
                    if(!isBedIDAlreadyInList(currentBed.BedID, currentServer)){
                        string DisplayName = utils.string_format("%s : BedID: %d Lat: %.1f Long: %.1f", currentBed.BedName.c_str(), currentBed.BedID, currentBed.BedWorldCoordinates.X, currentBed.BedWorldCoordinates.Y);
                        
                        if(ImGui::Selectable(DisplayName.c_str())){
                            ShowPickBedMenu = false;
                            ServerList[ServerListIndex].ServerBeds.push_back(currentBed);
                        }
                    }
                }
            }
            else
            {
                ImGui::Columns(2, NULL, false);
                
                if(ImGui::Button(GetMenuText("Add Nearby Bed"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
                    GetWorldBedList();
                    if(WorldBeds.size() > 0){
                        ShowPickBedMenu = true;
                    }
                } ImGui::NextColumn();
                
                if(ImGui::Button(GetMenuText("Add Custom Bed"), ImVec2(ImGui::GetColumnWidth()-10, 20))){
                    AddCustomBed(ServerListIndex);
                }
                
                ImGui::Columns();
                
                if(currentServer.ServerBeds.size() > 0){
                    for(BedStructure& currentBed : currentServer.ServerBeds){
                        string DisplayName = utils.string_format("%s : BedID: %d Lat: %.1f Long: %.1f", currentBed.BedName.c_str(), currentBed.BedID, currentBed.BedWorldCoordinates.X, currentBed.BedWorldCoordinates.Y);
                        
                        ImGui::Separator();
                        
                        ImGui::Text("%s", DisplayName.c_str());
                        
                        ImGui::Columns(3, NULL, false);
                        
                        string IDOne = to_string(currentBed.BedID) + "One";
                        string IDTwo = to_string(currentBed.BedID) + "Two";
                        string IDThree = to_string(currentBed.BedID) + "Three";
                        
                        ImGui::PushID(IDOne.c_str());
                        
                        if(ImGui::Button(GetMenuText("Teleport"), ImVec2(ImGui::GetColumnWidth() - 10, 20))){
                            functions.BedTeleport(currentBed.BedID);
                        } ImGui::NextColumn();
                        
                        ImGui::PopID();
                        
                        ImGui::PushID(IDTwo.c_str());
                        
                        if(ImGui::Button(GetMenuText("Delete Bed"), ImVec2(ImGui::GetColumnWidth() - 10, 20))){
                            DeleteBed(currentBed.BedID, ServerListIndex);
                        } ImGui::NextColumn();
                        
                        ImGui::PopID();
                        
                        ImGui::PushID(IDThree.c_str());
                        
                        if(ImGui::Button(GetMenuText("Change Name"), ImVec2(ImGui::GetColumnWidth() - 10, 20))){
                            ChangeBedName(currentBed, ServerListIndex);
                        } ImGui::NextColumn();
                        
                        ImGui::PopID();
                        
                        ImGui::Columns();
                        
                    }
                }
            }
            
        }
    } else {
        currentServer = NullEntry;
        ImGui::Text("Join A Server to use this feature");
    }
}
