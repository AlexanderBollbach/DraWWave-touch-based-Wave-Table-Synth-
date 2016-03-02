//
//  ViewController.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/13/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "SynthVC.h"
#import "AudioController.h"
#import "functions.h"
#import "KS_ConnectorView.h"
#import "WaveFormView.h"
#import "KS_ConnectionViewController.h"
#import "KS_ControlPad.h"
#import "KS_ConnectionManager.h"

#import "KS_ElementButton.h"

#import "ParameterBankView.h"

@interface SynthVC () <KS_ControlPadDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) AudioController * audioController;
@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) KS_ConnectionViewController * KS_ConnectionViewController;
@property BOOL tapped;

@property (nonatomic,strong) KS_ControlPad * controlPad1;
@property (nonatomic,strong) KS_ControlPad * controlPad2;

@property (nonatomic,strong) ParameterBankView * parameterBankView;

@property (nonatomic,strong) KS_ConnectionManager * connectionManager;


@property (nonatomic,assign) KS_Element_t selectedElement;
@property (nonatomic,assign) KS_Parameter_t selectedParameter;

@end

@implementation SynthVC


- (void)viewDidLoad {
   [super viewDidLoad];
   
   CGRect waveFormFrame = self.view.bounds;
   
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:waveFormFrame];
   [self.view addSubview:self.waveFormView];
   

   
   
   

   #pragma mark - KS Setup -

   CGRect kcvFr1 = self.view.bounds;
   kcvFr1.size.width /= 2;
   
   CGRect kcvFr2 = kcvFr1;
   kcvFr2.origin.x += kcvFr2.size.width;
   
   //self.connectionManager = [KS_ConnectionManager sharedInstance];
  // self.connectionManager.delegate = self;
   
   self.controlPad1 = [[KS_ControlPad alloc] initWithFrame:kcvFr1];
   self.controlPad1.elementX = KS_Element1;
   self.controlPad1.elementY = KS_Element2;
   self.controlPad1.delegate = self;
   [self.view addSubview:self.controlPad1];
   
   self.controlPad2 = [[KS_ControlPad alloc] initWithFrame:kcvFr2];
   self.controlPad2.elementX = KS_Element3;
   self.controlPad2.elementY = KS_Element4;
   self.controlPad2.delegate = self;
   [self.view addSubview:self.controlPad2];
   
   
   
   self.controlPad1.elementXParameter = KS_Parameter2;
      self.controlPad1.elementYParameter = KS_Parameter3;
      self.controlPad2.elementXParameter = KS_Parameter4;
      self.controlPad2.elementYParameter = KS_Parameter5;
   
   self.KS_ConnectionViewController = [[KS_ConnectionViewController alloc] init];
   
   self.view.backgroundColor = [UIColor blackColor];
   
   
   self.audioController = [AudioController sharedInstance];
   
   UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
   tap.numberOfTapsRequired = 2;
   [self.view addGestureRecognizer:tap];
   
   
   
   self.parameterBankView = [[ParameterBankView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 8)];
   [self.view addSubview:self.parameterBankView];
   
}







- (void)changedWithParameter:(KS_Parameter_t)parameter andValue:(float)value {
   switch (parameter) {
         
         // empty
      case KS_Parameter1: {
         value = alexMap(value, 0, 100, 50, 500000);
        // [self.audioController setSamplesDurationValue:value];
        // [self.waveFormView setNumOfSamplesToDraw:value];
         break;
      }

         // samples (short)
      case KS_Parameter2: {
         value = alexMap(value, 0, 100, 0, 1000);
         [self.audioController setSamplesDurationValue:value];
         [self.waveFormView setNumOfSamplesToDraw:value];
         break;
      }
       
         // lfo rate
      case KS_Parameter3: {
         value = alexMap(value, 0, 100, 5, 100);
         [self.audioController setLfoRateValue:value];
         break;
      }
         
         // lfo amount
      case KS_Parameter4: {
         value = alexMap(value, 0, 100, 0, 0.2);
         [self.audioController setLfoAmountValue:value];
         break;
      }
         
         // reverb
      case KS_Parameter5: {
         value = alexMap(value, 0, 100, 0, 100);
         [self.audioController setReverbAmount:value];
         
         break;
      }
         
         // empty
      case KS_Parameter6:
         
         break;
         
      default:
         break;
   }
}








- (void)viewWillAppear:(BOOL)animated {
   
   for (UIView * view in self.view.subviews) {
      view.hidden = NO;
   }
   [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)tap {
   for (UIView * view in self.view.subviews) {
      view.hidden = YES;
   }
   [self.navigationController pushViewController:self.KS_ConnectionViewController animated:YES];
}




@end
