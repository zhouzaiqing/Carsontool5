//
//  WeaponColor.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/24/23.
//

class WeaponColor {
  
public:
    static WeaponColor& getInstance() {
        static WeaponColor instance; // The single instance
        return instance;
    }
    
    void DrawWeaponColorMenu();
    void ChangeWeaponColor();
    void ModifyWorldColors();
    int GetNumMaterials(UObject* SkinnedMeshComponent);
    UObject* GetMaterial(UObject* SkinnedMeshComponent, int ElementIndex);
    int GetColorIndex(int ListIndex);
};
