//
//  Mode.h
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gesture.h"
#import "Types.h"

@protocol ParameterManagerDelegate <NSObject>
- (void)gestureChanged:(Gesture *)gesture withValue:(float)value;
@end

@interface ParameterManager : NSObject


@property (nonatomic,strong) id <ParameterManagerDelegate> delegate;

@property (nonatomic,strong) Gesture * waveStart;
@property (nonatomic,strong) Gesture * waveEnd;
@property (nonatomic,strong) Gesture * lfoAmount;
@property (nonatomic,strong) Gesture * lfoRate;

@property (nonatomic,strong) Gesture * dummyParam;


@property (nonatomic,strong) Gesture * gesture_PanX;
@property (nonatomic,strong) Gesture * gesture_PanY;

+ (instancetype)sharedInstance;

- (void)connectGesture:(Gesture_t)gesture toParameter:(ParamSelected_t)parameter;

- (void)setPanXParamValue:(float)value;
- (void)setPanYParamValue:(float)value;


- (void)unattach:(Gesture_t)gesture;

@end
