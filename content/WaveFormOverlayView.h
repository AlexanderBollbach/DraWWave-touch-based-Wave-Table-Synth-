//
//  WaveFormOverlay.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveFormOverlayView : UIView

@property (nonatomic) float xPosition;
@property (nonatomic) float yPosition;

@property (nonatomic,strong) NSString * panXValReadOut;
@property (nonatomic,strong) NSString * panYValReadOut;


- (void)setPanXValueReadOut:(NSString *)str;
- (void)setPanYValueReadOut:(NSString *)str;

- (void)setPanXPosition:(float)position;
- (void)setPanYPosition:(float)position;


@end
