//
//  Mode.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Mode.h"
#import "Global.h"

@implementation Mode

- (instancetype)init {
   if (self = [super init]) {
     
      self.param1 = [[Parameter alloc] init];
      self.param2 = [[Parameter alloc] init];
      self.param3 = [[Parameter alloc] init];


      self.allParameters = [NSMutableArray arrayWithObjects:self.param1,self.param2,self.param3, nil];
      
      [self setActiveParameterWithId:0];
      
      self.param1.value = -2;
      
   }
   return self;
}


- (BOOL)isParamActive:(int)paramIndex {
   
   Parameter *param = [self.allParameters objectAtIndex:paramIndex];
   
   if ([param isEqual:self.activeParameter]) {
      return YES;
   } else {
      return NO;
   }
}

- (Parameter *)getParameter:(int)paramId {
   return [self.allParameters objectAtIndex:paramId];
}


- (void)setActiveParamValue:(UIPanGestureRecognizer *)pan andView:(UIView *)view {
   
   
   [self.delegate parameterChanged:self.activeParameter.name withValue:self.activeParameter.value];
}


- (void)setActiveParameterWithId:(int)Id {
   self.activeParameter = [self.allParameters objectAtIndex:Id];
}

@end
