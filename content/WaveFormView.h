//
//  WaveFormView.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/14/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaveFormViewDelegate <NSObject>
- (void)didPanWithValue:(float)value;
- (void)waveFormViewPressed;

@end

@interface WaveFormView : UIView

@property float numOfSamplesToDraw;
@property (nonatomic,weak) id <WaveFormViewDelegate> delegate;
@property BOOL expanded;

- (void)setNumOfSamplesToDraw:(float)num;
- (void)setColorOnWaveForm:(float)value;
@end
