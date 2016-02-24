//
//  AlexRingBuffer.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/17/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "AlexRingBuffer.h"
#import "RingBuff_t.h"

@implementation AlexRingBuffer {
   ringBuf_t theRingBuffer;
}

+ (instancetype)sharedInstance {
   static dispatch_once_t once;
   static id sharedInstance;
   dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
   });
   return sharedInstance;
}

- (instancetype)init {
   if (self = [super init]) {
      ringBufS_init(&theRingBuffer);
   }
   return self;
}


- (void)putFloat:(float)c {
   ringBufS_put(&theRingBuffer, c);
}


- (void)flush {
   ringBufS_flush(&theRingBuffer, 0);
}

- (float)getFloat {
  return ringBufS_get(&theRingBuffer);
}


@end
