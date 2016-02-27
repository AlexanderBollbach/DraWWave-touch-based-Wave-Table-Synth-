//
//  ControlsViewB.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlsView.h"
#import "CV_lineDrawer.h"
#import "Param_Gesture_View.h"

@interface ControlsView()

@property (nonatomic,strong) Param_Gesture_View * panXView;
@property (nonatomic,strong) Param_Gesture_View * panYView;

@property (nonatomic,strong) Param_Gesture_View * blank;
@property (nonatomic,strong) Param_Gesture_View * samplesDurationView;
@property (nonatomic,strong) Param_Gesture_View * lfoRateView;
@property (nonatomic,strong) Param_Gesture_View * lfoAmountView;
@property (nonatomic,strong) Param_Gesture_View * reverbAmountView;
@property (nonatomic,strong) Param_Gesture_View * blank2;


@property (nonatomic,strong) NSArray * parameterViews;
@property (nonatomic,strong) CV_lineDrawer * lineDrawer;
@property (nonatomic) Gesture_t touchedGesture;

@property (nonatomic,strong) UIView * mainView;


@property BOOL touchActuallyMoved;

@end

@implementation ControlsView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}

- (void)setup {
   
   self.clearsContextBeforeDrawing = YES;
   
   CGRect mainViewFr = CGRectInset(self.bounds, 100, 20);
   mainViewFr.origin.y += 75;
   self.mainView = [[UIView alloc] initWithFrame:mainViewFr];
   
   
   self.mainView.backgroundColor = [UIColor blackColor];
   [self addSubview:self.mainView];
   
   
   self.panXView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.panYView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   
   self.blank = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.samplesDurationView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.lfoRateView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.lfoAmountView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.reverbAmountView = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];
   self.blank2 = [[Param_Gesture_View alloc] initWithFrame:CGRectZero];

   self.panXView.gestureType = panX;
   self.panYView.gestureType = panY;
   
   self.blank.paramType = blank;
   self.samplesDurationView.paramType = samplesDuration;
   self.lfoRateView.paramType = lfoRate;
   self.lfoAmountView.paramType = lfoAmount;
   self.reverbAmountView.paramType = reverbAmount;
   self.blank2.paramType = blank2;

   
   self.panXView.name.text = @"X";
   self.panYView.name.text = @"Y";
   
   self.blank.name.text = @"blank";
   self.samplesDurationView.name.text = @"duration";
   self.lfoRateView.name.text = @"rate";
   self.lfoAmountView.name.text = @"amount";
   self.reverbAmountView.name.text = @"rev amount";
   self.blank2.name.text = @"blank 2";

   self.panXView.isGesture = YES;
   self.panYView.isGesture = YES;
   
   self.blank.isGesture = NO;
   self.samplesDurationView.isGesture = NO;
   self.lfoRateView.isGesture = NO;
   self.lfoAmountView.isGesture = NO;
   self.reverbAmountView.isGesture = NO;
   self.blank2.isGesture = NO;

   self.parameterViews = [NSArray arrayWithObjects:
                          self.panXView,
                          self.panYView,self.blank,
                          self.samplesDurationView,
                          self.lfoRateView,
                          self.lfoAmountView,
                          self.reverbAmountView,
                          self.blank2,
                          nil];

   self.lineDrawer = [[CV_lineDrawer alloc] initWithFrame:self.bounds];
   
   [self.mainView addSubview:self.panXView];
   [self.mainView addSubview:self.panYView];
   
   [self.mainView addSubview:self.blank];
   [self.mainView addSubview:self.samplesDurationView];
   [self.mainView addSubview:self.lfoRateView];
   [self.mainView addSubview:self.lfoAmountView];
   [self.mainView addSubview:self.reverbAmountView];
   [self.mainView addSubview:self.blank2];

   
   self.blank.tag = 1;
   self.samplesDurationView.tag = 2;
   self.lfoRateView.tag = 3;
   self.lfoAmountView.tag = 4;
   self.reverbAmountView.tag = 5;
   self.blank2.tag = 6;
   
   [self.mainView addSubview:self.lineDrawer];
   
   
   
   
   self.backgroundColor = [UIColor blackColor];
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
   UITouch * touch = [touches anyObject];
   Param_Gesture_View * gestureView = (Param_Gesture_View *)touch.view;
  
   NSLog(@"began tag %i", (int)gestureView.tag);
   
   if (![gestureView isKindOfClass:[Param_Gesture_View class]]) {
      return;
   }
   
   if (!gestureView.isGesture) {
      [self clearAnimations];
      return;
   }
   
   //take note of gesture tapped for connection
   self.touchedGesture = gestureView.gestureType;
   
   [gestureView animate:YES];
   
   // let drawer know where to stop choosing line from
   self.lineDrawer.chosenGesturePoint = touch.view.center;
   self.lineDrawer.currentPoint = touch.view.center;
   self.lineDrawer.drawChoosingLine = YES;

   [self.lineDrawer setNeedsDisplay];

   self.touchActuallyMoved = NO; // if no touch moved than we want a deattach
   // unfortunately the current scheme reattaches parameter in touches end so if we go from touches began directly to ended then we want to bypass the connection

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

   
   UIView * view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:event];

   Param_Gesture_View * gestureView = (Param_Gesture_View *)view;

   // rule out any non gesture/param related views
   if (![gestureView isKindOfClass:[Param_Gesture_View class]]) {
      return;
   }
   
   // only parameters should be selected
   if (gestureView.isGesture) {
      return;
   }

   // animate on hover
   [self clearAnimations];
   [gestureView animate:YES];

   // set end point for choosing line
   self.lineDrawer.currentPoint = gestureView.center;
   [self.lineDrawer setNeedsDisplay];
   
   // we are going to make a connection
   self.touchActuallyMoved = YES;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  
   // drawing
   [self clearAnimations];
   self.lineDrawer.drawChoosingLine = NO;
   [self.lineDrawer setNeedsDisplay];
   
   
   // break connection if touches began was not gesture and touches end was not parameter
   if (!self.touchActuallyMoved) {
    
      switch (self.touchedGesture) {
         case panX:
            self.lineDrawer.xISConnected = NO;
            [self.delegate breakConnectionFor:panX];
            break;
         case panY:
            self.lineDrawer.yISConnected = NO;
            [self.delegate breakConnectionFor:panY];
            break;
            
         default:
            break;
      }
      

      return;
   }

   
   
   UIView * view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:event];

   // check if its param view
   if (![view isKindOfClass:[Param_Gesture_View class]]) {
      return;
   }
   
   Param_Gesture_View * paramView = (Param_Gesture_View *)view;

   // tell VC to make connection in parameter manager
   [self.delegate connectionMadeFromGesture:self.touchedGesture toParameter:paramView.paramType];

   switch (self.touchedGesture) {
      case panX: {
        
         self.lineDrawer.xISConnected = YES;
         self.lineDrawer.xFrom = self.panXView.center;
         self.lineDrawer.xTo = paramView.center;

      } break;
         
      case panY: {
        
         self.lineDrawer.yISConnected = YES;
         self.lineDrawer.yFrom = self.panYView.center;
         self.lineDrawer.yTo = paramView.center;
         
      } break;
      default:
         break;
   }


}






