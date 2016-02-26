//
//  Mode3.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "LFOMode.h"

@implementation LFOMode




-(void)setActiveParamValue:(UIPanGestureRecognizer *)pan andView:(UIView *)view {
   
   [super setActiveParamValue:pan andView:view];
   
   int panScale = 100;
   float value = [pan velocityInView:view].x / panScale;
   
   
   self.activeParameter.value += value;
   
   
   
}


@end
