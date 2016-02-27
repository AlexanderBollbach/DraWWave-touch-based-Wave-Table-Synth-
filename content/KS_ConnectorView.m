//
//  ControlsViewB.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ConnectorView.h"
#import "CV_lineDrawer.h"
#import "KS_ElementView.h"
#import "KS_ParameterView.h"

@interface KS_ConnectorView()

@property (nonatomic,strong) KS_ElementView * KS_X1_view;
@property (nonatomic,strong) KS_ElementView * KS_Y1_view;
@property (nonatomic,strong) KS_ElementView * KS_X2_view;
@property (nonatomic,strong) KS_ElementView * KS_Y2_view;

@property (nonatomic,strong) KS_ParameterView * blank;
@property (nonatomic,strong) KS_ParameterView * samplesDurationView;
@property (nonatomic,strong) KS_ParameterView * lfoRateView;
@property (nonatomic,strong) KS_ParameterView * lfoAmountView;
@property (nonatomic,strong) KS_ParameterView * reverbAmountView;
@property (nonatomic,strong) KS_ParameterView * blank2;


@property (nonatomic,strong) NSArray * animatingElements;


@property (nonatomic,strong) CV_lineDrawer * lineDrawer;
@property (nonatomic,strong) KS_ElementView * touchedElement; // need to be strong if just ref?

@property (nonatomic,strong) UIView * mainView;


@property BOOL touchActuallyMoved;

@end

@implementation KS_ConnectorView

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
   
   self.KS_X1_view = [[KS_ElementView alloc] initWithFrame:CGRectZero];
   self.KS_Y1_view = [[KS_ElementView alloc] initWithFrame:CGRectZero];
   self.KS_X2_view = [[KS_ElementView alloc] initWithFrame:CGRectZero];
   self.KS_Y2_view = [[KS_ElementView alloc] initWithFrame:CGRectZero];
   
   self.blank = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   self.samplesDurationView = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   self.lfoRateView = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   self.lfoAmountView = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   self.reverbAmountView = [[KS_ParameterView alloc] initWithFrame:CGRectZero];
   self.blank2 = [[KS_ParameterView alloc] initWithFrame:CGRectZero];

   self.KS_X1_view.element = KS_X1;
   self.KS_Y1_view.element = KS_Y1;
   self.KS_X2_view.element = KS_X2;
   self.KS_Y2_view.element = KS_Y2;
   
   self.blank.parameter = KS_blank;
   self.samplesDurationView.parameter = KS_samplesDuration;
   self.lfoRateView.parameter = KS_lfoRate;
   self.lfoAmountView.parameter = KS_lfoAmount;
   self.reverbAmountView.parameter = KS_reverbAmount;
   self.blank2.parameter = KS_blank2;

   self.KS_X1_view.name.text = @"KS_X1";
   self.KS_Y1_view.name.text = @"KS_Y1";
   self.KS_X2_view.name.text = @"KS_X2";
   self.KS_Y2_view.name.text = @"KS_Y2";
   
   self.blank.name.text = @"blank";
   self.samplesDurationView.name.text = @"duration";
   self.lfoRateView.name.text = @"rate";
   self.lfoAmountView.name.text = @"amount";
   self.reverbAmountView.name.text = @"rev amount";
   self.blank2.name.text = @"blank 2";

   self.animatingElements = [NSArray arrayWithObjects:
                          self.KS_X1_view,
                          self.KS_Y1_view,
                             self.KS_X2_view,
                             self.KS_Y2_view,
                             self.blank,
                          self.samplesDurationView,
                          self.lfoRateView,
                          self.lfoAmountView,
                          self.reverbAmountView,
                          self.blank2,
                          nil];

   self.lineDrawer = [[CV_lineDrawer alloc] initWithFrame:self.bounds];
   
   [self.mainView addSubview:self.KS_X1_view];
   [self.mainView addSubview:self.KS_Y1_view];
   [self.mainView addSubview:self.KS_X2_view];
   [self.mainView addSubview:self.KS_Y2_view];
   
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



// get only element view, animate, note elementview ref as self.touchedElement, tell line draw to mark source of line to draw while connecting, set 'actually moved' in preperation for a breaking all the conections of one element

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
   UITouch * touch = [touches anyObject];
   KS_ElementView * ks_View = (KS_ElementView *)touch.view;
  
   NSLog(@"began tag %i", (int)ks_View.tag);
   
   if (![ks_View isKindOfClass:[KS_ElementView class]]) {
      [self clearAnimations];
      return;
   }
   
  
   
   //take note of which element was touched
   self.touchedElement = ks_View;
   
   [ks_View animate:YES];
   
   // let drawer know where to stop choosing line from
   self.lineDrawer.chosenGesturePoint = touch.view.center;
   self.lineDrawer.currentPoint = touch.view.center;
   self.lineDrawer.drawChoosingLine = YES;
   [self.lineDrawer setNeedsDisplay];

   self.touchActuallyMoved = NO; // if no touch moved than we want a deattach
   // unfortunately the current scheme reattaches parameter in touches end so if we go from touches began directly to ended then we want to bypass the connection

}

