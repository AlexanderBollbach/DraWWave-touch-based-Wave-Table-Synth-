//
//  KaossControlView.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ControlPad.h"
#import "functions.h"
#import "KS_ConnectionManager.h"

#import "KS_ElementButton.h"

@interface KS_ControlPad()

@property float xPosition;
@property float yPosition;

@property (nonatomic,strong) NSString * xReadOut;
@property (nonatomic,strong) NSString * yReadOut;

@property (nonatomic,strong) KS_ElementButton * element1Button;
@property (nonatomic,strong) KS_ElementButton * element2Button;


@end

@implementation KS_ControlPad

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}




- (void)setup {
   
   
   self.backgroundColor = [UIColor clearColor];
   self.clearsContextBeforeDrawing = YES;
   
   UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
   [self addGestureRecognizer:pan];
   
   
   self.xReadOut = @"test x";
   self.yReadOut = @"test y";
   
   self.element1Button = [[KS_ElementButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
   [self addSubview:self.element1Button];
   self.element1Button.owningControlPad = self;
   
   [self.element1Button addTarget:self action:@selector(elementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
   
   self.element2Button = [[KS_ElementButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
   [self addSubview:self.element2Button];
   self.element2Button.owningControlPad = self;
   
   [self.element2Button addTarget:self action:@selector(elementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

}


- (void)elementButtonTapped:(KS_ElementButton *)sender {
   
//   [self.delegate elementButtonTapped:sender.element];
   sender.selected = !sender.selected;
   self.selectedElement = sender.element;
   self.elementIsListening = sender.selected;
 
   [sender animate:self.elementIsListening];
   
}

// sends values of 0-100 along with element that sent them to connection manager
- (void)pan:(UIPanGestureRecognizer *)pan {
   
   float xPanVal = [pan locationInView:self].x;
   
   if (xPanVal > CGRectGetWidth(self.bounds)) { // so left controlpad does not go off to second control pad
      return;
   }
   
   self.xPosition = xPanVal;
   

   xPanVal = alexMap(xPanVal, 0, CGRectGetWidth(self.bounds), 0, 100);
//   [self changedWithElement:self.elementX andValue:xPanVal];
   [self.delegate changedWithParameter:self.elementXParameter andValue:xPanVal];
   
   float yPanVal = [pan locationInView:self].y;
   self.yPosition = yPanVal;

   yPanVal = alexMap(yPanVal, 0, CGRectGetHeight(self.bounds), 0, 100);
//   [self changedWithElement:self.elementY andValue:yPanVal];
   [self.delegate changedWithParameter:self.elementYParameter andValue:yPanVal];

   

   [self setNeedsDisplay];
}


- (void)changedWithElement:(KS_Element_t)element andValue:(float)value {
   
   KS_ConnectionManager * connMan = [KS_ConnectionManager sharedInstance];
   
   for (KS_Connection * connection in connMan.connections) {
     
      if (connection.element == element) {
         [self.delegate changedWithParameter:connection.parameter andValue:value];
      
         NSString * string = [[KS_TypesAndHelpers sharedInstance] getNameFromKS_Parameter:connection.parameter];
         NSString * stringWithValue = [NSString stringWithFormat:@"%@ : %f", string, value];
         
         if (connection.element == KS_Element1 || connection.element == KS_Element3) {
            [self setXreadOutWithString:stringWithValue];
         }
         if (connection.element == KS_Element2 || connection.element == KS_Element4) {
            [self setYreadOutWithString:stringWithValue];
         }
      }
   }
}


- (void)drawRect:(CGRect)rect {
   [super drawRect:rect];
   
 //  CGContextRef context = UIGraphicsGetCurrentContext();
   
   UIBezierPath * pathS = [UIBezierPath bezierPath];
   UIBezierPath * pathE = [UIBezierPath bezierPath];
   
   float w = CGRectGetWidth(self.bounds);
   float h = CGRectGetHeight(self.bounds);
   
   
//   CGRect handleFrame = CGRectMake(self.xPosition, CGRectGetHeight(self.bounds) / 2, 25, 25);
//   CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//   CGContextFillRect(context, handleFrame);
   
   self.element1Button.center = CGPointMake(self.xPosition, CGRectGetHeight(self.bounds) / 3);
   self.element2Button.center = CGPointMake(CGRectGetWidth(self.bounds) / 3, self.yPosition);

   // start
   [pathS moveToPoint:CGPointMake(self.xPosition, 0)];
   [pathS addLineToPoint:CGPointMake(self.xPosition, h)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathS setLineWidth:2];
   [pathS stroke];
   
   

   
   
   // end
   [pathE moveToPoint:CGPointMake(0, self.yPosition)];
   [pathE addLineToPoint:CGPointMake(w, self.yPosition)];
   
   [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] set];
   [pathE setLineWidth:1];
   [pathE stroke];
   
   //string
//   NSDictionary * textAttributes = @{
//                                     NSFontAttributeName: [UIFont systemFontOfSize:10.0], NSForegroundColorAttributeName : [UIColor blackColor],
//                                     NSBackgroundColorAttributeName : [UIColor whiteColor]};
//   
//   NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
//   drawingContext.minimumScaleFactor = 1;
//   
//   CGRect panXStrRect = CGRectMake(self.xPosition + 2, CGRectGetHeight(self.bounds) * 0.9, 200, 15);
//   [self.xReadOut drawWithRect:panXStrRect
//                             options:NSStringDrawingUsesLineFragmentOrigin
//                          attributes:textAttributes
//                             context:drawingContext];
//   
//   
//   
//   CGRect panYStrRect = CGRectMake(w - 175, self.yPosition + 2, 200, 15);
//   [self.yReadOut drawWithRect:panYStrRect
//                             options:NSStringDrawingUsesLineFragmentOrigin
//                          attributes:textAttributes
//                             context:drawingContext];
}

- (void)setXreadOutWithString:(NSString *)string {
   self.xReadOut = string;
}

- (void)setYreadOutWithString:(NSString *)string {
   self.yReadOut = string;
}
@end
