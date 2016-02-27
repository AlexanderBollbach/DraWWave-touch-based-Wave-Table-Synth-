//
//  KS_TypesAndHelpers.m
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_TypesAndHelpers.h"

@implementation KS_TypesAndHelpers


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
      [self setup];
   }
   return self;
}


- (void)setup {
   
   
   
   
   
}



- (NSString *)getNameFromKS_Parameter:(KS_Parameter_t)parameter {
   
   switch (parameter) {
      case KS_samplesDurationLong:
         return @"samples long";
         break;
      case KS_samplesDuration:
         return @"samples short";
         break;
      case KS_lfoRate:
         return @"lfo rate";
         break;
      case KS_lfoAmount:
         return @"lfo amount";
         break;
      case KS_reverbAmount:
         return @"reverb amount";
         break;
      case KS_blank2:
         return @"blank2";
         break;
         
      default:
         break;
   }
   
}



@end
