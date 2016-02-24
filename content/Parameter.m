//
//  Parameter.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Parameter.h"

@implementation Parameter : NSObject 


- (instancetype)init {
   if (self = [super init]) {
      self.name = @"someParam";
      self.value = 0;
   }
   return self;
}

@end
