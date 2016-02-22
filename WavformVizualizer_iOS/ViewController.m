//
//  ViewController.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/13/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ViewController.h"
#import "WaveFormView.h"
#import "MicController.h"
#import "functions.h"
#import "ControlsView.h"
#import "WaveFormOverlay.h"
#import "Global.h"

#import "Draw_Helper.h"

@interface ViewController ()<ControlsViewDelegate, globalDelegator, UIGestureRecognizerDelegate> {
   Global * g;
}

@property (nonatomic,strong) MicController * micController;
@property (nonatomic,strong) WaveFormView * waveFormView;;
@property (nonatomic,strong) WaveFormOverlay * waveFormOverlay;;

@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,strong) ControlsView *controlsView;



// viewing
@property (nonatomic,strong) UILabel * samplesOnScreenLabel;
@property (nonatomic,strong) UILabel * startingSample;
@property (nonatomic,strong) UILabel * samplesToPlayLabel;



@property (nonatomic,strong) UIPanGestureRecognizer * panMain;
@end

@implementation ViewController



- (void)viewDidLoad {
   [super viewDidLoad];
   self.micController = [MicController sharedInstance];
   
   
   [Draw_Helper sharedInstance];
   
   g = [Global sharedInstance];
   
   
   self.waveFormView = [[WaveFormView alloc] initWithFrame:self.view.frame];
   [self.view addSubview:self.waveFormView];
   
   
   self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
   [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
   
   CGRect controlsFrame = self.view.bounds;
   controlsFrame.origin.y -= controlsFrame.size.height/5;
   controlsFrame.size.height /= 5;
   
   self.controlsView = [[ControlsView alloc] initWithFrame:controlsFrame];
   self.controlsView.delegate = self;
   [self.view addSubview:self.controlsView];
   
   self.waveFormOverlay = [[WaveFormOverlay alloc] initWithFrame:self.view.bounds];
   [self.view addSubview:self.waveFormOverlay];
   
   Global *global = [Global sharedInstance];
   global.delegate = self;
   
   
   UIScreenEdgePanGestureRecognizer *edge = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(handleEdge:)];
   [edge setEdges:UIRectEdgeRight];
   [self.view addGestureRecognizer:edge];
   edge.delegate = self;
   
   
   // controls effects
   self.panMain = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self.view addGestureRecognizer:self.panMain];
   
   
   
   
   
   
   CGFloat w = CGRectGetWidth(self.view.bounds);
   
   
   
   
   self.samplesToPlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 100, 30)];
   self.samplesToPlayLabel.textColor = [UIColor redColor];
   self.samplesToPlayLabel.font = [UIFont systemFontOfSize:15];
   self.samplesToPlayLabel.userInteractionEnabled = NO;
   [self.view addSubview:self.samplesToPlayLabel];
   
   
   self.samplesOnScreenLabel = [[UILabel alloc] initWithFrame:CGRectMake(w - 110,55,100,30)];
   self.samplesOnScreenLabel.text = @"0 samples";
   self.samplesOnScreenLabel.hidden = YES;
   self.samplesOnScreenLabel.font = [UIFont systemFontOfSize:15];
   self.samplesOnScreenLabel.textColor = [UIColor redColor];
   [self.view addSubview:self.samplesOnScreenLabel];
   
   
   
   UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToScale:)];
   [self.view addGestureRecognizer:pinch];
   
}




#pragma mark - GESTURES -

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   if (gestureRecognizer == self.panMain) {
      //
   }
   return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
   
   return YES;
}




- (void)pinchToScale:(UIPinchGestureRecognizer *)pinch {
   
   int newAmount = g.samplesOnScreen;
   
   if (pinch.velocity > 0) { // zoom in
      newAmount = -10;
   } else {
      newAmount = 10;
   }
   
   
   if ((g.samplesOnScreen + newAmount) > 0 && (g.samplesOnScreen + newAmount) < 10000) {
      g.samplesOnScreen += newAmount;
   }
   
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
   
   if ( event.subtype == UIEventSubtypeMotionShake ) {
      float * p = [MicController sharedInstance].getsamplesBuffer;
      for (int x = 0; x < *[[MicController sharedInstance] getsamplesSize]; x++) {
         // printf("%i : %f \n",x,p[x]);
         *(p + x) = 0;
      }
      
   }
   
   if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
      [super motionEnded:motion withEvent:event];
}


