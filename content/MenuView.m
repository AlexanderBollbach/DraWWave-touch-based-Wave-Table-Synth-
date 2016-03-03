//
//  MenuView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "MenuView.h"
#import "constants.h"

@interface MenuView() <MenuSelectViewDelegate>

@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}

- (void)setup {
   
   self.menuSelectView = [[MenuSelectView alloc] initWithFrame:CGRectZero];
   self.menuSelectView.delegate = self;

   [self addSubview:self.menuSelectView];

   self.abScene = [[ABScene alloc] initWithFrame:CGRectZero];
   [self addSubview:self.abScene];
   self.abScene.backgroundColor = [UIColor blackColor];
   
   self.parameterBankView = [[ParameterBankView alloc] initWithFrame:CGRectZero];
   self.parameterBankView.backgroundColor = [UIColor clearColor];
   [self addSubview:self.parameterBankView];
   

   [self resetStuff];
   
   
   // taps first button on launch
   [self.menuSelectView.delegate menuSelectButtonTappedWithId:0];
   self.menuSelectView.button1.layer.borderWidth = 1;
   
}


- (void)resetStuff {
   
   self.parameterBankView.hidden = YES;
   self.abScene.hidden = YES;
}

- (void)layoutSubviews {
   
   CGRect LeftFrame = self.bounds;
   LeftFrame.size.width /= 2;
   
   CGRect RightFrame = self.bounds;
   RightFrame.size.width /= 2;
   RightFrame.origin.x += RightFrame.size.width;
   
   self.parameterBankView.frame = LeftFrame;
   self.abScene.frame = LeftFrame;
   self.menuSelectView.frame = CGRectInset(RightFrame, kAppSmallPadding, kAppSmallPadding);
}



#pragma mark - menuSelectView delegate -

- (void)menuSelectButtonTappedWithId:(int)Id {
   
   [self resetStuff];
   
   switch (Id) {
      case 0:
         self.abScene.hidden = NO;
         break;
      case 1:
         self.parameterBankView.hidden = NO;
         break;
      case 2:
         
         break;
      case 3:
         
         break;
         
      default:
         break;
   }
   
}

@end
