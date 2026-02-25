//
//  Prefs.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/8/23.
//
class Pref {
    
public:
    static Pref& getInstance() {
        static Pref instance; // The single instance
        return instance;
    }
    void InitPref();
};
