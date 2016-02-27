//
//  WaveFormHolderView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormHolderView.h"

@implementation WaveFormHolderView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}


- (void)setup {
   
   // self.clearsContextBeforeDrawing = YES;
   self.backgroundColor = [UIColor blackColor];
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:self.bounds];
   self.waveFormOverlayView = [[WaveFormOverlayView alloc] initWithFrame:self.bounds];
//   self.waveFormBackgroundView = [[WaveFormBackgroundView alloc] initWithFrame:self.bounds];
   
   
   [self addSubview:self.waveFormView];
   [self addSubview:self.waveFormOverlayView];
//   [self addSubview:self.waveFormBackgroundView];
   
   
   CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
   [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
   
   
}

-(void)layoutSubviews {
   self.waveFormView.frame = self.bounds;
   self.waveFormOverlayView.frame = self.bounds;
}

- (void)tick {
   [self setNeedsDisplay];
   [self.waveFormView setNeedsDisplay];
   [self.waveFormOverlayView setNeedsDisplay];
}

- (void)setNumOfSamplesToDraw:(float)num {
   self.waveFormView.numOfSamplesToDraw = num;
}


@end
