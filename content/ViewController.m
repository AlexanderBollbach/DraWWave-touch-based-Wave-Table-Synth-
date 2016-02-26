//
//  ViewController.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/13/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ViewController.h"
#import "AudioController.h"
#import "functions.h"

#import "ControlsView.h"
#import "ControlsViewB.h"

#import "Global.h"

#import "WaveFormHolderView.h"

#import "Draw_Helper.h"

@interface ViewController ()<globalDelegate, UIGestureRecognizerDelegate>


@property (nonatomic,strong) AudioController * audioController;

@property (nonatomic,strong) ControlsView *controlsView;
@property (nonatomic,strong) ControlsViewB *controlsViewB;

@property (nonatomic,strong) WaveFormHolderView * waveFormHolderView;;
@property (nonatomic,strong) WaveFormView * waveFormView;
@property (nonatomic,strong) Global * global;
@end

@implementation ViewController



- (void)viewDidLoad {
   [super viewDidLoad];
   
   
   self.view.backgroundColor = [UIColor blackColor];
   
   self.global = [Global sharedInstance];
   self.global.delegate = self;
   
   self.audioController = [AudioController sharedInstance];
   
   
   CGRect waveFormHolderFrame = self.view.bounds;
   waveFormHolderFrame.origin.x = 0;
   waveFormHolderFrame.size.width = CGRectGetWidth(self.view.bounds) * 0.8;
   waveFormHolderFrame.origin.y = 0;
   waveFormHolderFrame.size.height  = CGRectGetHeight(self.view.bounds);
   
   self.waveFormHolderView = [[WaveFormHolderView alloc] initWithFrame:waveFormHolderFrame];
   [self.view addSubview:self.waveFormHolderView];
   

   
   
   CGRect controlsFrame = self.view.bounds;
   controlsFrame.origin.x += CGRectGetWidth(self.view.bounds) * 0.8;
   controlsFrame.size.width = CGRectGetWidth(self.view.bounds) * 0.2;

   
   self.controlsViewB = [[ControlsViewB alloc] initWithFrame:controlsFrame];
   [self.view addSubview:self.controlsViewB];
   
   
   
   
   
   // controls effects
   UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self.waveFormHolderView addGestureRecognizer:pan];

}




#pragma mark - GESTURES -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}


-(void)showOnHUDDisplay:(NSString *)string {
   self.controlsView.hudLabel.text = string;
}


- (void)pan:(UIPanGestureRecognizer*)pan {
   [[Global sharedInstance].modeManager.activeXParam];
}








@end
