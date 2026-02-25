//
//  FunctionQueue.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/9/23.
//

class FunctionQueue{
public:
    static FunctionQueue& getInstance() {
        static FunctionQueue instance; // The single instance
        return instance;
    }
    void AddFunction(std::function<void()> func);
    void ExecuteQueue();
};
