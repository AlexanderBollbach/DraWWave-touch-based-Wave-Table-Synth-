//
//  ControlsViewController.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlsViewController.h"
#import "ControlsView.h"
#import "ParameterManager.h"

@interface ControlsViewController() <ControlsViewDelegate>

@property (nonatomic,strong) ControlsView * controlsView;
@property (nonatomic,strong) ParameterManager * pm;
@end

@implementation ControlsViewController

- (void)loadView {
   self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}


- (void)connectionMadeFromGesture:(Gesture_t)gesture toParameter:(ParamSelected_t)parameter {
   [self.pm connectGesture:gesture toParameter:parameter];
   
   [self connectAnimation];


   
}

-(void)breakConnectionFor:(Gesture_t)gesture {
   [self.pm unattach:gesture];
   
   [self connectAnimation];
}

-(void)viewDidLoad {
   [super viewDidLoad];
   
   self.pm = [ParameterManager sharedInstance];
   
   self.controlsView = [[ControlsView alloc] initWithFrame:self.view.bounds];
   [self.view addSubview:self.controlsView];
   
   self.controlsView.delegate = self;

 
}


- (void)connectAnimation {
   [UIView animateWithDuration:0.09 delay:0 options:UIViewAnimationOptionAutoreverse  | UIViewAnimationOptionAllowUserInteraction animations:^{
      self.controlsView.alpha = 0.0;
      self.controlsView.backgroundColor = [UIColor purpleColor];
   } completion:^(BOOL finished) {
      self.controlsView.alpha = 1;
      self.controlsView.backgroundColor = [UIColor blackColor];
   }];
}

-(void)viewWillAppear:(BOOL)animated {
   
   [self.navigationController setNavigationBarHidden:NO animated:NO];
   self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
   self.navigationController.title = @"Connections";
   
   [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
      self.controlsView.alpha = 0.5;
   } completion:nil];
   
}

-(void)viewWillDisappear:(BOOL)animated {
   self.controlsView.alpha = 1;
   [self.view.layer removeAllAnimations];
}

@end
