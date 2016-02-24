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
#import "AlexRingBuffer.h"
#import "Global.h"

@implementation WaveFormView {
   
   
   //AlexRingBuffer * alexRingBuffer;
   
   UIBezierPath * path;
   
//   float * data;
   
   int startingSample; // 0 -- current sample count - 1
   
   
   float * sampleData;
}

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      
      
      
      self.clearsContextBeforeDrawing = YES;
      path = [UIBezierPath bezierPath];
      
      
      AudioController *mc = [AudioController sharedInstance];
      sampleData = [mc getsamplesBuffer];
      
   
   }
   return self;
}




- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   float w = CGRectGetWidth(self.bounds);
   
   path = [UIBezierPath bezierPath];
 
   sampleData = [[AudioController sharedInstance] getsamplesBuffer];

   
   for (int i = 0; i < w; i++) {
 
      int idx = alexMap(i, 0, w, 0,w);
      
      float f = sampleData[idx];
      float amplitude = alexMap(fabsf(f), 0, 1, 0, self.bounds.size.height);;
      
      [path moveToPoint:CGPointMake(i,CGRectGetHeight(self.bounds))];
      [path addLineToPoint:CGPointMake(i,CGRectGetHeight(self.bounds) - amplitude)];
   }
   
   [[UIColor redColor] set];
   [path setLineWidth:1];
   [path stroke];
}




@end
