//
//  Testing.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/24/23.
//

class Testing {
  
public:
    static Testing& getInstance() {
        static Testing instance; // The single instance
        return instance;
    }
    
    
    void PlayerBodyTest();
    void PlacerColorTest();
    void ShooterWeaponTest();
    void RemoveScopeTest();
    void ReadPointerTest();
    void PrintProcessesTest();
    void MakeRecipeTest();
    void UnclaimDinos();
    void GrenadeSpam();
    void TestMove();
    void TestFindObject();
    UObject* ResolveFullClassName(std::string FullName);
    void TestGetWeaponColorChangeName();
    void TestMountTargetDino();
    void TestFireC4();
};
