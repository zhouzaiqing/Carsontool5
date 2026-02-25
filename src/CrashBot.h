//
//  CrashBot.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 7/25/23.
//


class CrashBot {
  
private:
    bool isActive = false;
    string ServerIP;
    string ServerName;
    
public:
    static CrashBot& getInstance() {
        static CrashBot instance; // The single instance
        return instance;
    }
    
    
    void CrashBotButtonPushed();
    void ActivateCrashBot();
    void StopCrashBot();
    
    
    void HandleCrashBot();
    void JoinServer();
    
};
