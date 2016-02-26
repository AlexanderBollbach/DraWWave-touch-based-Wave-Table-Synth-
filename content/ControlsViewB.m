//
//  ControlsViewB.m
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlsViewB.h"
#import "CV_lineDrawer.h"
#import "ParameterView.h"

@interface ControlsViewB()

@property (nonatomic,strong) ParameterView * xAxisView;
@property (nonatomic,strong) ParameterView * yAxisView;

@property (nonatomic,strong) ParameterView * waveStartView;
@property (nonatomic,strong) ParameterView * waveEndView;
@property (nonatomic,strong) ParameterView * lfoRateView;
@property (nonatomic,strong) ParameterView * lfoAmountView;


@property (nonatomic,strong) CV_lineDrawer * lineDrawer;


@end

@implementation ControlsViewB



- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self setup];
   }
   return self;
}



- (void)setup {
   
   
   self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
   self.clearsContextBeforeDrawing = YES;
   
   
   self.xAxisView = [[ParameterView alloc] initWithFrame:CGRectZero];
   self.yAxisView = [[ParameterView alloc] initWithFrame:CGRectZero];
   
   self.waveStartView = [[ParameterView alloc] initWithFrame:CGRectZero];
   self.waveEndView = [[ParameterView alloc] initWithFrame:CGRectZero];
   self.lfoRateView = [[ParameterView alloc] initWithFrame:CGRectZero];
   self.lfoAmountView = [[ParameterView alloc] initWithFrame:CGRectZero];
   
   self.waveStartView.name.text = @"start";
   self.waveEndView.name.text = @"end";
   self.lfoRateView.name.text = @"lfoRate";
   self.lfoAmountView.name.text = @"lfoAmount";
   
   self.xAxisView.name.text = @"X";
   self.yAxisView.name.text = @"Y";
   
   
   

   
   
   self.lineDrawer = [[CV_lineDrawer alloc] initWithFrame:self.bounds];
   
   [self addSubview:self.xAxisView];
   [self addSubview:self.yAxisView];
   
   [self addSubview:self.waveStartView];
   [self addSubview:self.waveEndView];
   
   [self addSubview:self.lineDrawer];

   
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
   UITouch * touch = [touches anyObject];

   
   self.lineDrawer.stopDrawing = NO;
   
   self.lineDrawer.chosenGesturePoint = touch.view.center;

   if ([touch.view isEqual:self.xAxisView]) {
      [self.xAxisView animate:YES];
   }
   
   if ([touch.view isEqual:self.yAxisView]) {
      [self.yAxisView animate:YES];
   }
   
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   [super touchesMoved:touches withEvent:event];
   
   self.lineDrawer.currentPoint = [((UITouch*)[touches anyObject]) locationInView:self];
   [self.lineDrawer setNeedsDisplay];
   
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
   

   
   [self.lineDrawer setNeedsDisplay];
   self.lineDrawer.stopDrawing = YES;
}






-(void)layoutSubviews {
   
   CGRect xAxisFr = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height / 5);
   CGRect yAxisFr = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height / 5);
   
   CGRect waveStartFr = xAxisFr;
   waveStartFr.origin.y += xAxisFr.size.height;

   CGRect waveEndFr = yAxisFr;
   waveEndFr.origin.y += yAxisFr.size.height;

   
   self.xAxisView.frame = xAxisFr;
   self.yAxisView.frame = yAxisFr;
   
   self.waveStartView.frame = waveStartFr;
   self.waveEndView.frame = waveEndFr;

}


@end
