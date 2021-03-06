//
//  ControlPadMatrixView.h
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlPadMatrixViewDelegate <NSObject>

- (void)elementXChangedWithValue:(float)value;
- (void)elementYChangedWithValue:(float)value;

@end

@interface ControlPadMatrixView : UIView

@property (nonatomic,weak) id <ControlPadMatrixViewDelegate> delegate;

@end
