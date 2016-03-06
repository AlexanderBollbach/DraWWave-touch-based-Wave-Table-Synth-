//
//  ControlPadViewController.m
//  DraWave
//
//  Created by alexanderbollbach on 3/5/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlPadViewController.h"

#import "ControlPadTopView.h"
#import "ControlPadMatrixView.h"
#import "ControlPadParameterVew.h"

#import "ControlPad_Element.h"

#import "MainParameters.h"

@interface ControlPadViewController() <ControlPadTopViewDelegate, ControlPadMatrixViewDelegate, ControlPadParameterViewDelegate>

// views
@property (nonatomic,strong) ControlPadTopView * topView;
@property (nonatomic,strong) ControlPadMatrixView * matrixView;
@property (nonatomic,strong) ControlPadParameterVew * paramView;


// state
@property (nonatomic,strong) ControlPad_Element * elementX;
@property (nonatomic,strong) ControlPad_Element * elementY;
@property (nonatomic,strong) ControlPad_Element * activeElement;


@property BOOL elementX_isActive;
@property BOOL elementY_isActive;


@property (nonatomic,strong) MainParameters * mainParameters;
@end

@implementation ControlPadViewController


- (void)viewDidLoad {
   
   self.view.backgroundColor = [UIColor blueColor];
   
   self.topView = [[ControlPadTopView alloc] initWithFrame:CGRectZero];
   self.topView.delegate = self;
   
   self.matrixView = [[ControlPadMatrixView alloc] initWithFrame:CGRectZero];
   self.matrixView.delegate = self;
   
   self.paramView = [[ControlPadParameterVew alloc] initWithFrame:CGRectZero];
   self.paramView.delegate = self;
   
   self.paramView.hidden = YES;
   
   [self setupElements];
   
   
   [self.view addSubview:self.topView];
   [self.view addSubview:self.matrixView];
   [self.view addSubview:self.paramView];

   self.mainParameters = [MainParameters sharedInstance];
}


- (void)setupElements {
   
   self.elementX = [[ControlPad_Element alloc] init];
   self.elementX.parameter = KS_Parameter1;
   
   self.elementY = [[ControlPad_Element alloc] init];
   self.elementY.parameter = KS_Parameter2;
   
}




#pragma mark - controlPadTopViewDelegate -

- (void)elementXButtonTapped {
   
   self.elementX_isActive = !self.elementX_isActive;
   
   if (self.elementX_isActive) {
      self.activeElement = self.elementX;
      self.paramView.hidden = NO;
   } else {
      self.paramView.hidden = YES;
   }
   
   
}


- (void)elementYButtonTapped {
   
   self.elementY_isActive = !self.elementY_isActive;
   
   if (self.elementY_isActive) {
      self.activeElement = self.elementY;
      self.paramView.hidden = NO;
   } else {
      self.paramView.hidden = YES;
   }
}


#pragma mark - controlPadMatrixViewDelegate -


- (void)elementXChangedWithValue:(float)value {
   
   [self.mainParameters setValue:value withParameterId:self.elementX.parameter];
   
}

- (void)elementYChangedWithValue:(float)value {
   
   [self.mainParameters setValue:value withParameterId:self.elementY.parameter];

}

#pragma mark - controlPadParamViewDelegate -

- (void)parameterButtonTapped:(KS_Parameter_t)parameter {
   
   self.activeElement.parameter = parameter;
   self.paramView.hidden = YES;
   
   self.elementX_isActive = NO;
   self.elementY_isActive = NO;
   
   KS_TypesAndHelpers * help = [KS_TypesAndHelpers sharedInstance];
   NSString * parameterName = [help getNameFromKS_Parameter:parameter];
   
   if ([self.activeElement isEqual:self.elementX]) {
      [self.topView setElementXNameWithString:parameterName];
   }
   
   
   if ([self.activeElement isEqual:self.elementY]) {
      [self.topView setElementYNameWithString:parameterName];
   }
}


- (void)viewDidLayoutSubviews {
   
   
   CGRect main = self.view.bounds;
   
   CGRect top = main;
   top.size.height *= 0.25;
   
   CGRect bottom = main;
   bottom.origin.y += top.size.height;
   bottom.size.height *= 0.75;
   
   self.topView.frame = top;
   self.matrixView.frame = bottom;
   self.paramView.frame = bottom;
   
}

@end
