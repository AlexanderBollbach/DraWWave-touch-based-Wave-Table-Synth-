//
//  Mode.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ModeManager.h"


@implementation ModeManager

- (instancetype)init {
   if (self = [super init]) {
      
      self.mode1 = [[SampleMode alloc] init];
      self.mode1.name = @"sample";
      self.mode1.delegate = self;
      self.mode1.param1.name = @"start";
      self.mode1.param2.name = @"end";
      self.mode1.param3.name = @"scan";

      
      self.mode2 = [[LFOMode alloc] init];
      self.mode2.name = @"LFO";
      self.mode2.param1.name = @"rate";
      self.mode2.param2.name = @"amount";
      self.mode2.param3.name = @"---";
      self.mode2.delegate = self;
      
      self.mode3 = [[CreateMode alloc] init];
      self.mode3.name = @"mode3";
      self.mode3.param1.name = @"param1";
      self.mode3.param2.name = @"param2";
      self.mode3.delegate = self;
      
      self.mode4 = [[Mode alloc] init];
      self.mode4.name = @"no mode";
      self.mode4.param1.name = @"---";
      self.mode4.param2.name = @"---";
      self.mode4.delegate = self;
      
      self.mode5 = [[Mode alloc] init];
      self.mode5.name = @"no mode";
      self.mode5.param1.name = @"---";
      self.mode5.param2.name = @"---";
      self.mode5.delegate = self;
      
      
      self.waveStart = [[Parameter alloc] init];
      self.waveStart.value = 0;
      self.waveStart.name = @"waveStart";
      
      self.waveEnd = [[Parameter alloc] init];
      self.waveEnd.value = 0;
      self.waveEnd.name = @"waveEnd";
      
      self.lfoRate = [[Parameter alloc] init];
      self.lfoRate.value = 0;
      self.lfoRate.name = @"lfoRate";
      
      self.lfoAmount = [[Parameter alloc] init];
      self.lfoAmount.value = 0;
      self.lfoAmount.name = @"lfoAmount";
      
      self.allModes = [NSMutableArray arrayWithObjects:self.mode1,self.mode2,self.mode3,self.mode4,self.mode5, nil];
      
      
      self.activeMode = self.mode1;
   }
   return self;
}

- (BOOL)isModeActive:(int)mode {
   Mode * theMode = [self.allModes objectAtIndex:mode];

   if ([theMode isEqual:self.activeMode]) {
      return YES;
   } else {
      return NO;
   }
}


- (NSString *)getNameForMode:(int)mode {
   Mode * theMode = [self.allModes objectAtIndex:mode];
   return theMode.name;
}

- (NSString *)getNameForParam:(int)paramId ofMode:(int)modeId {
   Mode * theMode = [self.allModes objectAtIndex:modeId];
   Parameter * theParam = [theMode getParameter:paramId];
   return theParam.name;
}


- (NSString *)getNameForActiveParam:(int)paramId {
   Parameter * theParam = [self.activeMode getParameter:paramId];
   return theParam.name;
}

- (void)setActiveModeWithId:(int)Id {
   self.activeMode = [self.allModes objectAtIndex:Id];
}


- (void)setActiveXParamValue:(float)value {
   self.activeXParam.value = value;
}

- (void)setActiveYParamValue:(float)value {
   self.activeYParam.value = value;
}

#pragma mark - mode delegate -

-(void)parameterChanged:(NSString *)parameter withValue:(float)value {
   [self.delegate parameterChangedWithName:parameter andValue:value];
}



@end
