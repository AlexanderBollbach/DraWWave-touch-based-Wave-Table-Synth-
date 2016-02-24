//
//  MicController.h
//  WaveForm2
//
//  Created by alexanderbollbach on 2/11/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "functions.h"


@interface AudioController : NSObject
@property (nonatomic,assign) float amp;
@property (nonatomic,assign) AudioBufferList * inputBuffer;
@property (nonatomic,assign) AudioStreamBasicDescription streamFormat;

+ (instancetype)sharedInstance;
- (void)setBufferSizeFromMode:(int)mode;


//DSP settings // knob twiddling
- (void)setEffect1:(float)amount;
- (void)setEffect2:(float)amount;
- (void)setEffect3:(float)amount;
- (void)setEffect4:(float)amount;
- (void)setEffect5:(float)amount;

- (int *)getsamplesSize;
- (float *)getsamplesBuffer;
- (int*)getsamplesIndex;


@end
