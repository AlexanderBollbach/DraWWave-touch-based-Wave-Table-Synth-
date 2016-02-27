//
//  KaossControlView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"

@class KS_ControlPad;

@protocol KS_ControlPadDelegate <NSObject>
//- (void)changedWithElement:(KS_Element_t)element andValue:(float)value;
- (void)changedWithParameter:(KS_Parameter_t)parameter andValue:(float)value;
@end

@interface KS_ControlPad : UIView

@property (nonatomic,weak) id <KS_ControlPadDelegate> delegate;

@property KS_Element_t elementX;
@property KS_Element_t elementY;

- (void)setXreadOutWithString:(NSString *)string;
- (void)setYreadOutWithString:(NSString *)string;

@end

