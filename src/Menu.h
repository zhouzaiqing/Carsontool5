//
//  Header.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//

class Menu {
  
public:
    static Menu& getInstance() {
        static Menu instance; // The single instance
        return instance;
    }
    
    void DrawMainMenu();
    void ConsoleLog(string Sender, string Entry, FLinearColor Color);
    void ConsoleClear();
    
};
