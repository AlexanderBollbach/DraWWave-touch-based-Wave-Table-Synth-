//
//  CreateMode.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "CreateMode.h"
#import "Draw_Helper.h"

@implementation CreateMode



-(void)setActiveParamValue:(UIPanGestureRecognizer *)pan andView:(UIView *)view {
   [super setActiveParamValue:pan andView:view];
   
   
   
   CGPoint point = [pan locationInView:view];
   BOOL direction = [pan velocityInView:view].x > 0;

   if (pan.state == UIGestureRecognizerStateEnded) {
      [[Draw_Helper sharedInstance] reset];
      return;
   }
   
   
   if (self.activeParameter == self.param1) { // draw param
      
      
               Draw_Helper * d = [Draw_Helper sharedInstance];
      
               [d pushPoint:point withDirection:direction];
   
   }
   
   if (self.activeParameter == self.param2) { // clear param
      
   }

   
   
}




@end
