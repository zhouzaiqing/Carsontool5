//
//  CodeManagment.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//

#include "CodeManagment.h"
#import <Foundation/Foundation.h>
#include "../Includes.h"

// ---------------------------------------------------------------------------
// Server endpoint — replace with actual URL
// ---------------------------------------------------------------------------
static NSString* const kLoginURL = @"https://api.carsontool.com/v1/login";

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
static NSString* GetDeviceID() {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

// ---------------------------------------------------------------------------
// CodeManagment
// ---------------------------------------------------------------------------

void CodeManagment::SendServerLogin() {
    // Server verification is bypassed: every user is treated as a max-tier login.
    CarsontoolCode = "dev";
    AuthString = "You Are Logged In";
    currentTier = Tier_Dev;
    return;
}

bool CodeManagment::isNormalCode() {
    return currentTier >= Tier_Normal;
}

bool CodeManagment::isProCode() {
    return currentTier >= Tier_Pro;
}

bool CodeManagment::isMaxCode() {
    return currentTier >= Tier_Max;
}

bool CodeManagment::isDevCode() {
    return currentTier >= Tier_Dev;
}
