//
//  GOD.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Global.h"
#import "functions.h"
#import "MicController.h"

@implementation Global

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
      self.startingSample = 0;
      self.samplesOnScreen = 500;
      
      [self addObserver:self forKeyPath:@"samplesOnScreen" options:0 context:nil];
      [self addObserver:self forKeyPath:@"startingSample" options:0 context:nil];
   }
   return self;
}


#pragma mark - KVO -

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  
   
   if ([keyPath isEqualToString:@"samplesOnScreen"]) {
      [self.delegate samplesOnScreenChanged];
   } else if ([keyPath isEqualToString:@"startingSample"]) {
      [self.delegate samplesOnScreenChanged];
   }
   
}

#pragma mark - editing audio model -

- (void)writeSampleWithPoint:(CGPoint)point {

   float screenWidth = [UIScreen mainScreen].bounds.size.width;
   float screenHeight = [UIScreen mainScreen].bounds.size.height;
   
   float xPos = point.x;
   float amp = alexMap(point.y, 0, screenHeight, 1, 0);

   int i = alexMap(xPos, 0, screenWidth, self.startingSample, self.startingSample + self.samplesOnScreen);
   
   float * buffer = [[MicController sharedInstance] getsamplesBuffer];
   
   buffer[i] = amp;
}




@end
