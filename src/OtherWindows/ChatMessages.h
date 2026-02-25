//
//  ChatMessages.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/19/23.
//

/*
 struct TextEntries{
     NSString* PlayerName;
     NSString* TextString;
     EChatMessageSource Source;
     EChatChannel Channel;
     EChatMessageType Type;
     TeamType TeamID;
     string Translated = "";
 };
 */



class ChatMessages {
private:
    vector<SavedChatMessage> Messages;
public:
    static ChatMessages& getInstance() {
        static ChatMessages instance; // The single instance
        return instance;
    }
    void InitializeChatImages();
    void DrawChatMenu();
    void GetChatMessages();
    
};
