//
//  DinoSpawn.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/23/23.
//

class DinoSpawn {
    char textfieldBuffer[256];
    UITextField *textField;
    vector<CreatureIDStruct> Dinosaurs;
    
public:
    static DinoSpawn& getInstance() {
        static DinoSpawn instance; // The single instance
        return instance;
    }
    
    string GetDinoBlueprintString(string DisplayName);
    string GetDinoEntityName(string DisplayName);
    
    void InitializeDinoList()__attribute((__annotate__(("nostrenc"))));
    void DrawMenu();
};
