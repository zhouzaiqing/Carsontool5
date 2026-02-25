//
//  ESP.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 6/26/23.
//

class ESP {
private:
    UObject* TargettedPlayer;
    
public:
    static ESP& getInstance() {
        static ESP instance; // The single instance
        return instance;
    }
    
    void ESPMain();
    void FilterESP();
    
};
