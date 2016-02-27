//
//  KaossControlView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KaossControlView.h"

@interface KaossControlView()

@property float xPosition;
@property float yPosition;

@property (nonatomic,strong) NSString * xReadOut;
@property (nonatomic,strong) NSString * yReadOut;

@end

@implementation KaossControlView

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
   
   
   self.xReadOut = @"test x";
   self.yReadOut = @"test y";
}


- (void)pan:(UIPanGestureRecognizer *)pan {
   
   float xPanVal = [pan locationInView:self].x;
   [self.delegate kaossChangedWithElement:self.elementX andValue:xPanVal];
   
   float yPanVal = [pan locationInView:self].y;
   [self.delegate kaossChangedWithElement:self.elementY andValue:xPanVal];
   
   self.xPosition = xPanVal;
   self.yPosition = yPanVal;
   
   [self setNeedsDisplay];
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
   
   //string
   NSDictionary * textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName : [UIColor blackColor],
                                     NSBackgroundColorAttributeName : [UIColor whiteColor]};
   
   NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
   drawingContext.minimumScaleFactor = 1;
   
   CGRect panXStrRect = CGRectMake(self.xPosition + 2, CGRectGetHeight(self.bounds) * 0.9, 75, 15);
   [self.xReadOut drawWithRect:panXStrRect
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:textAttributes
                             context:drawingContext];
   
   
   
   CGRect panYStrRect = CGRectMake(w - 50, self.yPosition + 2, 75, 15);
   [self.yReadOut drawWithRect:panYStrRect
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:textAttributes
                             context:drawingContext];
}


@end
