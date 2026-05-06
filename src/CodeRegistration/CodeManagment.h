//
//  CodeManagment.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//
#pragma once
#include <string>
using namespace std;

// Tier levels are cumulative: Dev > Max > Pro > Normal > None
enum CodeTier : uint8_t {
    Tier_None   = 0,
    Tier_Normal = 1,
    Tier_Pro    = 2,
    Tier_Max    = 3,
    Tier_Dev    = 4
};

class CodeManagment {
private:
    CodeTier currentTier = Tier_Dev;

public:
    static CodeManagment& getInstance() {
        static CodeManagment instance;
        return instance;
    }

    // Sends CarsontoolCode to the license server and updates AuthString + currentTier
    void SendServerLogin();

    bool isNormalCode();
    bool isProCode();
    bool isMaxCode();
    bool isDevCode();
};
