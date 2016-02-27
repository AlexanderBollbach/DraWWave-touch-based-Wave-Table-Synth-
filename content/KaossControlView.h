//
//  KaossControlView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kaossTypes.h"

@protocol KaossControlViewDelegate <NSObject>
- (void)kaossChangedWithElement:(kaossElement_t)kaossElement andValue:(float)value;
@end

@interface KaossControlView : UIView

@property (nonatomic,weak) id <KaossControlViewDelegate> delegate;

@property kaossElement_t elementX;
@property kaossElement_t elementY;

@end