- (void)layoutSubviews {

   CGRect masterFr = self.mainView.bounds;

   // left column
   CGRect xAxisFr = CGRectMake(masterFr.origin.x,
                               masterFr.origin.y,
                               masterFr.size.width / 2.0,
                               masterFr.size.height / 6.0);

   CGRect blankFr = xAxisFr;
   blankFr.origin.y += xAxisFr.size.height + 26.0;

   CGRect lfoRateFr = blankFr;
   lfoRateFr.origin.y += blankFr.size.height;
   
   CGRect revAmountFr = lfoRateFr;
   revAmountFr.origin.y += lfoRateFr.size.height;

   
   
   // right column
   CGRect yAxisFr = CGRectMake(masterFr.size.width / 2.0,
                               masterFr.origin.y,
                               masterFr.size.width / 2.0,
                               masterFr.size.height / 6.0);
   
   CGRect samplesDurationFr = yAxisFr;
   samplesDurationFr.origin.y += yAxisFr.size.height + 26.0;
   
   CGRect lfoAmountFr = samplesDurationFr;
   lfoAmountFr.origin.y += samplesDurationFr.size.height;

   CGRect blank2Fr = lfoAmountFr;
   blank2Fr.origin.y += lfoAmountFr.size.height;
   
   self.panXView.frame = xAxisFr;
   self.panYView.frame = yAxisFr;
   
   self.blank.frame = blankFr;
   self.samplesDurationView.frame = samplesDurationFr;
   self.lfoRateView.frame = lfoRateFr;
   self.lfoAmountView.frame = lfoAmountFr;
   self.reverbAmountView.frame = revAmountFr;
   self.blank2.frame = blank2Fr;
   
   
   NSLog(@"blank %@", NSStringFromCGPoint(self.blank.center));
      NSLog(@"rate %@", NSStringFromCGPoint(self.lfoRateView.center));

}



- (void)clearAnimations {
   
   for (Param_Gesture_View * param in self.parameterViews) {
      [param animate:NO];
   }
}

@end
