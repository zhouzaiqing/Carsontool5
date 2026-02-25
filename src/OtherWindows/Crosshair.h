//
//  Crosshair.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/24/23.
//
class Crosshair {
  
public:
    static Crosshair& getInstance() {
        static Crosshair instance; // The single instance
        return instance;
    }
    
    
    void DrawCrosshairMenu();
    void DrawCrosshairOnScreen();
    
    void DrawPlusCrosshair();
    void DrawCircleCrosshair();
    void DrawXCrosshair();
    void DrawCarrotCrosshair();
    
};
