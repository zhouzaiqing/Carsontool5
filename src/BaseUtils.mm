//
//  GameOffsets.m
//  BaseMenu
//
//  Created by Carson Mobile on 4/10/23.
//
//#include "BaseUtils.h"
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#include "Includes.h"





bool BaseUtils::isValidAdress(long Adress){
    return Adress > 0x100000000 && Adress < 0x5000000000;
}

bool BaseUtils::isValidAdress(UObject* Adress){
    return (long)Adress > 0x100000000 && (long)Adress < 0x5000000000;
}


bool BaseUtils::isObject(long UObject){
    if(!isValidAdress(UObject)) return false;
    if(!isValidAdress(Read<long>(UObject))) return false;
    int ObjectIndex = Read<int>(UObject + 0x18);
    if(ObjectIndex < 100 || ObjectIndex > 300000) return false;
    return true;
    
}

bool BaseUtils::_read(long addr, void *buffer, int len)
{
    if (!isValidAdress(addr)) return false;
    vm_size_t size = 0;
    kern_return_t error = vm_read_overwrite(mach_task_self(), (vm_address_t)addr, len, (vm_address_t)buffer, &size);
    if(error != KERN_SUCCESS || size != len)
    {
        return false;
    }
    return true;
}

template Vector3 BaseUtils::Read<Vector3>(long address);
template float BaseUtils::Read<float>(long address);
template int BaseUtils::Read<int>(long address);
template bool BaseUtils::Read<bool>(long address);
template long BaseUtils::Read<long>(long address);
template uint32_t BaseUtils::Read<uint32_t>(long address);
template FRotator BaseUtils::Read<FRotator>(long address);
template UObject* BaseUtils::Read<UObject*>(long address);

template<typename T> T BaseUtils::Read(long address) {
    T data;
    _read(address, reinterpret_cast<void *>(&data), sizeof(T));
    return data;
}



template uint8_t BaseUtils::Read<uint8_t>(UObject* address);
template uint32_t BaseUtils::Read<uint32_t>(UObject* address);
template UObject* BaseUtils::Read<UObject*>(UObject* address);
template UObject** BaseUtils::Read<UObject**>(UObject* address);
template Vector3 BaseUtils::Read<Vector3>(UObject* address);
template FLinearColor BaseUtils::Read<FLinearColor>(UObject* address);
template int BaseUtils::Read<int>(UObject* address);
template bool BaseUtils::Read<bool>(UObject* address);
template long BaseUtils::Read<long>(UObject* address);
template double BaseUtils::Read<double>(UObject* address);
template float BaseUtils::Read<float>(UObject* address);
template FRotator BaseUtils::Read<FRotator>(UObject* address);
template TArray<UObject*> BaseUtils::Read<TArray<UObject*>>(UObject* address);
template EPrimalEquipmentType BaseUtils::Read<EPrimalEquipmentType>(UObject* address);
template EPrimalItemType BaseUtils::Read<EPrimalItemType>(UObject* address);
template uint16_t BaseUtils::Read<uint16_t>(UObject* address);
template EChatChannel BaseUtils::Read<EChatChannel>(UObject* address);
template TArray<FColorDefinition> BaseUtils::Read<TArray<FColorDefinition>>(UObject* address);
template TArray<FSkeletalMaterial> BaseUtils::Read<TArray<FSkeletalMaterial>>(UObject* address);
template TArray<FVectorParameterValue> BaseUtils::Read<TArray<FVectorParameterValue>>(UObject* address);
template TArray<FFontParameterValue> BaseUtils::Read<TArray<FFontParameterValue>>(UObject* address);
template TArray<FScalarParameterValue> BaseUtils::Read<TArray<FScalarParameterValue>>(UObject* address);
template TArray<FTextureParameterValue> BaseUtils::Read<TArray<FTextureParameterValue>>(UObject* address);
template TArray<UClassPointer> BaseUtils::Read<TArray<UClassPointer>>(UObject* address);
template EArmorQuality BaseUtils::Read<EArmorQuality>(UObject* address);
template FQuat BaseUtils::Read<FQuat>(UObject* address);
template TArray<GameFTransform> BaseUtils::Read<TArray<GameFTransform>>(UObject* address);
template TArray<FChatEntry> BaseUtils::Read<TArray<FChatEntry>>(UObject* address);
template TArray<FTamedDinoEntry> BaseUtils::Read<TArray<FTamedDinoEntry>>(UObject* address);



template<typename T> T BaseUtils::Read(UObject* address) {
    return Read<T>((long)address);
}


void BaseUtils::DefineRead(long address){
    auto var = Read<uint8_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint16_t>(address);
    var = Read<uint64_t>(address);
    var = Read<long>(address);
    var = Read<float>(address);
    var = Read<int>(address);
    var = Read<double>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    var = Read<uint32_t>(address);
    Vector3 myVec = Read<Vector3>(address);
}
long BaseUtils::getOffset(long offset){
    return (long)_dyld_get_image_header(0) + offset;
}
Vector2 BaseUtils::ScaleVector(Vector2 InVec, Vector2 Scale){
    return {InVec.X * Scale.X, InVec.Y * Scale.Y};
}
float BaseUtils::GetDistance(Vector3 To, Vector3 From){
    
    float DistanceX = (To.X - From.X)/100;
    float DistanceY = (To.Y - From.Y)/100;
    float DistanceZ = (To.Z - From.Z)/100;
    float sqDistnace = (DistanceZ * DistanceZ) + (DistanceX * DistanceX) + (DistanceY * DistanceY);
    return sqrt(sqDistnace);
}
float BaseUtils::GetScreenDistance(Vector2 To, Vector2 From){
    float DistanceX = To.X - From.X;
    float DistanceY = To.Y - From.Y;
    float sqDistance = (DistanceX * DistanceX) + (DistanceY * DistanceY);
    return sqrt(sqDistance);
}

