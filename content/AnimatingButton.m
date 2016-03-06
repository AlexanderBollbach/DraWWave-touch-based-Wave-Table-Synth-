//
//  AnimatingButton.m
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "AnimatingButton.h"

@implementation AnimatingButton



- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}


- (void)setup {
   
   self.backgroundColor = [UIColor clearColor];

   self.title = [[UILabel alloc] initWithFrame:CGRectZero];
   self.title.textColor = [UIColor whiteColor];
   self.title.textAlignment = NSTextAlignmentCenter;
   [self addSubview:self.title];
   
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   self.layer.borderWidth = 1;
   
}



- (void)animate:(BOOL)animate {
   
   if (animate) {
      [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
         self.backgroundColor = [UIColor whiteColor];
      } completion:nil];
   } else {
      [self.layer removeAllAnimations];
      self.backgroundColor = [UIColor blackColor];
   }
}

- (void)animateQuick {
   
   
   [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction animations:^{
      self.backgroundColor = [UIColor whiteColor];
   } completion:^(BOOL finished) {
      [self.layer removeAllAnimations];
      self.backgroundColor = [UIColor blackColor];
      
   }];
   
   
   
}

-(void)layoutSubviews {
   self.title.frame = self.bounds;
}
@end
