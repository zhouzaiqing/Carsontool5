#line 1 "/Users/carsonmobile/Desktop/XCTests/simplemnkydevimgui/mnkydevtest2Dylib/Logos/mnkydevtest2Dylib.xm"
#import "mnkydevtest2Dylib.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include "../KittyMemory/imgui.h"
#include "../KittyMemory/imgui_internal.h"
#include "../KittyMemory/imgui_impl_metal.h"
#import <Foundation/Foundation.h>
#import <os/log.h>
#include <vector>
#import <dlfcn.h>
#include <map>
#include <substrate.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

#include <unistd.h>
#include <string.h>
#include <pthread.h>

#include "../src/Includes.h"
#include "PubgLoad.h"



#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale





@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;

@end
@implementation ImGuiDrawView

static bool MenDeal = true;
/*
 ImGuiIO & io = ImGui::GetIO();
     ImFontConfig config;
     config.FontDataOwnedByAtlas = false;

     static ImWchar ranges[] = { 0x1, 0xFFFF, 0};
     NSString *MainFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"ESPFont.otf"];
     _espFont = io.Fonts->AddFontFromFileTTF(MainFont.UTF8String, 20.f, &config, ranges);
 */

/*
 ImFontConfig config;
 config.FontDataOwnedByAtlas = false;

 io.Fonts->Clear(); // clear fonts if you loaded some before (even if only default one was loaded)
 
 static ImWchar ranges[] = { 0x1, 0xFFFF, 0};
 NSString *MainFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"HansSerifBold.otf"];
 io.Fonts->AddFontFromFileTTF(MainFont.UTF8String, 16.f, NULL, ranges);
 
 //static ImWchar ranges[] = { 0x1, 0xFFFF, 0};
 NSString *KoreanFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"ESPFont.otf"];
 

 static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_FA, 0 };
 ImFontConfig icons_config;
 icons_config.MergeMode = true;
 icons_config.PixelSnapH = true;
 icons_config.FontDataOwnedByAtlas = false;
 io.Fonts->AddFontFromFileTTF(KoreanFont.UTF8String, 16.f, &icons_config, io.Fonts->GetGlyphRangesKorean());
 io.Fonts->AddFontFromMemoryTTF((void*)fontAwesome, sizeof(fontAwesome), 16, &icons_config, icons_ranges);

 ImGui_ImplMetal_Init(_device);
 */
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui::StyleColorsDark();
    
    ImFontConfig config;
    config.FontDataOwnedByAtlas = false;

    io.Fonts->Clear(); // clear fonts if you loaded some before (even if only default one was loaded)
    
    static ImWchar ranges[] = { 0x1, 0xFFFF, 0};
    NSString *MainFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"HansSerifBold.otf"];
    io.Fonts->AddFontFromFileTTF(MainFont.UTF8String, 16.f, NULL, ranges);
    
    NSString *KoreanFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"ESPFont.otf"];

    ImFontConfig icons_config;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    icons_config.FontDataOwnedByAtlas = false;
    
    io.Fonts->AddFontFromFileTTF(KoreanFont.UTF8String, 16.f, &icons_config, io.Fonts->GetGlyphRangesKorean());
    io.Fonts->AddFontFromFileTTF(MainFont.UTF8String, 16.f, &icons_config, io.Fonts->GetGlyphRangesDefault());
    
    /*
    io.Fonts->Clear();
    
    static ImWchar ranges[] = { 0x1, 0xFFFF, 0};
    NSString *MainFont = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"HansSerifBold.otf"];
    io.Fonts->AddFontFromFileTTF(MainFont.UTF8String, 16.f, NULL, ranges);
    */
    ImGui_ImplMetal_Init(_device);

    return self;
}


+ (void)showChange:(BOOL)open {
    MenDeal = open;
}
+ (BOOL)isMenuShowing {
    return MenDeal;
}



- (MTKView *)mtkView {
    return (MTKView *)self.view;
}
 



- (void)loadView {
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
    
}


#pragma mark - Interaction




- (void)updateIOWithTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

 


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

static void SaveSettings(){
    static bool Timer = true;
    if(Timer){
        
        Timer = false;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 1)), dispatch_get_main_queue(), ^{
            Timer = true;
        });
        
        preferences.SaveDefaults();
        bedList.SaveServerBedList();
        menuStyle.SaveStyle();
        SetLanguage((ECurrentLanguage)LanguageValue);
        
        SpeedZeroSwitch.alpha = PVPSpeedZero ? 1.0f : 0.0f;
        AutoShootSwitch.alpha = (PVPAutoFire || AimlockToggleSwitch) ? 1.0f : 0.0f;
    }
    hideRecordTextfield.secureTextEntry = StreamerMode;
}

- (void)drawInMTKView:(MTKView*)view {
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;


    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];

        if (MenDeal == true)
        {
            [self.view setUserInteractionEnabled:YES];
            [self.view.superview setUserInteractionEnabled:YES];
            [menuTouchView setUserInteractionEnabled:YES];
        }
        else if (MenDeal == false)
        {
           
            [self.view setUserInteractionEnabled:NO];
            [self.view.superview setUserInteractionEnabled:NO];
            [menuTouchView setUserInteractionEnabled:NO];
        }
        
        
    
        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    
        misc.SlidersMain();
        SaveSettings();
    
        static bool Timer = true;
        if (renderPassDescriptor != nil && (Timer || MenuFPS == 120))
        {
            
            Timer = false;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC / MenuFPS)), dispatch_get_main_queue(), ^{
                Timer = true;
            });
            
            
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            ImFont* font = ImGui::GetFont();
            font->Scale = 10.f / font->FontSize;
            
            Minimap::getInstance().UpdateMinimap();
            
            if (MenDeal == true)
            {
                menu.DrawMainMenu();
            }
            
            
            hooks.StartHooks();
            crashBot.HandleCrashBot();
            esp.ESPMain();
            crosshair.DrawCrosshairOnScreen();
            dinoColors.ChangeDinoColor();
            weaponColor.ChangeWeaponColor();
            aimAssist.DrawAimlockCircles();
           
            
            /*
             What Causes the crash?
             
             1. Disable Everything Except Menu - No Dismount Crash
             2. Enable Hooks - Raft Crash
             3. Everything Except Hooks - Crash
             4. Sliders, Hooks, Crashbot, SaveSetttings Disabled - No Crash
             5. After changing the mounted dino function: Hooks, Crashbot, SaveSetttings Disabled - No Crash
             6. Appears to have been fixed by changing the mountedDino function
             Need to find out what tf exactly causes this shit omg
             
             
             Relog is causing a crash again.
             1. Disable StartHooks and SlidersMain - Still crashes when relog
             2. Disable everything except menuDraw and SaveSettings() - still Crashes. Unkown Reason.
             
             */
            ImDrawList* draw_list = ImGui::GetForegroundDrawList();

            
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
            
        }
        

        [commandBuffer commit];
          
}



- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {
    
}

@end