void BaseUtils::WriteToEndOfFile(NSString *Content, NSString *FileName){
    NSString* content = [NSString stringWithFormat:@"%@\n",Content];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:FileName];

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
    }
}

UIViewController* BaseUtils::currentTopViewControllerFn() {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

std::chrono::steady_clock::time_point first_tp;
unsigned long frame_count = 0;

std::chrono::duration<double> uptime()
{
    if (first_tp == std::chrono::steady_clock::time_point{})
        return std::chrono::duration<double>{ 0 };

    return std::chrono::steady_clock::now() - first_tp;
}

double fps()
{
    const double uptime_sec = uptime().count();

    if (uptime_sec == 0)
        return 0;

    return frame_count / uptime_sec;
}
void BaseUtils::Frame(){
    static bool onetime = true;
    if(onetime){
        first_tp = std::chrono::steady_clock::now();
        onetime = false;
    }
    
    frame_count++;
}
int BaseUtils::GetFPS(){
    return (int)fps();
}

std::string BaseUtils::string_format(const std::string &fmt, ...) {
    std::vector<char> str(100,'\0');
    va_list ap;
    while (1) {
        va_start(ap, fmt);
        auto n = vsnprintf(str.data(), str.size(), fmt.c_str(), ap);
        va_end(ap);
        if ((n > -1) && (size_t(n) < str.size())) {
            return str.data();
        }
        if (n > -1)
            str.resize( n + 1 );
        else
            str.resize( str.size() * 2);
    }
    return str.data();
}


bool BaseUtils::_write(UObject* addr, void *buffer, int len)
{
    if (!isValidAdress(addr)) return false;
    kern_return_t error = vm_write(mach_task_self(), (vm_address_t)addr, (vm_offset_t)buffer, (mach_msg_type_number_t)len);
    if(error != KERN_SUCCESS)
    {
        return false;
    }
    return true;
}
//template Vector3 BaseUtils::Read<Vector3>(long address);
template<> void BaseUtils::Write<float>(UObject* address, float data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(float));
}
template<> void BaseUtils::Write<bool>(UObject* address, bool data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(bool));
}
template<> void BaseUtils::Write<uint8_t>(UObject* address, uint8_t data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(uint8_t));
}
template<> void BaseUtils::Write<uint16_t>(UObject* address, uint16_t data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(uint16_t));
}
template<> void BaseUtils::Write<FQuat>(UObject* address, FQuat data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(FQuat));
}
template<> void BaseUtils::Write<int>(UObject* address, int data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(int));
}
template<> void BaseUtils::Write<long>(UObject* address, long data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(long));
}
template<> void BaseUtils::Write<UObject*>(UObject* address, UObject* data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(UObject*));
}
template<> void BaseUtils::Write<FLinearColor>(UObject* address, FLinearColor data) {
    _write(address, reinterpret_cast<void*>(&data), sizeof(FLinearColor));
}


template<typename T> void BaseUtils::Write(UObject* address, T data) {
    _write(address, reinterpret_cast<void *>(&data), sizeof(T));
}


ImU32 BaseUtils::FloatColorsToImU32(const float colors[4]) {
    ImVec4 color(colors[0], colors[1], colors[2], colors[3]);
    return ImGui::ColorConvertFloat4ToU32(color);
}

FLinearColor BaseUtils::GetRainbowLinearColor(float CycleTimeSeconds, float alpha){ 
    // Get current time in milliseconds
    struct timeval currentTime;
    gettimeofday(&currentTime, NULL);
    long currentTimeInMs = currentTime.tv_sec * 1000 + currentTime.tv_usec / 1000;

    double TimeInSeconds = ((double)currentTimeInMs) / 1000;
    double timeFraction = fmod((double)TimeInSeconds, CycleTimeSeconds) / CycleTimeSeconds;

    // Calculate the RGB values based on the time fraction
    double red = 0.0, green = 0.0, blue = 0.0;
    if (timeFraction < 1.0/6.0) {
        red = 1.0;
        green = timeFraction * 6.0;
    } else if (timeFraction < 2.0/6.0) {
        red = (2.0/6.0 - timeFraction) * 6.0;
        green = 1.0;
    } else if (timeFraction < 3.0/6.0) {
        green = 1.0;
        blue = (timeFraction - 2.0/6.0) * 6.0;
    } else if (timeFraction < 4.0/6.0) {
        green = (4.0/6.0 - timeFraction) * 6.0;
        blue = 1.0;
    } else if (timeFraction < 5.0/6.0) {
        red = (timeFraction - 4.0/6.0) * 6.0;
        blue = 1.0;
    } else {
        red = 1.0;
        blue = (6.0/6.0 - timeFraction) * 6.0;
    }

    FLinearColor retCol = {(float)red, (float)blue, (float)green, alpha};
    return retCol;
}
bool BaseUtils::containsIgnoreCase(const std::string& str1, const std::string& str2) {
    std::string str1_lower, str2_lower;
    str1_lower.resize(str1.size());
    str2_lower.resize(str2.size());
    
    // Convert both strings to lowercase
    std::transform(str1.begin(), str1.end(), str1_lower.begin(), [](unsigned char c){ return std::tolower(c); });
    std::transform(str2.begin(), str2.end(), str2_lower.begin(), [](unsigned char c){ return std::tolower(c); });
    
    // Check if str1_lower contains str2_lower
    return str1_lower.find(str2_lower) != std::string::npos;
}
