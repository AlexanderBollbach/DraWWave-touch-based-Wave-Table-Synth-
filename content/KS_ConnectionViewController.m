//
//  ControlsViewController.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ConnectionViewController.h"
#import "KS_ConnectorView.h"
#import "KS_ConnectionManager.h"

@interface KS_ConnectionViewController() <KS_ConnectorViewDelegate>

@property (nonatomic,strong) KS_ConnectorView * ks_ConnectorView;
@property (nonatomic,strong) KS_ConnectionManager * ks_ConnectionManager;

@end

@implementation KS_ConnectionViewController

- (void)loadView {
   self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}


-(void)viewDidLoad {
   [super viewDidLoad];
   
   
   self.ks_ConnectionManager = [KS_ConnectionManager sharedInstance];
   
   self.ks_ConnectorView = [[KS_ConnectorView alloc] initWithFrame:self.view.bounds];
   [self.view addSubview:self.ks_ConnectorView];
   
   self.ks_ConnectorView.delegate = self;

 
}


#pragma mark - KS_ConnectorViewDelegate -

- (void)connectionMadeFromElement:(KS_Element_t)element toParameter:(KS_Parameter_t)parameter {

   [self.ks_ConnectionManager addConnectionWithKS_Element:element
                                          andKS_Parameter:parameter];
}

- (void)breakConnectionsForElement:(KS_Element_t)element {

   [self.ks_ConnectionManager breakConnectionsWithElement:element];
}


-(void)settingsButtonTappedWithSettings:(settingsType_t)settings selected:(BOOL)selected {
   
   switch (settings) {
      case settings1:
         
         break;
      case settings2:
         
         break;
      case settings3:
         
         break;
      case settings4:
         
         break;
         
      default:
         break;
   }
   
   
}


- (void)connectAnimation {
   [UIView animateWithDuration:0.09 delay:0 options:UIViewAnimationOptionAutoreverse  | UIViewAnimationOptionAllowUserInteraction animations:^{
      self.ks_ConnectorView.alpha = 0.0;
      self.ks_ConnectorView.backgroundColor = [UIColor purpleColor];
   } completion:^(BOOL finished) {
      self.ks_ConnectorView.alpha = 1;
      self.ks_ConnectorView.backgroundColor = [UIColor blackColor];
   }];
}

-(void)viewWillAppear:(BOOL)animated {
   
   [self.navigationController setNavigationBarHidden:NO animated:NO];
   self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
   self.navigationController.title = @"Connections";
   
   [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
      self.ks_ConnectorView.alpha = 0.5;
   } completion:nil];
   
}

-(void)viewWillDisappear:(BOOL)animated {
   self.ks_ConnectorView.alpha = 1;
   [self.view.layer removeAllAnimations];
}

@end
