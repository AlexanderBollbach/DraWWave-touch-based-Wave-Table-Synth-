//
//  ControlsView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlsView.h"
#import "functions.h"
#import "Global.h"


@interface ControlsView() {
   
   int effectMode;
   

   
}

@property (nonatomic,strong) NSMutableArray * effectButtons;
@property (nonatomic,strong) UILabel * status;





@end

@implementation ControlsView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
     
      [self setup];
      
      
      
   }
   return self;
}

- (void)buttonTapped:(UIButton*)sender {
   
   [self clearUIForEffectState];
   
   sender.layer.borderColor = [UIColor whiteColor].CGColor;

   [self.delegate modeButtonTapped:(int)sender.tag];
}


- (void)layoutSubviews {
   [self buttonTapped:[self.effectButtons objectAtIndex:0]];
}

- (void)setup {
   
   self.effectButtons = [NSMutableArray array];
   
   self.backgroundColor = [UIColor clearColor];
   self.hidden = NO;
  
   CGRect buttonsFrame = self.bounds;
   
   NSArray *titles = @[@"samples", @"draw", @"three", @"four", @"View"];
   
   for (int x = 0; x < 5; x++) {
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setTitle:[titles objectAtIndex:x] forState:UIControlStateNormal];
      button.tag = x + 1;
      CGFloat width = (CGRectGetWidth(self.bounds) / 5) * x;
      button.frame = CGRectMake(width, 0, buttonsFrame.size.width / titles.count, buttonsFrame.size.height);
      [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
      button.layer.borderColor = [UIColor whiteColor].CGColor;
      button.layer.borderWidth = 1;
      
      [self addSubview:button];
      
      [self.effectButtons addObject:button];
   }
   
   
   UIButton *button = [self.effectButtons objectAtIndex:0];
   [button sendAction:@selector(buttonTapped:) to:self forEvent:nil];


   
   self.pulledDown = NO;

   
}




- (void)clearUIForEffectState {
   for (UIButton *button in self.effectButtons) { // clear
      button.layer.borderColor = [UIColor clearColor].CGColor;
   }
}







@end
