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



- (float *)getsamplesBuffer;
- (int *)getsamplesIndex;


//- (void)setWaveStartValue:(float)value;
- (void)setSamplesDurationValue:(float)value;
- (void)setLfoRateValue:(float)value;
- (void)setLfoAmountValue:(float)value;


- (OSStatus)setReverbAmount:(float)amount;


@end
