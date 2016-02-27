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
#import "ParameterManager.h"
#import "WaveFormView.h"
#import "KS_ConnectionViewController.h"
#import "KS_ControlPad.h"
#import "KS_ConnectionManager.h"

@interface SynthVC () <KS_ConnectionManagerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) AudioController * audioController;
@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) KS_ConnectionViewController * KS_ConnectionViewController;
@property BOOL tapped;

@end

@implementation SynthVC


- (void)viewDidLoad {
   [super viewDidLoad];
   
   CGRect waveFormFrame = self.view.bounds;
   
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:waveFormFrame];
   [self.view addSubview:self.waveFormView];
   
   CGRect kcvFr1 = self.view.bounds;
   kcvFr1.size.width /= 2;
   
   CGRect kcvFr2 = kcvFr1;
   kcvFr2.origin.x += kcvFr2.size.width;
   
   
   
   
   KS_ConnectionManager * kaossManager = [KS_ConnectionManager sharedInstance];
   kaossManager.delegate = self;
   
   KS_ControlPad * kcv = [[KS_ControlPad alloc] initWithFrame:kcvFr1];
   kcv.elementX = KS_X1;
   kcv.elementY = KS_Y1;
   [self.view addSubview:kcv];
   
   KS_ControlPad * kcv2 = [[KS_ControlPad alloc] initWithFrame:kcvFr2];
   kcv2.elementX = KS_X2;
   kcv2.elementY = KS_Y2;
   [self.view addSubview:kcv2];
   
   self.KS_ConnectionViewController = [[KS_ConnectionViewController alloc] init];
   
   self.view.backgroundColor = [UIColor blackColor];
   
   
   
   
   self.audioController = [AudioController sharedInstance];
   
   
   
   
   
   UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
   tap.numberOfTapsRequired = 2;
   [self.view addGestureRecognizer:tap];
   
   
}




#pragma mark - ks_ConnectionManager delegate -

- (void)elementChangedWithParameter:(KS_Parameter_t)parameter andValue:(float)value {
   
   switch (parameter) {
      case KS_blank: {
         
         break;
      }
         
      case KS_samplesDuration: {
         value = alexMap(value, 0, 100, 50, 700);
         [self.audioController setSamplesDurationValue:value];
         [self.waveFormView setNumOfSamplesToDraw:value];
         break;
      }
         
      case KS_lfoRate: {
         value = alexMap(value, 0, 100, 50, 100);
         [self.audioController setLfoRateValue:value];
         break;
      }
         
      case KS_lfoAmount: {
         value = alexMap(value, 0, 100, 0, 0.1);
         [self.audioController setLfoAmountValue:value];
         break;
      }
         
      case KS_reverbAmount: {
         value = alexMap(value, 0, 100, 0, 100);
         [self.audioController setReverbAmount:value];
         
         break;
      }
         
         
      case KS_blank2:
         NSLog(@"blank2 changed %i   with Value %f", parameter,value);
         
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
