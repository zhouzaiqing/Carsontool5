//
//  Misc.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/12/23.
//

class Miscellaneous {
    
public:
    static Miscellaneous& getInstance() {
        static Miscellaneous instance; // The single instance
        return instance;
    }
    
    void SlidersMain();
    void CheckboxesMain();
    void OtherMain();
    void WorldLoop();
    void InventoryLoop();
};
