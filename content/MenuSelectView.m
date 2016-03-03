//
//  MenuSelectView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "MenuSelectView.h"

@interface MenuSelectView()

@end

@implementation MenuSelectView


- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}


- (void)setup {
   
   self.backgroundColor = [UIColor clearColor];
   
   self.button1 = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   self.button2 = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   self.button3 = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   self.button4 = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   
   [self resetBorders];
   
   [self addSubview:self.button1];
   [self addSubview:self.button2];
   [self addSubview:self.button3];
   [self addSubview:self.button4];
   
   self.button1.title.text = @"button1";
   self.button2.title.text = @"button2";
   self.button3.title.text = @"button3";
   self.button4.title.text = @"button4";
   
   [self.button1 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.button2 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.button3 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.button4 addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
   
   self.button1.tag = 0;
   self.button2.tag = 1;
   self.button3.tag = 2;
   self.button4.tag = 3;
}



- (void)resetBorders {
   
   self.button1.layer.borderWidth = 0;
   self.button2.layer.borderWidth = 0;
   self.button3.layer.borderWidth = 0;
   self.button4.layer.borderWidth = 0;
}


- (void)buttonTapped:(AnimatingButton *)sender {
   
   [self resetBorders];
   
   sender.layer.borderWidth = 1;
   
   [self.delegate menuSelectButtonTappedWithId:(int)sender.tag];
   
}

- (void)layoutSubviews {
   
   CGRect top = self.bounds;
   top.size.height /= 2;
   
   CGRect bottom = top;
   bottom.origin.y += bottom.size.height;
   
   CGRect topLeft = top;
   topLeft.size.width /= 2;
   
   CGRect topRight = topLeft;
   topRight.origin.x += topRight.size.width;
   
   CGRect bottomLeft = bottom;
   bottomLeft.size.width /= 2;
   
   CGRect bottomRight = bottomLeft;
   bottomRight.origin.x += bottomRight.size.width;
   
   self.button1.frame = topLeft;
   self.button2.frame = topRight;
   self.button3.frame = bottomLeft;
   self.button4.frame = bottomRight;
   
}



@end
