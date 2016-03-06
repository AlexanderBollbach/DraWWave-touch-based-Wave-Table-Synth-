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

@interface WaveFormView()
@property (nonatomic,strong) UIColor * waveFormColor;
@end

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
      
      
      UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
      [self addGestureRecognizer:pan];
      
      
      UILongPressGestureRecognizer * lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lp:)];
      lp.minimumPressDuration = 0.4;
      [self addGestureRecognizer:lp];
      
      self.waveFormColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
   }
   return self;
}


- (void)pan:(UIPanGestureRecognizer *)pan {
   
   float value = [pan locationInView:self].x;
   
   if ([pan locationInView:self].y > CGRectGetHeight(self.bounds) / 2) {
      value *= 1000;
   }
   
   [self.delegate didPanWithValue:value];
   
}

- (void)lp:(UILongPressGestureRecognizer *)press {
   
   if (press.state == UIGestureRecognizerStateBegan) {
      [self.delegate waveFormViewPressed];
   }
}


- (void)tick {
   [self setNeedsDisplay];
}

- (void)setColorOnWaveForm:(float)value {
   value = alexMap(value, 0, 1, 0, 1);
   self.waveFormColor = [UIColor colorWithRed:0.8 green:0.2 blue:value alpha:1];
}


- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
   float w = CGRectGetWidth(self.bounds);
   
   path = [UIBezierPath bezierPath];
   
   sampleData = [[AudioController sharedInstance] PgetsamplesBuffer];
   
   for (int i = 0; i < w; i++) {
      
      int idx = alexMap(i, 0, w, 0, self.numOfSamplesToDraw);
      
      float f = sampleData[idx];
      
      float amplitude = alexMap(f, -1, 1, 0, self.bounds.size.height);;
      
      [path moveToPoint:CGPointMake(i,CGRectGetHeight(self.bounds))];
      [path addLineToPoint:CGPointMake(i,CGRectGetHeight(self.bounds) - amplitude)];
   }
   
   [self.waveFormColor set];
   [path setLineWidth:1];
   [path stroke];
}

- (void)setNumOfSamplesToDrawValue:(float)value {
   self.numOfSamplesToDraw = value;
}


@end
