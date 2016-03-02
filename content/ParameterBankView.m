//
//  ParameterBankView.m
//  DraWave
//
//  Created by alexanderbollbach on 3/1/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ParameterBankView.h"
//#import "KS_TypesAndHelpers.h"

@interface ParameterBankView()
@property (nonatomic,strong) KS_ParameterView * parameterView1;
@property (nonatomic,strong) KS_ParameterView * parameterView2;
@property (nonatomic,strong) KS_ParameterView * parameterView3;
@property (nonatomic,strong) KS_ParameterView * parameterView4;
@property (nonatomic,strong) KS_ParameterView * parameterView5;
@property (nonatomic,strong) KS_ParameterView * parameterView6;

@end

@implementation ParameterBankView


-(instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}



-(void)setup {
  


   self.parameterView1 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView1];
   self.parameterView2 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView2];
   self.parameterView3 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView3];
   self.parameterView4 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView4];
   self.parameterView5 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView5];
   self.parameterView6 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.parameterView6];

 
   self.parameterView1.parameter = KS_Parameter1;
   self.parameterView2.parameter = KS_Parameter2;
   self.parameterView3.parameter = KS_Parameter3;
   self.parameterView4.parameter = KS_Parameter4;
   self.parameterView5.parameter = KS_Parameter5;
   self.parameterView6.parameter = KS_Parameter6;
   
   
   KS_TypesAndHelpers * help = [KS_TypesAndHelpers sharedInstance];
   self.parameterView1.name.text = [help getNameFromKS_Parameter:self.parameterView1.parameter];
   self.parameterView2.name.text = [help getNameFromKS_Parameter:self.parameterView2.parameter];
   self.parameterView3.name.text = [help getNameFromKS_Parameter:self.parameterView3.parameter];
   self.parameterView4.name.text = [help getNameFromKS_Parameter:self.parameterView4.parameter];
   self.parameterView5.name.text = [help getNameFromKS_Parameter:self.parameterView5.parameter];
   self.parameterView6.name.text = [help getNameFromKS_Parameter:self.parameterView6.parameter];
   
}


-(void)layoutSubviews {
   CGRect parameter1Fr = self.bounds;
   parameter1Fr.size.width /= 6;
   
   CGRect parameter2Fr = parameter1Fr;
   parameter2Fr.origin.x += parameter2Fr.size.width;
   
   CGRect parameter3Fr = parameter2Fr;
   parameter3Fr.origin.x += parameter2Fr.size.width;
   
   CGRect parameter4Fr = parameter3Fr;
   parameter4Fr.origin.x += parameter2Fr.size.width;
   
   CGRect parameter5Fr = parameter4Fr;
   parameter5Fr.origin.x += parameter2Fr.size.width;
   
   CGRect parameter6Fr = parameter5Fr;
   parameter6Fr.origin.x += parameter2Fr.size.width;
   self.parameterView1.frame = parameter1Fr;
   self.parameterView2.frame = parameter2Fr;
   self.parameterView3.frame = parameter3Fr;
   self.parameterView4.frame = parameter4Fr;
   self.parameterView5.frame = parameter5Fr;
   self.parameterView6.frame = parameter6Fr;

}

@end
