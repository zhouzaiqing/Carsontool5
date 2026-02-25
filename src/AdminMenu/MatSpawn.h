//
//  MatSpawn.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 10/9/23.
//
enum EGiveItem : uint8_t {
    SilicaPearls = 0,
    Thatch = 1,
    Fiber = 2,
    LeechBlood = 3,
    Sap = 4,
    Metal = 5,
    Charcoal = 6,
    AnglerGel = 7,
    Sparkpowder = 8,
    Oil = 9,
    Obsidian = 10,
    Pelt = 11,
    MetalIngot = 12,
    Stone = 13,
    Wood = 14,
    Hide = 15,
    Crystal = 16,
    Gasoline = 17,
    CementingPaste = 18,
    Chitin = 19,
    Electronics = 20,
    Flint = 21,
    Polymer = 22,
    Biotoxin = 23,
    BlackPearl = 24,
    EGiveItem_MAX = 25
};

class MatSpawn {
public:
    static MatSpawn& getInstance() {
        static MatSpawn instance; // The single instance
        return instance;
    }
    void DrawMenu();
    void SpawnMaterial(EGiveItem ItemToGive, int Ammount);
    //void ServerGodConsoleCommandThree(enum class EGiveItem ItemToGive, bool MaxStack);
    
};
