//
//  ParameterBankView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/1/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlPadParameterVew.h"

@interface ControlPadParameterVew()
@property (nonatomic,strong) KS_ParameterButton * parameterView1;
@property (nonatomic,strong) KS_ParameterButton * parameterView2;
@property (nonatomic,strong) KS_ParameterButton * parameterView3;
@property (nonatomic,strong) KS_ParameterButton * parameterView4;
@property (nonatomic,strong) KS_ParameterButton * parameterView5;
@property (nonatomic,strong) KS_ParameterButton * parameterView6;
@property (nonatomic,strong) KS_ParameterButton * parameterView7;
@property (nonatomic,strong) KS_ParameterButton * parameterView8;
@end

@implementation ControlPadParameterVew


-(instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}


- (void)setup {
   
   self.backgroundColor = [UIColor blackColor];

   self.parameterView1 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView1];
   self.parameterView2 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView2];
   self.parameterView3 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView3];
   self.parameterView4 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView4];
   self.parameterView5 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView5];
   self.parameterView6 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView6];
   self.parameterView7 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView7];
   self.parameterView8 = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView8];
   
   
   self.parameterView1.parameter = KS_Parameter1;
   self.parameterView2.parameter = KS_Parameter2;
   self.parameterView3.parameter = KS_Parameter3;
   self.parameterView4.parameter = KS_Parameter4;
   self.parameterView5.parameter = KS_Parameter5;
   self.parameterView6.parameter = KS_Parameter6;
   self.parameterView7.parameter = KS_Parameter7;
   self.parameterView8.parameter = KS_Parameter8;
   
   
   KS_TypesAndHelpers * help = [KS_TypesAndHelpers sharedInstance];
   
   self.parameterView1.name.text = [help getNameFromKS_Parameter:self.parameterView1.parameter];
   self.parameterView2.name.text = [help getNameFromKS_Parameter:self.parameterView2.parameter];
   self.parameterView3.name.text = [help getNameFromKS_Parameter:self.parameterView3.parameter];
   self.parameterView4.name.text = [help getNameFromKS_Parameter:self.parameterView4.parameter];
   self.parameterView5.name.text = [help getNameFromKS_Parameter:self.parameterView5.parameter];
   self.parameterView6.name.text = [help getNameFromKS_Parameter:self.parameterView6.parameter];
   self.parameterView7.name.text = [help getNameFromKS_Parameter:self.parameterView7.parameter];
   self.parameterView8.name.text = [help getNameFromKS_Parameter:self.parameterView8.parameter];
   
   
   [self.parameterView1 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView2 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView3 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView4 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView5 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView6 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView7 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   [self.parameterView8 addTarget:self action:@selector(parameterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   

}


- (void)parameterButtonTapped:(KS_ParameterButton *)sender {
   
  
   [self.delegate parameterButtonTapped:sender.parameter];
   
   [sender animateQuick];
   
}

- (void)layoutSubviews {
   
   
   CGRect top = self.bounds;
   top.size.height /= 2;
   
   CGRect bottom = top;
   bottom.origin.y += top.size.height;
   
   
   CGRect top1 = top;
   top1.size.width /= 4;
   
   CGRect top2 = top1;
   top2.origin.x += top1.size.width;
   
   CGRect top3 = top2;
   top3.origin.x += top1.size.width;
   
   CGRect top4 = top3;
   top4.origin.x += top1.size.width;
   
   CGRect bot1 = bottom;
   bot1.size.width /= 4;
   
   CGRect bot2 = bot1;
   bot2.origin.x += bot1.size.width;
   
   CGRect bot3 = bot2;
   bot3.origin.x += bot1.size.width;
   
   CGRect bot4 = bot3;
   bot4.origin.x += bot1.size.width;
   
   self.parameterView1.frame = CGRectInset(top1, 5, 5);
   self.parameterView2.frame = CGRectInset(top2, 5, 5);
   self.parameterView3.frame = CGRectInset(top3, 5, 5);
   self.parameterView4.frame = CGRectInset(top4, 5, 5);
   self.parameterView5.frame = CGRectInset(bot1, 5, 5);
   self.parameterView6.frame = CGRectInset(bot2, 5, 5);
   self.parameterView7.frame = CGRectInset(bot3, 5, 5);
   self.parameterView8.frame = CGRectInset(bot4, 5, 5);
   
}

@end
