//
//  CV_lineDrawer.m
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "CV_lineDrawer.h"

@implementation CV_lineDrawer


- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      
      self.clearsContextBeforeDrawing = YES;
      self.backgroundColor = [UIColor clearColor];
      self.userInteractionEnabled = NO;
   }
   return self;
}

- (void)drawRect:(CGRect)rect {

   if (self.stopDrawing) {
      return;
   }
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   CGContextMoveToPoint(context, self.chosenGesturePoint.x,self.chosenGesturePoint.y);
   
   
   CGContextSetLineWidth(context, 1.0f);
   
   CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
   
   [[UIColor whiteColor] setStroke];
   CGContextDrawPath(context,kCGPathFillStroke);
   
}


@end
