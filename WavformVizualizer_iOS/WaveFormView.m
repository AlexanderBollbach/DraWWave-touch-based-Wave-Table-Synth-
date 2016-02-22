//
//  WaveFormView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/14/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormView.h"
#import "functions.h"
#import "MicController.h"
#import "AlexRingBuffer.h"
#import "Global.h"

@implementation WaveFormView {
   
   
   //AlexRingBuffer * alexRingBuffer;
   
   UIBezierPath * path;
   
//   float * data;
   
   int startingSample; // 0 -- current sample count - 1
   
   
   float * sampleData;
   int * samples;
}

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      
      
      self.backgroundColor = [UIColor blackColor];
      self.clearsContextBeforeDrawing = YES;
      
      path = [UIBezierPath bezierPath];
      
      
      
      MicController *mc = [MicController sharedInstance];

      sampleData = [mc getsamplesBuffer];
      samples = [mc getsamplesSize];
      
      startingSample = [Global sharedInstance].startingSample;
   
   }
   return self;
}




- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   float w = CGRectGetWidth(self.bounds);
   
   path = [UIBezierPath bezierPath];
 
   startingSample = [Global sharedInstance].startingSample;

   int samplesOnScreen = [Global sharedInstance].samplesOnScreen;
   
   for (int i = 0; i < w; i++) {
 
      int outStart = startingSample;
      float outEnd = (samplesOnScreen + startingSample);
      int idx = alexMap(i, 0, w, outStart, outEnd);
      
      float f = *(sampleData + idx);
      float amplitude = alexMap(fabsf(f), 0, 1, 0, self.bounds.size.height);;
      
      [path moveToPoint:CGPointMake(i,CGRectGetHeight(self.bounds))];
      [path addLineToPoint:CGPointMake(i,CGRectGetHeight(self.bounds) - amplitude)];
   }
   [[UIColor redColor] set];
   [path setLineWidth:1];
   [path stroke];
}



//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   CGPoint point = [[touches anyObject] locationInView:self];
//   [[Global sharedInstance] writeSampleWithPoint:point];
//}
//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   CGPoint point = [[touches anyObject] locationInView:self];
//   [[Global sharedInstance] writeSampleWithPoint:point];
//}

@end
