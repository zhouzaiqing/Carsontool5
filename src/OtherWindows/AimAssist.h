//
//  AimAssist.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/19/23.
//

#ifndef AimAssist_h
#define AimAssist_h



class AimAssist {

public:
    static AimAssist& getInstance() {
        static AimAssist instance; // The single instance
        return instance;
    }
    
    void DrawAimlockCircles();
    void DrawAimAssistMenu();
    void HandleAimAssist(UObject* TargettedPlayer);
    
};

#endif /* AimAssist_h */
