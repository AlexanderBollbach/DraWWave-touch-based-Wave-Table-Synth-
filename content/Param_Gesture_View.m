//
//  ParameterView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Param_Gesture_View.h"

@implementation Param_Gesture_View

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}


- (void)setup {
   
   self.backgroundColor = [UIColor blackColor];
   
   self.name = [[UILabel alloc] initWithFrame:CGRectZero];
   self.name.textColor = [UIColor whiteColor];
   self.name.textAlignment = NSTextAlignmentCenter;
   [self addSubview:self.name];
   
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   self.layer.borderWidth = 1;

}

-(void)layoutSubviews {
   self.name.frame = self.bounds;
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

@end
