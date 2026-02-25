//
//  IconSwitcher.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/8/23.



class IconSwitcher {
    public:
        static IconSwitcher& getInstance() {
            static IconSwitcher instance; // The single instance
            return instance;
        }
        
        void ShowIconSwitcher();
};

