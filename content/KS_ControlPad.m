//
//  KaossControlView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ControlPad.h"
#import "functions.h"
#import "KS_ConnectionManager.h"

#import "KS_ElementButton.h"

#import "AnimatingButton.h"
#import "ControlPadMatrixView.h"

@interface KS_ControlPad() <ControlPadMatrixDelegate>



@property (nonatomic,strong) AnimatingButton * elementXButton;
@property (nonatomic,strong) AnimatingButton * elementYButton;

@property (nonatomic,strong) AnimatingButton * selectedElementButton;

@property (nonatomic,strong) ControlPadMatrixView * matrixView;
@property (nonatomic,strong) UIView * topView;

@end

@implementation KS_ControlPad

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}




- (void)setup {
   
   
   self.backgroundColor = [UIColor clearColor];
   self.clearsContextBeforeDrawing = YES;
   
   self.layer.borderWidth = 1;
   self.layer.borderColor = [UIColor whiteColor].CGColor;
   
   
   self.elementX = [[KS_ControlPad_Element alloc] init];
   self.elementY = [[KS_ControlPad_Element alloc] init];
   
   
   
   
   
   self.topView = [[UIView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.topView];
   
   
   
   self.matrixView = [[ControlPadMatrixView alloc] initWithFrame:CGRectZero];
   [self addSubview:self.matrixView];
   self.matrixView.delegate = self;
   
   
   
   self.elementXButton = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.elementXButton];
   self.elementXButton.tag = 0;
   [self.elementXButton setTitle:@"X" forState:UIControlStateNormal];
   [self.elementXButton addTarget:self action:@selector(handleTapped:) forControlEvents:UIControlEventTouchUpInside];
   
   self.elementYButton = [[AnimatingButton alloc] initWithFrame:CGRectZero];
   [self addSubview:self.elementYButton];
      [self.elementYButton setTitle:@"Y" forState:UIControlStateNormal];
   self.elementYButton.tag = 1;
   [self.elementYButton addTarget:self action:@selector(handleTapped:) forControlEvents:UIControlEventTouchUpInside];
   
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(parameterChanged:)
                                                name:@"parameterTapped"
                                              object:nil];
   
   
   [self setNeedsDisplay];
   
}

-(void)elementXChangedWithValue:(float)value {
   [self.delegate changedWithParameter:self.elementX.parameter andValue:value];
}

-(void)elementYChangedWithValue:(float)value {
   [self.delegate changedWithParameter:self.elementY.parameter andValue:value];
}


- (void)parameterChanged:(NSNotification *)notification {
   
   NSDictionary *theData = [notification userInfo];
   
   KS_Parameter_t param = (KS_Parameter_t)[[theData objectForKey:@"parameter"]integerValue];
   
   NSString * name = [[KS_TypesAndHelpers sharedInstance] getNameFromKS_Parameter:param];
   
   if (self.elementIsListening) {
      [self.selectedElementButton animate:NO];
      self.elementIsListening = NO;
      [self.selectedElementButton setTitle:name forState:UIControlStateNormal];
      self.selectedElement.parameter = param;
      
   }
}


- (void)handleTapped:(AnimatingButton *)sender {

   sender.selected = !sender.selected;

   if (sender.selected) {
      
  
   if (sender.tag == 0) {
      self.selectedElement = self.elementX;
   } else if (sender.tag == 1) {
      self.selectedElement = self.elementY;
   }
   
   [sender animate:YES];
   self.elementIsListening = YES;
   self.selectedElementButton = sender;
   
      
   } else {
      
      [sender animate:NO];
      self.elementIsListening = NO;
      
   }
   
}

-(void)layoutSubviews {
   
   CGRect topFrame = self.bounds;
   topFrame.size.height = CGRectGetHeight(self.bounds) / 6;
   
   CGRect matrixFrame = self.bounds;
   matrixFrame.origin.y += topFrame.size.height;
   matrixFrame.size.height -= topFrame.size.height;
   
   self.topView.frame = topFrame;
   self.matrixView.frame = matrixFrame;
   
   
   
   CGRect elemXButFr = topFrame;
   elemXButFr.size.width /= 2;
   elemXButFr.origin.x = 0;
   
   CGRect elemYButFr = elemXButFr;
   elemYButFr.origin.x += elemYButFr.size.width;
   
   self.elementXButton.frame = elemXButFr;
   self.elementYButton.frame = elemYButFr;
}

@end
