//
//  ControlsViewB.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ConnectorView.h"
#import "KS_LineDrawer.h"
#import "KS_ElementButton.h"
#import "KS_ParameterButton.h"
#import "KS_TypesAndHelpers.h"
#import "KS_SettingsButton.h"

@interface KS_ConnectorView()

@property (nonatomic,strong) KS_ElementButton * KS_Element1_View;
@property (nonatomic,strong) KS_ElementButton * KS_Element2_View;
@property (nonatomic,strong) KS_ElementButton * KS_Element3_View;
@property (nonatomic,strong) KS_ElementButton * KS_Element4_View;

@property (nonatomic,strong) KS_ParameterButton * KS_Parameter1_View;
@property (nonatomic,strong) KS_ParameterButton * KS_Parameter2_View;
@property (nonatomic,strong) KS_ParameterButton * KS_Parameter3_View;
@property (nonatomic,strong) KS_ParameterButton * KS_Parameter4_View;
@property (nonatomic,strong) KS_ParameterButton * KS_Parameter5_View;
@property (nonatomic,strong) KS_ParameterButton * KS_Parameter6_View;

@property (nonatomic,strong) NSArray * animatingElements;

@property (nonatomic,strong) KS_ElementButton * touchedElement;

@property (nonatomic,strong) KS_LineDrawer * lineDrawer;

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
   
   CGRect mainViewFr = CGRectInset(self.bounds, 50, 10);
   mainViewFr.origin.y += 50;
   self.mainView = [[UIView alloc] initWithFrame:mainViewFr];
   
   self.mainView.backgroundColor = [UIColor blackColor];
   [self addSubview:self.mainView];
   
   self.KS_Element1_View = [[KS_ElementButton alloc] initWithFrame:CGRectZero];
   self.KS_Element2_View = [[KS_ElementButton alloc] initWithFrame:CGRectZero];
   self.KS_Element3_View = [[KS_ElementButton alloc] initWithFrame:CGRectZero];
   self.KS_Element4_View = [[KS_ElementButton alloc] initWithFrame:CGRectZero];
   
   self.KS_Parameter1_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   self.KS_Parameter2_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   self.KS_Parameter3_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   self.KS_Parameter4_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   self.KS_Parameter5_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   self.KS_Parameter6_View = [[KS_ParameterButton alloc] initWithFrame:CGRectZero];
   
   self.KS_Element1_View.element = KS_Element1;
   self.KS_Element2_View.element = KS_Element2;
   self.KS_Element3_View.element = KS_Element3;
   self.KS_Element4_View.element = KS_Element4;
   
   self.KS_Parameter1_View.parameter = KS_Parameter1;
   self.KS_Parameter2_View.parameter = KS_Parameter2;
   self.KS_Parameter3_View.parameter = KS_Parameter3;
   self.KS_Parameter4_View.parameter = KS_Parameter4;
   self.KS_Parameter5_View.parameter = KS_Parameter5;
   self.KS_Parameter6_View.parameter = KS_Parameter6;
   
   KS_TypesAndHelpers * help = [KS_TypesAndHelpers sharedInstance];
   
   self.KS_Element1_View.name.text = [help getNameFromKS_Element:self.KS_Element1_View.element];
   self.KS_Element2_View.name.text = [help getNameFromKS_Element:self.KS_Element2_View.element];
   self.KS_Element3_View.name.text = [help getNameFromKS_Element:self.KS_Element3_View.element];
   self.KS_Element4_View.name.text = [help getNameFromKS_Element:self.KS_Element4_View.element];
   
   self.KS_Parameter1_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter1_View.parameter];
   self.KS_Parameter2_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter2_View.parameter];
   self.KS_Parameter3_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter3_View.parameter];
   self.KS_Parameter4_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter4_View.parameter];
   self.KS_Parameter5_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter5_View.parameter];
   self.KS_Parameter6_View.name.text = [help getNameFromKS_Parameter:self.KS_Parameter6_View.parameter];
   
   self.animatingElements = [NSArray arrayWithObjects:
                             self.KS_Element1_View,
                             self.KS_Element2_View,
                             self.KS_Element3_View,
                             self.KS_Element4_View,
                             self.KS_Parameter1_View,
                             self.KS_Parameter2_View,
                             self.KS_Parameter3_View,
                             self.KS_Parameter4_View,
                             self.KS_Parameter5_View,
                             self.KS_Parameter6_View,
                             nil];
   
   self.lineDrawer = [[KS_LineDrawer alloc] initWithFrame:self.bounds];
   
   [self.mainView addSubview:self.KS_Element1_View];
   [self.mainView addSubview:self.KS_Element2_View];
   [self.mainView addSubview:self.KS_Element3_View];
   [self.mainView addSubview:self.KS_Element4_View];
   
   [self.mainView addSubview:self.KS_Parameter1_View];
   [self.mainView addSubview:self.KS_Parameter2_View];
   [self.mainView addSubview:self.KS_Parameter3_View];
   [self.mainView addSubview:self.KS_Parameter4_View];
   [self.mainView addSubview:self.KS_Parameter5_View];
   [self.mainView addSubview:self.KS_Parameter6_View];
   
   
   [self.mainView addSubview:self.lineDrawer];
   
}



