//
//  WaveFormHolderView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WaveFormView.h"
#import "WaveFormOverlayView.h"

@interface WaveFormHolderView : UIView

@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) WaveFormOverlayView * waveFormOverlayView;

- (void)setNumOfSamplesToDraw:(float)num;

- (void)setPanXValueReadOut:(NSString *)str;
- (void)setPanYValueReadOut:(NSString *)str;

- (void)setPanXPosition:(float)position;
- (void)setPanYPosition:(float)position;
@end
