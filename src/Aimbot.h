//
//  Aimbot.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/20/23.
//

class Aimbot {
    
public:
    static Aimbot& getInstance() {
        static Aimbot instance; // The single instance
        return instance;
    }
    
    bool isInstantWeapon(UObject* Weapon);
    bool isProjectileWeapon(UObject* Weapon);
    bool isRidingDino(UObject* Player);
    bool ShouldSlowDino(UObject* Dino);
    UObject* GetRidingDino(UObject* Player);
    UObject* FindBestAimbotTarget();
    Vector3 GetBoneLocation(int BoneIndex);
    void HandleAutoFiring();
    bool FireWeapon();
    void HandleReloading();
    bool HandleSimulateShot(int BoneIndex, UObject* Target);
};
