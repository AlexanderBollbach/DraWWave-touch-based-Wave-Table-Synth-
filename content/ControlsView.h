//
//  ControlsViewB.h
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Types.h"

@protocol ControlsViewDelegate <NSObject>

- (void)connectionMadeFromGesture:(Gesture_t)gesture toParameter:(ParamSelected_t)parameter;
- (void)breakConnectionFor:(Gesture_t)gesture;
@end

@interface ControlsView : UIView

@property (nonatomic,weak) id<ControlsViewDelegate> delegate;

@end
