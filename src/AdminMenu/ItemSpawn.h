//
//  ItemSpawn.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/23/23.
//

class ItemSpawn {
    char textfieldBuffer[256];
    UITextField *itemTextField;
    vector<ItemIDStruct> Items;
    
public:
    static ItemSpawn& getInstance() {
        static ItemSpawn instance; // The single instance
        return instance;
    }
    
    void InitializeItemList()__attribute((__annotate__(("nostrenc"))));
    void DrawMenu();
    
};
