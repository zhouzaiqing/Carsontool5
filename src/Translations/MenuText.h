//
//  MenuText.h
//  mnkydevtest2
//
//  Created by Carson Mobile on 8/5/23.
//
enum ECurrentLanguage : uint8_t {
    Lang_English = 0,
    Lang_Chinese = 1,
    Lang_Japenese = 2,
    Lang_Max = 3
};
extern char* GetMenuText(string Key);
extern void SetLanguage(ECurrentLanguage Language);

