//
//  ParameterView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"

@interface Param_Gesture_View : UIView

@property (nonatomic,strong) UILabel * name;
@property (nonatomic) ParamSelected_t paramType;
@property (nonatomic) Gesture_t gestureType;
@property BOOL isGesture;

- (void)animate:(BOOL)animate;

@end
