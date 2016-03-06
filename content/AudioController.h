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
#import "KS_TypesAndHelpers.h"


@protocol AudioControllerDelegate <NSObject>
- (void)waveFormChangedWithValue:(float)value;
@end

@interface AudioController : NSObject


@property (nonatomic,assign) float amp;
@property (nonatomic,assign) AudioBufferList * inputBuffer;
@property (nonatomic,assign) AudioStreamBasicDescription streamFormat;



+ (instancetype)sharedInstance;

@property (nonatomic,weak) id <AudioControllerDelegate> delegate;

- (float *)PgetsamplesBuffer;
- (float)PgetNumOfSamples;
- (void)PsetDuration:(float)value;

//- (void)PsetSamplesDurationValue:(float)value;




@end
