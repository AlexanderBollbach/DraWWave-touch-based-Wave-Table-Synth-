//
//  KaossControlView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ControlPad.h"
#import "functions.h"
#import "KS_ConnectionManager.h"

@interface KS_ControlPad()

@property float xPosition;
@property float yPosition;

@property (nonatomic,strong) NSString * xReadOut;
@property (nonatomic,strong) NSString * yReadOut;

@end

@implementation KS_ControlPad

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}

- (void)setup {
   
   self.delegate = [KS_ConnectionManager sharedInstance];
   
   self.backgroundColor = [UIColor clearColor];
   self.clearsContextBeforeDrawing = YES;
   
   UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self addGestureRecognizer:pan];
   
   
   self.xReadOut = @"test x";
   self.yReadOut = @"test y";
}

// sends values of 0-100 along with element that sent them to connection manager
- (void)pan:(UIPanGestureRecognizer *)pan {
   
   float xPanVal = [pan locationInView:self].x;
   self.xPosition = xPanVal;

   xPanVal = alexMap(xPanVal, 0, CGRectGetWidth(self.bounds), 0, 100);
   
   [self.delegate ks_ChangedWithElement:self.elementX andValue:xPanVal];
   
   float yPanVal = [pan locationInView:self].y;
   self.yPosition = yPanVal;

   yPanVal = alexMap(yPanVal, 0, CGRectGetHeight(self.bounds), 0, 100);

   [self.delegate ks_ChangedWithElement:self.elementY andValue:xPanVal];
   

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
