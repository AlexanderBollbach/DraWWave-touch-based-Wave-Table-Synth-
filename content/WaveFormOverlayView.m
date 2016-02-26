//
//  WaveFormView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/14/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormOverlayView.h"
#import "functions.h"
#import "AudioController.h"
#import "Global.h"

@implementation WaveFormOverlayView
- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      self.opaque = NO;
      self.clearsContextBeforeDrawing = YES;
      self.userInteractionEnabled = NO;
      self.backgroundColor = [UIColor clearColor];
   }
   return self;
}


- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   UIBezierPath * pathS = [UIBezierPath bezierPath];
   UIBezierPath * pathE = [UIBezierPath bezierPath];

   float h = CGRectGetHeight(self.bounds);
   int outStart = (int)[Global sharedInstance].modeManager.mode1.param1.value;
   int outEnd = (int)[Global sharedInstance].modeManager.mode1.param2.value;
  
   
   [[UIColor colorWithRed:0 green:1 blue:1 alpha:0.1] setFill];
   UIRectFill(CGRectMake(outStart, 0.0, outEnd - outStart, CGRectGetHeight(self.bounds)));
   
   
   
   [pathS moveToPoint:CGPointMake(outStart, 0)];
   [pathS addLineToPoint:CGPointMake(outStart, h)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathS setLineWidth:1];
   [pathS stroke];

   
   [pathE moveToPoint:CGPointMake(outEnd, 0)];
   [pathE addLineToPoint:CGPointMake(outEnd, h)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathE setLineWidth:1];
   [pathE stroke];
   

   
}

@end
