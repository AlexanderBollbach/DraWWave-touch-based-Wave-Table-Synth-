//
//  KS_SettingsButton.m
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_SettingsButton.h"

@implementation KS_SettingsButton

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}





- (void)setup {
  
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   self.layer.borderWidth = 1;
}


- (void)animate:(BOOL)animate {
   
   if (animate) {
      [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction animations:^{
         self.backgroundColor = [UIColor whiteColor];
         [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      } completion:^(BOOL finished) {
         self.backgroundColor = [UIColor whiteColor];
      }];
      
   } else {
      [self.layer removeAllAnimations];
      [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      self.backgroundColor = [UIColor blackColor];
   }
}


@end
