//
//  CV_lineDrawer.m
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "CV_lineDrawer.h"

@interface CV_lineDrawer()
@property (nonatomic) float dashConstant1;
@end

@implementation CV_lineDrawer


- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      
      self.clearsContextBeforeDrawing = YES;
      self.backgroundColor = [UIColor clearColor];
      self.userInteractionEnabled = NO;
      
      self.dashConstant1 = 1;
      
      [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(time) userInfo:nil repeats:YES];
   }
   return self;
}

- (void)time {
   self.dashConstant1 -= 3;
   [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
   

   CGContextRef context = UIGraphicsGetCurrentContext();
   
   CGFloat val[2] = { 4,5 };
   CGContextSetLineDash(context, self.dashConstant1, val, 2);
   
   if (self.drawChoosingLine) {
      CGContextMoveToPoint(context, self.chosenGesturePoint.x,self.chosenGesturePoint.y);
      CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
   }
   
   if (self.xISConnected) {
      CGContextMoveToPoint(context, self.xFrom.x, self.xFrom.y);
      CGContextAddLineToPoint(context, self.xTo.x, self.xTo.y);
   }
   
   if (self.yISConnected) {
      CGContextMoveToPoint(context, self.yFrom.x, self.yFrom.y);
      CGContextAddLineToPoint(context, self.yTo.x, self.yTo.y);
   }
   
   
   CGContextSetLineWidth(context, 1.0f);
   [[UIColor whiteColor] setStroke];
   CGContextDrawPath(context,kCGPathFillStroke);
   
}


@end
