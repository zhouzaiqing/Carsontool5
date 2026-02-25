//
//  DinoColors.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/24/23.
//

class DinoColors {
  
public:
    static DinoColors& getInstance() {
        static DinoColors instance; // The single instance
        return instance;
    }
    
    uint8_t IndexRegionColor(int Index);
    void CopyDinoColors();
    void HandleDinoRainbow();
    void DrawDinoColorMenu();
    void ChangeDinoColor();
    void HandleDinoWireframe();
    void HandleDustRegions(UObject* Dino);
    void HandleColorRegions(UObject* Dino);
    void HandleDinoEery(UObject* Dino);
};
