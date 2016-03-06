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
#import "WaveFormView.h"
#import "ControlPadTopView.h"
//#import "KS_ElementButton.h"
#import "ControlPadParameterVew.h"
#import "constants.h"
#import "ControlPadViewController.h"

@interface SynthVC () <WaveFormViewDelegate, AudioControllerDelegate>

@property (nonatomic,strong) AudioController * audioController;
@property BOOL tapped;
//
//@property (nonatomic,strong) ControlPadTopView * controlPad1;
//@property (nonatomic,strong) ControlPadTopView * controlPad2;
//


//
//
//@property (nonatomic,strong) UIView * leftSlot;
//@property (nonatomic,strong) UIView * rightSlot;
//

@property (nonatomic,strong) WaveFormView * waveFormView;
@property CGRect waveFormViewFrame;

@property (nonatomic,strong) ControlPadViewController * controlPadVC1;
@property (nonatomic,strong) ControlPadViewController * controlPadVC2;

@end

@implementation SynthVC


- (void)viewDidLayoutSubviews {
   
   float width = CGRectGetWidth(self.view.bounds);
   //  float height = CGRectGetHeight(self.view.bounds);
   
   
   
   CGRect topFrame = self.view.bounds;
   topFrame.size.height /= 3.5;
   
   CGRect topLeft = topFrame;
   topLeft.size.width *= 0.75;
   
   CGRect topRight = topFrame;
   topRight.origin.x += topLeft.size.width;
   topRight.size.width = width * 0.25;
   
   
   self.waveFormView.frame = CGRectInset(topFrame, kAppMaxPadding, kAppMaxPadding);
   self.waveFormViewFrame = self.waveFormView.frame;
   
   CGRect lowerFrame = self.view.bounds;
   lowerFrame.origin.y += topFrame.size.height;
   lowerFrame.size.height -=topFrame.size.height;
   
   CGRect leftSlotFrame = lowerFrame;
   leftSlotFrame.size.width /= 2;
   
   CGRect rightSlotFrame = leftSlotFrame;
   rightSlotFrame.origin.x += rightSlotFrame.size.width;
   
   self.controlPadVC1.view.frame = leftSlotFrame;
   self.controlPadVC2.view.frame = rightSlotFrame;
   

}

- (void)viewDidLoad {
   [super viewDidLoad];
   
   
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:CGRectZero];
   self.waveFormView.delegate = self;
   [self.view addSubview:self.waveFormView];
   
   
  
  
   
   self.controlPadVC1 = [[ControlPadViewController alloc] init];
   [self.view addSubview:self.controlPadVC1.view];

   self.controlPadVC2 = [[ControlPadViewController alloc] init];
   [self.view addSubview:self.controlPadVC2.view];
   
   self.view.backgroundColor = [UIColor blackColor];
   
   
   self.audioController = [AudioController sharedInstance];
   self.audioController.delegate = self;
   
   
}











#pragma mark - audioController delegate -


- (void)waveFormChangedWithValue:(float)value {
   
   

   [self.waveFormView setColorOnWaveForm:value];
   
}


#pragma mark - waveFormView delegate -

- (void)didPanWithValue:(float)value {
   [self.audioController PsetDuration:value];
   [self.waveFormView setNumOfSamplesToDraw:value];
}

- (void)waveFormViewPressed {
   self.waveFormView.expanded = !self.waveFormView.expanded;
   
   [self.view bringSubviewToFront:self.waveFormView];
   
      [UIView animateWithDuration:0.4 animations:^{
         
         CGRect frame;
         if (self.waveFormView.expanded) {
            frame = self.waveFormViewFrame;
         } else {
            frame = self.view.bounds;
         }
         
         self.waveFormView.frame = frame;
      }];
}

@end
