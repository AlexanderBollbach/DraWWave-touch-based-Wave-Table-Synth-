//
//  SampleMode.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "SampleMode.h"

@implementation SampleMode

-(void)setActiveParamValue:(UIPanGestureRecognizer *)pan andView:(UIView *)view {
   [super setActiveParamValue:pan andView:view];
   
   
   
   if ([self.activeParameter isEqual:self.param1]) {
      int panScale = 100;
      float value = [pan velocityInView:view].x / panScale;
      
      
      self.activeParameter.value += value;
   }
   
 
   
   if ([self.activeParameter isEqual:self.param2]) {
      int panScale = 100;
      float value = [pan velocityInView:view].x / panScale;
      
      
      self.activeParameter.value += value;
   }
   
   
   
   // special case: 3rd param adjusts 1st & 2nd param
 
   if ([self.activeParameter isEqual:self.param3]) {
      int panScale = 100;
      float value = [pan velocityInView:view].x / panScale;
      self.activeParameter.value = value;

      self.param1.value += self.param3.value;
      self.param2.value += self.param3.value;
   }
   
}




@end
