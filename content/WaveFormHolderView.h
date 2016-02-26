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
#import "WaveFormBackgroundView.h"

@interface WaveFormHolderView : UIView

@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) WaveFormOverlayView * waveFormOverlayView;
@property (nonatomic,strong) WaveFormBackgroundView * waveFormBackgroundView;

@end
