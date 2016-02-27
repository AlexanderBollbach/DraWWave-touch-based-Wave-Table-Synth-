//
//  KaossManager.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KaossConnectionManager.h"

@implementation KaossConnectionManager


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





-(void)kaossChangedWithElement:(kaossElement_t)kaossElement andValue:(float)value {
   
   
   switch (kaossElement) {
      case k_X1:
         
         break;
      case k_Y1:
         
         break;
      case k_X2:
         
         break;
      case k_Y2:
         
         break;
         
      default:
         break;
   }
   
}

@end
