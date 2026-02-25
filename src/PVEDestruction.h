//
//  PVEDestruction.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 1/23/24.
//

#ifndef PVEDestruction_h
#define PVEDestruction_h

class PVEDestruction {
    public:
        static PVEDestruction& getInstance() {
            static PVEDestruction instance; // The single instance
            return instance;
        }
        
        void ShowPVEDestructionMenu();
        void Handle();
        
        /*
         Pickup Bottom Up
            - Item Caches
            - Foundations
            - Turrets
            - Structures
         Demolish Target / Pickup Target
            - Automatic (Enemy)
            - When Punching
         
        Claim Enemy Dino
            - All in Render Distance Automatically
            - All in Render Distance Once
            - When Punching
            
         */
};


#endif /* PVEDestruction_h */
