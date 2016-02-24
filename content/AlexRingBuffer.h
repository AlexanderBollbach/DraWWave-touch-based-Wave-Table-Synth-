//
//  AlexRingBuffer.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/17/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlexRingBuffer : NSObject

+ (instancetype)sharedInstance;

- (float)getFloat;
- (void)putFloat:(float)c;
- (void)flush;

@end