// get only element view, animate, note elementview ref as self.touchedElement, tell line draw to mark source of line to draw while connecting, set 'actually moved' in preperation for a breaking all the conections of one element

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
   UITouch * touch = [touches anyObject];
   KS_ElementButton * ks_View = (KS_ElementButton *)touch.view;
   
   NSLog(@"began tag %i", (int)ks_View.tag);
   
   if (![ks_View isKindOfClass:[KS_ElementButton class]]) {
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
   
   KS_ElementButton * parameterView = (KS_ElementButton *)view;
   
   // rule out any non gesture/param related views
   if (![parameterView isKindOfClass:[KS_ParameterButton class]]) {
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
         case KS_Element1:
            self.lineDrawer.KS_Element1_isConnected = NO;
            break;
         case KS_Element2:
            self.lineDrawer.KS_Element2_isConnected = NO;
            break;
         case KS_Element3:
            self.lineDrawer.KS_Element3_isConnected = NO;
            break;
         case KS_Element4:
            self.lineDrawer.KS_Element4_isConnected = NO;
            break;
         default:
            break;
      }
      [self.delegate breakConnectionsForElement:self.touchedElement.element];
      return;
   }
   
   
   
   UIView * view = [self hitTest:[[touches anyObject] locationInView:self] withEvent:event];
   
   if (![view isKindOfClass:[KS_ParameterButton class]]) {
      return;
   }
   KS_ParameterButton * touchedEndedParameter = (KS_ParameterButton *)view;
   
   [self.delegate connectionMadeFromElement:self.touchedElement.element toParameter:touchedEndedParameter.parameter];
   
   
   // if we get here create one of four lines to draw (must be updated to accomodate multiple connections
   switch (self.touchedElement.element) {
      case KS_Element1: {
         self.lineDrawer.KS_Element1_isConnected = YES;
         self.lineDrawer.KS_Element1_From = self.KS_Element1_View.center;
         self.lineDrawer.KS_Element1_To = touchedEndedParameter.center;
      } break;
      case KS_Element2: {
         self.lineDrawer.KS_Element2_isConnected = YES;
         self.lineDrawer.KS_Element2_From = self.KS_Element2_View.center;
         self.lineDrawer.KS_Element2_To = touchedEndedParameter.center;
      } break;
      case KS_Element3: {
         self.lineDrawer.KS_Element3_isConnected = YES;
         self.lineDrawer.KS_Element3_From = self.KS_Element3_View.center;
         self.lineDrawer.KS_Element3_To = touchedEndedParameter.center;
      } break;
      case KS_Element4: {
         self.lineDrawer.KS_Element4_isConnected = YES;
         self.lineDrawer.KS_Element4_From = self.KS_Element4_View.center;
         self.lineDrawer.KS_Element4_To = touchedEndedParameter.center;
      } break;
         
      default:
         break;
   }
}






