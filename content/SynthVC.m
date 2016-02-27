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
#import "ControlsView.h"
#import "ParameterManager.h"
#import "WaveFormHolderView.h"
#import "ControlsViewController.h"
#import "KaossControlView.h"
#import "KaossConnectionManager.h"

@interface SynthVC ()<ParameterManagerDelegate,UIGestureRecognizerDelegate,KaossControlViewDelegate>

@property (nonatomic,strong) AudioController * audioController;
@property (nonatomic,strong) ParameterManager * pm;
@property (nonatomic,strong) ControlsView * controlsView;

@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) WaveFormOverlayView * waveFormOverlayView;

@property (nonatomic,strong) ControlsViewController * controlsVC;

@property BOOL tapped;

@end

@implementation SynthVC




- (void)viewDidLoad {
   [super viewDidLoad];
   
   
   
   CGRect kcvFr1 = self.view.bounds;
   kcvFr1.size.width /= 2;
   
   CGRect kcvFr2 = kcvFr1;
   kcvFr2.origin.x += kcvFr2.size.width;
   

   
   
   KaossConnectionManager * kaossManager = [KaossConnectionManager sharedInstance];
   
   
   KaossControlView * kcv = [[KaossControlView alloc] initWithFrame:kcvFr1];
   kcv.delegate = kaossManager;
   kcv.elementX = k_X1;
   kcv.elementY = k_Y1;
   [self.view addSubview:kcv];
   
   KaossControlView * kcv2 = [[KaossControlView alloc] initWithFrame:kcvFr2];
   kcv2.delegate = kaossManager;
   kcv.elementX = k_X2;
   kcv.elementY = k_Y2;
   [self.view addSubview:kcv2];
   
   //  self.controlsVC = [[ControlsViewController alloc] init];
   
   self.view.backgroundColor = [UIColor blackColor];
   
   self.pm = [ParameterManager sharedInstance];
   self.pm.delegate = self;
   // self.audioController = [AudioController sharedInstance];
   
   CGRect waveFormFrame = self.view.bounds;
   CGRect waveFormOverlayFrame = waveFormFrame;
   waveFormOverlayFrame.size.width /= 2;
   
   
   //   self.waveFormView = [[WaveFormView alloc] initWithFrame:waveFormFrame];
   // [self.view addSubview:self.waveFormView];
   
   
   //  self.waveFormOverlayView = [[WaveFormOverlayView alloc] initWithFrame:waveFormOverlayFrame];
   //  [self.view addSubview:self.waveFormOverlayView];
   
   
   //   CGRect controlsFrame = self.view.bounds;
   //   controlsFrame.origin.x += CGRectGetWidth(self.view.bounds) * 0.6;
   //   controlsFrame.size.width = CGRectGetWidth(self.view.bounds) * 0.4;
   //
   //
   //   self.controlsView = [[ControlsView alloc] initWithFrame:self.view.bounds];
   //   self.controlsView.delegate = self;
   //   [self.view addSubview:self.controlsView];
   
   self.controlsView.hidden = YES;
   
   
   // UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   // [self.waveFormView addGestureRecognizer:pan];
   
   
   
   UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
   tap.numberOfTapsRequired = 2;
   [self.view addGestureRecognizer:tap];
   
   
   CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
   [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
   
   
}

-(void)viewWillAppear:(BOOL)animated {
   
   [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)tick {
   [self.view setNeedsDisplay];
   //   [self.waveFormOverlayView setNeedsDisplay];
   //  [self.waveFormView setNeedsDisplay];
}


- (void)tap {
   [self.navigationController pushViewController:self.controlsVC animated:YES];
}

//
//
//- (void)connectionMadeFromGesture:(Gesture_t)gesture toParameter:(ParamSelected_t)parameter {
//   [self.pm connectGesture:gesture toParameter:parameter];
//}



- (void)pan:(UIPanGestureRecognizer*)pan {
   
   // TODO: crash when pan to right edge of screen then pan onto controls view
   float x = alexMap([pan locationInView:self.view].x,
                     0, self.waveFormOverlayView.bounds.size.width,
                     0, self.waveFormOverlayView.bounds.size.width);
   float y = alexMap([pan locationInView:self.view].y,
                     0, self.waveFormOverlayView.bounds.size.height,
                     0, self.waveFormOverlayView.bounds.size.height);
   
   [self.pm setPanXParamValue:x];
   [self.pm setPanYParamValue:y];
   
   //   NSLog(@"loc x : %f", [pan locationInView:self.view].x);
   //   NSLog(@"screen %f", [UIScreen mainScreen].bounds.size.width);
}


// range comes in 0-500 for all parameters and param enum type
-(void)gestureChanged:(Gesture *)gesture withValue:(float)value {
   
   NSString * valueString = [NSString stringWithFormat:@"%.2f", value];
   
   
   switch (gesture.gesture) {
      case panX: {
         [self.waveFormOverlayView setPanXPosition:value];
      } break;
      case panY: {
         [self.waveFormOverlayView setPanYPosition:value];
      } break;
   }
   
   switch (gesture.controlledParameter) {
      case blank:
         break;
      case samplesDuration: {
         value = alexMap(value, 0, CGRectGetWidth(self.waveFormOverlayView.bounds), 0, 5000);
         valueString = [NSString stringWithFormat:@"%.2f", value];
         [self.audioController setSamplesDurationValue:value];
         [self.waveFormView setNumOfSamplesToDraw:value];
         break;
      }
         
      case lfoRate:
         value = alexMap(value, 0, CGRectGetWidth(self.waveFormOverlayView.bounds), 0, 100);
         valueString = [NSString stringWithFormat:@"%.2f", value];
         [self.audioController setLfoRateValue:value];
         break;
      case lfoAmount:
         value = alexMap(value, 0, CGRectGetWidth(self.waveFormOverlayView.bounds), 0, 0.1);
         valueString = [NSString stringWithFormat:@"%.2f", value];
         [self.audioController setLfoAmountValue:value];
         break;
      case reverbAmount: {
         value = alexMap(value, 0, CGRectGetWidth(self.waveFormOverlayView.bounds), 0, 75);
         valueString = [NSString stringWithFormat:@"%.2f", value];
         [self.audioController setReverbAmount:value];
      }
         break;
         
      default:
         break;
   }
   
   
   
   
   
   switch (gesture.gesture) {
      case panX: {
         [self.waveFormOverlayView setPanXValueReadOut:valueString];
      } break;
      case panY: {
         [self.waveFormOverlayView setPanYValueReadOut:valueString];
      } break;
   }
   
   
   
   
}




@end
