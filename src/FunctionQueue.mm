//
//  FunctionQueue.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

#import <Foundation/Foundation.h>
#include "Includes.h"

std::queue<std::function<void()>> funcQueue;

void FunctionQueue::AddFunction(std::function<void()> func)
{
    funcQueue.push(func);
}
 
void FunctionQueue::ExecuteQueue()
{
    while (!funcQueue.empty()) {
        auto func = funcQueue.front();
        funcQueue.pop();
        func();
    }
}