- (void)layoutSubviews {
   
   float verticalSpacer = 7;
   
   CGRect masterFr = self.mainView.bounds;
   
   CGRect bottomButtonsFr = self.mainView.bounds;
   bottomButtonsFr.origin.y += (5 * masterFr.size.height / verticalSpacer);
   bottomButtonsFr.size.height /= 7;
   
   CGRect button1 = bottomButtonsFr;
   button1.size.width /= 4;
   
   CGRect button2 = button1;
   button2.origin.x += button2.size.width;
   
   CGRect button3 = button2;
   button3.origin.x += button3.size.width;
   
   CGRect button4 = button3;
   button4.origin.x += button4.size.width;
   
   KS_SettingsButton * ks_sb1 = [[KS_SettingsButton alloc] initWithFrame:button1];
   [ks_sb1 setTitle:@"button 1" forState:UIControlStateNormal];
   [self.mainView addSubview:ks_sb1];
   [ks_sb1 addTarget:self action:@selector(handleSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
   
   KS_SettingsButton * ks_sb2 = [[KS_SettingsButton alloc] initWithFrame:button2];
   [ks_sb2 setTitle:@"button 1" forState:UIControlStateNormal];
   [self.mainView addSubview:ks_sb2];
   [ks_sb2 addTarget:self action:@selector(handleSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
   
   KS_SettingsButton * ks_sb3 = [[KS_SettingsButton alloc] initWithFrame:button3];
   [ks_sb3 setTitle:@"button 1" forState:UIControlStateNormal];
   [self.mainView addSubview:ks_sb3];
   [ks_sb3 addTarget:self action:@selector(handleSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
   
   KS_SettingsButton * ks_sb4 = [[KS_SettingsButton alloc] initWithFrame:button4];
   [ks_sb4 setTitle:@"button 1" forState:UIControlStateNormal];
   [self.mainView addSubview:ks_sb4];
   [ks_sb4 addTarget:self action:@selector(handleSettingsButton:) forControlEvents:UIControlEventTouchUpInside];
   
   
   ks_sb1.type = settings1;
   ks_sb1.type = settings2;
   ks_sb1.type = settings3;
   ks_sb1.type = settings4;
   
   
   // left column
   CGRect xAxisFr = CGRectMake(masterFr.origin.x,
                               masterFr.origin.y,
                               masterFr.size.width / 2.0,
                               masterFr.size.height / verticalSpacer);
   
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
                               masterFr.size.height / verticalSpacer);
   
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
   
   self.KS_Element1_View.frame = xAxisA;
   self.KS_Element2_View.frame = xAxisB;
   self.KS_Element3_View.frame = yAxisA;
   self.KS_Element4_View.frame = yAxisB;
   
   self.KS_Parameter1_View.frame = blankFr;
   self.KS_Parameter2_View.frame = samplesDurationFr;
   self.KS_Parameter3_View.frame = lfoRateFr;
   self.KS_Parameter4_View.frame = lfoAmountFr;
   self.KS_Parameter5_View.frame = revAmountFr;
   self.KS_Parameter6_View.frame = blank2Fr;
   
   
}

- (void)handleSettingsButton:(KS_SettingsButton *)sender {
   
   sender.selected = !sender.selected;
   
   [sender animate:sender.selected];
   
  // [self.delegate settingsButtonTappedWithParameter:sender.type selected:sender.selected];
   
   
}

- (void)clearAnimations {
   
   for (KS_ElementButton * param in self.animatingElements) {
      [param animate:NO];
   }
}

@end
