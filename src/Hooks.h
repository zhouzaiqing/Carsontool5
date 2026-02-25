//
//  Hooks.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

class Hooks {
    
public:
    static Hooks& getInstance() {
        static Hooks instance; // The single instance
        return instance;
    }
    
    void StartHooks();
};
