//
//  BedIcon.h
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/8/23.
//

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#ifndef BedIcon_h 
#define BedIcon_h


@interface BedIcon : UIButton

@property (nonatomic, assign) UInt32 BedID;
 
- (void)buttonClicked;
- (void)AddMethod;
- (void)move:(float)x y:(float)y;
- (void)SetSleepingBag;
- (void)SetSimpleBed;
- (void)SetElegantBed;
- (void)SetBunkBed;
- (void)SetSleepingPod;

@end

@interface TransferButton : UIButton

@property (nonatomic, assign) UObject* Pointer;

- (void)AddMethod;
- (void)move:(float)x y:(float)y;

@end

@interface StealButton : UIButton

@property (nonatomic, assign) UObject* Pointer;

- (void)AddMethod;
- (void)move:(float)x y:(float)y;

@end


#endif /* BedIcon_h */
