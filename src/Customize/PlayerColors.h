//
//  PlayerColors.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/26/23.
//

class PlayerColors {
  
public:
    static PlayerColors& getInstance() {
        static PlayerColors instance; // The single instance
        return instance;
    }
    
    void DrawMenu();
    void HandlePlayerRainbow();
    void ChangePlayerColors();
    void HandlePlayerWireframe();
    
    
};
