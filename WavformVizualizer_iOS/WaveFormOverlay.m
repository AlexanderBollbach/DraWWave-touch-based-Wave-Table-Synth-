//
//  WaveFormView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/14/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormOverlay.h"
#import "functions.h"
#import "MicController.h"


@implementation WaveFormOverlay {
   
   
   
   UIBezierPath * path;
   MicController *mc;
  
   
   int * samples;

   int * idx;
}

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      
      //   alexRingBuffer = [AlexRingBuffer sharedInstance];
      
      self.backgroundColor = [UIColor clearColor];
      self.clearsContextBeforeDrawing = YES;
      
      path = [UIBezierPath bezierPath];
      
      self.userInteractionEnabled = NO;
      idx = [[MicController sharedInstance] getsamplesIndex];
      
      samples = [[MicController sharedInstance] getsamplesSize];

   }
   return self;
}


- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   
   path = [UIBezierPath bezierPath];
   

   int s = alexMap(*idx, 0, *samples, 0, CGRectGetWidth(self.bounds));
   
   [path moveToPoint:CGPointMake(s,0)];
   [path addLineToPoint:CGPointMake(s,CGRectGetHeight(self.bounds))];
   
   
   [[UIColor whiteColor] set];
   [path setLineWidth:1];
   [path stroke];
   
   
   
}

@end
