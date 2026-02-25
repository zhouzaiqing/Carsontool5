//
//  QuickCommands.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/23/23.
//

class QuickCommands {
  
public:
    static QuickCommands& getInstance() {
        static QuickCommands instance; // The single instance
        return instance;
    }
    
    
    void DrawMenu();
};
