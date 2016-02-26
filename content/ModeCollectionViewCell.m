//
//  ModeCollectionViewCell.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ModeCollectionViewCell.h"

@interface ModeCollectionViewCell()
@end

@implementation ModeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {

      self.name = [[UILabel alloc] initWithFrame:self.bounds];
      self.name.text = @"test";
      self.name.textAlignment = NSTextAlignmentCenter;
      self.name.textColor = [UIColor whiteColor];
      [self addSubview:self.name];
      
      
      self.backgroundColor = [UIColor clearColor];
      
      self.layer.borderColor = [UIColor whiteColor].CGColor;
      self.layer.borderWidth = 0.4;
   }
   return self;
}

-(void)layoutSubviews {
}

@end
