//
//  Parameter.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Gesture.h"

@implementation Gesture : NSObject 


- (instancetype)init {
   if (self = [super init]) {
      self.value = 0;
   }
   return self;
}


- (void)setParamValue:(float)value {
   
   
   self.value = value;
}



@end
