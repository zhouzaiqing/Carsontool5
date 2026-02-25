//
//  BedList.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/26/23.
//

class BedList {

private:
    bool hasLoadedBeds = false;
    
public:
    static BedList& getInstance() {
        static BedList instance; // The single instance
        return instance;
    }
    
    void LoadServerBedList();
    void SaveServerBedList();
    
    void DrawBedListMenu();
};
