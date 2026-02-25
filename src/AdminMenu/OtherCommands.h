//
//  Other.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/26/23.
//

class OtherCommands {
  
public:
    static OtherCommands& getInstance() {
        static OtherCommands instance; // The single instance
        return instance;
    }
    
    void DrawMenu();
};
