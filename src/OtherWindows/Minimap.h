//
//  Minimap.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/20/23.
//

class Minimap {
  
public:
    static Minimap& getInstance() {
        static Minimap instance; // The single instance
        return instance;
    }
    
    
    void CreateLargeImage();
    void DrawMinimapSettingsMenu();
    void UpdateMinimap();
    void DrawPlayer(Vector3 WorldLocation, ESPTeam PlayerTeam);
    void DrawDinosaur(Vector3 WorldLocation, ImU32 DrawColor);
    void DrawTurret(Vector3 WorldLocation, ImU32 DrawColor);
};


@interface MapButton : UIButton

- (void)Initialize;

@end


