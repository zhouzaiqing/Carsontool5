//
//  MTKView+Interactive.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 6/26/23.
//

#import <Foundation/Foundation.h>
#import "MTKView+Interactive.h"
 
@implementation MTKView (Interactive)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event { 
    CGRect touchableArea = CGRectMake([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width - 200, 0, 200, 200); // Define the desired touchable area

    // Check if the touch point is within the touchable area
    if (CGRectContainsPoint(touchableArea, point)) {
        return [super pointInside:point withEvent:event];
    }

    return NO;
}

@end
