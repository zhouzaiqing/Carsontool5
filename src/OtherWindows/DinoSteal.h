//
//  DinoSteal.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/22/23.
//

class DinoSteal {

public:
    static DinoSteal& getInstance() {
        static DinoSteal instance; // The single instance
        return instance;
    }
    
    void DrawDinoStealMenu();
    void StealDinos(bool StealWilds, bool StealAlly, bool StealEnemy);
    
};