- (void)pan:(UIPanGestureRecognizer*)pan {
   
   float f =[pan velocityInView:self.view].x;
   if (f > 0) {
      f = 0.01;
   } else {
      f = -0.01;
   }
   
   // NSLog(@"%f",f);
   
   float * state;
   
   
   
   switch (g->mode_settings.modeState) {
         
         // samples
      case 1:
         state = &g->mode_settings.mode1_PanState_X;
         *state += f;
         [self capAtPosTwo:state];
         // [self changeEffectOnMode:1 withValue:*state];
         float valueMapped = alexMap(*state, 0, 2, 0, 10000);
         [self.micController setEffect1:valueMapped];
         self.samplesToPlayLabel.text = [NSString stringWithFormat:@"%i samples", (int)valueMapped];
         
         
         
         break;
         
         
         // draw
      case 2:
      {
         CGPoint point = [pan locationInView:self.view];
         
            NSLog(@"%@", NSStringFromCGPoint(point));
         
         
         Draw_Helper * d = [Draw_Helper sharedInstance];
         
         
         [d pushXValue:point.x];
         [d pushYValue:point.y];
         
         BOOL direction = [pan velocityInView:self.view].x > 0;


         NSMutableArray * thePoints = [d getMissingPoints_WithDirection:direction];

// get missing points than increment, otherwise the empty new value will confuse getMissingPoints functions first check that xAxis[idx] and xAxis[idx -1] not be greater that 1.
         
         [d increment];
         
         
         
         for (NSValue * pointValue in thePoints) {
            CGPoint missingPoint = [pointValue CGPointValue];
            [g writeSampleWithPoint:missingPoint];
         }
         
         [g writeSampleWithPoint:point];
         
         break;
      }
         
         
      case 3:
         
         break;
      case 4:
         
         break;
         
         
         
         
         // navigate
      case 5:
         //         g->mode_settings.mode5_PanState_X:
         (f > 0) ? [self scrollRight] : [self scrollLeft];
         
         
         break;
      default:
         break;
   }
   
   
   
   
   if (pan.state == UIGestureRecognizerStateEnded) {
      NSLog(@"times");
      [[Draw_Helper sharedInstance] dump];
      [[Draw_Helper sharedInstance] reset];
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







#pragma mark - controlsView delegate -

-(void)modeButtonTapped:(int)tag {
   
   [self clearLabels];
   
   g->mode_settings.modeState = tag;
   
   
   switch (g->mode_settings.modeState) {
      case 1:
         self.samplesToPlayLabel.hidden = NO;
         break;
         
         
      case 2:
         
         break;
      case 3:
         
         break;
      case 4:
         
         break;
      case 5:
         self.samplesOnScreenLabel.hidden = NO;
         
         break;
         
      default:
         break;
   }
}




- (void)clearLabels {
   self.samplesOnScreenLabel.hidden = YES;
   self.samplesToPlayLabel.hidden = YES;
   
}







#pragma mark - GLOBAL delegate -

- (void)samplesOnScreenChanged {
   int start = g.startingSample;
   int amount = g.samplesOnScreen;
   
   self.samplesOnScreenLabel.text = [NSString stringWithFormat:@"%i -- %i", start, (start + amount)];
}


#pragma mark - parameter ranges -


- (void)capAtOne:(float*)number {
   if (*number > 1) {
      *number = 1;
   } else if (*number < -1) {
      *number = -1;
   }
}

- (void)capAtPosTwo:(float*)number {
   if (*number > 2) {
      *number = 2;
   } else if (*number <= 0) {
      *number = 0.005;
   }
}






#pragma mark - navigation -


- (void)scrollRight {
   if (g.startingSample <= 0) return;
   
   
   float amountToScroll = g.samplesOnScreen / 15;
   g.startingSample -= (int)amountToScroll;
}

- (void)scrollLeft {
   float amountToScroll = g.samplesOnScreen / 15;
   
   g.startingSample += (int)amountToScroll;
}





#pragma mark - display - 



- (void)tick {
   [self.waveFormView setNeedsDisplay];
   [self.waveFormOverlay setNeedsDisplay];
   
}



@end
