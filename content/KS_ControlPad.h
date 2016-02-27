//
//  KaossControlView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kaossTypes.h"

@protocol KS_ControlPadDelegate <NSObject>
- (void)ks_ChangedWithElement:(KS_Element_t)element andValue:(float)value;
@end

@interface KS_ControlPad : UIView

@property (nonatomic,weak) id <KS_ControlPadDelegate> delegate;

@property KS_Element_t elementX;
@property KS_Element_t elementY;

@end
