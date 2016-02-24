//
//  GOD.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Global.h"
#import "functions.h"
#import "AudioController.h"

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

      
      self.modeManager = [[ModeManager alloc] init];
      self.modeManager.delegate = self;
      
      }
   return self;
}

#pragma mark - editing audio model -

//- (void)writeSampleWithPoint:(CGPoint)point {


//
//   int i = alexMap(xPos, 0, screenWidth, self.startingSampleOnScreen, self.startingSampleOnScreen + self.samplesOnScreen);
//   
//   float * buffer = [[AudioController sharedInstance] getsamplesBuffer];
//   
//   buffer[i] = amp;

//}





-(void)parameterChangedWithName:(NSString *)name andValue:(float)value {
   
   NSString * hudString = [NSString stringWithFormat:@"%@->%@ : %f", self.modeManager.activeMode.name,name, value];
   [self.delegate showOnHUDDisplay:hudString];
}

@end




