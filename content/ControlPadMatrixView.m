//
//  ControlPadMatrixView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlPadMatrixView.h"
#import "functions.h"

@interface ControlPadMatrixView()

@property float xPosition;
@property float yPosition;

@end

@implementation ControlPadMatrixView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}



- (void)setup {
   
   self.backgroundColor = [UIColor blackColor];
   self.clearsContextBeforeDrawing = YES;
   
   UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self addGestureRecognizer:pan];
 
   
   [self setNeedsDisplay];

}




- (void)pan:(UIPanGestureRecognizer *)pan {
   
   if ([pan locationInView:self].x > CGRectGetWidth(self.bounds)) {
      // so left controlpad does not go off to second control pad
      return;
   }
   
   float xPanVal = [pan locationInView:self].x;
   self.xPosition = xPanVal;
   
   xPanVal = alexMap(xPanVal, 0, CGRectGetWidth(self.bounds), 0, 100);
   [self.delegate elementXChangedWithValue:xPanVal];
   
   float yPanVal = [pan locationInView:self].y;
   self.yPosition = yPanVal;
   
   yPanVal = alexMap(yPanVal, 0, CGRectGetHeight(self.bounds), 0, 100);
   [self.delegate elementYChangedWithValue:yPanVal];
   
   
   [self setNeedsDisplay];
}

- (void)layoutSubviews {
   
   self.xPosition = CGRectGetWidth(self.bounds) / 2;
   self.yPosition = CGRectGetHeight(self.bounds) / 2;
}

- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   
   UIBezierPath * pathS = [UIBezierPath bezierPath];
   UIBezierPath * pathE = [UIBezierPath bezierPath];
   
   float w = CGRectGetWidth(self.bounds);
   float h = CGRectGetHeight(self.bounds);

   // start
   [pathS moveToPoint:CGPointMake(self.xPosition, 0)];
   [pathS addLineToPoint:CGPointMake(self.xPosition, h)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathS setLineWidth:2];
   [pathS stroke];
   
   // end
   [pathE moveToPoint:CGPointMake(0, self.yPosition)];
   [pathE addLineToPoint:CGPointMake(w, self.yPosition)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathE setLineWidth:1];
   [pathE stroke];

}
@end
