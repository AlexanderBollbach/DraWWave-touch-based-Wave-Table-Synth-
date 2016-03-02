//
//  MenuView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}

- (void)setup {
   
   self.parameterBankView = [[ParameterBankView alloc] initWithFrame:CGRectZero];
   self.parameterBankView.backgroundColor = [UIColor redColor];
   [self addSubview:self.parameterBankView];
   
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   self.layer.borderWidth = 1;
   
}


- (void)layoutSubviews {
   
   CGRect parameterBankFrame = self.bounds;
   parameterBankFrame.size.width /= 1.5;
   
   self.parameterBankView.frame = parameterBankFrame;
   
   
}

@end
