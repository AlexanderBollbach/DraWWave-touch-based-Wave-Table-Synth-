//
//  WaveFormView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/14/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormView.h"
#import "functions.h"
#import "AudioController.h"

@implementation WaveFormView {

   UIBezierPath * path;
   float * sampleData;
}

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {

      self.backgroundColor = [UIColor blackColor];
      self.clearsContextBeforeDrawing = YES;
      path = [UIBezierPath bezierPath];
      
      CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
      [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
      
   }
   return self;
}


- (void)tick {
   [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   float w = CGRectGetWidth(self.bounds);
   
   path = [UIBezierPath bezierPath];
 
   sampleData = [[AudioController sharedInstance] getsamplesBuffer];

   
   for (int i = 0; i < w; i++) {
 
      int idx = alexMap(i, 0, w, 0, self.numOfSamplesToDraw);
      
      float f = sampleData[idx];
      
      float amplitude = alexMap(f, -1, 1, 0, self.bounds.size.height);;
      
      [path moveToPoint:CGPointMake(i,CGRectGetHeight(self.bounds))];
      [path addLineToPoint:CGPointMake(i,CGRectGetHeight(self.bounds) - amplitude)];
   }
   
   [[UIColor colorWithRed:0.8 green:0.2 blue:0.4 alpha:0.5] set];
   [path setLineWidth:1];
   [path stroke];
}

- (void)setNumOfSamplesToDrawValue:(float)value {
   self.numOfSamplesToDraw = value;
}


@end
