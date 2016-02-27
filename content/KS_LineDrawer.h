//
//  CV_lineDrawer.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KS_LineDrawer : UIView

@property (nonatomic) CGPoint chosenGesturePoint;
@property (nonatomic) CGPoint currentPoint;
@property BOOL drawChoosingLine;

@property BOOL KS_X1_ISConnected;
@property CGPoint KS_X1_From;
@property CGPoint KS_X1_To;

@property BOOL KS_Y1_ISConnected;
@property CGPoint KS_Y1_From;
@property CGPoint KS_Y1_To;

@property BOOL KS_X2_ISConnected;
@property CGPoint KS_X2_From;
@property CGPoint KS_X2_To;

@property BOOL KS_Y2_ISConnected;
@property CGPoint KS_Y2_From;
@property CGPoint KS_Y2_To;

@end
