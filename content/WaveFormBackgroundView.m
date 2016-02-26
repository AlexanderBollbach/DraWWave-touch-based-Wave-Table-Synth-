//
//  WaveFormBackgroundView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "WaveFormBackgroundView.h"

@implementation WaveFormBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
   }
   return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
