//
//  Parameter.h
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Types.h"

@interface Gesture : NSObject

@property (nonatomic) ParamSelected_t controlledParameter;
@property (nonatomic) Gesture_t gesture;

@property (nonatomic) float value;
@property BOOL isAttached;

- (void)setParamValue:(float)value;

@end