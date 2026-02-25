//
//  GameOffsets.h
//  BaseMenu
//
//  Created by Carson Mobile on 4/10/23.
//
#include <cstdio>
#include <cstdint>
#include <map>
#include <unordered_map>
#include <vector>
#include <string>
#include <Foundation/Foundation.h>
#include "../Utils/Structures.h"

using namespace std;

#ifndef BASEUTILS_H
#define BASEUTILS_H

// Make this the base class, and an extension of it
class BaseUtils {
    
    
public:
    bool _read(long addr, void *buffer, int len);
    static BaseUtils& getInstance() {
        static BaseUtils instance; // The single instance
        return instance;
    }
    void DefineRead(long address);
    bool isValidAdress(long Adress);
    bool isValidAdress(UObject* Adress);
    bool isObject(long UObject);
    template<typename T> T Read(long address);
    template<typename T> T Read(UObject* address);
    long getOffset(long offset);
    Vector2 ScaleVector(Vector2 InVec, Vector2 Scale);
    float GetDistance(Vector3 To, Vector3 From);
    float GetScreenDistance(Vector2 To, Vector2 From);
    void WriteToEndOfFile(NSString* Content, NSString* FileName);
    UIViewController* currentTopViewControllerFn();
    int GetFPS();
    void Frame();
    std::string string_format(const std::string &fmt, ...);
    bool _write(UObject* addr, void *buffer, int len);
    template<typename T> void Write(UObject* address, T data);

    ImU32 FloatColorsToImU32(const float colors[4]);
    FLinearColor GetRainbowLinearColor(float CycleTimeSeconds, float alpha);
    
    bool containsIgnoreCase(const std::string& str1, const std::string& str2);
};


#endif // BASEUTILS_H
