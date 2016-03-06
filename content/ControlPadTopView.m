//
//  KaossControlView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlPadTopView.h"
#import "functions.h"

//#import "KS_ElementButton.h"

#import "AnimatingButton.h"


@interface ControlPadTopView() 
@property (nonatomic,strong) AnimatingButton * elementXButton;
@property (nonatomic,strong) AnimatingButton * elementYButton;
@end

@implementation ControlPadTopView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}

- (void)setup {
   
   
   self.clearsContextBeforeDrawing = YES;
   
   self.layer.borderWidth = 1;
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   

   
   self.elementXButton = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.elementXButton];
   self.elementXButton.typeName = @"X";
   [self.elementXButton addTarget:self action:@selector(elementXTapped:) forControlEvents:UIControlEventTouchUpInside];
   
   self.elementYButton = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.elementYButton];
   self.elementYButton.typeName = @"Y";
   
   [self.elementYButton addTarget:self action:@selector(elementYTapped:) forControlEvents:UIControlEventTouchUpInside];
   
 
   [self setNeedsDisplay];
   
}

#pragma mark - delegate -

- (void)elementXTapped:(AnimatingButton *)button {
   [self.delegate elementXButtonTapped];
}

- (void)elementYTapped:(AnimatingButton *)button {
   [self.delegate elementYButtonTapped];
}

- (void)refreshElementButtonNames {
   
   KS_TypesAndHelpers * help = [KS_TypesAndHelpers sharedInstance];
   
   self.elementXButton.title.text = [NSString stringWithFormat:@"%@:%@",self.elementXButton.typeName,[help getNameFromKS_Parameter:self.elementX.parameter]];
   
   self.elementYButton.title.text = [NSString stringWithFormat:@"%@:%@",self.elementYButton.typeName,[help getNameFromKS_Parameter:self.elementY.parameter]];
}

- (void)setElementXNameWithString:(NSString *)string {
 
   self.elementXButton.title.text = string;
}

- (void)setElementYNameWithString:(NSString *)string {
   
   self.elementYButton.title.text = string;
}

- (void)layoutSubviews {
   
   CGRect elemXButFr = self.bounds;
   elemXButFr.size.width /= 2;

   
   CGRect elemYButFr = elemXButFr;
   elemYButFr.origin.x += elemYButFr.size.width;
   
   self.elementXButton.frame = elemXButFr;
   self.elementYButton.frame = elemYButFr;
}

@end