// get parameterView or return, animate, tell line drawer the current destination of choosing line, note that we moved so we won't break any connection with 'actually moved'

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

   
   UIView * view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:event];

   KS_ElementView * parameterView = (KS_ElementView *)view;

   // rule out any non gesture/param related views
   if (![parameterView isKindOfClass:[KS_ParameterView class]]) {
      [self clearAnimations];
      return;
   }


   // animate on hover
   [self clearAnimations];
   [parameterView animate:YES];

   // set end point for drawing choosing line
   self.lineDrawer.currentPoint = parameterView.center;
   [self.lineDrawer setNeedsDisplay];
   
   // we are going to make a connection
   self.touchActuallyMoved = YES;
}



// if no 'actually moved' then go into break connections routine handled by KS_connectionmanger and tell line draw to remove line from element to parameter, get only parameter view,

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  
   // drawing
   [self clearAnimations];
   self.lineDrawer.drawChoosingLine = NO;
   [self.lineDrawer setNeedsDisplay];
   
   
   // break connection if touches began was not gesture and touches end was not parameter
   if (!self.touchActuallyMoved) {
    
      switch (self.touchedElement.element) {
         case KS_X1:
            self.lineDrawer.KS_X1_ISConnected = NO;
            break;
         case KS_Y1:
            self.lineDrawer.KS_Y1_ISConnected = NO;
            break;
         case KS_X2:
            self.lineDrawer.KS_X2_ISConnected = NO;
            break;
         case KS_Y2:
            self.lineDrawer.KS_Y2_ISConnected = NO;
            break;
         default:
            break;
      }
      [self.delegate breakConnectionsForElement:self.touchedElement.element];
      return;
   }

   
   
   UIView * view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:event];
   
   if (![view isKindOfClass:[KS_ParameterView class]]) {
      return;
   }
   KS_ParameterView * touchedEndedParameter = (KS_ParameterView *)view;

   [self.delegate connectionMadeFromElement:self.touchedElement.element toParameter:touchedEndedParameter.parameter];

   
   // if we get here create one of four lines to draw (must be updated to accomodate multiple connections
   switch (self.touchedElement.element) {
      case KS_X1: {
        
         self.lineDrawer.KS_X1_ISConnected = YES;
         self.lineDrawer.KS_X1_From = self.KS_X1_view.center;
         self.lineDrawer.KS_X1_To = touchedEndedParameter.center;

      } break;
         
      
      case KS_Y1: {
         
         self.lineDrawer.KS_Y1_ISConnected = YES;
         self.lineDrawer.KS_Y1_From = self.KS_Y1_view.center;
         self.lineDrawer.KS_Y1_To = touchedEndedParameter.center;
         
      } break;
         
      case KS_X2: {
         
         self.lineDrawer.KS_X2_ISConnected = YES;
         self.lineDrawer.KS_X2_From = self.KS_X2_view.center;
         self.lineDrawer.KS_X2_To = touchedEndedParameter.center;
         
      } break;
         
      case KS_Y2: {
         
         self.lineDrawer.KS_Y2_ISConnected = YES;
         self.lineDrawer.KS_Y2_From = self.KS_Y2_view.center;
         self.lineDrawer.KS_Y2_To = touchedEndedParameter.center;
         
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
   
   CGRect xAxisA = xAxisFr;
   xAxisA.size.width /= 2;
   CGRect xAxisB = xAxisA;
   xAxisB.origin.x += xAxisB.size.width;
   
   

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
   
   CGRect yAxisA = yAxisFr;
   yAxisA.size.width /= 2;
   CGRect yAxisB = yAxisA;
   yAxisB.origin.x += yAxisB.size.width;
   
   CGRect samplesDurationFr = yAxisFr;
   samplesDurationFr.origin.y += yAxisFr.size.height + 26.0;
   
   CGRect lfoAmountFr = samplesDurationFr;
   lfoAmountFr.origin.y += samplesDurationFr.size.height;

   CGRect blank2Fr = lfoAmountFr;
   blank2Fr.origin.y += lfoAmountFr.size.height;
   
   self.KS_X1_view.frame = xAxisA;
   self.KS_Y1_view.frame = xAxisB;
   self.KS_X2_view.frame = yAxisA;
   self.KS_Y2_view.frame = yAxisB;
   
   self.blank.frame = blankFr;
   self.samplesDurationView.frame = samplesDurationFr;
   self.lfoRateView.frame = lfoRateFr;
   self.lfoAmountView.frame = lfoAmountFr;
   self.reverbAmountView.frame = revAmountFr;
   self.blank2.frame = blank2Fr;
   

}



- (void)clearAnimations {
   
   for (KS_ElementView * param in self.animatingElements) {
      [param animate:NO];
   }
}

@end
