//
//  ViewController.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/13/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ViewController.h"
#import "WaveFormView.h"
#import "AudioController.h"
#import "functions.h"
#import "ControlsView.h"
#import "WaveFormOverlay.h"
#import "Global.h"

#import "Draw_Helper.h"

@interface ViewController ()<globalDelegate, UIGestureRecognizerDelegate>


@property (nonatomic,strong) AudioController * audioController;



@property (nonatomic,strong) ControlsView *controlsView;
@property (nonatomic,strong) WaveFormView * waveFormView;;
@property (nonatomic,strong) WaveFormOverlay * waveFormOverlay;

@property (nonatomic,strong) Global * global;

@property (nonatomic,strong) UILabel * hudLabel;



@end

@implementation ViewController



- (void)viewDidLoad {
   [super viewDidLoad];
   
   
  // [Draw_Helper sharedInstance];
   
   self.global = [Global sharedInstance];
   self.global.delegate = self;
   
   self.audioController = [AudioController sharedInstance];
   
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:self.view.frame];
   self.waveFormView.backgroundColor = [UIColor blackColor];
   [self.view addSubview:self.waveFormView];
   
   
   CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
   [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
   
   
   
   
   [self createControlsView];
   
   
   self.waveFormOverlay = [[WaveFormOverlay alloc] initWithFrame:self.view.bounds];
   [self.view addSubview:self.waveFormOverlay];
   
   
   
   
   
   
   // controls effects
   UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self.view addGestureRecognizer:pan];
   
   
   
   self.hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
   self.hudLabel.center = self.view.center;
   [self.view addSubview:self.hudLabel];
   self.hudLabel.textColor = [UIColor whiteColor];
   
   
   UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToScale:)];
   [self.view addGestureRecognizer:pinch];
   
   
   
   
}




#pragma mark - GESTURES -




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
   
   return YES;
}




//- (void)pinchToScale:(UIPinchGestureRecognizer *)pinch {
//
//   int newAmount = g.samplesOnScreen;
//
//   if (pinch.velocity > 0) { // zoom in
//      newAmount = -10;
//   } else {
//      newAmount = 10;
//   }
//
//
//   if ((g.samplesOnScreen + newAmount) > 0 && (g.samplesOnScreen + newAmount) < 10000) {
//      g.samplesOnScreen += newAmount;
//   }
//
//}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
   
   if ( event.subtype == UIEventSubtypeMotionShake ) {
      float * p = [AudioController sharedInstance].getsamplesBuffer;
      for (int x = 0; x < *[[AudioController sharedInstance] getsamplesSize]; x++) {
         // printf("%i : %f \n",x,p[x]);
         *(p + x) = 0;
      }
      
   }
   
   if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
      [super motionEnded:motion withEvent:event];
}


-(void)showOnHUDDisplay:(NSString *)string {
   self.hudLabel.text = string;
}

- (void)pan:(UIPanGestureRecognizer*)pan {
   
   
 
   
   [[Global sharedInstance].modeManager.activeMode setActiveParamValue:pan andView:self.view];

     
      if (pan.state == UIGestureRecognizerStateEnded) {
         [[Global sharedInstance].modeManager.mode2 resetDraw];
      }

}


















- (void)handleEdge:(UIScreenEdgePanGestureRecognizer*)edge {
   
   
   if (edge.state == UIGestureRecognizerStateBegan) {
      self.controlsView.pulledDown = !self.controlsView.pulledDown;
      
      CGRect newFrame = self.controlsView.frame;
      if (self.controlsView.pulledDown) {
         newFrame.origin.y += newFrame.size.height;
      } else {
         newFrame.origin.y -= newFrame.size.height;
         
      }
      self.controlsView.frame = newFrame;
   }
}









- (void)createControlsView {
   
   CGRect controlsFrame = self.view.bounds;
   controlsFrame.origin.y -= controlsFrame.size.height / 3.5;
   controlsFrame.size.height /= 3.5;
   
   self.controlsView = [[ControlsView alloc] initWithFrame:controlsFrame];
   [self.controlsView setup];
   [self.view addSubview:self.controlsView];
   
   
   UIScreenEdgePanGestureRecognizer *edge = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(handleEdge:)];
   [edge setEdges:UIRectEdgeRight];
   [self.view addGestureRecognizer:edge];
   edge.delegate = self;
}


#pragma mark - display -



- (void)tick {
   [self.waveFormView setNeedsDisplay];
   [self.waveFormOverlay setNeedsDisplay];
  
}



@end
