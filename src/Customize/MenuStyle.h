//
//  MenuStyle.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/26/23.
//

class MenuStyle {
  
public:
    static MenuStyle& getInstance() {
        static MenuStyle instance; // The single instance
        return instance;
    }
    
    void LoadStyle();
    void SaveStyle();
    void DrawMenu();
    
    
};
